module INPUT_M

! Input types and routines for 1401 Autocoder.

  implicit NONE
  private

  integer, public, save :: INUNIT
  integer, public, save :: LINE_NO

  public :: READ_LINE

contains

  subroutine READ_LINE ( LINE, IOSTAT )
    character(80), intent(out) :: LINE
    integer, intent(out) :: IOSTAT

    integer :: I

    if ( inunit < 0 ) then
      read ( *, '(a)', iostat=iostat ) line
    else
      read ( inunit, '(a)', iostat=iostat ) line
    end if
    if ( iostat /= 0 ) return
    do i = 1, 80
      if ( iachar(line(i:i)) >= iachar('a') .and. &
        &  iachar(line(i:i)) <= iachar('z') ) &
        & line(i:i) = achar(iachar('A')-iachar('a')+iachar(line(i:i)))
        
      ! replace '&' with '+' as Stan Paddock requested
      ! commented because it creates problems to Marc Verdiell
      !if ( line(6:6) /= '*' .and. line(i:i) == '+' ) line(i:i) = '&'
      	
      if ( iachar(line(i:i)) == 9 ) line(i:i) = '' ! tab -> blank
    end do
  end subroutine READ_LINE

end module INPUT_M
