program TO_SIMH

! Read a "tape" in the format written by Van Snyder's autocoder, and
! write it in the format Supnik's simh 1401 simulator
! (simh.trailing-edge.com) expects.

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

  use Machine ! at least for IO_Error and HP, but maybe for getarg too

  integer, parameter :: OutBufSz = 32 ! Record size for output.
    ! This is a compromise between frequent writes, and wasted space,
    ! since Fortran can only write fixed-size-record direct-access
    ! files.  Direct access is used because on many systems such files
    ! are written with no "record envelopes."  Until Fortran 2003
    ! processors are widely available, this is the closest we can get
    ! to stream I/O.

  integer :: IOSTAT, N1, N2
  character(len=160) InBuf
  character(len=1023) Line ! from the command line
  character(len=outBufSz) :: OutBuf
  integer :: Pos, Rec      ! Position in record, Record number

  call getarg ( hp+1, line )

  open ( 10, file=trim(line), form='formatted', access='sequential', &
    & status='old', iostat=iostat )
  if ( iostat /= 0 ) then
    call io_error ( 'While opening input file', iostat, trim(line) )
    stop
  end if

  call getarg ( hp+2, line )

  open ( 11, file=trim(line), form='unformatted', access='direct', &
    & recl=outBufSz, iostat=iostat )
  if ( iostat /= 0 ) then
    call io_error ( 'While opening output file', iostat, trim(line) )
    stop
  end if

  pos = 0
  rec = 1
  do
    read ( 10, '(2i3,a)', end=9 ) n1, n2, inbuf(:n1)
    call output_count ( n1 )
    call output_ascii ( inbuf(:n1) )
    if ( mod(n1,2) /= 0 ) call output ( 0 ) ! simh wants even length
    call output_count ( n1 )
  end do
9 call output_count ( 0 ) ! end-of-file mark
  do while ( pos < outBufSz )
    call output ( 0 )
  end do

  close ( 10 )
  close ( 11 )

contains

  subroutine Output ( N )
    integer, intent(in) :: N
    ! Output N as an 8-bit number
    pos = pos + 1
    if ( pos > outBufSz ) then
      write ( 11, rec=rec ) outBuf
      rec = rec + 1
      pos = 1
    end if
    outBuf(pos:pos) = char(n)
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

end program TO_SIMH
