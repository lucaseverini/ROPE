module MACHINE
  implicit none

  character(LEN=2) :: END_LINE = ' ' // char(10)
  character(LEN=1) :: FILSEP = '/'      ! '/' for Unix, '\' for DOS or NT
  integer, parameter :: HP = 0          ! Offset for first argument for GETARG

contains

!   subroutine GetArg ( ArgNum, ArgVal )
!     integer, intent(in) :: ArgNum
!     character(len=*), intent(out) :: ArgVal
! 
!     character(len=1023) :: CmdLine ! The whole command line, from GETCL
!     integer :: I, J
! 
!     if ( ArgNum < 1 ) then
!       print *, 'Argument number must be > 0'
!       stop
!     end if
! 
!     call getcl ( cmdLine )
!     j = 1
!     do i = 1, argNum
!       cmdLine = adjustl(cmdLine(j:))
!       j = index(cmdLine,' ')
!     end do
! 
!     argVal = cmdLine(:j)
!   end subroutine GetArg

  subroutine IO_ERROR ( MESSAGE, IOSTAT, FILE )
  ! Print MESSAGE and FILE, and then do something reasonable with IOSTAT.

    character(len=*), intent(in) :: MESSAGE
    integer, intent(in) :: IOSTAT
    character(len=*), intent(in), optional :: FILE

    integer :: L
!     character(len=127) :: MSG           ! From the Lahey IOSTAT_MSG intrinsic

    write (*,*) message(:len_trim(message))
    if ( present(file) ) then
      l = len_trim(file)
      write (*,*) file(:l)
    end if
!     call iostat_msg (iostat, msg)       ! Lahey intrinsic
!     write (*,*) msg(:len_trim(msg))     ! Print the error message
    write (*,*) 'Error status code =', iostat
    return
  end subroutine IO_ERROR

end module MACHINE
