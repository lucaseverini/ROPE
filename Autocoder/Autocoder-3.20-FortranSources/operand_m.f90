module OPERAND_M

  ! The OPERAND type, and the OPERANDS and NUM_OPERANDS variables.

  implicit NONE
  public

  integer, parameter :: K_NONE = 0
  integer, parameter :: K_ACTUAL = K_NONE + 1          ! Number
  integer, parameter :: K_ADCON_LIT = K_ACTUAL + 1     ! +@...#
  integer, parameter :: K_ADDR_CON = K_ADCON_LIT + 1   ! +/-Name
  integer, parameter :: K_AREA_DEF = K_ADDR_CON + 1    ! Name#Number
  integer, parameter :: K_ASTERISK = K_AREA_DEF + 1    ! *
  integer, parameter :: K_BLANK_CON = K_ASTERISK + 1   ! #Number
  integer, parameter :: K_CHAR_LIT = K_BLANK_CON + 1   ! @...@
  integer, parameter :: K_DA_OPT = K_CHAR_LIT + 1      ! LABEL has DA opts
  integer, parameter :: K_DEVICE = K_DA_OPT + 1        ! %<letter><digit>
  integer, parameter :: K_NUM_LIT = K_DEVICE + 1       ! +/-Number
  integer, parameter :: K_OTHER = K_NUM_LIT + 1        ! Probably a D modifier
  integer, parameter :: K_SYMBOLIC = K_OTHER + 1       ! Name

  character(10) :: OperandNames(k_actual:k_symbolic) = &
    & (/ 'ACTUAL   ', 'ADCON_LIT', 'ADDR_CON ', 'AREA_DEF ', 'ASTERISK ', &
    &    'BLANK_CON', 'CHAR_LIT ', 'DA_OPT   ', 'DEVICE   ', 'NUM_LIT  ', &
    &    'OTHER    ', 'SYMBOLIC ' /)

  integer, parameter :: X00 = 100000                   ! For ORG *+X00

  type, public :: OPERAND
    integer :: ADDR      ! First subfield, depends on Kind:
                         !  Value for K_Actual if not DCW, else width,
                         !  Value for K_Blank_Con,
                         !  Lit index or Width for K_Adcon_Lit,
                         !  Lit index for K_Area_Def, K_Char_Lit, K_NumLit,
                         !   K_Addr_Con if a lit is created, else width,
                         !  Sym index for K_Symbolic
                         !  Zero for K_Asterisk or K_other
    integer :: KIND      ! What is Addr field? K_... above
    integer :: OFFSET    ! +/- from Addr, or +X00 for +X00 (duh)
    character(2) :: D    ! Maybe D character -- 2nd char for error check
    character :: INDEX   ! Blank or 0..3
    character(6) :: LABEL     ! Label, or option characters from DA
  end type OPERAND

  type(operand), save :: Operands(0:99)

  integer, save :: Num_Operands

end module OPERAND_M
