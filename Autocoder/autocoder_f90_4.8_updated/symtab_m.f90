module SYMTAB_M

! Symbol table for 1401 Autocoder

  implicit NONE
  private

  type, public :: SYMBOL_T
    character(6) :: LABEL     ! From label field of input
    integer :: VALUE          ! Typically an address
    integer :: LC             ! Location counter for VALUE. -1..99.  Zero is
                              ! not relocatable, negative means external.
    integer :: INDEX          ! Index register number, 0..3
    character(3) :: DEV       ! Device %<letter><number> if LABEL is on EQU
    logical :: REF
  end type SYMBOL_T

  type(symbol_t), save, allocatable :: SYMBOLS(:)

  integer, parameter, public :: REF = -30000

  integer, save :: NUM_SYMS

  integer, parameter :: INIT_SIZE = 100

  ! Location counter table.  0 => not in use, -1 => relocatable, 1 => absolute
  integer, parameter, public :: LC_MAX = 9
  character(*), parameter, public :: LC_MAX_T = '9' ! for error messages
  integer, save, public :: LC_TAB(0:LC_MAX)
  data lc_tab(0) /1/, lc_tab(1:LC_MAX) / LC_MAX*0 /

  public :: DUMP_SYMTAB, ENTER, INIT_SYM_TABLE, LOOKUP, SYMBOLS

contains

  ! ------------------------------------------------  DUMP_SYMTAB  -----
  subroutine DUMP_SYMTAB ( Unit, Heading, Sort )
    use BCD_TO_ASCII_m, only: BCD_to_ASCII, B_AMPER
    integer, intent(in), optional :: Unit    ! stdout if absent or negative
    character(len=*), intent(in), optional :: Heading  ! printed before the dump
    logical, intent(in), optional :: Sort    ! Sort, default false

    integer :: I, J, K, MyUnit
    logical MySort
    integer :: N                             ! Symbols per line
    type(symbol_t) :: OneSym
    character(5) :: Value(6)
    character(2) :: LC(6)
    character(3) :: X(6)
    integer, parameter :: Nun = 17 ! Number of unreferenced symbols per line
    character(7*Nun) :: Line
    logical :: Unref ! At least one symbol was not referenced

    if ( num_syms == 0 ) return
    myUnit = -1
    if ( present(unit) ) myUnit = unit
    if ( present(heading) ) then
      if ( myUnit < 0 ) then
        print *
        print *, trim(heading)
      else
        write ( myUnit, * )
        write ( myUnit, * ) trim(heading)
      end if
    end if
    mySort = .false.
    if ( present(sort) ) mySort = sort

    n = 4
    if ( mySort ) then
      n = 6
      ! First put the smallest one at location 1
      oneSym = symbols(1)
      j = 1
      do i = 2, num_syms
        if ( symbols(i)%label < oneSym%label ) then
          oneSym = symbols(i)
          j = i
        end if
      end do ! i
      symbols(j) = symbols(1)
      symbols(1) = oneSym
      ! Now do an insertion sort
      do i = 2, num_syms
        oneSym = symbols(i)
        j = i
        do
          if ( oneSym%label > symbols(j-1)%label ) then
            symbols(j) = oneSym
            exit
          end if
          symbols(j) = symbols(j-1)
          j = j - 1
        end do ! j
      end do ! i
    end if

    unref = .false.
    do i = 1, num_syms, n
      do j = 1, n
        if ( i+j-1 > num_syms ) exit
        unref = unref .or. .not. symbols(i+j-1)%ref
        x(j) = ''
        write ( lc(j), '(i2)' ) symbols(i+j-1)%lc
        if ( symbols(i+j-1)%value <= ref ) then
          value(j) = 'UNDEF'
          lc(j) = '##'
        else if ( symbols(i+j-1)%dev /= '' ) then
          value(j) = symbols(i+j-1)%dev
        else
          write ( value(j), '(i5.4)' ) symbols(i+j-1)%value
          if ( symbols(i+j-1)%index /= 0 ) &
            & write ( x(j), '(a,"X",i1)' ) &
              & bcd_to_ascii(b_amper), symbols(i+j-1)%index
        end if
      end do
      if ( myUnit < 0 ) then
        if ( mySort ) then
          print 10, (symbols(i+k-1)%label, value(k), lc(k), x(k), k = 1, j-1)
