module MACRO_PASS_M

  implicit NONE
  private
  public :: Ext_T, First_Ext, Last_Ext, Path_T, First_Path, Last_Path
  public :: Add_Ext, Add_Path, Macro_Pass
  public :: TOT_LINES

  type :: Ext_T
    character(len=4) :: Ext ! an extension to try for macros
    type(ext_t), pointer :: Next => Null()
  end type Ext_T

  type(ext_t), pointer :: First_ext => NULL(), Last_ext => NULL()

  type :: Path_T
    character(len=1023) :: Path ! A path to search for macros
    integer :: Len = 0
    type(path_t), pointer :: Next => NULL()
  end type Path_T

  type(path_t), pointer :: First_path => NULL(), Last_Path => NULL()

  logical, public :: MA_Macro = .false. ! MA is macro
  integer :: TOT_LINES

contains

  ! ----------------------------------------------------  Add_Ext  -----
  subroutine Add_Ext ( Ext )
  ! Add Ext to the end of the list of extensions to search for macro files
    character(len=*), intent(in) :: Ext
    if ( .not. associated(first_ext) ) then
      allocate ( first_ext )
      first_ext%ext = ''
      last_ext => first_ext
    end if
    allocate ( last_ext%next )
    last_ext => last_ext%next
    last_ext%ext = "." // ext
  end subroutine Add_Ext

  ! ---------------------------------------------------  Add_Path  -----
  subroutine Add_Path ( Path )
  ! Add a path to the list of paths to search for macro files
    character(len=*), intent(in) :: Path
    if ( .not. associated(first_path) ) then
      allocate ( first_path )
      first_path%path = '.'
      first_path%len = 1
      last_path => first_path
    end if
    allocate ( last_path%next )
    last_path => last_path%next
    last_path%path = path
    last_path%len = len(path)
  end subroutine Add_Path

  ! -------------------------------------------------  Macro_Pass  -----
  recursive subroutine MACRO_PASS ( ArgLine, ArgPos )

  ! Process the input file, expanding macros, and including INCLD and
  ! CALL macros.
  ! Generate branches for CALL entries and DCW's for their args.
  ! Accumulate CALL and INCLD file names.
  ! Generate a LITS record before EX or END or after LTORG.
  ! Insert CALL files before LITS record.

    use ERROR_M, only: ErrCode, BadStatement, DO_ERROR, MacroErr, Overcall
    use FLAGS, only: Traces
    use INPUT_M, only: INUNIT, READ_LINE
    use IO_UNITS, only: U_INPUT, U_SCR2, FMT_S2
    use MACHINE, only: IO_ERROR
    use OPERAND_M, only: Num_Operands, Operands, K_None, K_Symbolic
    use OP_CODES_M, only: OP_CODES
    use PARSER, only: PARSE

    character(len=*), intent(in), optional :: ArgLine
    integer, intent(in), optional :: ArgPos(0:)

    integer, parameter :: Max_Calls = 55 ! max pending CALL and INCLD files

    integer :: ArgNum      ! From )#X
    integer :: Args(0:99)  ! ARGS(i) == end of i'th arg of macro or call
    integer :: ArgZone     ! From )#X
    character(len=3), save :: CallQueue(max_calls)   ! CALL held until EX, END, LTORG
    character(5) :: CMD
    character(34) :: DCW   ! Generated from SPS
    character(len=1023) :: FILE ! File name for error messages
    integer :: I, L
    integer :: IOSTAT
    character(len=6) :: Label   ! from CALL statement
    character(len=400) :: Line
    character(len=80) :: LineSave
    integer :: Macro_Depth = 0  ! Read from unit U_Input+Macro_Depth
    integer :: MacroNum = 0     ! Serial number
    integer :: NumArgs     ! Number of args of CALL or macro ref
    integer :: NumCalls = 0
    integer :: Save_Inunit
    logical :: Saved_Line  ! Process LineSave
    logical :: SPS_mode = .false.
    integer :: Status
    integer :: TheCall = 0 ! Which call is being processed
    logical :: Trace
    character(5) :: WHY    ! Why is record on scratch file?
                           ! '     ' => Directly from input
                           ! 'MACRO' => CALL, INCLD or macro ref
                           ! 'GEN  ' => Generated line
                           ! 'LITS ' => Time to generate lits
                           
