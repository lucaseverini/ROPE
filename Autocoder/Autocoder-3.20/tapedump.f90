program TapeDump
  ! Dump a tape that is in the format output by the Autocoder assembler:
  ! Three digit total length (including word marks)
  ! Three digit data-only length
  ! Data+word marks with the first four characters of the deck ID and a
  ! group mark with a word mark at the end.

  ! Input is from stdin.  Output is to stdout.

  character(160) :: InBuf          ! Input from the tape
  character(80) :: Data, WMS       ! To print
  integer :: I, J                  ! Positions in input
  integer :: M, N                  ! Total length, data length 

  write ( *, '(2a)' ) '....5...10...15...20...25...30...35...40', &
    &                 '...45...50...55...60...65...70...75...80'
  do
    read ( *, '(2i3,a)', end=99 ) m, n, inBuf(:m)
    data = ''
    wms = ''
    i = 1
    do j = 81-n, 80
      if ( inBuf(i:i) == '=' ) then
        wms(j:j) = '1'
        i = i + 1
      end if
      if ( i <= m ) data(j:j) = inBuf(i:i)
      i = i + 1
    end do
    write ( *, '(a)' ) data
    write ( *, '(a)' ) wms
  end do
99 continue
end program TapeDump
