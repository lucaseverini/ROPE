module PARSER

! Parser for 1401 Autocoder

  use BCD_TO_ASCII_m, only: Char_To_Digit
  use ERROR_M, only: DO_ERROR
  use FLAGS, only: TRACES
  use LEXER, only: LEX,  T_AT, T_CHARS,  T_COMMA, T_DEVICE, T_DONE, T_HASH, &
    & T_MINUS, T_NAME, T_NUMBER, T_OTHER, T_PLUS, T_STAR
  use LITERALS_M, only: CREATE_LIT, L_ADCON_LIT, L_ADDR_CON, L_AREA_DEF, &
    & L_CHAR_LIT, L_NUM_LIT, LITERALS
  use OPERAND_M, only: K_ACTUAL, K_ADCON_LIT, K_ADDR_CON, K_AREA_DEF, &
    & K_ASTERISK, K_BLANK_CON, K_CHAR_LIT, K_DA_OPT, K_DEVICE, K_NONE, &
    & K_NUM_LIT, K_OTHER, K_SYMBOLIC, NUM_OPERANDS, OPERAND, OPERANDS, &
    & OPERANDNAMES, X00
  use SYMTAB_M, only: ENTER, REF

  implicit NONE
  private

  public :: ADJUST, PARSE

  character, public, save :: SFX = ''