! ########################################################################    
 
    integer :: IDX   
    integer :: STR_LEN                      
    character :: CH
    
    TOT_LINES = 0
  
! ########################################################################      
 
    line = ''
    saved_line = .false.
    save_inunit = inunit ! stdin or a file
    theCall = 0
    trace = index(traces,'M') > 0
    if ( trace ) then
      if ( present(argLine) ) then
        write ( *, '("Enter Macro_Pass, macro_depth = ",i0," with arguments")' ) macro_depth
      else
        write ( *, '("Enter Macro_Pass, macro_depth = ",i0)' ) macro_depth
      end if
    end if
  o:do
      errCode = ''
      if ( numCalls <= 0 .and. saved_line ) then
        if ( macro_depth == 0 ) write ( u_scr2, fmt_s2 ) 'LITS ', '', ''
        write ( u_scr2, fmt_s2 ) '', errCode, trim(lineSave)
        saved_line = .false.
        cycle
      end if
      call read_line ( line, iostat )
      if ( iostat < 0 ) then  ! End of file
        if ( inunit > 0 ) then
          if ( trace ) then
            inquire ( unit=inunit, name=file )
            write ( *, '(a,a,a,i0)' ) 'Finished file ', trim(file), &
              & ', macro_depth = ', macro_depth
          end if
!          if ( macro_depth == 0 ) write ( u_scr2, fmt_s2 ) 'LITS ', '', ''
          close ( inunit )
        end if
        macro_depth = macro_depth - 1
        inunit = inunit - 1
        if ( present(argLine) ) exit o ! Finished a macro, not an INCLD
        if ( numCalls <= 0 ) then
          if ( saved_line ) write ( u_scr2, fmt_s2 ) '', errCode, trim(lineSave)
          exit o
        end if
        if ( macro_depth <= 0 ) then
          inunit = save_inunit
          if ( numCalls > 0 ) then
            call open_call
            if ( numCalls == 0 ) then
              write ( u_scr2, fmt_s2 ) 'LITS ', '', ''
              if ( saved_line ) then
                write ( u_scr2, fmt_s2 ) '', '', trim(lineSave)
                saved_line = .false.
              end if
            end if
          end if
        end if
        cycle o
      end if
      if ( iostat > 0 ) then  ! Error
        inquire ( unit=inunit, name=file )
        call io_error ( "While reading input", inunit, file )
        stop
      end if
      
! ########################################################################      

      	TOT_LINES = TOT_LINES + 1
      
		IDX = 1
		STR_LEN = 80

		do while (IDX <= 80)
			CH = line(IDX : IDX)
			if(CH /= ' ') then
				exit
			end if
			IDX = IDX + 1
		end do

		if(IDX > STR_LEN) then
			!print *, "Line", TOT_LINES, STR_LEN, "is empty!"
			line(6:6) = '*'
		end if

! ########################################################################      

      if ( SPS_mode ) then
        if ( line(14:16) == 'ENT' ) then
          SPS_mode = .false.
          cycle
        end if
        if ( line(8:8) == '*' ) then
          write ( u_scr2, fmt_s2 ) '', '', line(1:5) // trim(line(8:))
          cycle
        end if
        if ( line(14:16) == 'DCW' .or. line(14:16) == 'DC ' ) then
          read ( line(6:7), '(i2)' ) i ! Count field
          if ( line(22:22) == '-' .or. &
             & line(22:22) == '&' .or. line(22:22) == '+' ) then
            dcw = line(24:24+i) // '  ' // trim(line(max(40,25+i):))
          else
            dcw = '@' // line(24:23+i) // '@' // trim(line(max(40,24+i):))
          end if
          if ( line(17:17) /= '*' ) then
