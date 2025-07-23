module ERROR_M

  use INPUT_M, only: LINE_NO
  use IO_UNITS, only: U_ERROR, U_LIST

  implicit NONE
  private :: LINE_NO

  character, save :: ErrCode
  character, parameter :: NoErr = ' '        ! No error
  character, parameter :: AddrErr = '1'      ! 1 <= address <= 80
  character, parameter :: LabelErr = '2'     ! Duplicate
  character, parameter :: MacroErr = '3'     ! MACRO ERROR
  character, parameter :: NoBXLErr = '4'     ! No bXl in a DA
  character, parameter :: OpErr = '5'        ! Invalid mnemonic op code
  character, parameter :: Overcall = '6'     ! Too many calls (can't happen)
  character, parameter :: SymErr = '7'       ! Undefined symbol
  character, parameter :: UndefOrg = '8'     ! Undefined ORG or LTORG
  character, parameter :: BadStatement = '9' ! Lots of reasonsu
  logical, save :: ERROR
  integer, save :: N_ERRORS

contains

  ! -------------------------------------------------  DO_ERROR  -----
  subroutine DO_ERROR ( MESSAGE, FIELD, WARNING )
    character(len=*), intent(in) :: MESSAGE
    integer, intent(in), optional :: FIELD   ! operand field # in error
    logical, intent(in), optional :: WARNING
    integer :: MyField
    character(72) :: MyMessage
    logical :: MyWarning
    character(5) :: WHY
    
    myMessage = Message ! to pad it to 80 characters for u_scratch
    why = 'ERROR'
    myWarning = .false.
    if ( present(warning) ) myWarning = warning
    if ( myWarning ) then
      why = 'WARN'
      print *, "[WARNING: " , MESSAGE, "]"
    else
      print *, "[ERROR: " , MESSAGE, "]"
      error = .true.
      n_errors = n_errors + 1
    end if
    if ( present(field) ) then
      myField = field
      print '(i5,": (",i1,") ",a)', line_no, field, message
    else
      myField = 0
      print '(i5,": ",a)', line_no, message
    end if
    if ( u_error < 0 ) then
      print 200, why, myMessage, 0, line_no, myField, 0
    else if ( u_error == u_list ) then
      write ( u_list, 100 ) trim(myMessage), why
100   format ( 6x, '*****  ** ', a, t106, a )
    else
      write ( u_error, 200 ) why, myMessage, 0, line_no, myField, 0
200   format ( a5, '******* ', a72, 3i6, 1x, i6 )
    end if
  end subroutine DO_ERROR

end module ERROR_M
