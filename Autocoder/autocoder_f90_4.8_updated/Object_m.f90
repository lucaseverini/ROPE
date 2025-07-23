module Object_m

! Stuff for writing Autocoder-format object "deck" and "tape" files.

  implicit NONE
  public
  save

  character(80) :: Card
  integer :: CARD_NO
  character(5) :: Deck_Id = ''   ! From the JOB card, for 76:80 of obj deck
  integer :: Diag_No             ! Card number in "diagnostic format" deck
  logical :: Do_Diag = .false.   ! Make a diagnostic format "deck"
  logical :: Do_Object = .false. ! Make an object "deck" (turned on by -o)
  logical :: Do_Rel = .false.    ! Make a relocatable file (turned on by -r)
  logical :: Do_Tape = .false.   ! Make an object "tape" (turned on by -t)
  integer :: Last_Obj_P = -1     ! Last position loaded by object record
  integer :: Num_Load_Ops = 0    ! In load area of object card
  integer :: Num_Swms = 0        ! Number of set word mark instructions in TSWMS
  integer :: OBJ_POS = 0         ! Last used in data area
  integer :: Seq                 ! Sequence number in listing
  integer :: SWQ(16000)          ! Set word mark queue
  integer :: SWQH = 1, SWQT = 0  ! Head, Tail of SWQ
  character(56) :: TSWMS         ! Set word mark instructions for tape output

contains

  subroutine FINISH_OBJ ( LC, TOUCH, FinalCard )
  
  ! Finish a card or tape record
    use IO_Units, only: U_Obj
    use Zone_m, only: Num_To_Addr
    integer, intent(in) :: LC                   ! Current location counter
    character(*), intent(in), optional :: TOUCH ! Finishing touch, for cc 68-71
    character(71), intent(out), optional :: FinalCard ! Before output and reset
     
    if ( do_object ) then
      do while ( swqh <= swqt .and. num_load_ops < 6 )
        call sw ( swq(swqh), lc )
        swqh = swqh + 1
      end do
      if ( obj_pos > 0 ) then
        card(40:40) = 'L'
        write ( card(41:43), '(i3.3)' ) obj_pos
        call num_to_addr ( last_obj_p, 0, card(44:46) )
      end if
      if ( present(touch) ) card(68:71) = touch
      write ( u_obj, 100 ) card(:71), card_no, trim(deck_id)