90          format ( 6x, a5, a, t22, a3, 2x, a: t63, a )
            write ( u_scr2, 90 ) line(1:5), line(8:13), 'EQU', line(17:20)
            write ( u_scr2, 90 ) line(1:5), line(17:22), line(14:16), &
              & trim(dcw)
          else
            write ( u_scr2, 90 ) line(1:5), line(8:13), line(14:16), &
              & trim(dcw)
          end if
          cycle
        end if ! DCW
        if ( line(14:16) == 'DS ' ) then
          if ( line(17:17) == '*' ) then
            write ( u_scr2, 90 ) line(1:5), line(8:13), 'DS ', line(6:7), &
              & trim(line(40:55))
          else
            write ( u_scr2, 90 ) line(1:5), line(8:13), 'EQU', line(17:20), &
              & trim(line(40:55))
          end if
          cycle
        end if
        if ( line(14:16) == 'DSA' ) then
          if ( line(17:17) /= '*' ) then
            write ( u_scr2, 90 ) line(1:5), line(8:13), 'EQU', line(17:20)
            write ( u_scr2, 90 ) line(1:5), line(17:22), line(14:16), &
              & trim(line(28:33)) // trim(line(34:34)) // trim(adjustl(line(35:37))), &
              & trim(line(40:55))
          else
            write ( u_scr2, 90 ) line(1:5), line(8:13), line(14:16), &
              & trim(line(28:33)) // trim(line(34:34)) // trim(adjustl(line(35:37))), &
              & trim(line(40:55))
          end if
          cycle
        end if
        if ( line(14:16) == 'B' ) then
          if ( line(28:38) /= '' ) then
            line(14:16) = 'BCE'
          else
            do i = 1, size(op_codes)
              if ( op_codes(i)%machineOp == 'B' .and. &
                 & op_codes(i)%d == line(39:39) ) then
                line(14:16) = op_codes(i)%op
                line(39:39) = ''
                exit
              end if
            end do
          end if
        end if
        if ( line(17:38) == '' ) then
          write ( u_scr2, 90 ) line(1:5), line(8:13), line(14:16), &
            trim(line(39:39)), trim(line(40:55))
        else if ( line(28:38) == '' ) then
          write ( u_scr2, 90 ) line(1:5), line(8:13), line(14:16), &
            & trim(line(17:22)) // trim(line(23:23)) // trim(adjustl(line(24:26))) // &
            & trim(merge('&x','  ',line(27:27) /= '')) // trim(line(27:27)) // &
            & trim(merge(',',' ',line(39:39) /= '' .or. line(14:16) == 'BIN')) // &
            & trim(line(39:39)), trim(line(40:55))
        else
          write ( u_scr2, 90 ) line(1:5), line(8:13), line(14:16), &
            & trim(line(17:22)) // trim(line(23:23)) // trim(adjustl(line(24:26))) // &
            & trim(merge('&x','  ',line(27:27) /= '')) // trim(line(27:27)) // ',' // &
            & trim(line(28:33)) // trim(line(34:34)) // trim(adjustl(line(35:37))) // &
            & trim(merge('&x','  ',line(38:38) /= '')) // trim(line(38:38)) // &
            & trim(merge(',',' ',line(39:39) /= '' .or. line(14:16) == 'BCE')) // &
            & trim(line(39:39)), trim(line(40:55))
        end if
        cycle
      end if ! SPS

      if ( line(16:23) == 'ENT  SPS' ) then
        SPS_mode = .true.
        cycle
      end if

      why = ''
      if ( macro_depth > 0 ) why = 'GEN'
      if ( present(argLine) ) then
        if ( line(16:20) == 'HEADR' ) cycle o
        if ( line(16:20) == 'INSER' ) cycle o
        ! Delete the line because of selectors in the comment field?
        l = len_trim(line)-2
        i = index(line(:l),'  ',back=.true.) ! Beginning of comment field
        if ( i < 21 .or. index(line(i:),'@') /= 0 ) l = 0 ! Codes have to be in the comment field
        do while ( l > 8 )
          if ( line(l:l) /= ')' ) exit ! Not )#X
          call arg_num ( line(l:l+2), argNum, argZone )
          if ( argZone == 1 ) then ! delete if argNum present
            if ( argPos(argNum) >= argPos(argNum-1) + 2 ) then
              if ( trace ) write ( *, '(a/a,i0,a)' ) trim(line), &
                & 'deleted because argument ', -argNum, ' present'
              cycle o
            end if
          else if ( argZone == 3 ) then ! delete if argNum absent
            if ( argPos(argNum) < argPos(argNum-1) + 2 ) then
              if ( trace ) write ( *, '(a/a,i0,a)' ) trim(line), &
                & ' deleted because argument ', -argNum, ' absent'
              cycle o
            end if
          else
            exit ! No zone, B zone, or something wrong with )#X
          end if
          line(l:l+2) = ''
          l = l - 3
        end do
        ! Substitute arguments in line(i+1:)
        if ( line(6:11) == ')00' ) then
          line(6:12) = argLine(6:12)
          if ( trace ) write ( *, '(3a,i0,a,i0,a,a)' ) 'Replace ', &
              & ')00', '(', 6, ':', 8, ') by ', trim(argline(6:12))
        end if
        i = 0
        do
          l = index(line(i+1:),')')
          if ( l == 0 ) exit
          l = l + i
          call arg_num ( line(l:l+2), argNum, argZone )
          select case ( argZone )
          case ( 0, 3 ) ! Substitute argNum
            if ( argZone == 3 .and. &  ! Delete if argNum absent
               & argPos(argNum) < argPos(argNum-1) + 2 ) then
              if ( trace ) write ( *, '(a/a,i0,a)' ) trim(line), &
                & ' deleted because argument ', argNum, ' absent'
              cycle o
            end if
            if ( trace ) write ( *, '(3a,i0,a,i0,a,a)' ) 'Replace ', &
              & line(l:l+2), '(', l, ':', l+2, ') by ', &
              & argLine(argPos(argNum-1)+2:argPos(argNum))
            if ( line(6:6) == '*' ) then
              line(l:) = trim(adjustl(argLine(argPos(argNum-1)+2:argPos(argNum)))) // line(l+3:)
            else if ( l < 16 ) then
              line(6:15) = adjustl(argLine(argPos(argNum-1)+2:argPos(argNum)))
            else if ( l < 21 ) then
              line(16:20) = adjustl(argLine(argPos(argNum-1)+2:argPos(argNum)))
            else
              line(l:) = trim(adjustl(argLine(argPos(argNum-1)+2:argPos(argNum)))) // line(l+3:)
            end if
          case ( 2 ) ! Generate internal label
            if ( l /= 6 ) line(l+6:) = line(l+3:)
            write ( line(l+3:l+5), '(i3.3)' ) macroNum
            i = l + 5
            if ( trace ) write ( *, '(3a,i0,a,i0,a)' ) &
              & 'Generate internal label ', line(l:l+5), '(', l, ':', &
              & l+5, ')'
          case default ! A-zone or Something wrong with )#X, ignore it
            i = l
          end select
        end do
      end if

      l = min(80,len_trim(line))
      if ( line(6:6) == '*' ) then
        write ( u_scr2, fmt_s2 ) why, errCode, line(:l)
      else
        select case ( line(16:20) )
        case ( 'CALL', 'INCLD' )
          operands(1)%kind = k_none
          num_Operands = 0
          i = 21
