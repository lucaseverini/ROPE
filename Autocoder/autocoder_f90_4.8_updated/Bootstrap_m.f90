module Bootstrap_m

! Stuff for card and tape bootstrapping

  implicit NONE
  public

  character, public :: BootLoader = 'I' ! I for IBM
                                        ! N for None
                                        ! V for Van's Favorite 2-card loader
  integer, public :: CoreSize = 16000   ! 1400, 2000, 8000, 12000 or 16000

  character(71) :: BOOTSTRAP = & ! Bootstrap card
    & ',008015,022029,036040,047054,061068,072/061039              ,0010011040'
  character(*), parameter :: BOOT_T = &    ! Tape bootstrap record
    & 'U%U1B.L%U1020RB001L.020 BOOTSTRAP'
  character(*), parameter :: BOOT_TW = &   ! Word marks for BOOT_T
    & '1    11       1    1   1         1'
  character(*), parameter :: BOOT_V = &    ! Van's favorite bootstrap/clear card
    & ',008047/047046       /000H025B022100  4/061046,054061,068072,0010401040'
  character(71) :: CS1_4 = & ! First clear-storage card -- IBM 4K
    & ',008015,019026,030,034041,045,053,0570571026                           '
    !  1      1      1   1      1   1   1      1   1       1   1
  character(71) :: CS1_6 = & ! First clear-storage card -- IBM 16K
    & ',008015,022026,030037,044,049,053053N000000N00001026                   '
    !  1      1      1      1   1   1      1      1    1   1
  character(71) :: CS2_4 = & ! Second clear-storage card -- IBM 4K
    & 'L068112,102106,113/101099/I99,027A070028)027B0010270B0261,001/001113I0 '
    !  1      1      1   1      14  1   1      1   1       1   32   2      2
  character(71) :: CS2_6 = & ! Second clear-storage card -- IBM 16K
    & 'L068116,105106,110117B101/I9I#071029C029056B026/B001/0991,001/001117I0?'
    !  1      1      1      1   1   1      1      1    1   3   22   2      2
!   character(*), parameter :: CST = &   ! Clear-storage record for tape
!     & ',200/000H008V0052001L051115L/100099L%U1001R/007199 CLEAR STORAGE'
!   character(*), parameter :: CSTW = &  ! Word marks for CST
!     & '1   1   1   1       1      11      1       1'
  character(*), parameter :: CST = &   ! Tape clear-storage and boot record
    & 'B024 .L%U1020RB001L.020B056L/000H032V0291001L060005B007U%U1BB020 CLR&BOOT                           '
  character(*), parameter :: CSTW = &  ! Word marks for CST sets WM in 100 for clear
    & '1    11       1    1   1    1   1   1       1      1   1    1   1                                  1'
  character(*), parameter :: CS_V = &  ! Van's favorite clear bootstrap card
    & ',008015,022026,030040/019,001L020100   ,047054,061068,072072)0810811022'
  character(71) :: EX1 = & ! First "restart after EX" card
    & ',015022)024056,029036,040047,0540611001,001008B001     ,001008B001     '
  character(71) :: EX2 = & ! Second "restart after EX" card
    & ',068072)063067/061039                                       ,0010011040'
  character(*), parameter :: RE_EX = &     ! Quick re-bootstrap after EX
    & ',008047/047046                         N000000,054061,068072,0010401040'

end module Bootstrap_m

!>> 2011-08-21 Initial version

!>> 2013-09-22 New tape bootstrap record
