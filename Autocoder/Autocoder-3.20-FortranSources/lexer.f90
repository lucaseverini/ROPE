module LEXER

  use BCD_TO_ASCII_M, only: AT, DEV, HASH, PLUS, Char_To_Digit
  use ERROR_M, only: DO_ERROR
  use FLAGS, only: TRACES

  implicit NONE
  private

  integer, public, parameter :: T_AT = 1               ! @ (maybe a D modifier)
  integer, public, parameter :: T_CHARS = T_AT + 1     ! @...@
  integer, public, parameter :: T_COMMA = T_CHARS + 1  ! ,
  integer, public, parameter :: T_DEVICE = T_COMMA + 1 ! %<letter><digit>
  integer, public, parameter :: T_DONE = T_DEVICE + 1
  integer, public, parameter :: T_HASH = T_DONE + 1    ! #
  integer, public, parameter :: T_MINUS = T_HASH + 1   ! -
  integer, public, parameter :: T_NAME = T_MINUS + 1   ! L ( L+D)*
  integer, public, parameter :: T_NUMBER = T_NAME + 1  ! Unsigned
  integer, public, parameter :: T_OTHER = T_NUMBER + 1 ! Anything else
  integer, public, parameter :: T_PLUS = T_OTHER + 1   ! & or +
  integer, public, parameter :: T_STAR = T_PLUS + 1    ! *

  character(6), public :: TokenNames(t_at:t_star) = &
    & (/ 'AT    ', 'CHARS ', 'COMMA ', 'DEVICE', 'DONE  ', 'HASH  ', 'MINUS ', &
    &    'NAME  ', 'NUMBER', 'OTHER ', 'PLUS  ', 'STAR  ' /)

  public :: LEX

contains

  subroutine LEX ( LINE, START, END, TOKEN, NOSIGN )
  ! Examine LINE starting at START.  Return the TOKEN type (one of T_...
  ! above) and its END.
    character(len=*), intent(in) :: LINE
    integer, intent(inout) :: START
    integer, intent(out) :: END
    integer, intent(out) :: TOKEN
    logical, intent(in), optional :: NOSIGN ! Don't allow signed nums if present

    if ( start > len(line) ) then
      end = len(line) + 1
      token = t_done
      go to 999
    end if

    end = start - 1
    if ( line(start:min(72,start+1)) == '' ) then
      if ( start > 21 .and. line(end:end) /= ',' ) end = end + 1
      token = t_done
      go to 999
    end if

    start = start + max(verify(line(start:min(72,len(line))),' '),1) - 1
    end = start
    select case ( line(end:end) )
    case ( ' ' )
      token = t_done
    case ( '@', "'" )                   ! T_chars
      if ( line(end:end) /= at ) then 
        token = t_other
      else
        end = len(line)
        do while ( line(end:end) /= at )
          end = end - 1
        end do
        token = t_other
        if ( end == start ) then
          token = t_at                    ! T_at, maybe a D modifier
        else if ( end == start + 1 ) then
          call do_error ( 'Zero-length character literal' )
        else
          token = t_chars
        end if
      end if
    case ( ',' )                        ! T_comma
      token = t_comma
    case ( '%', '(' )                   ! May be T_device
      if ( line(end:end) /= dev ) then
        token = t_other
      else if ( line(end+1:end+1) >= 'A' .and. line(end+1:end+1) <= 'Z' .and. &
             &  line(end+2:end+2) >= '0' .and. line(end+2:end+2) <= '9' ) then
        end = end + 2
        token = t_device
      else
        token = t_other
      end if
    case ( '#', '=' )                   ! T_hash
      if ( line(end:end) == hash ) then
        token = t_hash
      else
        token = t_other
      end if
    case ( '-' )                        ! T_minus
      token = t_minus
    case ( 'A' : 'Z', '.', ')' )        ! T_name
      token = t_name
      do while ( line(end:end) /= ',' .and. line(end:end) /= '#' .and. &
        &        line(end:end) /= '&' .and. line(end:end) /= '-' )
        if ( end == len(line) ) go to 999
        if ( line(end:end+1) == '  ' ) exit
        end = end + 1
      end do
      end = end - 1
    case ( '0' : '9' )                  ! T_number
      token = t_number
      do while ( line(end:end) >= '0' .and. line(end:end) <= '9' )
        if ( end == len(line) ) go to 999
        end = end + 1
      end do
      ! Allow low-order character to be zoned
      if ( present(nosign) .or. char_to_digit(line(end:end)) < -10 ) &
        & end = end - 1
    case ( '&', '+' )                   ! T_plus
      if ( line(end:end) == plus ) then
        token = t_plus
      else
        token = t_other
      end if
    case ( '*' )
      token = t_star
    case default
      token = t_other
    end select

999 continue
    if ( index(traces,'l') /= 0 ) &
      & print *, 'Lexer: token = ', line(start:end), ' = ', tokenNames(token)
  end subroutine LEX

end module LEXER
