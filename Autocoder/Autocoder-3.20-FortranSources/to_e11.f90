program TO_SIMH_E11

! Read a "tape" in the format written by Van Snyder's autocoder, and
! write it in the E11 format Supnik's simh 1401 simulator
! (simh.trailing-edge.com) expects.  E11 is different from SIMH in that
! odd-length records are not padded.

! In Snyder's format, records are ASCII.  Each record begins with a
! three-digit total-record length, which includes word marks, followed
! by a three-digit data-only length, which would be the length if a
! word mark were represented by a bit in each character, followed by the
! data.  Word marks are represented by =, and apply to the next
! character, as for the 1401.  The mapping from BCD to ASCII is given
! by the array ascii_to_bcd.

! simh wants records on "tapes" to be represented by a 32-bit little-
! endian count before and after the record.  The characters are
! represented in the low-order six bits of each byte, in BCD, with no
! parity.  A word mark is represented by a word mark character before
! the data character, just like on 1401 tapes.  The number of
! characters in each record has to be even, even if the count is odd. 
! simh ignores the extra character.

! Output is done using Fortran unformatted write, which happens to
! produce what simh wants on many systems.

  use BCD_to_ASCII_m, only: ASCII_to_BCD
  use Machine ! at least for IO_Error and HP, but maybe for getarg too

  integer :: I, IOSTAT, N1, N2
  character(len=160) :: InBuf
  character(len=1023) :: Line ! From the command line

  call getarg ( hp+1, line )

  open ( 10, file=trim(line), form='formatted', access='sequential', &
    & status='old', iostat=iostat )
  if ( iostat /= 0 ) then
    call io_error ( 'While opening input file', iostat, trim(line) )
    stop
  end if

  call getarg ( hp+2, line )

  open ( 11, file=trim(line), form='unformatted', access='sequential', &
    & iostat=iostat )
  if ( iostat /= 0 ) then
    call io_error ( 'While opening output file', iostat, trim(line) )
    stop
  end if

  do
    read ( 10, '(2i3,a)', end=9 ) n1, n2, inbuf(:n1)
    do i = 1, n1
      inbuf(i:i) = char(ascii_to_bcd(iachar(inbuf(i:i))))
    end do
    write ( 11 ) inbuf(:n1)
  end do

  write ( 11 ) ! Maybe this writes a record with zero in the count field.
  ! simh appears to be happy without a 0x00000000 record to mark EOF, so
  ! long as the file ends.

9 close ( 10 )
  close ( 11 )

end program TO_SIMH_E11
