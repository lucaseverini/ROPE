module LITERALS_M

  ! Process literals for autocoder

  use ERROR_M, only: DO_ERROR, NoErr, SymErr
  use FLAGS, only: TRACES
  use IO_UNITS, only: U_SCRATCH
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
    integer :: KIND           ! L_... above
    integer :: WIDTH          ! Width of the literal for Name#Number
    integer :: OFFSET         ! for +/-adcon +/- offset
    character(1) :: INDEX     ! blank or 0...3
    character(52) :: TEXT     ! Text of the literal, @...@ or +/-Number
                              !  or Name for Name#Number
  end type LITERALS_T

  type(literals_t), save, allocatable :: LITERALS(:)

  integer, parameter :: INIT_LIT_POOL_SIZE = 100

  integer, save :: LAST_LTORG      ! Next available space after last LTORG,
                                   !  Initially 1, set to Num_Lits + 1
                                   !  when LTORG is encountered

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

contains

  ! -------------------------------------------------  CREATE_LIT  -----
  subroutine CREATE_LIT ( KIND, WIDTH, TEXT, NUM, OFFSET, INDX )
    integer, intent(in) :: KIND         ! Kind of the lit, L_... above
    integer, intent(in) :: WIDTH        ! Storage size of the lit
    character(*), intent(in), optional :: TEXT    ! of the literal
    integer, intent(out) :: NUM         ! Which one is it?
    integer, intent(in), optional :: OFFSET
    character, intent(in), optional :: INDX ! for %index field

    integer :: L, START, TEST_WIDTH

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
      l = len(text)
      start = last_ltorg
      do num = start, num_lits
        if ( text(:l) == literals(num)%text ) then
          if ( kind == l_area_def ) then
            if ( index(traces,'C') /= 0 ) write ( *, '(a)' ) ''
            call do_error ( text(:l) // &
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
    character(len=*), parameter :: HEAD = &
      & ' NUM KIND        ADDR WIDTH OFFSET X TEXT'
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
      if ( myUnit < 0 ) then
        print 10, i, lit_names(literals(i)%kind), literals(i)%addr, &
          & literals(i)%width, literals(i)%offset, literals(i)%index, &
          & trim(literals(i)%text)
10      format ( i4, 1x, a, t16, 2i6, i7, 1x, a, 1x, a )
      else
        write ( myUnit, 10 ) i, lit_names(literals(i)%kind), literals(i)%addr, &
          & literals(i)%width, literals(i)%offset, literals(i)%index, &
          & trim(literals(i)%text)
      end if
    end do
  end subroutine DUMP_LIT_TABLE

  ! ---------------------------------------------  INIT_LIT_TABLE  -----
  subroutine INIT_LIT_TABLE
    if ( allocated(literals) ) deallocate ( literals )
    last_ltorg = 1
    num_lits = 0
    allocate ( literals(init_lit_pool_size) )
  end subroutine INIT_LIT_TABLE

  ! ----------------------------------------------  PROCESS_LTORG  -----
  subroutine PROCESS_LTORG ( P, EMIT, CALLER, UP_TO )
  ! Process the literal table.  Compute addresses for them.  Update
  ! P depending on their size.  Emit DCW's for them if EMIT is true.
    integer, intent(inout) :: P
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
    if ( index(traces,'P') /= 0 ) &
      & print *, 'Enter PROCESS_LTORG from ', trim(caller), &
        & ' with P =', p, ' and EMIT = ', emit, &
        & ' to process', last_ltorg, ' through', howMany
    do i = last_ltorg, howMany
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
        call enter ( line(6:11), p + width - 1, 0, ixLab, dup )
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
      if ( emit ) &
        & write ( u_scratch, 200 ) why, line, ixLab, p, width, errCode, &
        & num_operands, operands(1:num_operands)
200   format ( a5, a80, 3i6, a1, i6, 4(3i6,a2,a1,a6) )
      p = p + width
      if ( index(traces,'P') /= 0 ) &
        & print *, 'Literals(', i, ')%addr =', literals(i)%addr, &
        &  ', %kind = ', trim(lit_names(literals(i)%kind)), &
        &  ', %width =', literals(i)%width, &
        &  ', %text = ', trim(literals(i)%text), &
        &  ', %offset = ', literals(i)%offset
    end do
    last_ltorg = howMany + 1
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
