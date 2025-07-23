program Link

! Link Autocoder programs using -r output from Autocoder

! Linking is controlled by a control file with the following syntax:

! <control> ::= <early>
!               <segment> [ <segment> ... ]
!               END [ label ]

! <early> ::= ID [ deck_id ]

! <early> ::= SKIP <number>
!  skip this much in every block after the first one on the core file.

! <segment> ::= <seg> <in> [ <in> ... ]
!
! <seg> ::= SEG dname [ [+]<number> ]
!  start relocatable location counters in segment at max of <number> or zero
!  and one more than the maximum absolute address in the segment
!
! <seg> ::= SEG dname -<number>
!  end relocatable location counters in segment at <number>
!
! <seg> ::= SEG dname *label [ +/- <number> ]
!  start relocatable location counters in segment at label

! <seg> ::= SEG dname rname [ rname... ]
!  start relocatable location counters in segment at max of beginnings
!  of segments rname [ rname ... ]
!
! <seg> ::= SEG dname ( rname [ rname... ] )
!  start segment relocatable location counters in segment after max of ends
!  of segments rname [ rname ... ]
!
! <in> ::= DATA file
!  include data
!
! <in> ::= IN file [ file ... ]
!  include specified .r files

! Lines beginning with ! or * are comments
! On a SEG command, everything after ! is a comment.

  use Bootstrap_m, only: Bootloader, CoreSize
  use IO_Units, only: R_File, R_Fmt, &
                      U_Cont,    &  ! Control file
                      U_Diag,    &  ! Diagnostic format "Deck" file
                      U_Rel,     &  ! An input relocatable file
                      U_Obj,     &  ! Autocoder format "Deck" file
                      U_Core => U_Scr2, & ! "Core" tape
                      U_Scratch, &  ! Scratch file
                      U_Tape        ! "Tape" file
  use Machine, only: Get_Command_Argument
  use Object_m, only: Deck_ID, Do_Diag, Do_Object, Do_Tape
  use Symtab_m, only: LC_MAX

  implicit NONE

  type(r_file) :: R        ! From an input file

  type :: SegFile
    character(255) :: Name
    type(segFile), pointer :: Next => Null()
    integer :: LC_Min(0:LC_max)   ! Location counter starts, relative
    integer :: LC_Max(0:LC_max)   ! Location counter ends, relative
    integer :: LC_End(0:LC_max)   ! Location counter ends, absolute
    integer :: LC_Start(0:LC_max) ! Location counter starts, absolute
    logical :: LC_Rel(0:LC_max)   ! Location counter relocatable flag
    logical :: LC_X00(0:LC_max)   ! Location counter starts at x00+lc_off
    integer :: LC_Off(0:LC_max)   ! Offset from x00 if lc_x00
    character(6) :: LC_Ext(0:LC_max) = '' ! LC starts at label in LC_Ext
    logical :: LC_Def(0:LC_max) = .true.  ! LC origin is defined
    character :: Data = 'I'   ! I => object, D => Data, S => Sequenced data
    integer :: FirstSym, LastSym
  end type SegFile

  type(segFile), pointer :: FileList, TempFile ! in one segment

  type :: Seg
    character(12) :: Name  ! Segment name
    character(6) :: AtLabel = '' ! Label to start at if not blank
    integer :: Offset = 0  ! From AtLabel
    integer :: Min, Max    ! Minimum and maximum absolute addresses
    integer :: Start, End  ! Start and end relocatable addresses
    integer :: Size_Rel    ! Total of all relocatable location counters
    logical :: After = .false. ! false for at max of beginnings of others,
                           ! true for after max of ends of others
                           ! not used if Others is NULL()
    logical :: EndAt = .false. ! End at END
    logical :: Def = .false. ! Start addresses of relocatable LC's defined
    integer, pointer :: Others(:) => NULL() ! Indices of other segments
    type(segFile), pointer :: Files(:) => Null()
  end type Seg

  type(seg), pointer :: Segs(:), Temp_Segs(:)
  integer :: N_Segs = 0

  type :: Sym
    character(6) :: Label
    integer :: Addr          ! in LC, < 0 means undefined
    integer :: Off           ! from EQU
    integer :: File          ! in SEG
    integer :: IX = 0        ! Index
    integer :: LC            ! in File
    integer :: Seg
    character(3) :: Dev = '' ! %xx if LABEL EQU %xx
    character :: Dup = ''    ! '#' if duplicated
    character(6) :: Equ = '' ! if LABEL EQU EQU+Addr+IX
    integer :: Ultimate = 0  ! End of chain of EQU dependence
  end type Sym

  type(sym), pointer :: Syms(:)
  integer :: N_Syms = 0

  logical :: After_EX           ! Just did EX.  Don't do restart until
                                ! processing a subsequent DATA file
  integer :: Annotate = 0       ! >0 -> Emit SEG and IN into output
                                ! >1 -> Emit DATA into output
  character(2047) :: Arg        ! Command line argument or command file line
  integer :: ArgNum             ! Command line argument number
  character(16000) :: Core      ! For "core" format tape
  logical :: Detail = .false.   ! Detailed symbol table
  logical :: Do_Core = .false.  ! Write a "core" tape -- one block per
                                ! segment
  logical :: Do_List = .false.  ! List the control file
  character(6) :: ENT = ''      ! Entry label from END command
  integer :: EntAdr = -30000    ! Entry address from END command
  logical :: Error = .false.    ! Saw an error in the control file
  integer :: I, J               ! Loop inductor, subscript
  character :: InType           ! I -> IN, D -> DATA, S -> SEQDATA
  logical :: Keep = .false.     ! Keep the scratch file
  integer :: N_Core = 0         ! Number of records on core file
  integer :: N_Diag             ! Diagnostic format "deck" "card" number
  integer :: N_Files            ! In a segment
  logical :: No_Re_Ex = .false. ! Don't emit the Re-EX card/tape
  integer :: Skip = 0           ! Amount to skip after first block on core file
  integer, pointer :: T(:)      ! Used to increase seg(.)%others
  character :: Trace = ''       ! What to trace
  logical :: Undef              ! A segment's start is undefined
  character(16000) :: WM        ! For "core" format tape

  character(*), parameter :: Version = &
    & 'Autocoder linker, Copyright (c) 2013 Van Snyder, van.snyder@sbcglobal.net Version 1.3'

  ! Collect the command-line arguments
  argNum = 0
  do
    argNum = argNum + 1
    call get_command_argument ( argNum, arg )
    if ( arg(1:1) /= '-' ) exit
    select case ( arg(2:2) )
    case ( 'a' )
      annotate = 1
    case ( 'A' )
      annotate = 2
    case ( 'b' ) ! Boot
      if (arg(3:) == '' ) then
        argNum = argNum + 1
        call get_command_argument ( argNum, arg(3:) )
      end if
      bootLoader = adjustl(arg(3:))
      if ( bootLoader >= 'a' .and. bootLoader <= 'z' ) &
        & bootLoader = achar(iachar(bootLoader) + iachar('A') - iachar('a'))
      if ( bootLoader /= 'B' .and.  bootLoader /= 'I' .and. bootLoader /= 'N' .and. &
        & bootLoader /= 'V' ) then
        print *, 'Boot Loader (-b option) must be I or N or B or V; IX used'
        bootLoader = 'I'
        arg(4:4) = 'X'
      end if
      if ( bootLoader == 'I' ) then
        select case ( arg(4:4) ) ! Core size flag
        case ( '0' )
          coreSize = 0 ! IBM Boot only, with no clear
        case ( '1' )
          coreSize = 1400
        case ( '2' )
          coreSize = 2000
        case ( '4' )
          coreSize = 4000
        case ( '8' )
          coreSize = 8000
        case ( 'V', 'v' )
          coreSize = 12000
        case ( 'X', 'x' )
          coreSize = 16000
        case ( ' ' )
        case default
          print *, 'Invalid core size flag.  ', coreSize, ' used.'
        end select
      end if
    case ( 'c' )
      if ( arg(3:) == '' ) then
        argNum = argNum + 1
        call get_command_argument ( argNum, arg(3:) )
      end if
      open ( u_core, file=trim(adjustl(arg(3:))), form='formatted', recl=16000 )
      do_core = .true.
    case ( 'd' )
      if ( arg(3:) == '' ) then
        argNum = argNum + 1
        call get_command_argument ( argNum, arg(3:) )
      end if
      open ( u_diag, file=trim(adjustl(arg(3:))), form='formatted' )
      do_diag = .true.
    case ( 'l' )
      do_list = .true.
    case ( 'n' )
      if ( arg(3:) == '' ) then
        argNum = argNum + 1
        call get_command_argument ( argNum, arg(3:) )
      end if
      deck_id = arg(3:)
    case ( 'o' )
      if ( arg(3:) == '' ) then
        argNum = argNum + 1
        call get_command_argument ( argNum, arg(3:) )
      end if
      open ( u_obj, file=trim(adjustl(arg(3:))), form='formatted' )
      do_object = .true.
    case ( 'S' )
      detail = .true.
    case ( 't' )
      if ( arg(3:) == '' ) then
        argNum = argNum + 1
        call get_command_argument ( argNum, arg(3:) )
      end if
      open ( u_tape, file=trim(adjustl(arg(3:))), form='formatted' )
      do_tape = .true.
    case ( 'T' )
      if ( arg(3:) == '' ) then
        argNum = argNum + 1
        call get_command_argument ( argNum, arg(3:) )
      end if
      trace = adjustl(arg(3:))
    case ( 'V' )
      print '(a)', version
      stop
    case ( 'x' )
      no_re_ex = .true.
    case ( ' ' )
      argNum = argNum + 1
      call get_command_argument ( argNum, arg )
      exit
    case default
      if ( arg(2:) == '-keepscratch' ) then
        keep = .true.
        cycle
      end if
      call get_command_argument ( 0, arg )
      print *, 'Usage: ' // trim(arg) // ' [options] control-file'
      print *, ' Options:'
      print *, '  -a => Annotate outputs with segment and IN file names,'
      print *, '        but not DATA file names'
      print *, '  -A => Annotate outputs with segment names, IN file names,'
      print *, '        and DATA file names'
      print *, '  -b[ ]X[#] => Select boot loader;'
      print *, '     X = I => IBM, # is the core size selector:'
      print *, '       0 => Boot, no clear, sequence numbers start at 3,'
      print *, '       1 => 1400, 2 => 2000, 4 => 4000, 8 => 8000,'
      print *, '       v => 12000, x => 16000.  Default ', coreSize
      print *, '     X = N => None,'
      print *, '     X = B => Van''s favorite 1-card boot/no clear,'
      print *, '     X = V => Van''s favorite 2-card boot/clear,'
      print *, '  -c[ ]file => Bootable core-image ``tape'''
      print *, '  -d[ ]file => Diagnostic format output "deck"'
      print *, '  -l => List the control file'
      print *, '  -n[ ]id => ID for output, overridden by ID in control file'
      print *, '  -o[ ]file => Autocoder format output "deck"'
      print *, '  -S => Symbol table list shows address, LC, file and segment'
      print *, '        Default is only address'
      print *, '  -t[ ]file => Output "tape"'
      print *, '  -V => print version info and stop'
      print *, '  -x => do not emit a card or tape record to re-create the'
      print *, '        bootstrap environment after an EX or XFR command'
      print *, '  -h => print this information and stop'
      print *, trim(version)
      stop
    end select
  end do

  open ( u_cont, file=trim(arg), form='formatted', status='old' )
  open ( u_scratch, file='linkScratch', form='formatted' )

  allocate ( segs(10), syms(100) )

  ! Process the control file
  call read_cont ( *6 )
  call up ( arg )
  do
    if ( arg(1:3) == 'ID' ) then
      arg = adjustl(arg(4:))
      deck_id = arg
      if ( deck_id /= arg ) &
        & call errMsg ( 'Only first five characters of deck ID used' )
    else if ( arg(1:5) == 'SKIP' ) then
      arg = adjustl(arg(6:))
      read ( arg, * ) skip
    else
      exit
    end if  
    call read_cont ( *6 )
    call up ( arg )
  end do

  do
    arg = adjustl(arg)
    if ( arg(1:4) == 'END' ) then
      arg = adjustl(arg(5:))
      i = scan(arg,'!')
      if ( i > 0 ) arg(i:) = ''
      call up ( arg )
      if ( arg /= '' ) then
        ! Save the entry label or address
        read ( arg, *, iostat=j ) i
        if ( j == 0 ) then
          entAdr = i
        else
          ent = arg
          if ( ent /= arg ) call errMsg ( &
            & 'Only first five characters of entry label ' // &
            & trim(arg) // ' used.' )
        end if
      end if
      exit
    end if

    ! Process a SEG command
    if ( arg(1:4) /= 'SEG' ) then
      call errMsg ( 'SEG expected' )
      error = .true.
      call read_cont ( *6 )
      call up ( arg )
      cycle
    end if

    call seg_command

    n_files = 0

    do
      call read_cont ( *6 )
      i = scan(arg,' ')
      call up ( arg(1:i-1) )
      if ( arg(1:3) /= 'IN ' .and. arg(1:5) /= 'DATA ' .and. &
         & arg(1:8) /= 'SEQDATA' ) exit
      inType = arg(1:1) ! Needed because In_Command clobbers ARG
      call in_command ( inType )
    end do ! IN commands in one seg

    ! Copy the linked list of file information to the seg's array
    if ( n_files == 0 ) call errMsg ( &
      & 'No files in segment ' // trim(segs(n_segs)%name) )
    allocate ( segs(n_segs)%files(n_files) )
    do j = n_files, 1, -1
      segs(n_segs)%files(j) = fileList
      tempFile => fileList
      fileList => fileList%next
      deallocate ( tempFile )
    end do

  end do ! loop over SEG commands and their IN commands
6 continue

  if ( index(trace,'S') /= 0 ) call dump_seg_table

  if ( error ) then
    print '("Errors in control file.  Processing terminated.")'
    stop
  end if

  call analyze_symtab
  call compute_addr

  if ( ent /= '' ) then
    read ( ent, *, iostat=i ) entAdr
    if ( i /= 0 ) then
      i = findLabel ( ent )
      if ( i == 0 ) then
        call errMsg ( 'Entry label ' // trim(ent) // ' not found.' )
        error = .true.
      else
        if ( syms(i)%dev(1:1) == '%' ) then
          call errMsg ( 'Entry ' // trim(ent) // ' cannot be ' // syms(i)%dev )
        else
          entAdr = syms(i)%addr
        end if
      end if
    end if
  end if

  if ( error ) then
    print '("Errors in control file.  Processing terminated.")'
    stop
  end if

  call seg_print

  if ( undef ) then
    call errMsg ( 'Cannot resolve segment or location counter origins.' )
    call errMsg ( 'Could be due to undefined labels or circular dependence.' )
  else if ( .not. error ) then
    write ( *, '(/"Entry address: ", i0/)' ) entAdr
    if ( do_object .or. do_tape .or. do_diag .or. do_core ) then
      end file u_scratch
      rewind u_scratch
      call pass_2
    end if

    if ( do_core ) call write_core ( entAdr )
  end if

  close ( u_scratch, status=merge('keep  ','delete',keep) )

contains

  subroutine Analyze_Symtab
    ! Look for symbol table entries defined in terms of others and resolve
    ! them to addresses or devices if possible.
    integer :: I
    integer :: OFF(n_syms)
    integer :: S
    logical :: Visited(n_syms)
    do i = 1, n_syms
      visited = .false.
      if ( syms(i)%equ /= '' .and. syms(i)%addr < 0 ) then
        s = i
        off(i) = syms(i)%off
        do
          visited(s) = .true.
          s = findLabel(syms(s)%equ)
          if ( s == 0 ) exit
          if ( visited(s) ) then
            call errMsg ( 'Circular dependence for definition of ' // &
              & trim(syms(i)%label) )
            syms(i)%addr = -9999
            exit
          end if
          if ( syms(s)%dev /= '' ) then
            syms(i)%dev = syms(s)%dev
            exit
          end if
          off(i) = off(i) + syms(s)%off
          if ( syms(s)%equ == '' ) then
            syms(i)%ultimate = s
            if ( segs(syms(s)%seg)%files(syms(s)%file)%lc_rel(syms(s)%lc) ) then
              if ( syms(i)%ix == 0 ) syms(i)%ix = syms(s)%ix
              syms(i)%addr = -9999 ! < 0 Means not yet defined
            else
              syms(i)%lc = syms(s)%lc
              syms(i)%file = syms(s)%file
              if ( syms(i)%ix == 0 ) syms(i)%ix = syms(s)%ix
            end if
            exit
          end if
        end do
      end if
    end do
    where ( syms(:n_syms)%ultimate /= 0 ) syms(:n_syms)%off = off
  end subroutine Analyze_Symtab

  subroutine Compute_Addr
    ! Compute addresses and ranges of location counters in
    ! every file in every segment
    logical :: Change       ! A segment was defined, maybe looping will help
    logical :: Dup          ! There were duplicate labels
    integer :: I, J, K, L
    character(255) :: Line  ! For composing a print line
    integer :: MN, MX       ! Min and Max absolute location counter
    integer :: N            ! Length of a location counter
    integer :: P            ! pv(j) while printing sorted symbol table
    integer :: PV(n_syms)   ! For sorting the symbol table
    integer :: U            ! Ultimate definition for symbol, maybe itself

    change = .true.
    undef = .true.
    do while ( undef )
      if ( .not. change ) then
        write ( *, '(a)' ) '*** Undefined symbols remain but no change occurred'
        write ( *, '(a)' ) '*** There must be a circular dependence'
        exit
      end if
      change = .false.
      undef = .false.
      do i = 1, n_segs
        if ( segs(i)%def ) cycle
        ! Compute minimum and maximum of absolute addresses in the segment
        mn = 16000
        mx = 0
        do k = 1, size(segs(i)%files)
          mx = max(mx,maxval(segs(i)%files(k)%lc_max, .not.segs(i)%files(k)%lc_rel))
          mn = min(mn,minval(segs(i)%files(k)%lc_min, &
             &     .not.segs(i)%files(k)%lc_rel .and. segs(i)%files(k)%lc_max >= 0))
        end do
        segs(i)%min = mn
        segs(i)%max = mx
        ! Compute starting address for relocatable location counters in the segment
        if ( segs(i)%atlabel /= '' ) then ! Starting at a label
          j = findLabel(segs(i)%atlabel) ! Label was earlier checked to exist
          if ( syms(j)%dev(1:1) == '%' ) then
            call errMsg ( 'Cannot relocate to ' // syms(j)%dev )
            segs(i)%def = .true. ! Don't give the error message more than once
          else if ( segs(syms(j)%seg)%def ) then
            change = .true.
            segs(i)%def = .true.
            segs(i)%start = syms(j)%addr + segs(i)%offset
            segs(i)%def = .true.
          else
            undef = .true.
            cycle
          end if
        else if ( segs(i)%endAt ) then ! Ending at the end of core
        ! Compute total size of all relocatable location counters in the segment
          n = 0
          do k = 1, size(segs(i)%files)
            n = n + sum((segs(i)%files(k)%lc_max-segs(i)%files(k)%lc_min+1), &
                       & segs(i)%files(k)%lc_rel)                     
          end do
          segs(i)%start = segs(i)%end - n + 1
          segs(i)%def = .true.
          change = .true.
        else if ( size(segs(i)%others) /= 0 ) then ! Defined in terms of others
          if ( all(segs(segs(i)%others)%def) ) then
            if ( segs(i)%after ) then
              segs(i)%start = maxval(segs(segs(i)%others)%end) + 1
            else
              segs(i)%start = maxval(segs(segs(i)%others)%start)
            end if
            segs(i)%def = .true.
            change = .true.
          end if
        else ! Relocatables start after its own absolutes
          segs(i)%def = .true.
        end if
        segs(i)%start = max(1,segs(i)%max + 1,segs(i)%start)
        segs(i)%end = segs(i)%start - 1
        ! Compute starting and ending addresses of relocatable location counters
        do k = 1, size(segs(i)%files)
          do j = 0, LC_max
            if ( segs(i)%files(k)%lc_rel(j) ) then
              n = segs(i)%files(k)%lc_max(j) - segs(i)%files(k)%lc_min(j) + 1
              if ( segs(i)%files(k)%lc_ext(j) /= '' .and. &
                 & .not. segs(i)%files(k)%lc_def(j) ) then
                l = findLabel(segs(i)%files(k)%lc_ext(j))
                if ( l == 0 ) then
                  call errMsg ( 'Reference to undefined label "' // &
                    & trim(segs(i)%files(k)%lc_ext(j)) // &
                    & '" for LC origin in ' // trim(segs(i)%files(k)%name) )
                  cycle
                end if
                if ( segs(syms(l)%seg)%def ) then
                  change = .true.
                  segs(i)%files(k)%lc_def(j) = .true.
                  segs(i)%files(k)%lc_start(j) = syms(l)%addr + segs(i)%files(k)%lc_off(j)
                  segs(i)%def = .true.
                else
                  change = .true.
                  undef = .true.
                  segs(i)%def = .false.
                  cycle
                end if
              else ! Relocatable but not to an external label
                segs(i)%files(k)%lc_start(j) = max(segs(i)%end,segs(i)%max) + 1
                if ( segs(i)%files(k)%lc_x00(j) ) then
                  if ( segs(i)%files(k)%lc_start(j) - &
                     & mod(segs(i)%files(k)%lc_start(j),100) + &
                     & segs(i)%files(k)%lc_off(j) < segs(i)%files(k)%lc_start(j) ) &
                       & segs(i)%files(k)%lc_start(j) = &
                         & segs(i)%files(k)%lc_start(j) + 100
                  segs(i)%files(k)%lc_start(j) = segs(i)%files(k)%lc_start(j) - &
                     & mod(segs(i)%files(k)%lc_start(j),100) + &
                     & segs(i)%files(k)%lc_off(j)
                end if
              end if
              segs(i)%files(k)%lc_end(j) = segs(i)%files(k)%lc_start(j) + n - 1
              segs(i)%end = max(segs(i)%end,segs(i)%files(k)%lc_end(j))
              segs(i)%files(k)%lc_def(j) = .true.
            else
              segs(i)%files(k)%lc_start(j) = segs(i)%files(k)%lc_min(j)
              segs(i)%files(k)%lc_end(j) = segs(i)%files(k)%lc_max(j)
              segs(i)%files(k)%lc_def(j) = segs(i)%files(k)%lc_max(j) >= &
                                         & segs(i)%files(k)%lc_min(j)
            end if
          end do ! Location counters
          ! Define some more global symbols
          do j = segs(i)%files(k)%firstSym, segs(i)%files(k)%lastSym
            u = syms(j)%ultimate
            if ( u == 0 ) u = j
            if ( syms(u)%dev(1:1) /= '%' ) then
              if ( u == j ) then
                if ( segs(i)%files(k)%lc_def(syms(u)%lc) .and. &
                 & ( segs(i)%files(k)%lc_rel(syms(u)%lc) .or. &
                 &   segs(i)%files(k)%lc_x00(syms(u)%lc) .or. &
                 &   segs(i)%files(k)%lc_ext(syms(u)%lc) /= '' ) ) &
                 syms(j)%addr = syms(u)%addr + segs(i)%files(k)%lc_start(syms(u)%lc)
                 change = .true.
              else
                if ( syms(u)%addr < 0 ) then
                  undef = .true.
                else
                  syms(j)%addr = syms(u)%addr + syms(j)%off
                end if
              end if
            end if
          end do ! Labels
        end do ! Files
      end do ! Segments
    end do ! Change

    ! Sort the symbol table
    pv = (/ ( i, i = 1, n_syms ) /)
    do i = 2, n_syms
      do j = 1, i - 1
        if ( syms(pv(i))%label < syms(pv(j))%label ) then
          k = pv(i)
          pv(i) = pv(j)
          pv(j) = k
        end if
      end do
    end do

    ! Detect and mark duplicates
    dup = .false.
    do i = 2, n_syms
      if ( syms(pv(i))%label == syms(pv(i-1))%label ) then
        syms(pv(i))%dup = '#'
        syms(pv(i-1))%dup = '#'
        dup = .true.
      end if
    end do

    ! Print the symbol table
    if ( n_syms > 0 ) then
      if ( dup ) then
        write ( *, '(/"Symbol table. # means duplicated label.")' )
      else
        write ( *, '(/"Symbol table.")' )
      end if
      if ( detail ) then
        write ( *, '(" LABEL    ABS   REL:LC  SEG           FILE")' )
        do j = 1, n_syms
          p = pv(j)
          if ( syms(p)%dev(1:1) /= '%' ) then
            write ( line, '(a1,a6,i6)' ) &
              & syms(p)%dup, syms(p)%label, syms(p)%addr
            if ( segs(syms(p)%seg)%files(syms(p)%file)% &
              &   lc_rel(syms(p)%lc) ) then
              write ( line(14:), '(i6,":",i0)' ) &
                & syms(p)%addr - &
                &  segs(syms(p)%seg)%files(syms(p)%file)% &
                &   lc_start(syms(p)%lc), syms(p)%lc
            else
              write ( line(20:), '(":",i0)' ) syms(p)%lc
            end if
            write ( *, '(a,a12,2x,a)' ) &
              & line(:24), segs(syms(p)%seg)%name , &
              & trim(segs(syms(p)%seg)%files(syms(p)%file)%name)
          else
            write ( *, '(a1,a6,3x,a3,4x,t25,a12,2x,a)' ) &
              & syms(p)%dup, syms(p)%label, syms(p)%dev , &
              & segs(syms(p)%seg)%name, &
              & trim(segs(syms(p)%seg)%files(syms(p)%file)%name)
          end if
          if ( syms(p)%ultimate /= 0 ) then
            l = syms(p)%ultimate
            write ( *, '("  EQU ",a,sp,i0)', advance='no' ) &
              & trim(syms(l)%label), syms(p)%off
            if ( syms(p)%ix /= 0 ) &
              & write ( *, '("+X",i0)', advance='no' ) syms(p)%ix
            write ( *, '( " in LC ",i0," in file ",a," in SEG ",a)' ) &
              syms(l)%lc, &
              trim(segs(syms(l)%seg)%files(syms(l)%file)%name), &
              trim(segs(syms(l)%seg)%name)
          end if
        end do
      else
        do i = 1, n_syms, 7
          do j = i, min(i+6,n_syms)
            if ( j > i ) write ( *, '(" ")', advance='no' )
            if ( syms(pv(j))%dev(1:1) /= '%' ) then
              write ( *, '(a1,a6,i6)', &
                      & advance=merge('yes','no ',j==min(i+6,n_syms)) ) &
                & syms(pv(j))%dup, syms(pv(j))%label, syms(pv(j))%addr
            else
              write ( *, '(a1,a6,3x,a3)', &
                      & advance=merge('yes','no ',j==min(i+6,n_syms)) ) &
                & syms(pv(j))%dup, syms(pv(j))%label, syms(pv(j))%dev
            end if
          end do
        end do
      end if
    end if

  end subroutine Compute_Addr

  subroutine Core_Dump
    integer :: I
    do i = 1, 15999, 100
      ! Don't dump areas not yet initialized
      if ( verify(core(i:min(i+99,15999)),'z') /= 0 ) &
        & write ( *, '(i5,": ",a)' ) i, core(i:min(i+99,15999))
    end do
  end subroutine Core_Dump

  subroutine Dump_Seg_Table
    integer :: J, Seg
    do seg = 1, n_segs
      write ( *, 1 ) trim(segs(seg)%name), trim(segs(seg)%atLabel), &
        & segs(seg)%offset, segs(seg)%min, &
        & segs(seg)%max, segs(seg)%start, segs(seg)%end, segs(seg)%size_Rel, &
        & segs(seg)%after, segs(seg)%endAt
    1 format ( 'SEG ', a, ' at "', a, '"', sp, i0, ss, ', Min = ', i0, ', Max = ', i0, &
             & ', Start = ', i0, ', End = ', i0, ', Size_Rel = ', i0, &
             & ', After = ', l1, ', EndAt = ', l1 )
      if ( size(segs(seg)%others) /= 0 ) then
        write ( *, '(1x,a)', advance='no' ) trim(merge('After','At   ',segs(seg)%after))
        do j = 1, size(segs(seg)%others)
          write ( *, '(1x,a)', advance='no' ) trim(segs(segs(seg)%others(j))%name)
        end do
        write ( *, * )
      end if
      if ( size(segs(seg)%files) /= 0 ) then
        call printFile ( segs(seg)%files )
      end if
    end do
  end subroutine Dump_Seg_Table

  subroutine ErrMsg ( Msg )
    character(*), intent(in) :: Msg
    write ( *, '("*** ",a)' ) trim(msg)
  end subroutine ErrMsg

  integer function FindLabel ( Label )
    ! Return index is syms of Label
    character(6), intent(in) :: Label
    do findLabel = 1, n_syms
      if ( syms(findLabel)%label == label ) return
    end do
    findLabel = 0
  end function FindLabel

  subroutine In_Command ( Data )
    character, intent(in) :: Data ! I => In, D => Data, S => SeqData
    logical :: Exist
    integer :: Clear ! Size to clear
    ! Process an IN command
    i = scan(arg,' ')
    do
      arg = adjustl(arg(i+1:))
      if ( arg == '' ) exit
      ! Get the file name
      i = scan(arg,' ')
      n_files = n_files + 1
      ! Create a file list item for the seg
      allocate ( tempFile )
      tempFile%name = arg(:i-1)
      tempFile%next => fileList
      fileList => tempFile
      ! Initialize the segment memory information
      fileList%lc_min = 16000
      fileList%lc_max = -1
      fileList%lc_start = 16000
      fileList%lc_end = -1
      fileList%lc_def = .false.
      fileList%lc_rel = .false.
      fileList%lc_x00 = .false.
      fileList%lc_off = 0
      fileList%firstSym = n_syms + 1
      fileList%lastSym = n_syms
      fileList%data = data
      write ( u_scratch, r_fmt ) 'N', '', n_segs, n_files
      ! Make sure the data file exists
      if ( data /= 'I' ) then
        inquire ( file=arg(:i-1), exist=exist )
        if ( .not. exist ) then
          call errMsg ( 'Data file ' // arg(:i-1) // ' does not exist' )
          error = .true.
        end if
        cycle
      end if
      ! Open and Read the .r file
      open ( u_rel, file=arg(:i-1), form='formatted', status='old', iostat=j )
      if ( j /= 0 ) then
        call errMsg ( 'Unable to open ' // arg(:i-1) )
        error = .true.
        cycle
      end if
      do
        read ( u_rel, r_fmt, end=8 ) r
        write ( u_scratch, r_fmt ) r
        select case ( r%what )
        case ( 'A', 'C' ) ! Area, Clear
          read ( r%field(7:12), '(i6)' ) clear
          fileList%lc_min(r%loc) = &
            & min(fileList%lc_min(r%loc),r%adr)
          fileList%lc_max(r%loc) = &
            & max(fileList%lc_max(r%loc),r%adr+max(0,clear-1))
          fileList%lc_rel(r%loc) = r%r == 'R'
        case ( 'D' ) ! Label definition
          call incSyms
          syms(n_syms)%label = r%label
          syms(n_syms)%addr = r%adr
          syms(n_syms)%lc = r%loc
          syms(n_syms)%file = n_files
          syms(n_syms)%seg = n_segs
          if ( r%field(1:1) == '%' ) then
            syms(n_syms)%dev = r%field
          else
            syms(n_syms)%equ = r%field
          end if
          fileList%lastSym = n_syms
          read ( r%field(7:12), '(i6)' ) syms(n_syms)%off
          if ( r%adr >= 0 .and. r%field(1:6) == '' ) then
            ! Only do this for something other than a definition in
            ! terms of an external label
            fileList%lc_min(r%loc) = &
              & min(fileList%lc_min(r%loc),r%adr)
            fileList%lc_max(r%loc) = &
              & max(fileList%lc_max(r%loc),r%adr-1)
          end if
          fileList%lc_rel(r%loc) = r%r == 'R'
        case ( 'F' ) ! Field
          fileList%lc_min(r%loc) = &
            & min(fileList%lc_min(r%loc),r%adr)
          fileList%lc_max(r%loc) = &
            & max(fileList%lc_max(r%loc),r%adr+max(0,r%len-1))
          fileList%lc_rel(r%loc) = r%r == 'R'
        case ( 'L' ) ! Externally org'd location counter
          fileList%lc_x00(r%loc) = .false.
          fileList%lc_off(r%loc) = r%adr
          fileList%lc_ext(r%loc) = r%field(1:6)
          fileList%lc_def(r%loc) = .false.
          fileList%lc_rel(r%loc) = r%r == 'R'
        case ( '0' ) ! x00 location counter
          fileList%lc_x00(r%loc) = .true.
          fileList%lc_off(r%loc) = r%adr
          fileList%lc_rel(r%loc) = r%r == 'R'
          if ( segs(n_segs)%endAt ) then
            call errMsg ( &
              & 'Location counters with X00 origin not permitted in EndAt segments' )
            error = .true.
          end if
        end select
      end do
    8 close ( u_rel )
      do j = 0, LC_Max
        if ( fileList%lc_min(j) < fileList%lc_max(j) ) then
          if ( fileList%lc_rel(j) ) then
            segs(n_segs)%size_rel = segs(n_segs)%size_rel + &
            & fileList%lc_max(j) - fileList%lc_min(j) + 1
          else
            segs(n_segs)%min = &
              & min(segs(n_segs)%min,fileList%lc_min(j))
            segs(n_segs)%max = &
              & max(segs(n_segs)%max,fileList%lc_max(j))
          end if
        end if
      end do
    end do
  end subroutine In_Command

  subroutine IncSyms
  type(sym), pointer :: Temp_Syms(:)
    n_syms = n_syms + 1
    if ( n_syms > size(syms) ) then
      allocate ( temp_syms(2*size(syms)) )
      temp_syms(:size(syms)) = syms
      deallocate ( syms )
      syms => temp_syms
    end if
  end subroutine IncSyms

  subroutine Pass_2
    use BCD_to_ASCII_m, only: BCD_TO_ASCII, B_GRPMRK, B_WM
    use Bootstrap_m, only: Bootloader, Bootstrap, BOOT_T, BOOT_TW, BOOT_V, &
      & CoreSize, CS1_4, CS1_6, CS2_4, CS2_6, CST, CSTW, CS_V
    use IO_Units, only: U_Input, U_Obj
    use Object_m, only: Card, Card_No, Do_Object, Finish_Obj, Num_Load_Ops, &
      & Obj_Pos, SW, Write_Tape
    use Zone_m, only: Addr_To_Num, Init_Zoned, Num_To_Addr

    character(16000) :: Clear = ''
    integer :: File            ! Which file in SEG are we working on
    character(80) :: Loader(3) ! Boot loader cards
    integer :: I, J
    integer :: Index           ! From an address or from R
    character(80) :: Line
    integer :: Num             ! Corresponding to an address
    integer :: Num_Load_Cds    ! for bootstrap loader
    integer :: Off             ! Offset from label, from R
    integer :: P               ! Absolute or relocated load address
    logical :: Pending         ! Output of field is pending
    type(r_file) :: R, RP      ! From input, pending output
    integer :: Seg             ! Which seg are we working on

    call init_zoned

    card_no = 0
    n_diag = 1
    seg = 0

    ! Bootstrap
    if ( do_core ) then
      core = repeat('z',16000)
      wm = ''
    end if

    if ( do_diag ) &
      & write ( u_diag, '(",0080121001",t49,a24,i5.5," 0A")' ) '', n_diag

    if ( do_object ) then
      card_no = 1
      num_load_cds = 3
      select case ( bootLoader )
      case ( 'B')
        num_load_cds = 1
        loader(1) = boot_v
      case ( 'I' )
        if ( coreSize <= 4000 ) then
          loader = (/ cs1_4, cs2_4, bootstrap /)
          if ( coreSize == 0 ) then ! Boot only, no clear
            num_load_cds = 1
            card_no = 3
          end if
        else
          loader = (/ cs1_6, cs2_6, bootstrap /)
        end if
        call num_to_addr ( coreSize-1, 0, loader(2)(27:29) )
      case ( 'V' )
        num_load_cds = 2
        loader(1:2) = (/ cs_v, boot_v /)
      end select
      do i = card_no, card_no+num_load_cds-1
        card = loader(i)
        call finish_obj ( 0 ) ! LC doesn't matter here
      end do
    end if

    if ( do_tape ) then
      call write_tape ( cst, cstw, 80 )
!       call write_tape ( boot_t, boot_tw, 80 )
    end if

    pending = .false.
    after_EX = .false.
    do
      read ( u_scratch, r_fmt, end=9 ) r
      if ( pending .and. r%what /= 'R' ) then
        call write_field ( p, rp%field(:rp%len), rp%wm, rp%text )
        pending = .false.
      end if
      select case ( r%what )
      case ( 'C' ) ! Clear field of width FIELD(1:5) at ADR in LOC
        read ( r%field(7:12), '(i6)' ) i
        p = r%adr
        if ( r%r == 'R' ) p = p + segs(seg)%files(file)%lc_start(r%loc)
        call write_field ( p, clear(1:i), r%wm )
      case ( 'D' ) ! Handled in pass 1
      case ( 'E' ) ! END
        if ( do_object ) then
          if ( obj_pos > 0 .or. num_load_ops > 0 ) call finish_obj ( 0, '1040' )
        end if
        if ( entAdr >= 0 ) then
          if ( r%label /= '' ) then
            i = findLabel ( r%label )
            if ( i == 0 ) then
              call errMsg ( 'Reference to undefined label "' // trim(r%label) // &
                & '" at ' // r%line // ' in ' // trim(segs(seg)%files(file)%name) )
            else
              entAdr = syms(i)%addr
            end if
          else if ( r%adr /= 0 ) then
            entAdr = r%adr + merge(segs(seg)%files(file)%lc_start(r%loc), 0, &
                                  &segs(seg)%files(file)%lc_rel(r%loc))
          end if
        end if
        if ( do_core .and. r%label /= '' ) call write_core ( entAdr )
      case ( 'F' ) ! Field
        if ( after_EX ) call write_EX_restart
        p = r%adr
        if ( r%r == 'R' ) p = p + segs(seg)%files(file)%lc_start(r%loc)
        if ( r%len == 0 .and. r%wm == 'W' ) then
          if ( num_load_ops  >= 6 ) call finish_obj ( 0, '1040' )
          call sw ( p, 0 )
        else
          rp = r
          do i = 1, 2
            ! Relocate addresses in field if necessary
            if ( r%fr(i) /= 0 ) then
              call addr_to_num ( rp%field(rp%fr(i):rp%fr(i)+2), num, index )
              num = num + segs(seg)%files(file)%lc_start(r%lcr(i))
              call num_to_addr ( num, index, rp%field(rp%fr(i):rp%fr(i)+2) )
            end if
          end do
          pending = .true.
        end if
      case ( 'N' ) ! File number in segment
        seg = r%adr
        file = r%loc
        if ( segs(seg)%files(file)%data /= 'I' ) then
          call write_comment ( 'DATA ' // trim(segs(seg)%files(file)%name), &
                             & data=.true. )
          open ( u_input, file=trim(segs(seg)%files(file)%name), &
          & form='formatted', status='old', iostat=j )
          if ( j /= 0 ) then
            call errMsg ( 'Unable to open ' // trim(segs(seg)%files(file)%name) )
            cycle
          end if
          do
            read ( u_input, '(a)', end=5 ) line
            if ( segs(seg)%files(file)%data == 'D' ) then
              if ( do_diag ) write ( u_diag, '(a)' ) trim(line)
              if ( do_object ) write ( u_obj, '(a)' ) trim(line)
            else
              if ( do_diag ) write ( u_diag, 2 ) line(1:71), Card_No, Deck_ID
              if ( do_object ) write ( u_obj, 2 ) line(1:71), Card_No, Deck_ID
              card_no = card_no + 1
            2 format ( a71, i4.4, a5 )
            end if
            if ( do_core ) write ( u_core, '(a)' ) trim(line)
            if ( do_tape ) write ( u_tape, '(3a)' ) trim(line), &
                             & bcd_to_ascii(B_WM), bcd_to_ascii(B_GRPMRK)
          end do
        5 continue
          close ( u_input )
        else
          call write_comment ( 'IN ' // trim(segs(seg)%files(file)%name) )
        end if
        if ( after_EX ) call write_EX_restart
      case ( 'R' ) ! Relocate an external reference
        i = findLabel ( r%label )
        if ( i == 0 ) then
          call errMsg ( 'Reference to undefined label "' // trim(r%label) // &
            & '" at ' // r%line // ' in ' // trim(segs(seg)%files(file)%name) )
        else if ( syms(i)%addr < 0 ) then
          call errMsg ( 'Reference to undefined label "' // trim(r%label) // &
            & '" at ' // r%line // ' in ' // trim(segs(seg)%files(file)%name) )
        else
          read ( r%field(7:12), '(i6)' ) off
          num = syms(i)%addr + off
          i = r%adr - rp%adr - 1 ! Where in rp%field to put the address
          call num_to_addr ( num, r%ix, rp%field(i:i+2) )
        end if
      case ( 'S' ) ! Segment number
        if ( do_core .and. r%adr > 1 ) call write_core ( entAdr )
        call write_comment ( 'SEG ' // trim(segs(r%adr)%name) )
        seg = r%adr
      case ( 'X' ) ! EX or XFR
        if ( r%label /= '' ) then
          i = findLabel ( r%label )
          if ( i == 0 ) then
            call errMsg ( 'Reference to undefined label "' // trim(r%label) // &
              & '" at ' // r%line // ' in ' // trim(segs(seg)%files(file)%name) )
          else
            call write_ex ( syms(i)%addr )
          end if
        else
          call write_ex ( r%adr + &
                        & merge(segs(seg)%files(file)%lc_start(r%loc), 0, &
                               &segs(seg)%files(file)%lc_rel(r%loc)) )
        end if
      end select
    end do
  9 continue
    if ( after_EX ) call write_EX_restart
    call write_end
  end subroutine Pass_2

  subroutine PrintFile ( Files )
  ! Print the file information for a segment
    type(segFile), intent(in) :: Files(:)
    integer :: J, K, W
  ! integer :: L
    character(255) :: Line
    character(*), parameter :: What(3) = (/ 'IN  ', 'DATA', 'SEQ ' /)
    logical :: NeedFile
    do k = 1, size(files)
      do w = 1, size(what)
        if ( what(w)(1:1) == files(k)%data ) exit
      end do
      if ( w > 1 ) then ! Not IN, so no LC's
        write ( *, '(t55,a,1x,a)' ) &
          & trim(what(w)), trim(files(k)%name)
        cycle
      end if
      needFile = .true.
      do j = 0, LC_Max
        if ( files(k)%lc_def(j) ) then
          if ( files(k)%lc_start(j) >= 0 .and. &
             & files(k)%lc_end(j) >= 0 ) then
            write ( line, '(i8, ": ", i5.5, "-", i5.5)' ) &
              & j, files(k)%lc_start(j), files(k)%lc_end(j)
          else
            write ( line, '(i8, ": Empty")' ) j
          end if
          if ( files(k)%lc_rel(j) ) then
            line(22:) = " Relocatable"
            if ( files(k)%lc_x00(j) ) then
              write ( line(34:), '(" at X00", sp, i0)' ) &
                & files(k)%lc_off(j)
            else if ( files(k)%lc_ext(j) /= '' ) then
              ! l = findLabel ( files(k)%lc_ext(j) )
              write ( line(34:), '(" at ",a,"+",i0:" = ",i0)') &
                & trim(files(k)%lc_ext(j)), files(k)%lc_off(j) ! &
              ! &, syms(l)%addr + files(k)%lc_off(j)
            end if
          else
            line(22:) = " Absolute"
          end if
          if ( files(k)%lc_start(j) > files(k)%lc_end(j) ) &
            & line = trim(line) // " is empty"
          if ( needFile ) &
          & line(55:) = trim(what(w)) // ' ' // files(k)%name
          needFile = .false.
          write ( *, '(a)' ) trim(line)
        else if ( files(k)%lc_rel(j) ) then
          write ( *, '(i8, ": Start address undefined")' ) j
        end if
      end do
    end do
  end subroutine PrintFile

  subroutine Read_Cont ( * )
    integer, save :: N_Card = 0
    do
      read ( u_cont, '(a)', end=9 ) arg
      n_card = n_card + 1
      if ( do_list ) write ( *, '(i4, ": ", a)' ) n_card, trim(arg)
      arg = adjustl(arg)
      if ( arg /= '' .and. arg(1:1) /= '*' .and. arg(1:1) /= '!' ) exit
    end do
    return
  9 return 1
  end subroutine Read_Cont

  subroutine Seg_Command
    integer :: L ! Index of a label in the symbol table, or a string index
    call up ( arg )
    l = scan(arg,'!')
    if ( l /= 0 ) arg(l:) = '' ! Trim off comments
    arg = adjustl(arg(5:)) ! Trim off SEG
    n_segs = n_segs + 1
    if ( n_segs > size(segs) ) then ! Get more SEG table space
      temp_segs => segs
      l = 2*size(segs)
      allocate ( segs(l) )
      segs(:size(temp_segs)) = temp_segs
      deallocate ( temp_segs )
    end if
    i = scan(arg,' ')
    if ( i > 13 ) call errmsg ( 'Only first twelve characters of segment name used' )
    segs(n_segs)%name = arg(:min(i-1,6))
    segs(n_segs)%min = 16000
    segs(n_segs)%max = -1
    segs(n_segs)%start = 0
    segs(n_segs)%end = 0
    segs(n_segs)%size_rel = 0
    allocate ( segs(n_segs)%others(1:0) )
    arg = adjustl(arg(i+1:)) ! Trim off SEG name
    if ( arg /= '' ) then
      read ( arg, *, iostat=j ) i
      if ( j == 0 ) then
        segs(n_segs)%start = i
        if ( i < 0 ) then
          segs(n_segs)%end = -i
          segs(n_segs)%endAt = .true.
        end if
      else if ( arg(1:1) == '*' ) then
        arg = adjustl(arg(2:))
        l = scan(arg,' +-')
        segs(n_segs)%atLabel = adjustl(arg(:l-1))
        if ( segs(n_segs)%atLabel /= adjustl(arg(:l-1)) ) call errMsg ( &
          & 'Only first six characters of label ' // trim(adjustl(arg(2:))) // &
          & ' used.' )
        arg = adjustl(arg(l:))
        if ( arg(1:1) /= '' ) then
          do ! Squeeze out blanks
            l = scan(arg,' ')
            if ( arg(l:) == '' ) exit
            arg(l:) = adjustl(arg(l+1:))
          end do
          read ( arg, *, iostat=l ) segs(n_segs)%offset
          if ( l /= 0 ) then
            segs(n_segs)%offset = 0
            call errMsg ( 'Offset must be numeric' )
            error = .true.
          end if
        end if
        l = findLabel ( segs(n_segs)%atLabel )
        if ( l == 0 ) then
          call errMsg ( 'Label ' // trim(segs(n_segs)%atLabel) // ' not found' )
          error = .true.
        end if
      else
        if ( arg(1:1) == '(' ) then
          arg = adjustl(arg(2:))
          segs(n_segs)%after = .true.
        end if
        do while ( arg /= '' )
          call seg_lookup
          if ( arg(1:1) == ')' ) then
            if ( segs(n_segs)%after ) then
              if ( arg(2:) /= '' ) then
                call errMsg ( 'Syntax error: junk after ")"' )
                error = .true.
              end if
              exit
            end if
            call errMsg ( 'Syntax error: ")" not expected' )
            error = .true.
            exit
          else if ( arg == '' ) then
            if ( segs(n_segs)%after ) then
              call errMsg ( 'Syntax error: ")" expected' )
              error = .true.
            end if
            exit
          end if
        end do
      end if
    end if
    write ( u_scratch, r_fmt ) 'S', segs(n_segs)%name, n_segs
  end subroutine Seg_Command

  subroutine Seg_Lookup
    i = scan(arg,' ')
    if ( i > 7 ) call errMsg ( 'Only first six characters of segment name used' )
    do j = 1, n_segs
      if ( segs(j)%name == arg(:min(6,i-1)) ) exit
    end do
    if ( j > n_segs ) then
      call errMsg ( 'Segment ' // arg(:min(6,i-1)) // ' not previously declared' )
      error = .true.
      arg = adjustl(arg(i+1:))
      return
    end if
    t => segs(n_segs)%others
    allocate ( segs(n_segs)%others(size(t)+1) )
    segs(n_segs)%others(:size(t)) = t
    deallocate ( t )
    segs(n_segs)%others(size(segs(n_segs)%others)) = j
    arg = adjustl(arg(i+1:))
  end subroutine Seg_Lookup

  ! Print the segment information
  subroutine Seg_Print
    integer :: I, J
    do i = 1, n_segs
      write ( *, '(/i3,": SEG ", a)', advance='no' ) i, segs(i)%name
      if ( size(segs(i)%others) == 0 ) then
        write ( *, '(a)', advance='no' ) ' Relocatables at '
        if ( segs(i)%atLabel /= '' ) then
          write ( *, '(a)', advance='no' ) trim(segs(i)%atLabel)
          if ( segs(i)%offset /= 0 ) &
            & write ( *, '(sp,i0)', advance='no' ) segs(i)%offset
          write ( *, '(" = ")', advance='no' )
        end if
        if ( segs(i)%def ) then
          write ( *, '(i0)' ) segs(i)%start
        else
          write ( *, '(a)' ) '*** Start is undefined *** '
          error = .true.
        end if
      else if ( segs(i)%after ) then
        write ( *, '(a)', advance='no' ) ' Relocatables after maximum of ends of '
      else
        write ( *, '(a)', advance='no' ) ' Relocatables at maximum of starts of '
      end if
      if ( size(segs(i)%others) > 0 ) &
        & write ( *, '(a,3(1x,a),(13x,10(1x,a)))' ) &
          & (trim(segs(segs(i)%others(j))%name), j = 1, size(segs(i)%others) )
      if ( associated(segs(i)%files) ) call printFile ( segs(i)%files )
    end do
  end subroutine Seg_Print

  subroutine Up ( String )
    character(*), intent(inout) :: String
    integer :: I
    do i = 1, len(string)
      if ( iachar(string(i:i)) >= iachar('a') .and. &
         & iachar(string(i:i)) <= iachar('z') ) &
           & string(i:i) = achar(iachar(string(i:i)) + iachar('A') - iachar('a') )
    end do
  end subroutine Up

  subroutine Write_Comment ( Comment, Data )
    use Object_m, only: Card_No, Deck_ID, Finish_Obj, Num_Load_Ops, Obj_Pos, &
      & Write_tape
    character(*), intent(in) :: Comment
    logical, intent(in), optional :: Data ! Signals calling for DATA
    character(60) :: MyComment
    if ( annotate == 0 ) return
    if ( present(data) .and. annotate < 2 ) return
    myComment = Comment
    if ( do_diag ) then
      n_diag = n_diag + 1
      write ( u_diag, 1 ) myComment, n_diag
    1 format ( 'N0000001001 ', a60, t73, i5.5 )
    end if
    if ( do_object ) then
      if ( obj_pos > 0 .or. num_load_ops > 0 ) call finish_obj ( 0, '1040' )
      write ( u_obj, 2 ) myComment(1:39), card_no, deck_id
    2 format ( a39, 'N000000N000000N000000N0000001040',i4.4,a5 )
      card_no = card_no + 1
    end if
    if ( do_tape )  call write_tape ( 'B007 ' // myComment(1:55), '1   1', 61 )
  end subroutine Write_Comment

  subroutine Write_Core ( EntAdr )
    use BCD_to_ASCII_m, only: BCD_to_ASCII, B_GRPMRK
    use Object_m, only: Write_Tape
    use Zone_m, only: Num_To_Addr
    integer, intent(in) :: EntAdr
    integer :: I, J, K
    if ( n_core == 0 ) then
      core(1:13) = 'B010LB   .010'
      wm(1:14)   = '1    1   1   1'
      call num_to_addr ( entAdr, 0, core(7:9) )
    else
      core(1:skip) = repeat('z',skip)
      wm(1:skip) = repeat(' ', skip)
    end if
    if ( index(trace,'C') /= 0 ) call core_dump
    i = verify(core,'z') ! Look for first loaded character
    if ( i /= 0 ) then
      j = scan(core,bcd_to_ascii(b_grpmrk),back=.true.)
      if ( j == 0 ) then
        j = verify(core,'z',back=.true.)+1 ! Look for last loaded character
        core(j:j) = bcd_to_ascii(b_grpmrk)
        wm(j:j) = '1'
      end if
      do k = i, j
        if ( core(k:k) == 'z' ) core(k:k) = ''
      end do
      call write_tape ( core(i:j), wm(i:j), j-i+1, unit=u_core )
    end if
    core = repeat('z',16000)
    wm = ''
    n_core = n_core + 1
  end subroutine

  subroutine Write_End
  ! Write the END record with entry to entAdr
    use Object_m, only: Card, Finish_Obj, Num_Load_Ops, Obj_Pos, Write_Tape
    use Zone_m, only: Num_to_Addr
    character(3) :: Addr
    call num_to_addr ( entAdr, 0, addr )
    if ( do_diag ) then
      n_diag = n_diag + 1
      write ( u_diag, 1 ) addr, n_diag
    1 format ( "/", a3, "080", t73, i5.5 )
    end if
    if ( do_object ) then
      if ( obj_pos > 0 .or. num_load_ops > 0 ) call finish_obj ( 0, '1040' )
      card(40:71) = '/' // addr // '080'
      call finish_obj ( 0 )
    end if
    if ( do_tape ) call write_tape ( '/' // addr // '080 ', &
                                   & '1      1', 61 )
  end subroutine Write_End

  subroutine Write_EX ( P )
  ! Write an EX record with entry to P
    use Object_m, only: Card, Finish_Obj, Num_Load_Ops, Obj_Pos, Write_Tape
    use Zone_m, only: Num_to_Addr
    integer, intent(in) :: P
    character(3) :: Addr
    call num_to_addr ( p, 0, addr )
    if ( do_diag ) then
      n_diag = n_diag + 1
      write ( u_diag, 1 ) addr, n_diag
    1 format ( "N000000B", a3, t73, i5.5 )
    end if
    if ( do_core ) call write_core ( p )
    if ( do_object ) then
      if ( obj_pos > 0 .or. num_load_ops > 0 ) then
        call finish_obj ( 0, 'B' // addr )
      else
        card(40:46) = 'N000000'
        card(68:71) = 'B' // addr
        call finish_obj ( 0 )
      end if
    end if
    if ( do_tape ) then
      call write_tape ( 'N000000B' // Addr // ' ', &
        &               '1      1   1', 61 )
    end if
    after_EX = .not. no_re_ex
  end subroutine Write_EX

  subroutine Write_EX_Restart
  ! Write stuff to restart after EX or XFR
    use Bootstrap_m, only: Boot_T, Boot_TW, EX1, EX2
    use Object_m, only: Card, Finish_Obj, Write_Tape
    if ( do_object ) then
      card = ex1
      call finish_obj ( 0 )
      card = ex2
      call finish_obj ( 0 )
    end if
    if ( do_tape )  call write_tape ( boot_t, boot_tw, 80 )
    after_EX = .false.
  end subroutine Write_EX_Restart

  subroutine Write_Field ( P, Field, WM_char, Line )
  ! Write FIELD to load at P with a WM if WM == 'W'
    use BCD_to_ASCII_m, only: BCD_to_ASCII, B_GRPMRK
    use Object_m, only: Card, Finish_Obj, Last_Obj_P, Num_Load_Ops, Num_SWMs, &
      & Obj_Pos, Output_SWMs, SW, Write_Tape
    use Zone_m, only: Num_to_Addr
    integer, intent(in) :: P
    character(*), intent(in) :: Field
    character, intent(in) :: WM_char
    character(*), intent(in), optional :: Line

    integer, parameter :: MaxCard = 39

    character(3) :: Addr
    integer :: L
    integer :: Remain
    character(20) :: MyLine
    integer :: MyP
    character :: MyWM
    character(61) :: TDATA, TWMS           ! Tape data and word marks

    if ( do_core ) then
      core(p:p+len(field)-1) = field
      wm(p:p) = merge('1',' ',wm_char=='W')
    end if
    if ( do_diag ) then
      call num_to_addr ( p+len(field)-1, 0, addr )
      n_diag = n_diag + 1
      write ( u_diag, 1 ) 11 + len(field), addr, field, n_diag
    1 format ( "L",i3.3,a3,"1001",a,t73,i5.5 )
      if ( wm_char /= 'W' ) then
        call num_to_addr ( p, 0, addr )
        n_diag = n_diag + 1
        write ( u_diag, 2 ) addr, addr, n_diag
      2 format ( ")", 2a3, "1001", t73, i5.5 )
      end if
    end if
    if ( do_object ) then
      i = 1
      myP = p
      myWM = wm_char
      remain = len(field)
      if ( obj_pos > 0 .and. last_obj_p+1 /= myP .or. & ! not contiguous
           ! field won't fit
         & obj_pos + remain > maxCard .or. &
         & obj_pos == 0 .and. num_load_ops > 0 .and. myWm /= 'W' ) &
           ! don't lose SWs already set up
         & call finish_obj ( 0, '1040' )
      if ( num_load_ops >= 6 .and. myWm == 'W' ) call finish_obj ( 0, '1040' )
      do while ( remain > 0 )
        l = min(remain,maxCard-obj_pos)
        card(obj_pos+1:maxCard) = field(i:l+i-1)
        if ( obj_pos == 0 ) then
          if ( myWm /= 'W' ) then
            card(47:47) = ')'
            call num_to_addr ( myP, 0, card(48:50) )
            card(51:53) = card(48:50)
            num_load_ops = 2
          end if
        else if ( myWm == 'W' ) then
          if ( num_load_ops >= 6 ) call finish_obj ( 0, '1040' )
          if ( myWm == 'W' ) call sw ( myP, 0, .true. ) ! .true. means "calling from DC"
        end if
        i = i + l
        myP = myP + l
        last_obj_p = myP - 1
        myWm = ' '
        obj_pos = obj_pos + l
        if ( obj_pos == maxCard ) call finish_obj ( 0, '1040' )
        remain = remain - l
      end do
    end if
    if ( do_tape ) then
      i = 1
      myLine = ''
      if ( present(line) ) myLine = line
      myP = p
      myWM = wm_char
      remain = len(field)
      if ( num_swms > 0 ) call output_swms
      do while ( remain > 0 )
        if ( field(i:i) /= bcd_to_ascii(B_GRPMRK) ) then
          l = min(remain,32)
          tdata(:15) = 'L      N000B007'
          twms       = '1      1   1   1'
          write ( tdata(2:4), '(i3.3)' ) l+34
          call num_to_addr ( myP+l-1, 0, tdata(5:7) )
          if ( myWm == ' ' ) then
            tdata(8:8) = ')'
            call num_to_addr ( myP, 0, tdata(9:11) )
          end if
          tdata(16:) = field(i:i+l-1)
        else
          l = min(remain,14)
          tdata(:23) = ',043L      )043043B007 '
          twms       = '1   1      1      1   1'
          write ( tdata(6:8), '(i3.3)' ) l+42
          call num_to_addr ( myP+l-1, 0, tdata(9:11) )
          if ( myWm == ' ' ) call num_to_addr ( myP, 0, tdata(16:18) )
          tdata(24:) = field(i:i+l-1)
        end if
        if ( l <= 8 ) tdata(34:53) = myLine
        call write_tape ( tdata, twms, 61 )
        myWm = ''
        myP = myP + l
        remain = remain - l
        i = i + l
      end do
    end if

  end subroutine write_field

end program Link
!>> 2011-08-20 1.0: Initial version
!>> 2011-09-02 1.1: Quicker EX
!>> 2012-09-26 1.2: Do pass 2 if do_core, don't dump unitialized core
!>> 2013-05-04 1.3: Revised tape boot