!           why = 'MACRO'
          call parse ( line, i, status, .false., no_lit=.false. )
          if ( operands(1)%kind /= k_symbolic ) then
            call do_error ( 'First operand of CALL or INCLD is not a name' )
            errCode = badStatement
          else
            ! Only one of each CALL or INCLD file
            do i = 1, numCalls
              if ( callQueue(i) == operands(1)%label(1:3) ) then
                numCalls = numCalls - 1
                exit
              end if
            end do
            numCalls = numCalls + 1
            callQueue(numCalls) = operands(1)%label(1:3) ! Only three chars count
            if ( trace ) write ( *, '(a,i0,2a)' ) &
              & 'Enqueue ', numCalls, ': ', trim(callQueue(numCalls))
          end if
          if ( numCalls >= ubound(callQueue,1) ) errCode = overcall
          call get_args
          if ( theCall > 1 .and. numArgs > 0 ) then
            call do_error ( 'Arguments not permitted within CALL file' )
            errCode = macroErr
          end if
          write ( u_scr2, fmt_s2 ) 'MACRO', errCode, line(:l)
          if ( errCode == '' .and. line(16:20) /= 'INCLD' ) then
            cmd = 'B'
            label = line(6:11)
            do i = 1, numArgs
              write ( u_scr2, 200 ) 'GEN  ', label, cmd, &
                & line(args(i-1)+2:args(i))