100   format ( a71, i4.4, a )
      if ( present(finalCard) ) finalCard = card ! in case of interleaved listing
      card(1:39) = ''
      card(40:67) = 'L001001,040040,040040,040040'
      card(68:) = ''
      card_no = card_no + 1
    end if
    obj_pos = 0
    num_load_ops = 0
  end subroutine FINISH_OBJ

  subroutine FLUSH_SW_QUEUE ( LC )
    integer, intent(in) :: LC ! Current location counter
    if ( .not. do_object ) return
    do while ( swqt >= swqh )
      if ( num_load_ops >= 6 ) call finish_obj ( lc, '1040' )
      call sw ( swq(swqh), lc, .true. )
      swqh = swqh + 1
    end do
  end subroutine FLUSH_SW_QUEUE

  character(5) function GenSeq ( Seq )
    ! Generate the text to print for the sequence number
    use BCD_TO_ASCII_M, only: Bcd_To_Ascii, B_RECMRK
    integer, intent(in) :: Seq
    integer :: Low ! mod(seq,1000)
    integer :: Hi  ! seq/1000
    character(30) :: OVFL = &      ! Overflows to represent high order
                                   ! digit of four-digit sequence number
      & '|/STUVWXYZ!JKLMNOPQR?ABCDEFGHI'
    ovfl(1:1) = bcd_to_ascii(B_RECMRK)
    if ( seq < 10000 ) then
      write ( genSeq, '(i5.3)' ) seq
    else
      low = mod(seq,1000)
      hi = seq / 1000 - 9
      genSeq(1:2) = ' ' // ovfl(hi:hi)
      if ( low == 0 ) then
        genSeq(3:5) = ''
      else
        write ( genSeq(3:5), '(i3)' ) low
      end if
    end if
  end function GenSeq

  subroutine OUTPUT_SWMS
    ! Output the buffer of set word mark instructions to the object tape
    integer :: I, N
    character(55) :: WMBUF       ! Word marks for set word mark instructions
    if ( num_swms > 0 .and. do_tape ) then
      n = 3*num_swms + num_swms / 2 + 1 + mod(num_swms,2)
      i = 1
      wmbuf = ''
      do while ( i < n )
        wmbuf(i:i) = '1'
        i = min(i+7,n)
      end do
      wmbuf(i:i+4) = '1   1'
      tswms(i:) = 'B007'
      call write_tape ( tswms, wmbuf, 61 )
      num_swms = 0
    end if
  end subroutine OUTPUT_SWMS

  subroutine SW ( MyP, LC, FromDC )
    ! Generate a set word mark instruction in the load area
    use Zone_m, only: Num_To_Addr
    integer, intent(in) :: MyP
    integer, intent(in) :: LC   ! Location counter for MyP
    logical, intent(in), optional :: FromDC     ! "Called from DC"
    integer :: J                           ! Index in CARD for SW address
    if ( do_object ) then
      j = 3*num_load_ops + num_load_ops / 2 + 48
      call num_to_addr ( myP, 0, card(j:j+2) )
      num_load_ops = num_load_ops + 1
    end if
    if ( do_tape .and. .not. present(fromDC) ) then
      if ( num_swms == 0 ) then
        tswms = ',      ,      ,      ,      ,      ,      ,'
      else if ( num_swms >= 14 ) then
        call output_swms
      end if
      j = 3*num_swms + num_swms / 2 + 2
      call num_to_addr ( myP, 0, tswms(j:j+2) )
      num_swms = num_swms + 1
    end if
    if ( do_rel .and. .not. present(fromDC) )  &
      & call write_rel ( 'F', '', myP, lc, 0, '', 'W' )
  end subroutine SW

  subroutine Write_Diag ( DATA )
    ! Write a record to the diagnostic deck.  The deck ID goes in 73-77
    ! and diag_no goes in 78-80.
    use IO_Units, only: U_Diag
    character(len=*), intent(in) :: Data
    diag_no = diag_no + 1
    write ( u_diag, '(a,t73,a5,i3.2)' ) data, deck_id, diag_no
  end subroutine Write_Diag

  subroutine Write_Rel ( What, Label, Adr, LC, IX, Field, W, FR, LCR, OFF, Line )
    use IO_Units, only: U_Rel, R_Fmt
    use Symtab_m, only: LC_Tab

    character(1), intent(in) :: What ! A to skip area of width FIELD(7:12)
                                     !   at ADR in LOC
                                     ! C to clear FIELD(7:12) at ADR in LC
                                     ! D for definition of LABEL as ADR in LC,
                                     !   or a device if field(1:1) == '%', or
                                     !   another label in field(1:6) with
                                     !   offset in field(7:12) if field(1:1)
                                     !   is not blank
                                     ! E for END to LABEL + ADR in LC or
                                     !   ADR in LC
                                     ! F for a FIELD of LEN at ADR in LC
                                     ! L for org LC to LABEL
                                     ! Q for A EQU B+Loc+ix and B is
                                     !   undefined, or A is external is
                                     !   external; field might be %xx
                                     ! R if ADR in LC is reference to Label
                                     !   with offset FIELD(7:12) in decimal
                                     !   and index IX
                                     ! X for EX or XFR to LABEL + ADR in LC
                                     !   or ADR in LC
                                     ! 0 for org to X00+adr
    character(*), intent(in) :: Label
    integer, intent(in) :: Adr       ! Address of field in decimal
    integer, intent(in) :: LC        ! Location counter in decimal
    integer, intent(in) :: IX        ! Index register in decimal, 0..3
    character(*), intent(in) :: Field
    character(*), intent(in) :: W    ! W If FIELD needs WM
    integer, intent(in), optional :: FR(2)  ! Starting positions in FIELD
                                     ! needing relocation, 0,1,2,5, default 0
    integer, intent(in), optional :: LCR(2) ! Location counters to use
                                     ! where FR /= 0
    integer, intent(in), optional :: OFF ! Offset if What = R
    character(*), intent(in), optional :: Line ! LINE(16:35)

    character(6) :: Lab
    character(5) :: Ch_Seq
    character(52) :: Fld
    integer :: MyFr(2), MyLC(2)
    character(20) :: MyLine

    ch_seq = genSeq(seq)
    fld = field
    lab = label
    if ( present(off) ) write ( fld(7:12), '(i6)' ) off
    myFR = 0
    if ( present(FR) ) myFR = FR
    myLC = 0
    if ( present(LCR) ) myLC = LCR
    myLine = ''
    if ( present(line) ) myLine = line
    write ( u_rel, r_fmt ) what, lab, max(adr,-9999), lc, &
      & merge('R',' ',lc_tab(lc)<0), ix, &
      & ch_seq, len(field), fld, w, myFR, myLC, trim(myLine)

  end subroutine Write_Rel

  subroutine Write_Tape ( Data, WMS, N, Unit )
    ! Write data with word marks.  Put the first four characters of the ID
    ! at the end of the record.  The last position gets a group mark and
    ! word mark.

    use BCD_TO_ASCII_M, only: BCD_TO_ASCII, B_WM, B_GRPMRK
    use IO_Units, only: U_Tape

    character(len=*), intent(in) :: DATA, WMS   ! Data and Word Marks
    integer, intent(in) :: N      ! Data length, either 80 or 61 for Autocoder
                                  ! Up to 16000 for linker
    integer, intent(in), optional :: Unit   ! Use this unit, and don't put
                                  ! Deck_ID at the end of the record if present.

    character(32000) :: Buffer    ! Room for characters and word marks
    integer :: I, J               ! Input, Buffer positions
    integer :: MyUnit

    j = 0
    myUnit = u_tape
    if ( present(unit) ) myUnit = unit
    do i = 1, max(len(data),len(wms))
      if ( i <= len(wms) ) then
        if ( wms(i:i) == '1' ) then
          j = j + 1
          buffer(j:j) = bcd_to_ascii(B_WM)
        end if
      end if
      if ( i <= len(data) ) then
        j = j + 1
        buffer(j:j) = data(i:i)
      end if
    end do
    if ( present(unit) ) then
      if ( buffer(j-1:j) /= bcd_to_ascii(B_WM) // bcd_to_ascii(B_GRPMRK) ) then
        buffer(j+1:j+2) = bcd_to_ascii(B_WM) // bcd_to_ascii(B_GRPMRK)
        j = j + 2
      end if
    else
      i = len(data)
      buffer(j+1:n-6-i+j) = ' '
      buffer(n-5-i+j:n+1-i+j) = deck_id // &
        & bcd_to_ascii(B_WM) // bcd_to_ascii(B_GRPMRK)
      j = n+1-i+j
    end if
    write ( myUnit, '(a)' ) buffer(:j)
  end subroutine WRITE_TAPE

end module Object_m

!>> 2011-08-21 Initial version
