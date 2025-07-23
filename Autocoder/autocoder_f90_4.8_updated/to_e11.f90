program TO_SIMH_E11

! Read a "tape" in the format written by Van Snyder's autocoder, and
! write it in the E11 format Supnik's simh 1401 simulator
! (simh.trailing-edge.com) expects.  E11 is different from SIMH in that
! odd-length records are not padded.

! Autocoder writes records in ASCII.  Each record ends with a group mark
! and a word mark, which are trimmed off here.  The mapping from ASCII
! to BCD is given by the array ascii_to_bcd.

! simh wants records on "tapes" to be represented by a 32-bit little-
! endian count before and after the record.  The characters are
! represented in the low-order six bits of each byte, in BCD, with no
! parity.  A word mark is represented by a word mark character before
! the data character, just like on 1401 tapes.

! Output is done using Fortran unformatted write, which happens to
! produce what simh wants on many systems.

  use BCD_to_ASCII_m, only: ASCII_to_BCD, B_GRPMRK, B_WM, Encodings, &
    & Fill_Encoding, &
    & Pierce_A_Encoding, Pierce_H_Encoding, SIMH_Encoding, Icelandic_Encoding
  use Machine, only: get_command_argument, hp, io_error

  implicit NONE

  character(5) :: Codes = 'AHSI*'
  integer :: ICodes(4) = (/ Pierce_A_Encoding, Pierce_H_Encoding, SIMH_Encoding, &
                    &       Icelandic_Encoding /)
  integer :: E, I, IOSTAT, N
  character(len=32000) :: InBuf
  character(len=1023) :: Line ! From the command line
  character(len=63) :: MyEncoding
  character(2) :: WMGM_Test ! Test for WM and GM

  e = Pierce_A_Encoding
  n = 0
  do
    n = n + 1
    call get_command_argument ( hp+n, line )
    if ( line(1:1) /= '-' ) exit
    if ( line(2:2) /= 'e' ) call usage
    e = scan(line(3:3), codes)
    if ( e == 0 ) call usage
  end do

  if ( e < 5 ) myEncoding = encodings(iCodes(e))
  call fill_encoding ( myEncoding )
  wmgm_test = myEncoding(b_wm:b_wm) // &
            & myEncoding(b_grpmrk:b_grpmrk)

  if ( line == '' ) call usage
 
   open ( 10, file=trim(line), form='formatted', access='sequential', &
    & status='old', iostat=iostat, recl=len(inBuf) )
  if ( iostat /= 0 ) then
    call io_error ( 'While opening input file', iostat, trim(line) )
    stop
  end if

  call get_command_argument ( hp+n+1, line )

  open ( 11, file=trim(line), form='unformatted', access='sequential', &
    & iostat=iostat, recl=len(inBuf) )
  if ( iostat /= 0 ) then
    call io_error ( 'While opening output file', iostat, trim(line) )
    stop
  end if

  do
    read ( 10, '(a)', end=9 ) inbuf
    n = len_trim(inbuf)
    if ( inbuf(n-1:n) == wmgm_test ) n = n - 2
    do i = 1, n
      inbuf(i:i) = char(ascii_to_bcd(iachar(inbuf(i:i))))
    end do
    write ( 11 ) inbuf(:n)
  end do

  write ( 11 ) ! Maybe this writes a record with zero in the count field.
  ! simh appears to be happy without a 0x00000000 record to mark EOF, so
  ! long as the file ends.

9 close ( 10 )
  close ( 11 )

contains

  subroutine Usage
    call get_command_argument ( 0, line )
    print '(a)', 'Usage: ' // trim(line) // ' [encoding] input output'
    print '(a)', ' "encoding" specifies the encoding of the input file using'
    print '(a)', '   -eA for Pierce A encoding (default)'
    print '(a)', '   -eH for Pierce H encoding'
    print '(a)', '   -eS for traditional SimH encoding'
    print '(a)', '   -eI for Icelandic encoding'
    print '(a)', '   -e*string for explicit encoding'
    print '(a)', '  For explicit encoding, "string" is a string of 63'
    print '(a)', '  characters, in BCD order, starting with 1; blank'
    print '(a)', '  is assumed to be zero.'
    stop
  end subroutine Usage

end program TO_SIMH_E11
