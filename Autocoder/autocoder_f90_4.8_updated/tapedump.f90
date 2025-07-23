program TapeDump
  ! Dump a tape that is in the format output by the Autocoder assembler:
  ! Data+word marks with the first four characters of the deck ID and a
  ! group mark with a word mark at the end.

  ! Input is from stdin.  Output is to stdout.

  use BCD_to_ASCII_m, only: BCD_to_ASCII, B_WM
  character(264) :: InBuf          ! Input from the tape
  character(132) :: Data, WMS      ! To print
  integer :: I, J                  ! Positions in input
  integer :: N                     ! Total length, data length 

  write ( *, '(2a)' ) '....5...10...15...20...25...30...35...40', &
    &                 '...45...50...55...60...65...70...75...80'
  do
    read ( *, '(a)', end=99 ) inBuf
    n = len_trim(inBuf)
    data = ''
    wms = ''
    i = 1
    j = 1
    do while ( i <= n )
      if ( inBuf(i:i) == bcd_to_ascii(B_WM) ) then
        wms(j:j) = '1'
        i = i + 1
      end if
      data(j:j) = inBuf(i:i)
      j = j + 1
      i = i + 1
    end do
    write ( *, '(a)' ) trim(data)
    write ( *, '(a)' ) trim(wms)
  end do
99 continue
end program TapeDump

!>> 2011-08-27 Revised tape format
!>> 2013-05-04 Increased record length, trim output lines