contains

  subroutine PARSE ( LINE, START, STATUS, ENTER_NAME, NO_LIT )
    ! Parse one operand, starting at Start in Line.  Set Start = 1 + end of
    ! last token.  Status = <0 -> Error,
    !                       0 -> Got a good operand ending with comma,
    !                       1 -> got a good operand ending with blank
    !                       >1 -> Done
    character(len=*), intent(in) :: LINE     ! of input
    integer, intent(inout) :: START          ! of next possible token
    integer, intent(out) :: STATUS
    logical, intent(in) :: ENTER_NAME        ! Enter a name into symtab
    logical, intent(in), optional :: NO_LIT  ! Don't do Create_lit

    integer :: Begin                         ! Start of operand, not token
    logical :: Do_Lit                        ! Do create_lit?
    integer :: End, Fin                      ! of a token
    character(6) :: LitText                  ! for adcon
    integer :: Next                          ! Num_Operands + 1
    integer :: Num
    integer :: Token, Token2                 ! T_... from Lexer module
    integer :: Width                         ! of an area-defining literal

    do_lit = .true.
    if ( present(no_lit) ) do_lit = .not. no_lit
    status = 0
    next = num_operands + 1
    operands(next) = operand(0,k_none,0,'  ',' ','      ') 
    call lex ( line, start, end, token )
    operands(next)%d = line(start:end)
    select case ( token )
    case ( t_at )
      num_operands = next
      operands(next)%addr = 0
      operands(next)%kind = k_other
      status = 2    ! Can only get t_at if it's the last thing
    case ( t_chars )                                             ! @...@
      num_operands = next
      operands(next)%kind = k_char_lit
      if ( do_lit ) then
        call create_lit ( l_char_lit, end-start-1, line(start+1:end-1), num )
        operands(next)%addr = num
      else
        operands(next)%addr = end - start - 1 ! don't count the @ signs in width
      end if
      call finish ( 'Character literals' )
    case ( t_comma )                                             ! ,
      start = end + 1
      call lex ( line, start, end, token )
      if ( token == t_done .or. line(start:end) == ' ' ) then ! , at end is OK
        num_operands = next
        operands(next)%kind = k_other
      else
        call parseError ( 'Operand missing', next )
      end if
    case ( t_device )                                            ! device
      num_operands = next
      operands(next) = operand(0,k_device,0,'  ',' ',line(start:end))
      call finish ( line(start:end) )
    case ( t_done )                                              ! done
      status = 2
      if ( num_operands > 0 ) then ! DONE makes an operand only if it's
        num_operands = next        ! not the first thing, so BCE X,Y, works
        operands(next) = operand(0,k_other,0,'  ',' ','      ')
      end if
    case ( t_other )                                             ! other
      num_operands = next
      operands(next)%addr = 0
      operands(next)%kind = k_other
      call finish ( line(start:end) )
    case ( t_hash )                                              ! #
      start = end + 1
      call lex ( line, start, end, token )
      if ( token == t_number ) then
        num_operands = next
        read ( line(start:end), * ) operands(next)%addr
        operands(next)%kind = k_blank_con
      else if ( token == t_done ) then
        num_operands = next
        operands(next)%addr = 0
        operands(next)%kind = k_other
      else
        call parseError ( 'Area definitions cannot have offset or indexing', &
          & next )
      end if
      call finish ( 'Area definitions' )
    case ( t_minus, t_plus )                                     ! +/-
      begin = start
      start = end + 1
      call lex ( line, start, end, token )
      select case ( token )
      case ( t_chars )                                           ! +/- @...@
        num_operands = next
        operands(next)%kind = k_adcon_lit
        if ( do_lit ) then
          call create_lit ( l_char_lit, end-start-1, line(start+1:end-1), num )
          call create_lit ( l_adcon_lit, end-start+2, line(start-1:end), &
            & operands(next)%addr )
          literals(operands(next)%addr)%width = num
        else
          operands(next)%addr = end-start-1
        end if
      case ( t_done )
        num_operands = next
        operands(next)%kind = k_other
      case ( t_name )                                            ! +/- name
        if ( end - start > 5 ) call parseError ( "Name too long", next )
        start = end + 1
        operands(next)%offset = 0
        litText = line(begin+1:end)
        if ( litText(6:6) == ' ' ) litText(6:6) = sfx
        call lex ( line, start, fin, token2 )
        if ( token2 == t_plus .or. token2 == t_minus ) then
          end = fin                                          ! +/- name +/-
          call adjust ( line, start, end, token, next, status )
        else
          fin = end + 2
        end if
        num_operands = next
        operands(next)%kind = k_addr_con
        operands(next)%label = litText
        if ( do_lit ) then
          call create_lit ( l_addr_con, 3, &
            & line(begin:begin) // trim(litText) // line(fin:end-1), &
            & num, operands(next)%offset, operands(next)%index )
          operands(next)%addr = num
          call enter ( litText, ref, 0, num )
          operands(next)%offset = 0  ! Offset and index are part of adcon,
          operands(next)%index = ' ' !  not operand
        else
          operands(next)%addr = 3
        end if
      case ( t_number )                                          ! +/- number
        num_operands = next
        operands(next)%kind = k_num_lit
        if ( do_lit ) then
          call create_lit ( l_num_lit, end-begin, line(begin:end), num )
          operands(next)%addr = num
        else
          operands(next)%addr = end - begin
        end if
      case default
        call parseError ( '+ or - must be followed by name or number', next )
      end select
      call finish ( 'Numeric literals and address constants' )
    case ( t_name, t_number, t_star )                  ! name, number, *
      select case ( token )
      case ( t_name )
        operands(next)%label = line(start:end)
        if ( line(start:end) == '' ) then
          operands(next)%kind = k_other
        else
          if ( end - start > 5 ) call parseError ( "Name too long", next )
          operands(next)%kind = k_symbolic
            if ( operands(next)%label(6:6) == '' ) &
              & operands(next)%label(6:6) = sfx
          if ( enter_name ) &
            & call enter ( operands(next)%label, ref, 0, operands(next)%addr )
        end if
      case ( t_number )
        operands(next)%kind = k_actual
        if ( do_lit ) then
          operands(next)%addr = 0
          if ( end > start ) read ( line(start:end-1), * ) operands(next)%addr
          num = char_to_digit(line(end:end))
          operands(next)%addr = 10 * sign(operands(next)%addr,num) + num
        else
          operands(next)%addr = end - start + 1
        end if
      case default
        operands(next)%kind = k_asterisk
      end select
      begin = start
      start = end + 1
      call lex ( line, start, end, token )
      select case ( token )
      case ( t_chars, t_star )                    ! name @...@ or name *
        call parseError ( 'Name must not be followed by * or character literal', &
          & next )
      case ( t_comma, t_done )                                  ! name ,
        num_operands = next
      case ( t_name, t_number, t_other )
        call parseError ( 'Missing punctuation', next )
      case ( t_hash )                                           ! name #
        if ( line(begin:begin) == '*' ) then
          call parseError ( 'Asterisk cannot be followed by #', next )
        else
          start = end + 1
          call lex ( line, start, end, token )
          if ( token == t_number ) then
            read ( line(start:end), * ) width
            litText = line(begin:start-2)
            if ( litText(6:6) == '' ) litText(6:6) = sfx
            call create_lit ( l_area_def, width, litText, num )
            num_operands = next
            operands(next)%addr = num
            operands(next)%kind = k_area_def
          else
            call parseError ( '# must be followed by a number', next )
          end if
        end if
        call finish ( 'Area-defining literal' )
      case ( t_minus, t_plus )                                ! name +/-
        call adjust ( line, start, end, token, next, status )
        num_operands = next
      end select
      call finish ( 'Offset or indexed name' )
      if ( status /= 0 ) num_operands = num_operands - 1
    end select
    start = end + 1
    if ( token == t_done ) then
      if ( status == 0 ) status = 1
    end if

    if ( index(traces,'p') /= 0 .and. num_operands > 0 ) &
      print *, 'Parser: operands(', num_operands, ')', &
        & '%addr = ', operands(num_operands)%addr, &
        & ', %kind = ', trim(operandNames(operands(num_operands)%kind)), &
        & ', %offset = ', operands(num_operands)%offset, &
        & ', %d = ', operands(num_operands)%d, &
        & ', %index = ', operands(num_operands)%index, &
        & ', %label = ', trim(operands(num_operands)%label)

  contains

    subroutine Finish ( What )
      character(len=*), intent(in) :: What ! are we working on
      if ( token == t_done ) return
      start = end + 1
      if ( token == t_comma ) return
      do
        call lex ( line, start, end, token )
        if ( token == t_done ) return
        start = end + 1
        if ( token == t_comma ) return
        if ( token == t_name ) then
          if ( line(start:end) == ' ' ) token = t_done
        end if
        if ( status == 0 ) call parseError ( &
          & what // ' must be last thing in operand', next )
      end do
    end subroutine Finish

    subroutine ParseError ( Message, Field )
      character(len=*), intent(in) :: Message
      integer, intent(in) :: Field
      call do_error ( message, field )
      status = -1
    end subroutine ParseError
  end subroutine PARSE

  subroutine ADJUST ( LINE, START, END, TOKEN, NEXT, STATUS )
  ! Process the stuff after + or - after a name, number or *
  ! Can be number + index, index, or x00.
    character(len=*), intent(in) :: LINE
    integer, intent(inout) :: START, END, STATUS
    integer, intent(out) :: TOKEN
    integer, intent(in) :: NEXT
    integer :: Offset ! number after &/-

    start = end + 1
    ! Get the token after +/-, prohibiting it to be signed with a zone
    call lex ( line, start, end, token, nosign=.true. )
    select case ( token )
    case ( t_name, t_number )               ! name +/- number
      operands(next)%offset = 0
   o: do
        if ( token == t_number ) then
          read ( line(start:end), * ) offset
          if ( line(start-1:start-1) == '-' ) offset = -offset
          operands(next)%offset = operands(next)%offset + offset
          start = end + 1
        else
          call index
        end if
        do
          call lex ( line, start, end, token )
          if ( token == t_plus .or. token == t_minus ) then
            ! name +/- number +/-
            start = end + 1
            call lex ( line, start, end, token )
            if ( token == t_name ) then
              call index   ! name +/- number + name
            else if ( token == t_number ) then
              exit
            else
              call do_error ( 'After &/- must be offset or index', next )
              exit o
            end if
          else if ( token /= t_comma .and. token /= t_done ) then
            call do_error ( 'Missing punctuation here', next )
            exit o
          else
            exit o
          end if
        end do
      end do o
    case default
      call do_error ( 'Offset or index must be number or X#', next )
      status = -1
    end select

  contains

    subroutine Index
      select case ( line(start:end) )
      case ( 'X0', 'X1', 'X2', 'X3' )
        operands(next)%index = line(end:end)
      case ( 'X00' )
        operands(next)%offset = x00
      case default
        call do_error ( 'Index must be X[0-3]', next )
        status = -1
      end select
      if ( line(start-1:start-1) == '-' ) then
        call do_error ( 'Index cannot be subtracted', next )
        status = -1
      end if
      start = end + 1
    end subroutine Index
  end subroutine ADJUST

end module PARSER
