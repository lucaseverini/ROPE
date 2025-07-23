module LITERALS_M

  ! Process literals for autocoder

  use ERROR_M, only: DO_ERROR, NoErr, SymErr
  use FLAGS, only: TRACES
  use IO_UNITS, only: U_SCRATCH, FMT_S
  use OPERAND_M, only: K_ACTUAL, K_ADCON_LIT, K_ADDR_CON, K_AREA_DEF, &
    & K_CHAR_LIT, NUM_OPERANDS, OPERAND, OPERANDS
  use SYMTAB_M, only: ENTER, LOOKUP, REF, SYMBOLS

  implicit NONE
  public

  integer, parameter :: L_ADCON_LIT = 1                ! +/-@...@
  integer, parameter :: L_ADDR_CON = L_ADCON_LIT + 1   ! +/-Name
  integer, parameter :: L_AREA_DEF = L_ADDR_CON + 1    ! Name#Number
  integer, parameter :: L_CHAR_LIT = L_AREA_DEF + 1    ! @...@
  integer, parameter :: L_NUM_LIT = L_CHAR_LIT + 1     ! +/-Number

  character(9) :: LIT_NAMES(l_adcon_lit:l_num_lit) = &
    & (/ 'ADCON_LIT', 'ADDR_CON ', 'AREA_DEF ', 'CHAR_LIT ', 'NUM_LIT  ' /)
  type :: LITERALS_T
    integer :: ADDR           ! Address of the literal
    integer :: LC             ! Location counter
    integer :: KIND           ! L_... above
    integer :: WIDTH          ! Width of the literal for Name#Number
    integer :: OFFSET         ! for +/-adcon +/- offset
    character(1) :: INDEX     ! blank or 0...3
    character(52) :: TEXT     ! Text of the literal, @...@ or +/-Number
                              !  or Name for Name#Number
    logical :: Done = .false. ! Literal has been created
  end type LITERALS_T

  type(literals_t), save, allocatable :: LITERALS(:)

  integer, parameter :: INIT_LIT_POOL_SIZE = 100

  logical :: LONG_LITS = .false.   ! If true, literals of any length are
                                   ! stored only once per program section.
                                   ! If false, numeric literals of more than
                                   ! five or fewer digits plus sign, or
                                   ! alphameric literals of four or fewer
                                   ! characters are stored once per program
                                   ! section, and longer literals are re-
                                   ! generated every time they appear.

  integer, save :: NUM_LITS

  private :: Check_Table_Size

  character(len=*), parameter, private :: HEAD = &
      & ' NUM KIND        ADDR LC WIDTH OFFSET X DONE TEXT'