10        format ( 6(1x, a6, 2x, a5, ':', a2, a3) )
        else
          print 20, i, (symbols(i+k-1)%label, value(k), lc(k), x(k), k = 1, j-1)
20        format ( i4, ':', 6(1x, a6, 2x, a5, ':', a2, a3) )
        end if
      else
        if ( mySort ) then
          write ( myUnit, 10 ) (symbols(i+k-1)%label, value(k), lc(k), x(k), k = 1, j-1)
        else
          write ( myUnit, 20 ) i, (symbols(i+k-1)%label, value(k), lc(k), x(k), k = 1, j-1)
        end if
      end if
    end do

    if ( unref ) then
      write ( myUnit, '(/"0UNREFERENCED SYMBOLS"/)' )
      n = 2
      line = ''
      do i = 1, num_syms
        if ( .not. symbols(i)%ref ) then
          if ( n >= len(line) ) then
            write ( myUnit, '(a)' ) trim(line)
            line = ''
            n = 2
          end if
          line(n:n+5) = symbols(i)%label
          n = n + 7
        end if
      end do
      write ( myUnit, '(a)' ) trim(line)
    end if

  end subroutine DUMP_SYMTAB

  ! ------------------------------------------------------  ENTER  -----
  subroutine ENTER ( LABEL, VALUE, LC, INDEX, NUM, DUPLICATE, DEV )
  ! Enter LABEL into the symbol table with VALUE, LC and INDEX.
  ! Return DUPLICATE = "It was already there!" -- but never if Value <= REF
  ! or if the value found <= REF.  Return NUM where it was found or inserted,
  ! or -1 if label == ''
    character(*), intent(in) :: LABEL
    integer, intent(in) :: VALUE   ! REF for references, else the value
    integer, intent(in) :: LC      ! Location counter for definitions
    integer, intent(in) :: INDEX
    integer, intent(out), optional :: NUM    ! Where it was found or created
    logical, intent(out), optional :: DUPLICATE
    character(3), intent(in), optional :: DEV     ! If label is on EQU
    logical :: lValue

    character(3) :: MyDev
    integer :: I
    type(symbol_t), allocatable :: TEMP(:)

    if ( present(duplicate) ) duplicate = .false.
    if ( present(num) ) num = -1
    if ( label == '' ) return
    myDev = ' '
    if ( present(dev) ) myDev = dev

    ! Create the symbol table if it doesn't exist
    if ( .not. allocated(symbols) ) call init_sym_table

    ! Check for duplicate definition
    do i = 1, num_syms
      if ( label == symbols(i)%label ) then
        if ( symbols(i)%value <= ref ) then
          symbols(i)%value = value
          symbols(i)%index = index
          symbols(i)%lc = lc
        else
          if (present(duplicate) ) duplicate = value > ref
        end if
        symbols(i)%ref = symbols(i)%ref .or. value == ref
        if ( present(num) ) num = i
        return
      end if
    end do

    ! Increase the size of the symbol table if necessary
    if ( num_syms >= size(symbols) ) then
      allocate ( temp(num_syms) )
      temp = symbols
      deallocate ( symbols )
      allocate ( symbols(2*num_syms) )
      symbols(:num_syms) = temp
      deallocate ( temp )
    end if
    
    lValue = (value == ref)

    num_syms = num_syms + 1
    if ( present(num) ) num = num_syms
    symbols(num_syms) = symbol_t ( label, value, lc, index, myDev, lValue )
  end subroutine ENTER

  ! ---------------------------------------------  INIT_SYM_TABLE  -----
  subroutine INIT_SYM_TABLE
    if ( allocated(symbols) ) deallocate ( symbols )
    allocate ( symbols(init_size) )
    num_syms = 0
  end subroutine INIT_SYM_TABLE

  ! -----------------------------------------------------  LOOKUP  -----
  subroutine LOOKUP ( LABEL, WHERE )
  ! Look up LABEL.  Return its location in SYMBOLS in WHERE.  If not
  ! found, return WHERE = -1
    character(*), intent(in) :: LABEL
    integer, intent(out), optional :: WHERE

    integer :: I

    if ( .not. allocated(symbols) ) call init_sym_table
    do i = 1, num_syms
      if ( label == symbols(i)%label ) then
        if ( present(where) ) where = i
        return
      end if
    end do

    if ( present(where) ) where = -1
  end subroutine LOOKUP

end module SYMTAB_M

!>> 2011-08-14 Location counter number
