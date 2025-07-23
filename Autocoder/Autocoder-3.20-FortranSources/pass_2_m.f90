module pass_2_m

! Resolve unresolved EQU's or ORG's

  use ERROR_M, only: DO_ERROR, ErrCode
  use FLAGS, only: TRACES
  use IO_UNITS, only: U_SCRATCH
  use LITERALS_M, only: LAST_LTORG, LITERALS, PROCESS_LTORG
  use OPERAND_M, only: K_ACTUAL, K_ASTERISK, K_DEVICE, K_SYMBOLIC, &
    & OPERANDS, X00
  use SYMTAB_M, only: REF, SYMBOLS

  implicit NONE
  private

  public :: Pass_2

contains

  subroutine Pass_2

    logical :: Change              ! A symbol got changed -- another pass
                                   !  could be fruitful
    integer :: IxLab               ! Index in Symbols of a label
    character(80) :: LINE          ! Input line
    integer :: New_Value           ! Usually operand(*)%addr or symbols()%value
    integer :: Num_Operands        ! in the scratch record
    integer :: P                   ! Program counter
    integer :: P_DA                ! P as of beginning of processing of DA
    integer :: P_IN                ! P from the input
    integer :: P_OFFSET            ! Either 0 or width-1
    logical :: UNDEF               ! An EQU or ORG is undefined
    character(5) :: WHY            ! Code for scratch record
    integer :: WIDTH               ! of the code generated from a scratch record

    last_ltorg = 1
    do
      if ( scan(traces,'P2') /= 0 ) print *, 'Rewind the scratch file'
      rewind ( u_scratch )
      p = 333
      change = .false.
      undef = .false.

      do
        read ( u_scratch, 200, end=300 ) why, line, ixLab, p_in, width, &
          & errCode, num_operands, operands(1:num_operands)
200     format ( a5, a80, 3i6, a1, i6, (4(3i6,a2,a1,a6)) )
        if ( line(6:6) == '*' ) cycle
        if ( why == 'LITS' ) then
          call process_ltorg ( p, .false., 'Pass 2.1', up_to=width )
          cycle
        end if
        if ( why == 'MACRO' ) cycle
        if ( p_in >= 0 ) p = p_in
        if ( line(16:18) == 'LTO' .or. line(16:18) == 'ORG' ) then
          if ( ixlab > 0 ) then
            if ( symbols(ixlab)%value <= ref ) then
              if ( p >= 0 ) then
                symbols(ixlab)%value = p
                change = .true.
              else
                undef = .true.
              end if
            end if
          end if
          select case ( operands(1)%kind )
          case ( k_actual )
            p = operands(1)%addr
          case ( k_asterisk )
            if ( p_in >= 0 ) p = p_in
            if ( p < 0 ) undef = .true.
          case ( k_symbolic )
            p = symbols(operands(1)%addr)%value
            if ( p < 0 ) undef = .true.
          end select
          if ( operands(1)%offset == x00 ) then
            p = p + 99
            p = p - mod(p,100)
          else
            p = p + operands(1)%offset
          end if
        else if ( line(16:18) == 'END' .or. line(16:18) == 'EX' ) then
          if ( p_in >= 0 ) p = p_in
        else if ( line(16:18) == 'EQU' ) then
          ! symbols(ixLab)%index doesn't need to be set again
          if ( ixlab /= 0 ) then
            if ( symbols(ixLab)%value <= ref ) then
              if ( operands(1)%kind == k_asterisk ) then
                if ( p >= 0 ) then
                  change = .true.
                  symbols(ixLab)%value = p - 1 + operands(1)%offset
                else
                  undef = .true.
                end if
              else if ( operands(1)%kind == k_symbolic ) then
                new_value = symbols(operands(1)%addr)%value
                if ( new_value > ref ) then
                  change = .true.
                  symbols(ixLab)%value = new_value + operands(1)%offset
                else
                  undef = .true.
                end if
              end if
            else if ( operands(1)%kind == k_device ) then
              symbols(ixLab)%dev = operands(1)%label
            end if
          end if
        else
          if ( p_in >= 0 ) p = p_in
          select case ( why )
          case ( '     ', 'GEN  ' )
            p_da = p ! In case next is FIELD or SBFLD
            if ( ixlab > 0 ) then
              p_offset = 0
              if ( line(16:18) == 'DC ' .or. line(16:18) == 'DCW' .or. &
                &  line(16:18) == 'DSA' ) p_offset = width - 1
              if ( symbols(ixlab)%value <= ref ) then
                if ( p >= 0 ) then
                  change = .true.
                  symbols(ixlab)%value = p + p_offset
                else
                  undef = .true.
                end if
              end if
            end if
            if ( ixlab >= 0 ) p = p + width
          case ( 'FIELD', 'SBFLD' )
            if ( ixlab > 0 ) then
              if ( symbols(ixLab)%value <= ref ) then
                if ( p >= 0 ) then
                  if ( why == 'SUB' ) then
                    new_value = operands(1)%addr
                  else
                    new_value = operands(2)%addr
                  end if
                  change = .true.
                  symbols(ixLab)%value = p_da + new_value - 1
                else
                  undef = .true.
                end if
              end if
            end if
          case ( 'AREA', 'LIT', 'ADCON' )
            if ( ixlab > 0 ) then ! an area-defining lit -- in the symbol table
              if ( symbols(ixlab)%value <= ref ) then
                if ( p >= 0 ) then
                  change = .true.
                  symbols(ixlab)%value = p + width - 1
                else
                  undef = .true.
                end if
              end if
            else if ( ixlab < 0 ) then ! in the literal table
              if ( literals(-ixlab)%addr < 0 ) then
                if ( p >= 0 ) then
                  change = .true.
                  literals(-ixlab)%addr = p + width - 1
                else
                  undef = .true.
                end if
              end if
            end if
            if ( literals(operands(1)%addr)%addr <= ref ) then
              if ( p >= 0 ) then
                change = .true.
                literals(operands(1)%addr)%addr = p + width - 1
              else
                undef = .true.
              end if
            end if
            if ( num_operands == 2 ) then
              if ( symbols(operands(1)%addr)%value <= ref ) then
                if ( p >= 0 ) then
                  change = .true.
                  symbols(operands(1)%addr)%value = p + width - 1
                else
                  undef = .true.
                end if
              end if
            end if
            if ( p_in <= 0 ) p = p + width
          end select
        end if
        if ( index(traces,'2') /= 0 ) &
          & print '(i6,1x,a5,1x,a)', p, why, trim(line)
      end do
300   continue
      rewind ( u_scratch )
      if ( .not. undef ) exit
      if ( .not. change ) then
        call do_error ( 'Undefined or unresolvable symbols' )
        exit
      end if
    end do
  end subroutine Pass_2

end module pass_2_m
