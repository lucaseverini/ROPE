program TO_SIMH

! Read a "tape" in the format written by Van Snyder's autocoder, and
! write it in the format Supnik's simh 1401 simulator
! (simh.trailing-edge.com) expects.

! Autocoder writes records in ASCII.  Each record ends with a group mark
! and a word mark, which are trimmed off here.  The mapping from ASCII
! to BCD is given by the array ascii_to_bcd.

! simh wants records on "tapes" to be represented by a 32-bit little-
! endian count before and after the record.  The characters are
! represented in the low-order six bits of each byte, in BCD, with no
! parity.  A word mark is represented by a word mark character before
! the data character, just like on 1401 tapes.  The number of
! characters in each record has to be even, even if the count is odd. 
! simh ignores the extra character.

  use BCD_to_ASCII_m, only: B_ALT, B_GRPMRK, B_WM, Encodings, Fill_Encoding, &
    & Pierce_A_Encoding, Pierce_H_Encoding, SIMH_Encoding, Icelandic_Encoding
  use Machine, only: Get_Command_Argument, IO_Error

  implicit NONE

  logical :: Alt = .false.  ! Replace blank with B_ALT
  character(5) :: Codes = 'AHSI*'
  integer :: ICodes(4) = (/ Pierce_A_Encoding, Pierce_H_Encoding, SIMH_Encoding, &
                    &       Icelandic_Encoding /)
  integer :: E, I, IOSTAT, N
  character(len=32000) InBuf
  character(len=1023) Line  ! from the command line
  integer :: Pos            ! Byte position in output file
  character(len=63) :: MyEncoding
  character(2) :: WMGM_Test ! Test for WM and GM

  e = Pierce_A_Encoding
  n = 0
  do
    n = n + 1
    call get_command_argument ( n, line )
    if ( line(1:1) /= '-' ) exit
    if ( line(2:3) == 'a' ) then
      alt = .true.
    else if ( line(2:2) == 'e' ) then
      e = scan(line(3:3), codes)
      if ( e == 0 ) call usage
    else
      call usage
    end if
  end do

  if ( e < 5 ) myEncoding = encodings(iCodes(e))
  call fill_encoding ( myEncoding )
  wmgm_test = myEncoding(b_wm:b_wm) // &
            & myEncoding(b_grpmrk:b_grpmrk)

  if ( line == '' ) call usage

  open ( 10, file=trim(line), form='formatted', access='sequential', &
    & status='old', iostat=iostat )
  if ( iostat /= 0 ) then
    call io_error ( 'While opening input file', iostat, trim(line) )
    stop
  end if

  call get_command_argument ( n+1, line )

  if ( line == '' ) call usage

!   open ( 11, file=trim(line), form='unformatted', access='stream', &
!     & iostat=iostat )
  open ( 11, file=trim(line), form='unformatted', access='direct', &
    & recl=1, iostat=iostat )
  if ( iostat /= 0 ) then
    call io_error ( 'While opening output file', iostat, trim(line) )
    stop
  end if

  pos = 0
  do
    read ( 10, '(a)', end=9 ) inbuf
    n = len_trim(inbuf)
    if ( inbuf(n-1:n) == wmgm_test ) n = n - 2
    if ( alt ) then
      do i = 1, n
        if ( inbuf(i:i) == '' ) inbuf(i:i) = myEncoding(b_alt:b_alt)
      end do
    end if
    inbuf(n+1:n+2) = ''
    n = n + mod(n,2)
    call output_count ( n )
    call output_ascii ( inbuf(:n) )
    call output_count ( n )
  end do
9 call output_count ( 0 ) ! end-of-file mark

  close ( 10 )
  close ( 11 )

contains

  subroutine Output ( N )
    integer, intent(in) :: N
    ! Output N as an 8-bit number
!     write ( 11 ) char(n)
    pos = pos + 1
    write ( 11, rec=pos ) char(n)
  end subroutine Output

  subroutine Output_Ascii ( Buf )
    use BCD_to_ASCII_m, only: ASCII_to_BCD
    character(len=*), intent(in) :: Buf
    ! output Buf one character at a time in BCD
    integer :: I
    do i = 1, len(buf)
      call output ( ascii_to_bcd(iachar(buf(i:i))) )
    end do
  end subroutine Output_Ascii

  subroutine Output_Count ( N )
    integer, intent(in) :: N
    ! Output N as 32-bit little-endian number
    integer :: I, J, K
    k = n
    do i = 1, 4
      j = mod(k,256)
      k = k / 256
      call output ( j )
    end do
  end subroutine Output_Count

  subroutine Usage
    call get_command_argument ( 0, line )
    print '(a)', 'Usage: ' // trim(line) // ' [options] input output'
    print '(a)', ' Options: -a => replace blank with 020 (0x10)'
    print '(a)', '          -eA for Pierce A encoding for the input file (default)'
    print '(a)', '          -eH for Pierce H encoding for the input file'
    print '(a)', '          -eS for traditional SimH encoding for the input file'
    print '(a)', '          -eI for Icelandic encoding for the input file'
    print '(a)', '          -e*string use explicit encoding for the input file'
    print '(a)', '  For explicit encoding, "string" is a string of 63'
    print '(a)', '  characters, in BCD order, starting with 1; blank'
    print '(a)', '  is assumed to be zero.'
    stop
  end subroutine Usage

end program TO_SIMH
