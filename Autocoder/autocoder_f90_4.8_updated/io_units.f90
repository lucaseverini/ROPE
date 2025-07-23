module IO_UNITS

  ! Input/output units and file names for Autocoder and linker programs

  implicit NONE
  public

  character(127) :: DIAG=' '  ! File name for diagnostic format "deck"
  character(127) :: INPUT     ! File name for Autocoder input
  character(127) :: LIST=' '  ! File name for listing
  character(127) :: OBJ=' '   ! File name for object "deck"
  character(127) :: TAPE=' '  ! File name for loadable "tape"

  integer, save :: U_ERROR = -1         ! Set by main program, used by Error_M
  integer, parameter :: U_INPUT = 20    ! Unit number for input.  U_INPUT
    ! needs to be the largest one because macro_depth is added to it
  integer, parameter :: U_Cont = 10     ! Control file for linker
  integer, parameter :: U_DIAG = 11     ! Unit number for diagnostic
                                        ! format (one field per card) deck.
  integer, parameter :: U_LIST = 13     ! Unit number for listing
  integer, parameter :: U_OBJ = 14      ! Unit number for object "deck"
  integer, parameter :: U_REL = 15      ! Unit number for reloctable file
  integer, parameter :: U_SCR2 = 16     ! Unit number for another scratch
  integer, parameter :: U_SCRATCH = 17  ! Unit number for scratch
  integer, parameter :: U_TAPE = 18     ! Unit number for loadable "tape"

  ! Format for Autocoder U_SCRATCH     why line ixlab p_scratch lc width errCode
  !                                    num_Operands operands
  character(*), parameter :: INFO = 'INFO *LINE' // repeat(' ',75) // &
    & ' IXLAB     P LC WIDTH E N_OP  ADDR  KIND  OFF D X LABEL'
  character(*), parameter :: FMT_S = '( a5, a80, 2i6, i3, i6, a1, i6, (4(3i6,a2,a1,a6)))'
  ! Format for Autocoder U_SCR2
  character(*), parameter :: FMT_S2 = '( a5, a1, a )'

  ! Stuff on the relocatable file
  type :: R_file
    character(1) :: What   ! A to skip area of width FIELD(7:12) at ADR in LOC
                           ! C to clear field of width FIELD(7:12) at ADR in LOC
                           ! D for definition of LABEL as ADR in LOC
                           !   or a device if field(1:1) == '%', or
                           !   another label if field(1:1) /= ''
                           ! E for END to LABEL + ADR in LOC or ADR in LOC
                           ! F for a FIELD of LEN at ADR in LOC
                           ! L for org LC to LABEL
                           ! Q for A EQU B+Loc+ix and B is undefined,
                           !   or A is external is external; field might be %xx
                           ! R if ADR in LOC is reference to Label with
                           !   offset FIELD(1:6) in decimal and index IX
                           ! X for EX or XFR to LABEL + ADR in LOC or ADR in LOC
                           ! 0 for org to X00+adr
                           ! Record types added here to the scratch file:
                           ! S if ADR is the index in SEGS of LABEL
                           ! N if ADR is a segment number and LOC is a file number.
    character(6) :: Label
    integer :: Adr         ! Decimal address
    integer :: Loc         ! Location counter in decimal
    character(1) :: R      ! R if Adr in Loc needs relocation
    integer :: IX          ! Index in decimal, 0..3
    character(5) :: Line   ! Line number in source file
    integer :: Len         ! Length of field, might be zero if WM from DA
    character(52) :: Field
    character(1) :: WM     ! W If FIELD needs WM
    integer :: FR(2)       ! Starting positions in FIELD needing relocation, 1,2,5
    integer :: LCR(2)      ! Location counters to use where FR is nonzero
    character(20) :: Text  ! Line(16:35) for output to tape
  end type R_file

  character(*), parameter :: R_fmt = &
  !    what label adr loc   r  ix seq len field  wm   fr  lcr  line(16:35)
    & '( a1,   a6, i5, i2, a1, i1, a5, i2,  a52, a1, 2i1, 2i2, a )'

end module IO_UNITS

!>> 2011-08-14 Parameters for formats for U_SCRATCH, U_SCR2
