program AUTOCODER

  use BCD_TO_ASCII_M, ONLY: CodeCodes, ENCODING, ENCODINGS, Fill_Encoding
  use Bootstrap_m, only: BOOTLOADER, CORESIZE
  use ERROR_M, only: DO_ERROR, N_ERRORS
  use FLAGS, only: TRACES
  use INPUT_M, only: INUNIT
  use IO_UNITS, only: DIAG, INPUT, LIST, OBJ, TAPE, U_DIAG, U_ERROR,&
    &  U_INPUT, U_LIST, U_OBJ, U_REL, U_SCRATCH, U_SCR2, U_TAPE
  use LITERALS_M, only: DUMP_LIT_TABLE, LONG_LITS
  use MACHINE, only: Get_Command_Argument, IO_ERROR
  use MACRO_PASS_M, only: ADD_EXT, ADD_PATH, MACRO_PASS, MA_MACRO
  use OBJECT_M, only: DO_DIAG, DO_OBJECT, DO_REL, DO_TAPE
  use OP_CODES_M, only: INIT_OP_CODES
  use PASS_1_M, only: PASS_1
  use PASS_2_M, only: PASS_2
  use PASS_3_M, only: EXTRA, INTERLEAVE, MAXLINE, &
    & NOTIN_1_80, PASS_3
  use SYMTAB_M, only: DUMP_SYMTAB
  use ZONE_M, only: INIT_ZONED

  implicit NONE

  character(127) :: ARG          ! Command line argument

  logical :: Do_List = .false.   ! Make a listing (turned on by -l)
  logical :: Do_1440 = .false.   ! Assemble 1440 I/O op codes
  integer :: I, J                ! Subscript, loop inductor
  integer :: IOSTAT              ! I/O status
  logical :: KeepScr = .false.   ! Keep the scratch file
  logical :: NeedPass2           ! Undefined ORG's or EQU's after pass 1
  integer :: PGLEN               ! Page Length (from -p option)
  logical :: Saw_Rel             ! Pass 1 saw relocatable stuff
  logical :: SYMTAB              ! Dump the symbol table
  character(len=*), parameter :: &
    & Version = &
    & '1401 Autocoder (c) Van Snyder <van.snyder@sbcglobal.net> 2014-01-03 version 4.8'//NEW_LINE('A')// &
    & 'Modified version by Luca Severini for CHM 2017-03-28'

  interleave = .false.
  inunit = -1
  notIn_1_80 = .true.
  symtab = .false.
  traces = ''

  ! Fill the default encoding
  call fill_encoding ( encodings(encoding) )

  i = 0
  do
    i = i + 1
    call get_command_argument ( i, arg )
    if ( arg(1:1) /= '-' ) exit
    if ( arg(2:3) == 'a ' ) then
      notIn_1_80 = .false.
    else if ( arg(2:2) == 'b' ) then   ! Boot
      if (arg(3:) == '' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
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
    else if ( arg(2:2) == 'd' ) then   ! "Diagnostic" object format file
      arg(3:) = adjustl(arg(3:))
      if ( arg(3:3) == ' ' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      do_diag = .true.
      diag = arg(3:)
      open ( u_diag, file=diag, form='formatted', access='sequential', &
        & iostat=iostat )
      if ( iostat /= 0 ) then
        call io_error ( 'While opening "diagnostic format" file', iostat, tape )
        stop
      end if
    else if ( arg(2:2) == 'e' ) then    ! Encodings
      arg(3:) = adjustl(arg(3:))
      if (arg(3:) == '' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      if ( arg(3:3) == '?' ) then ! Print encodings and stop
        print *, 'Built-in encodings, in BCD order, blank to GM:'
        print *, '  No zone +       A (0) zone +    B (11) zone +   AB (12) zone +'
        print *, '   123456789034567 123456789234567 123456789034567 123456789034567'
        print *, '             88888          888888           88888           88888'
        do j = 1, size(codeCodes)
          print *, codeCodes(j), ': ', encodings(j)
        end do
        print *, '^ is used for blank on even-parity tapes. It does not have an'
        print *, 'input punch encoding, punches as zero, and prints as record mark.'
        print *, 'Characters using 5-8, 6-8 or 7-8 do not print on standard chains.'
        stop
      end if
      do j = 1, size(codeCodes)
        if ( codeCodes(j) == arg(3:) ) then
          encoding = j
          exit
        end if
      end do
      if ( arg(3:3) == '*' ) then
        if ( arg(4:) == '' ) then
          call get_command_argument ( i, arg )
        else
          arg = arg(4:)
        end if
        if ( len_trim(arg) /= 63 ) then
          print *, 'Invalid encoding: Must be 63 characters in BCD order'
        else
          call fill_encoding ( arg(1:63) )
        end if
      else
        if ( j > size(codeCodes) ) &
          & print *, 'Invalid encoding, ', codeCodes(encoding), ' used.'
        call fill_encoding ( encodings(encoding) )
      end if
    else if ( arg(2:2) == 'I' ) then   ! Macro search path
      if ( arg(3:3) == '' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      call add_path ( trim(arg(3:)) )
    else if ( arg(2:3) == 'i ' ) then  ! Interleave
      interleave = .true.
    else if ( arg(2:2) == 'l' ) then   ! Listing file
      arg(3:) = adjustl(arg(3:))
      if ( arg(3:3) == ' ' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      do_list = .true.
      list = arg(3:)
      open ( u_list, file=list, form='formatted', access='sequential', &
        & iostat=iostat )
      if ( iostat /= 0 ) then
        call io_error ( 'While opening "listing" file', iostat, list )
        stop
      end if
    else if ( arg(2:3) == 'L ' ) then  ! Allow long lits
      long_lits = .true.
    else if ( arg(2:3) == 'M ' ) then  ! MA is a macro
      ma_macro = .true.
    else if ( arg(2:2) == 'm' ) then   ! Macro extension
      if ( arg(3:3) == '' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      call add_ext ( trim(arg(3:)) )
    else if ( arg(2:2) == 'o' ) then   ! Object file
      arg(3:) = adjustl(arg(3:))
      if ( arg(3:3) == ' ' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      do_object = .true.
      obj = arg(3:)
      open ( u_obj, file=obj, form='formatted', access='sequential', &
        & iostat=iostat )
      if ( iostat /= 0 ) then
        call io_error ( 'While opening "object deck" file', iostat, obj )
        stop
      end if
    else if ( arg(2:2) == 'p' ) then   ! Page length
      arg(3:) = adjustl(arg(3:))
      if ( arg(3:3) == ' ' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      read ( arg(3:), *, iostat=iostat ) pgLen
      if ( iostat == 0 ) then
        maxLine = pglen
      else
        call io_error ( 'While converting -p optipon', iostat )
        stop
      end if
    else if ( arg(2:2) == 'r' ) then   ! Relocatable file
      arg(3:) = adjustl(arg(3:))
      if ( arg(3:3) == ' ' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      do_rel = .true.
      obj = arg(3:)
      open ( u_rel, file=obj, form='formatted', access='sequential', &
        & iostat=iostat )
      if ( iostat /= 0 ) then
        call io_error ( 'While opening relocatable file', iostat, obj )
        stop
      end if
    else if ( arg(2:3) == 's' ) then   ! Dump symbol table
      symtab = .true.
    else if ( arg(2:2) == 't' ) then   ! Object Tape
      arg(3:) = adjustl(arg(3:))
      if ( arg(3:3) == ' ' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      do_tape = .true.
      tape = arg(3:)
      open ( u_tape, file=tape, form='formatted', access='sequential', &
        & iostat=iostat )
      if ( iostat /= 0 ) then
        call io_error ( 'While opening "loadable tape" file', iostat, tape )
        stop
      end if
    else if ( arg(2:2) == 'T' ) then   ! Traces
      arg(3:) = adjustl(arg(3:))
      if ( arg(3:) == '' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      traces = trim(traces) // arg(3:)
    else if ( arg(2:3) == 'V ' ) then  ! Print version and stop
      print '(a)', version
      stop
    else if ( arg(2:2) == 'X' ) then   ! Special switches
      arg(3:) = adjustl(arg(3:))
      if ( arg(3:) == '' ) then
        i = i + 1
        call get_command_argument ( i, arg(3:) )
      end if
      read ( arg(3:), *, iostat=iostat ) extra
      if ( iostat /= 0 ) then
        call io_error ( 'While processing X option', iostat, input )
        stop
      end if
    else if ( arg(2:) == '-keepscratch' ) then
      keepScr = .true.
    else if ( arg(2:) == '1440' ) then
      do_1440 = .true.
    else if ( arg(2:) == '' ) then
      exit
    else
      call get_command_argument ( 0, arg )
      print 1, 'Usage: ', trim(arg), ' [options] [input-file]'
      print 1, ' Options:'
      print 1, '  -h => Print this information and stop'
      print 1, '  -a => Code in 1..80 is OK'
      print 1, '  -b[ ]X[#] => Select boot loader;'
      print 1, '     X = I => IBM, # is the core size selector:'
      print 1, '       0 => Boot, no clear, sequence numbers start at 3,'
      print 1, '       1 => 1400, 2 => 2000, 4 => 4000, 8 => 8000,'
      print 2, '       v => 12000, x => 16000.  Default ', coreSize
      print 1, '     X = N => None,'
      print 1, '     X = B => Van''s favorite 1-card boot/no clear,'
      print 1, '     X = V => Van''s favorite 2-card boot/clear,'
      print 1, '  -d[ ]file => Diagnostic format "deck" file'
      print 1, '  -e[ ]X[ ][explicit] => Specify encoding, default ', codeCodes(encoding)
      print 1, '     X = A => Paul Pierce''s primary (IBM A) encoding'
      print 1, '     X = H => Paul Pierce''s alternative (IBM H) encoding'
      print 1, '     X = S => SIMH "traditional" encoding'
      print 1, '     X = I => Icelandic encoding'
      print 1, '     X = * => Explicit encoding; "explicit" must be 63 characters,'
      print 1, '              in BCD order, 1 ... GM.  Blank is assumed first.'
      print 1, '     X = ? => Print built-in encodings and stop'
      print 1, '         Differences:     12  0    11     0 12  0     0 12'
      print 1, '                              2  3  3  4  4  4  5  7  7  7'
      print 1, '                              8  8  8  8  8  4  8  8  8  8'
      print 1, '         ================================================='
      print 1, '     A:    Pierce Primary  &  |  #  $  @  %  )  ~  {  "  }'
      print 1, '     H:  Pierce Alternate  +  |  =  $  ''  (  )  ~  {  "  }'
      print 1, '     S:  Traditional SIMH  &  ''  #  $  @  %  )  =  (  +  "'
      print 1, '     I:         Icelandic  Ð  |  Æ  É  Ö  Þ  Á  ~  {  "  }'
      print 1, '  -I[ ]path => A path to search for macros.  First is always'
      print 1, '        "." Any number of -I options can appear.  Paths are'
      print 1, '        searched in the order specified.  INCLD or CALL'
      print 1, '        file names are first three letters, macro file'
      print 1, '        names are all five, all caps or all lower case.'
      print 1, '  -i => Interleave object deck into listing ', &
        &               '(needs -o and -l)'
      print 1, '  -l[ ]file => Listing file'
      print 1, '  -L => Store long literals once (unlike "real" Autocoder)'
      print 1, '  -M => MA is a macro in file ma or MA'
      print 1, '  -m[ ]ext => Add .ext to the list of extensions to use when'
      print 1, '        searching for macros.  Macros are searched in lower'
      print 1, '        case first (including extensions), then upper case.'
      print 1, '        Any number of -m options can be specified.  The path'
      print 1, '        loop is inside the extension loop'
      print 1, '  -o[ ]file => Object "deck" file'
      print 2, '  -p[ ]# => Page length in lines, default ', maxLine
      print 1, '  -r[ ]file => Relocatable object file'
      print 1, '  -s => Dump the symbol and literal tables (debug)'
      print 1, '  -t[ ]file => Loadable "tape" file'
      print 1, '  -T[ ]letters => Trace, depending on letters'
      print 1, '       l => Lexer, p => Parser, M => Macro files'
      print 1, '       P => PROCESS_LTORG'
      print 1, '  -V => Print version info and stop'
      print 1, '  -1440 => Assemble 1440 I/O op codes'
      print 1, '  -X[ ]flags => Set "extra" flags (sum them if needed):'
      print 1, '     flag 1 => Quick EX/XFR'
      print 1, '     flag 2 => Quick END'
      print 1, '     flag 4 => Queue SW instructions'
      print 1, '     flag 8 => No reloader after EX/XFR'
      print 1, 'If [input-file] is not on the command line it is taken from standard input'
      print 1, version
      stop
    1 format (3a)
    2 format (a,i0)
    end if
  end do

  if ( arg(1:1) /= '-' .and. arg /= '' ) then
    inunit = u_input
    input = arg
    open ( u_input, file=input, form='formatted', access='sequential', &
      & status='old', iostat=iostat )
    if ( iostat /= 0 ) then
      call io_error ( 'While opening input file', iostat, input )
      stop
    end if
  end if

  if ( keepScr ) then
    open ( u_scratch, form='formatted', access='sequential', &
      & file='scratch' )
    open ( u_scr2, form='formatted', access='sequential', &
      & file='scr2' )
  else
    open ( u_scratch, form='formatted', access='sequential', &
      & status='scratch' )
    open ( u_scr2, form='formatted', access='sequential', &
      & status='scratch' )
  end if

  call init_op_codes ( do_1440 )
  call init_zoned

  call macro_pass
  rewind ( u_scr2 )

  do
    n_errors = 0
    u_error = u_scratch
    call pass_1 ( iostat, needPass2, saw_rel )
    if ( saw_rel .and. ( do_object .or. do_tape .or. do_diag ) ) then
      print *, 'Relocatable output cannot be to -o, -t or -d file'
      cycle
    end if
    if ( iostat > 0 ) exit
    u_error = -1
    if ( do_list ) u_error = u_list
    if ( symtab ) then
      call dump_symtab ( heading='After pass 1:' )
      call dump_lit_table ( -1 )
    end if
    if ( iostat > 0 ) exit
    if ( needPass2 ) then
      call pass_2 ( saw_rel )! Resolve forward EQU, ORG and LTORG references
      if ( symtab ) then
        call dump_symtab ( heading='After pass 2:' )
        call dump_lit_table ( -1 )
      end if
    end if
    call pass_3 ( do_list, saw_rel )
    if ( n_errors > 0 ) then
      write ( arg(1:5), '(i5)' ) n_errors
      call do_error ( arg(1:5) // ' Errors' )
    end if
    if ( keepScr ) exit
    if ( iostat /= 0 ) exit
  end do

end program AUTOCODER

! $Log: $
! Version 1: Initial working version
! Version 1.1: Minor bug fix
! Version 1.2: 2004-12-09 Make scratch file scratch instead of named;
! Version 1.3:
!   Add Quick EX and Quick END; For Lahey, use getarg from Machine;
!   Add SW queueing.
! Version 1.4: Allow ¢ for blank for even parity tape, skip pass 2 if not
!   needed, some cannonball polishing.
! Version 1.5: Forgot to enter reason for it
! Version 1.6: Assemble without an END card
! Version 1.7: Bug fix to get rid of extra card after last card
! Version 1.8: Put "1040" in 68-71 of last object card if no END
! Version 1.9: Correct opcode for 7 is WRP
!   Finish object card if JOB and no -X options
! Version 2.0: "Diagnostic deck" format with -d option, -bI0 option,
!   repair bug DSA not announcing symbol error
! Version 2.1: Add Pierce's encodings and -e option to select encoding
! Version 2.2: Repair a bug in boot loader indexing
! Version 2.3: Print correct current encoding, print encodings if -e?,
!   improve usage description, handle blanks after initial letter of option
!   even if they're not in a different command-line field
! Version 2.4: Turn tabs in input into blanks.
! Version 2.5: Print GMARK for group marks instead of record marks.
! Version 2.6: Put NUM_LITS in scratch file if XFR.
! Version 2.7: Use BCD_TO_ASCII to get WM and GM for tape output.
! Version 2.8: Remove counts from bootable tape format
! Version 3.0: Implement INCLD, default encoding is Pierce A,
!   finish getting group mark from bcd_to_ascii for tape output
! Version 3.1: Fix error in load address on tape if card obj also
! Version 3.2: Implement CALL, materialize INCLD at LTORG (wrong in 3.0).
! Version 3.3: Spiff up the help message
! Version 3.4: Add 1440 I/O op codes
! Version 3.5: Bugs in INCLD, lits, SFX handling, parsing
! Version 3.6: Macros, bugs in DA, DCW
! Version 3.7: Yet another DCW bug (cut off at 48 instead of 50)
!   and a macro bug (need to left-adjust and trim macro arg)
! Version 3.8: Correct off-by-one in dcw  &@xyz@ (was making yz@ lit).
!   List card number on DA lines, DA with negative numeric operand.
!   Four-character sequence numbers with 1401 overflow.  Adcons with *.
! Version 3.9: Allow one blank in a label; allow zone on last digit
!   of number, except in DA; no SFX printed on JOB, SFX or Macro lines.
! Version 3.10: Explicit error message for DC/DCW wider than 52 chars.
! Version 3.11: Make D-modifier optional on SS
! Version 3.12: Don't allow zone-signed number as offset, eg name+number
! Version 3.13: Add macro extensions
! Version 3.14: Make sure Operands variable is completely defined
! Version 3.15: Correct usage instructions for -I option.
! Version 3.16: Check macro name to be MA or at least three characters.
! Version 3.17: Made junk in 73-75 a warning instead of error.
! Version 3.18: Do top-of-form on bootstrap listings after the first program
! Version 3.19: Add SPS support
! Version 3.20: Correct errors and oversights in SPS support
! Version 3.21: Add Icelandic encoding
! Version 3.22: Arbitrary encodings allowed by -e* option, lexer works in BCD
! Version 3.23: Correct wrong BCD name for ) -- B_SQUARE instead of B_RPAREN
! Version 4.0: Relocatable output; substantial other changes
! Version 4.1: Correct position of undef for 5- and 8- character instructions
! Version 4.2: Repair some trivial bugs re more than one assembly
! Version 4.3: Version 4.2 broke something; revert to 4.1, fix bug in ORG *&X00.
! Version 4.4: Repair another bug in ORG *&X00, bug in CC, new tape boot
! Version 4.5: Junk in 73-75 OK for comment, print %, #, index in Platt field
! Version 4.6: Allow offset on END, EX, XFR
! Version 4.7: Tiny improvement in tape bootstrap record, repair bug in CU
! Version 4.8: Don't require A address for RP instruction