contains

  ! -------------------------------------------------  CREATE_LIT  -----
  subroutine CREATE_LIT ( KIND, WIDTH, TEXT, LC, NUM, OFFSET, INDX )
    integer, intent(in) :: KIND         ! Kind of the lit, L_... above
    integer, intent(in) :: WIDTH        ! Storage size of the lit
    character(*), intent(in), optional :: TEXT    ! of the literal
    integer, intent(in) :: LC           ! LC in which to create lit
    integer, intent(out) :: NUM         ! Which one is it?
    integer, intent(in), optional :: OFFSET
    character, intent(in), optional :: INDX ! for %index field

    integer :: TEST_WIDTH

    if ( .not. allocated(literals) ) call init_lit_table

    test_width = 52
    if ( .not. long_lits ) then
      select case ( kind )
      case ( l_addr_con )
      case ( l_area_def )
      case ( l_char_lit )
        test_width = 4
      case ( l_num_lit )
        test_width = 6
      end select
    end if

    if ( index(traces,'C') /= 0 ) &
      & write ( *, '(a)', advance='no' ) 'Literal ' // trim(text)
    if ( width <= test_width ) then
      do num = 1, num_lits
        if ( text == literals(num)%text .and. &
           & lc == literals(num)%lc .and. &
           & .not. literals(num)%done ) then
          if ( kind == l_area_def ) then
            if ( index(traces,'C') /= 0 ) write ( *, '(a)' ) ''
            call do_error ( text // &
              & ' Previously defined area-defining literal ' // trim(text) )
            return
          end if
          if ( width == literals(num)%width ) then
            if ( index(traces,'C') /= 0 ) write ( *, '(a)' ) ' found'
            return
          end if
        end if
      end do
    else
      num = num_lits + 1
    end if
    call check_table_size ( num )
    if ( index(traces,'C') /= 0 ) write ( *, '(a)' ) ' new'
    literals(num)%addr = 0    ! Just so it has a value so it can be copied
    literals(num)%kind = kind
    literals(num)%width = width
    literals(num)%text = text
    literals(num)%lc = lc
    literals(num)%offset = 0
    if ( present(offset) ) literals(num)%offset = offset
    literals(num)%index = ''
    if ( present(indx) ) literals(num)%index = indx
    num_lits = num
  end subroutine CREATE_LIT

  ! ---------------------------------------------  DUMP_LIT_TABLE  -----
  subroutine DUMP_LIT_TABLE ( Unit )
  ! Dump the literal table on unit, stdout if absent or negative
    integer, intent(in), optional :: Unit
    integer :: I
    integer :: MyUnit

    myUnit = -1
    if ( present(unit) ) myUnit = unit

    if ( myUnit < 0 ) then
      print '(/a)', head
    else
      write ( myUnit, '(/a)' ) head
    end if
    do i = 1, num_lits
      call dump_one_lit ( i )
    end do
  end subroutine DUMP_LIT_TABLE

  ! -----------------------------------------------  DUMP_ONE_LIT  -----
  subroutine DUMP_ONE_LIT ( Num, Unit )
    integer, intent(in) :: Num
    integer, intent(in), optional :: Unit
    integer :: MyUnit

    myUnit = -1
    if ( present(unit) ) myUnit = unit

    if ( myUnit < 0 ) then
      print 10, num, lit_names(literals(num)%kind), literals(num)%addr, &
        & literals(num)%lc, literals(num)%width, literals(num)%offset,  &
        & literals(num)%index, literals(num)%done, trim(literals(num)%text)
10    format ( i4, 1x, a, t16, i6, i3, i6, i7, 1x, a, 3x, L1, 2x, a )
    else
      write ( myUnit, 10 ) num, lit_names(literals(num)%kind), literals(num)%addr, &
        & literals(num)%lc, literals(num)%width, literals(num)%offset, &
        & literals(num)%index, literals(num)%done, trim(literals(num)%text)
    end if

  end subroutine DUMP_ONE_LIT

  ! ---------------------------------------------  INIT_LIT_TABLE  -----
  subroutine INIT_LIT_TABLE
    if ( allocated(literals) ) deallocate ( literals )
    num_lits = 0
    allocate ( literals(init_lit_pool_size) )
  end subroutine INIT_LIT_TABLE

  ! ----------------------------------------------  PROCESS_LTORG  -----
  subroutine PROCESS_LTORG ( P, LC, EMIT, CALLER, UP_TO )
  ! Process the literal table.  Compute addresses for them.  Update
  ! P depending on their size.  Emit DCW's for them if EMIT is true.
    integer, intent(inout) :: P
    integer, intent(in) :: LC    ! Location counter for P
    logical, intent(in) :: EMIT
    character(len=*), intent(in) :: CALLER ! Who called me, for debugging
    integer, intent(in), optional :: UP_TO ! up to num_lits if absent

    logical :: DUP
    integer :: END                      ! of a token
    character :: ErrCode
    integer :: Found
    integer :: HowMany
    integer :: I
    integer :: IxLab                    ! Symbol table index for a label
    character(80) :: LINE
    character(5) :: WHY
    integer :: WIDTH

    howMany = num_lits
    if ( present(up_to) ) howMany = up_to
    if ( index(traces,'P') /= 0 ) then
      print *, 'Enter PROCESS_LTORG from ', trim(caller), &
        & ' with P =', p, ', LC =', lc, ', and EMIT = ', emit
      print '(a)', head
    end if
    do i = 1, howMany
      if ( literals(i)%done ) cycle
      if ( lc >= 0 .and. literals(i)%lc /= lc ) cycle
      if ( index(traces,'P') /= 0 ) call dump_one_lit ( i )
      literals(i)%done = .true.
      errCode = noErr
      ixlab = 0
      literals(i)%addr = p + literals(i)%width - 1
      num_operands = 1
      width = literals(i)%width
      if ( literals(i)%kind == l_area_def ) then
        line(1:5) = ' '
        line(6:15) = literals(i)%text
        line(16:21) = 'DCW  #'
        write ( line(22:), '(i2.2)' ) width
        call enter ( line(6:11), p + width - 1, lc, 0, ixLab, dup )
        if ( emit ) then
          if ( dup ) call do_error ( 'Label ' // trim(line(6:11)) // &
            & ' is a duplicate' )
        else if ( p > ref ) then
          symbols(ixLab)%value = p + width - 1
        end if
        operands(1) = operand(i,k_area_def,0,'  ',' ','      ') ! Lit tab
        why = 'AREA'
      else
        line(1:15) = ' '
        line(16:20) = 'DCW'
        why = 'LIT'
        if ( literals(i)%kind == l_char_lit ) then
          line(21:) = '@' // literals(i)%text(:width) // '@'
          operands(1) = operand(i,k_char_lit,0,'  ',literals(i)%index,'      ')
        else if ( literals(i)%kind == l_adcon_lit ) then
          found = width
          width = literals(found)%width
          line(21:) = '&@' // literals(found)%text(:width) // '@'
          operands(1) = operand(found,k_adcon_lit,0,'  ',literals(i)%index,'      ')
          width = 3
          ! width field is index of @...@, not width, which is 3
          literals(i)%addr = literals(i)%addr - literals(i)%width + 3
        else if ( literals(i)%kind == l_addr_con ) then
          end = scan(literals(i)%text(2:),'&-') ! Find offset if any
          if ( end <= 0 ) end = len_trim(literals(i)%text)
          call lookup ( literals(i)%text(2:end), found )
          line(21:) = literals(i)%text
          num_operands = 2
          operands(1) = operand(i,k_addr_con,literals(i)%offset,'  ', &
            & literals(i)%index,'      ') ! In the literals table
          operands(2) = operand(found,k_addr_con,literals(i)%offset,'  ', &
            & literals(i)%index,'      ') ! In the symbol table
          width = 3
          why = 'ADCON'
          if ( found < 0 ) errCode = symErr
        else
          line(21:) = literals(i)%text
          operands(1) = operand(i,k_actual,0,'  ',literals(i)%index,'      ')
        end if
      end if
      if ( emit ) then
        write ( u_scratch, fmt_s ) why, line, ixLab, p, lc, width, errCode, &
        & num_operands, operands(1:num_operands)
      end if
      p = p + width
    end do
    if ( index(traces,'P') /= 0 ) &
      & print *, 'Exit PROCESS_LTORG with P =', p
  end subroutine PROCESS_LTORG

! *****     Private Procedures *****************************************

  ! -------------------------------------------  Check_Table_Size  -----
  subroutine Check_Table_Size ( N )
    ! Double literals if N > size(literals)
    integer, intent(in) :: N
    integer :: I
    type(literals_t), allocatable :: New_Lit(:)

    if ( n <= ubound(literals,1) ) return
    allocate ( new_lit(lbound(literals,1):ubound(literals,1)) )
    do i = lbound(literals,1), ubound(literals,1)
      new_lit(i) = literals(i)
    end do
    deallocate ( literals )
    allocate ( literals(lbound(new_lit,1):2*ubound(new_lit,1)) )
    literals ( lbound(new_lit,1):ubound(new_lit,1)) = new_lit
    deallocate ( new_lit )
  end subroutine Check_Table_Size

end module LITERALS_M

!>> 2011-08-14 Location counter number