200           format ( a5, 6x, a6, 4x, a5, a )
              label = ''
              cmd = 'DCW'
            end do
          end if
        case ( 'END', 'EX' )
          if ( macro_depth > 0 .and. .not. present(argLine) ) then
            call do_error ( trim(line(16:20)) // ' not allowed in CALL file' )
            write ( u_scr2, fmt_s2 ) '', macroErr, line(:l)
          else
            lineSave = line ! save for processing after CALLs
            saved_line = .true.
            if ( numCalls > 0 ) then
              call open_call
            else
              write ( u_scr2, fmt_s2 ) 'LITS ', '', ''
            end if
          end if
        case ( 'LTORG' )
          if ( macro_depth > 0 .and. .not. present(argLine) ) then
            call do_error ( trim(line(16:20)) // ' not allowed in CALL file' )
            write ( u_scr2, fmt_s2 ) '', macroErr, line(:l)
          else
            write ( u_scr2, fmt_s2 ) '', errCode, line(:l)
            if ( numCalls > 0 ) then
              call open_call
            else
              write ( u_scr2, fmt_s2 ) 'LITS ', '', ''
            end if
          end if
        case ( 'ORG' )
          if ( macro_depth > 0 .and. .not. present(argLine) ) then
            call do_error ( trim(line(16:20)) // ' not allowed in CALL file' )
            write ( u_scr2, fmt_s2 ) '', macroErr, line(:l)
          else
            write ( u_scr2, fmt_s2 ) '', errCode, line(:l)
          end if
        case ( 'HEADR' ) ! ignore it
        case default
          ! Is it a standard op code?
          if ( .not. ma_macro .or. line(16:20) /= 'MA' ) then
            do i = 1, size(op_codes,1)-1
              if ( line(16:18) == '   ' .or. & ! machine op
                & line(16:20) == op_codes(i)%op ) then
                write ( u_scr2, fmt_s2 ) why, errCode, line(:l)
                cycle o
              end if
            end do
          end if
          ! No, look for a macro file of the same name.
          why = 'MACRO'
          write ( u_scr2, fmt_s2 ) why, errCode, line(:l)
          if ( open_macro (line(16:20)) < 0 ) then
            if ( inunit /= save_inunit ) why = ''
            errCode = macroErr
            write ( u_scr2, 300 ) why, errCode, &
              &  '     *  ' // line(16:20) // '  UNKNOWN'
 300        format ( a5, a1, a )
          else
            inunit = u_input + macro_depth
            macroNum = macroNum + 1
            why = 'GEN'
            call get_args
            call macro_pass ( line, args )
          end if
        end select
      end if
    end do o
    
    !print *, "Lines:", TOT_LINES

    if ( trace ) write ( *, '("Exit Macro_Pass, macro_depth = ",i0)' ) macro_depth

  contains

    ! --------------------------------------------------  ARG_NUM  -----
    subroutine ARG_NUM ( Arg, Num, Zone )
      ! Given an Arg of the form )#X, convert #X to a Num between
      ! 1 and 99, and return the Zone of X (0..3).  Num < 0 if error.
      use BCD_TO_ASCII_m, only: BCD_TO_ASCII, B_RECMRK
      character(3), intent(in) :: Arg
      integer, intent(out) :: Num
      integer, intent(out) :: Zone
      character(40) :: Ch = '0123456789|/STUVWXYZ!JKLMNOPQR?ABCDEFGHI'
      integer :: D1, D2
      ch(11:11) = bcd_to_ascii(b_recmrk)
      d1 = index(ch,arg(2:2))
      d2 = index(ch,arg(3:3))
      if ( d1 == 0 .or. d1 > 10 .or. d2 == 0 ) then
        num = -1
        zone = -1
        return
      end if
      num = 10 * (d1-1) + mod(d2 - 1,10)
      zone = (d2-1) / 10
    end subroutine ARG_NUM

    ! -------------------------------------------------  GET_ARGS  -----
    subroutine GET_ARGS
      ! Get all the args for a macro.  Pile all the necessary lines
      ! (max 5) into LINE.  Set ARGS(i) to the end of the i'th argument
      ! (ARGS(0) == 19).
      integer :: I, IOSTAT, J, NumLines
      args = 19
      i = 21
      numArgs = 0
      numLines = 1
      line(73:80) = ''
      do
        if ( line(i:i+1) == '  ' .and. line(i-1:i-1) /= ',' ) then
          ! end of args
          if ( i > 21 ) then          ! Is there a first arg?
            numArgs = numArgs + 1
            if ( numArgs > 99 ) then
              errCode = macroErr
            else
              args(numArgs) = i-1
            end if
          end if
          exit
        end if
        if ( line(i:i) == ',' ) then
          numArgs = numArgs + 1
          if ( numArgs > 99 ) then
            errCode = macroErr
            exit
          end if
          args(numArgs) = i-1
          if ( line(i+1:) == '' ) then ! comma then blanks -- need a line
            if ( numLines >= 5 ) then
              errCode = macroErr
              exit
            end if
            numLines = numLines + 1
            call read_line ( line(i+1:), iostat )
            if ( iostat < 0 ) then
              call do_error ( 'End-of-file while processing macro arguments' )
              exit
            end if
            if ( iostat > 0 ) then  ! Error
              inquire ( unit=inunit, name=file )
              call io_error ( "While reading input", inunit, file )
              stop
            end if
            write ( u_scr2, 200 ) 'MACRO', errCode, trim(line(i+1:i+80))
200         format ( a5,a1,a )
            line(i+1:i+52) = line(i+21:i+72)
            line(i+53:i+80) = ''
          end if
        else if ( line(i:i) == '@' ) then
          j = index(line,'@',back=.true.)
          if ( j == i ) then
            errCode = macroErr
            exit
          end if
          i = j
        end if
        i = i + 1
      end do
      if ( trace ) then
        write ( *, '(a)' ) "Macro arguments:"
        do i = 1, args(numArgs), 80
          write ( *, '(a)' ) trim(line(i:i+79))
        end do
        write ( *, '(20i4)' ) args(:numArgs)
      end if
    end subroutine GET_ARGS

    ! ------------------------------------------------  OPEN_CALL  -----
    subroutine OPEN_CALL
      ! Open the next CALL file
      do
        theCall = theCall + 1
        if ( theCall > numCalls ) then
          numCalls = 0
          theCall = 0
          return
        end if
        if ( open_macro (callQueue(theCall)) < 0 ) then
          why = ''
          errCode = macroErr
          write ( u_scr2, 300 ) why, errCode, &
            &  '     *  ' // callQueue(theCall) // '  UNKNOWN'
300       format ( a5, a1, a )
        else
          inunit = u_input + macro_depth
          why = 'GEN'
          return
        end if
      end do
    end subroutine OPEN_CALL

    ! ----------------------------------------------  OPEN_MACRO  -----
    integer function Open_Macro ( Macro )
    ! Open a file with the same name as Macro, trying each extension,
    ! and trying lower case first and then upper case for each
    ! extension. Return the macro depth if a file is successfully
    ! opened, else -1 if no such file is found.
      use IO_UNITS, only: U_INPUT
      character(len=*), intent(in) :: Macro
      character(len=len(macro)+4) :: Copy ! In either lower or upper case
      integer :: I, IOSTAT
      type(ext_t), pointer :: Ext   ! For searching
      type(path_t), pointer :: Path ! For searching
      ! Check that the macro name is either MA or at least three characters
      if ( len_trim(macro) < 3 .and. macro /= 'MA' ) then
        open_macro = -1
        return
      end if
      if ( .not. associated(first_ext) ) then
        allocate ( first_ext )
        first_ext%ext = ''
        last_ext => first_ext
      end if
      if ( .not. associated(first_path) ) then
        allocate ( first_path )
        first_path%path = '.'
        first_path%len = 1
        last_path => first_path
      end if
      macro_depth = macro_depth + 1
      open_macro = macro_depth
      ext => first_ext
      do while ( associated(ext) )
        path => first_path
        do while ( associated(path) )
          copy = trim(macro) // ext%ext
          do i = 1, len(macro)+4
            ! Try lower case first
            if ( iachar(copy(i:i)) >= iachar("A") .and. &
              &  iachar(copy(i:i)) <= iachar("Z") ) &
                & copy(i:i) = achar(iachar(copy(i:i)) + iachar("a") - iachar("A"))
          end do
          if ( trace ) write ( *, '(a,a)' ) 'Try macro file ', &
                & path%path(:path%len) // "/" // trim(copy)
          open ( unit=u_input+macro_depth, status='OLD', &
            &    file=path%path(:path%len) // "/" // copy, iostat=iostat )
          if ( iostat == 0 ) then
            if ( trace ) write ( *, '(a,a)' ) 'Start macro file ', &
                & path%path(:path%len) // "/" // trim(copy)
            return
          end if
          ! now try upper case
          copy = trim(macro) // ext%ext
          do i = 1, len(macro)+4
            if ( iachar(copy(i:i)) >= iachar("a") .and. &
              &  iachar(copy(i:i)) <= iachar("z") ) &
                & copy(i:i) = achar(iachar(copy(i:i)) + iachar("A") - iachar("a"))
          end do
          if ( trace ) write ( *, '(a,a)' ) 'Try macro file ', &
                & path%path(:path%len) // "/" // trim(copy)
          open ( unit=u_input+macro_depth, status='OLD', &
            &    file=path%path(:path%len) // "/" // copy, iostat=iostat )
          if ( iostat == 0 ) then
            if ( trace ) write ( *, '(a,a)' ) 'Start macro file ', &
                & path%path(:path%len) // "/" // trim(copy)
            return
          end if
          path => path%next
        end do
        ext => ext%next
      end do
      macro_depth = macro_depth - 1
      open_macro = -1
    end function Open_Macro

  end subroutine MACRO_PASS

end module MACRO_PASS_M

!>> 2011-08-14 Get U_SCR2 format from IO_UNITS
!>> 2011-09-04 Include column 12 in label substituted for )00
!>> 2011-09-18 Handle substitutions in comments correctly
