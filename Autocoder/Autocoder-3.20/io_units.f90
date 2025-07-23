module IO_UNITS

  ! Input/output units and file names for autocoder program

  implicit NONE
  public

  character(127) :: DIAG=' '  ! File name for diagnostic format "deck"
  character(127) :: INPUT     ! File name for input
  character(127) :: LIST=' '  ! File name for listing
  character(127) :: OBJ=' '   ! File name for object "deck"
  character(127) :: TAPE=' '  ! File name for loadable "tape"

  integer, save :: U_ERROR = -1         ! Set by main program, used by Error_M
  integer, parameter :: U_INPUT = 20    ! Unit number for input.  U_INPUT
    ! needs to be the largest one because macro_depth is added to it
  integer, parameter :: U_LIST = 12     ! Unit number for listing
  integer, parameter :: U_OBJ = 14      ! Unit number for object "deck"
  integer, parameter :: U_SCRATCH = 15  ! Unit number for scratch
  integer, parameter :: U_SCR2 = 16     ! Unit number for another scratch
  integer, parameter :: U_TAPE = 17     ! Unit number for loadable "tape"
  integer, parameter :: U_DIAG = 18     ! Unit number for diagnostic
                                        ! format (one field per card) deck.

end module IO_UNITS
