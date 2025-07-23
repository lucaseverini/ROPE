module OP_CODES_M

! Table describing op codes and pseudo-op codes.  We could put in the
! letters and numbers from BCD_TO_ASCII, but we assume they are
! mapped to the same upper-case ASCII letters and to the same numbers.

  use BCD_TO_ASCII_M, M => BCD_TO_ASCII
  implicit NONE
  private

  public :: INIT_OP_CODES

  type, public :: OP_CODE_T
    character(5) :: OP     ! Columns 16-20 of input
    character :: MachineOp ! Blank for pseudo op
                           ! 'p' for "use as previous" if current blank
    character(2) :: A      ! For A, B, D:    REQ => Required
    character :: B         ! OPT => Optional PRO => Prohibited
                           ! For A, if the second character is not blank,
                           ! it's used for the third character of the A
                           ! address (unit), the first operand is
                           ! required but used for the B operand, and the
                           ! second operand is prohibited.
    character :: D         ! D-modifier if not OPT, PRO or REQ
  end type OP_CODE_T

  character, public :: OPT
  character, public :: PRO
  character, public :: REQ

  type(op_code_t), public :: OP_CODES(0:127)

  character(5), parameter, public :: Sentnl = "#####" ! end of the table

contains

  subroutine Init_Op_Codes ( Do_1440 )

    logical, intent(in) :: Do_1440 ! Initialize 1440 op codes

    OPT = m(64)
    PRO = m(65)
    REQ = m(66)

    ! For the case when CC 16-18 are blank, OP in 19, D in 20
    op_codes(0) = &
      !           OP       MachineOp     A    B    D
      & op_code_t("     ", " ",          OPT, OPT, OPT)

    ! Declarative codes:
    op_codes(1:6) = (/ &
      !           OP       MachineOp     A    B    D
      & op_code_t("DA   ", " ",          REQ, PRO, PRO), &
      & op_code_t("DC   ", "p",          REQ, PRO, PRO), &
      & op_code_t("DCW  ", "p",          REQ, PRO, PRO), &
      & op_code_t("DS   ", "p",          REQ, PRO, PRO), &
      & op_code_t("DSA  ", "p",          REQ, PRO, PRO), &
      & op_code_t("EQU  ", "p",          REQ, PRO, PRO) /)

    ! Imperative codes -- Arithmetic
    op_codes(7:12) = (/ &
      !           OP       MachineOp     A    B    D
      & op_code_t("A    ", "A",          OPT, OPT, PRO), &
      & op_code_t("D    ", m(b_percnt),  OPT, OPT, PRO), &
      & op_code_t("M    ", m(b_at),      OPT, OPT, PRO), &
      & op_code_t("S    ", "S",          OPT, OPT, PRO), &
      & op_code_t("ZA   ", m(b_qmark),   OPT, OPT, PRO), &
      & op_code_t("ZS   ", m(b_bang),    OPT, OPT, PRO) /)

    ! Imperative codes -- Data Control
    op_codes(13:27) = (/ &
      !           OP       MachineOp     A    B    D
      & op_code_t("MBC  ", "M",          OPT, OPT, "B"), &
      & op_code_t("MBD  ", "M",          OPT, OPT, "D"), &
      & op_code_t("MCE  ", "E",          OPT, OPT, PRO), &
      & op_code_t("MCS  ", "Z",          OPT, OPT, PRO), &
      & op_code_t("MIZ  ", "X",          OPT, OPT, PRO), &
      & op_code_t("MLC  ", "M",          OPT, OPT, OPT), &
      & op_code_t("MCW  ", "M",          OPT, OPT, OPT), &
      & op_code_t("MLCWA", "L",          OPT, OPT, OPT), &
      & op_code_t("LCA  ", "L",          OPT, OPT, OPT), &
      & op_code_t("MLNS ", "D",          OPT, OPT, PRO), &
      & op_code_t("MN   ", "D",          OPT, OPT, PRO), &
      & op_code_t("MLZS ", "Y",          OPT, OPT, PRO), &
      & op_code_t("MZ   ", "Y",          OPT, OPT, PRO), &
      & op_code_t("MRCM ", "P",          OPT, OPT, OPT), &
      & op_code_t("MCM  ", "P",          OPT, OPT, OPT) /)

    ! Imperative codes -- Logic
    op_codes(28:48) = (/ &
      !           OP       MachineOp     A    B    D
      & op_code_t("B    ", "B",          OPT, OPT, OPT), &
      & op_code_t("BAV  ", "B",          REQ, PRO, "Z"), &
      & op_code_t("BBE  ", "W",          REQ, REQ, REQ), &
      & op_code_t("BC9  ", "B",          REQ, PRO, "9"), &
      & op_code_t("BCV  ", "B",          REQ, PRO, m(b_at)), &
      & op_code_t("BE   ", "B",          REQ, PRO, "S"), &
      & op_code_t("BEF  ", "B",          REQ, PRO, "K"), &
      & op_code_t("BER  ", "B",          REQ, PRO, "L"), &
      & op_code_t("BH   ", "B",          REQ, PRO, "U"), &
      & op_code_t("BIN  ", "B",          REQ, PRO, REQ), &
      & op_code_t("BL   ", "B",          REQ, PRO, "T"), &
      & op_code_t("BLC  ", "B",          REQ, PRO, "A"), &
      & op_code_t("BM   ", "V",          REQ, REQ, "K"), &
      & op_code_t("BPCB ", "B",          REQ, PRO, "R"), &
      & op_code_t("BPB  ", "B",          REQ, PRO, "P"), &
      & op_code_t("BU   ", "B",          REQ, PRO, m(b_slash)), &
      & op_code_t("BW   ", "V",          OPT, REQ, "1"), &
      & op_code_t("BWZ  ", "V",          OPT, REQ, REQ), &
      & op_code_t("BCE  ", "B",          OPT, REQ, REQ), &
      & op_code_t("BSS  ", "B",          REQ, PRO, REQ), &
      & op_code_t("C    ", "C",          OPT, OPT, PRO) /)

    ! Imperative codes -- Input/Output Commands
      ! A is the device code here
    op_codes(49:89) = (/ &
      !           OP       MachineOp     A    B    D
      & op_code_t("BSP  ", "U",          "U", PRO, "B"), &
      & op_code_t("CU   ", "U",          OPT, PRO, REQ), &
      & op_code_t("DCR  ", "U",          "F", PRO, "D"), &
      & op_code_t("ECR  ", "U",          "F", PRO, "E"), &
      & op_code_t("LU   ", "L",          REQ, REQ, REQ), &
      & op_code_t("MU   ", "M",          REQ, REQ, REQ), &
      & op_code_t("P    ", "4",          OPT, PRO, PRO), &
      & op_code_t("PCB  ", "4",          OPT, PRO, "C"), &
      & op_code_t("R    ", "1",          OPT, PRO, PRO), &
      & op_code_t("RCB  ", "1",          OPT, PRO, "C"), &
      & op_code_t("RD   ", "M",          "D", REQ, "R"), &
      & op_code_t("RDT  ", "M",          "D", REQ, "R"), &
      & op_code_t("RDTW ", "L",          "D", REQ, "R"), &
      & op_code_t("RDW  ", "L",          "D", REQ, "R"), &
      & op_code_t("RF   ", "4",          REQ, PRO, "R"), &
      & op_code_t("RP   ", "5",          REQ, PRO, PRO), &
      & op_code_t("RT   ", "M",          "U", REQ, "R"), &
      & op_code_t("RTB  ", "M",          "B", REQ, "R"), &
      & op_code_t("RTW  ", "L",          "U", REQ, "R"), &
      & op_code_t("RWD  ", "U",          "U", PRO, "R"), &
      & op_code_t("RWU  ", "U",          "U", PRO, "U"), &
      & op_code_t("SD   ", "M",          "D", REQ, "R"), &
      & op_code_t("SKP  ", "U",          "U", PRO, "E"), &
      & op_code_t("SPF  ", "9",          OPT, PRO, PRO), &
      & op_code_t("SRF  ", "8",          OPT, PRO, PRO), &
      & op_code_t("W    ", "2",          OPT, PRO, PRO), &
      & op_code_t("WD   ", "M",          "D", REQ, "W"), &
      & op_code_t("WDC  ", "M",          "D", REQ, "W"), &
      & op_code_t("WDCW ", "L",          "D", REQ, "W"), &
      & op_code_t("WDT  ", "M",          "D", REQ, "W"), &
      & op_code_t("WDTW ", "L",          "D", REQ, "W"), &
      & op_code_t("WDW  ", "L",          "D", REQ, "W"), &
      & op_code_t("WM   ", "2",          OPT, PRO, m(b_square)), &
      & op_code_t("WP   ", "6",          OPT, PRO, PRO), &
      & op_code_t("WR   ", "3",          OPT, PRO, PRO), &
      & op_code_t("WRF  ", "6",          OPT, PRO, "R"), &
      & op_code_t("WRP  ", "7",          OPT, PRO, PRO), &
      & op_code_t("WT   ", "M",          "U", REQ, "W"), &
      & op_code_t("WTB  ", "M",          "B", REQ, "W"), &
      & op_code_t("WTM  ", "U",          "U", PRO, "M"), &
      & op_code_t("WTW  ", "L",          "U", REQ, "W") /)

    ! Imperative codes -- Miscellaneous
    op_codes(90:101) = (/ &
      !           OP       MachineOp     A    B    D
      & op_code_t("CC   ", "F",          PRO, PRO, OPT), &
      & op_code_t("CCB  ", "F",          REQ, PRO, OPT), &
      & op_code_t("CS   ", m(b_slash),   OPT, OPT, PRO), &
      & op_code_t("CW   ", m(b_square),  OPT, OPT, PRO), &
      & op_code_t("H    ", m(b_decimal), OPT, OPT, PRO), &
      & op_code_t("MA   ", m(b_hash),    OPT, OPT, PRO), &
      & op_code_t("NOP  ", "N",          OPT, OPT, OPT), &
      & op_code_t("SAR  ", "Q",          OPT, PRO, PRO), &
      & op_code_t("SBR  ", "H",          OPT, OPT, PRO), &
      & op_code_t("SS   ", "K",          PRO, PRO, OPT), &
      & op_code_t("SSB  ", "K",          REQ, PRO, OPT), &
      & op_code_t("SW   ", m(b_comma),   OPT, OPT, PRO) /)

    ! Control codes
    op_codes(102:118) = (/ &
      !           OP       MachineOp     A    B    D
      & op_code_t("     ", " ",          REQ, PRO, PRO), &
      & op_code_t("ALTER", " ",          REQ, PRO, PRO), &
      & op_code_t("CALL ", " ",          REQ, OPT, OPT), &
      & op_code_t("CHAIN", " ",          REQ, PRO, PRO), &
      & op_code_t("CTL  ", " ",          REQ, PRO, PRO), &
      & op_code_t("DELET", " ",          REQ, PRO, PRO), &
      & op_code_t("END  ", " ",          REQ, PRO, PRO), &
      & op_code_t("ENT  ", " ",          REQ, PRO, PRO), &
      & op_code_t("EX   ", " ",          REQ, PRO, PRO), &
      & op_code_t("INCLD", " ",          REQ, PRO, PRO), &
      & op_code_t("INSER", " ",          REQ, PRO, PRO), &
      & op_code_t("JOB  ", " ",          REQ, PRO, PRO), &
      & op_code_t("LTORG", " ",          REQ, PRO, PRO), &
      & op_code_t("ORG  ", " ",          REQ, PRO, PRO), &
      & op_code_t("SFX  ", " ",          REQ, PRO, PRO), &
      & op_code_t("XFR  ", " ",          REQ, PRO, PRO), &
      & op_code_t(sentnl,  " ",          PRO, PRO, PRO) /) ! A sentinel

    op_codes(119:)%op = sentnl

    if ( do_1440 ) call insert_1440 ( (/ &
      & op_code_t("R    ", "M",          "G", REQ, "R"), &
      & op_code_t("PS   ", "M",          "G", REQ, "P"), &
      & op_code_t("P    ", "M",          "G", REQ, "G"), &
      & op_code_t("PSK  ", "M",          "G", REQ, "C"), &
      & op_code_t("W    ", "M",          "Y", REQ, "W"), &
      & op_code_t("WS   ", "M",          "Y", REQ, "S"), &
      & op_code_t("WCP  ", "M",          "T0", REQ, "W"), &
      & op_code_t("RCP  ", "M",          "T0", REQ, "R") /) )

  contains

    subroutine Insert_1440 ( codes )
      ! Scan the op_codes array for any codes that have the same op
      ! component value as an element of codes.  If one is found,
      ! replace it.  Otherwise, put the one from codes at the end and
      ! move the sentinel down one.
      type(op_code_t), intent(in) :: Codes(:)
      integer :: I, J

      do i = 1, size(codes)
        do j = 1, size(op_codes)
          if ( codes(i)%op == op_codes(j)%op ) then
            op_codes(j) = codes(i)
            exit
          end if
          if ( op_codes(j)%op == sentnl ) then
            op_codes(j+1) = op_codes(j)
            op_codes(j) = codes(i)
            exit
          end if
        end do
      end do

    end subroutine Insert_1440

  end subroutine Init_Op_Codes

end module OP_CODES_M
