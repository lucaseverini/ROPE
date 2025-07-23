module ZONE_M

  use BCD_TO_ASCII_M, only: BCD_TO_ASCII

  ! Handle putting zones on numbers

  implicit NONE
  public

  character :: ZONED(0:9,0:3)

contains

  subroutine Init_Zoned
    zoned = reshape( (/ &
      & bcd_to_ascii(10), bcd_to_ascii(1:9),      & ! 0-9
      & bcd_to_ascii(26), bcd_to_ascii(17:25),    & ! RM, /, S-Z
      & bcd_to_ascii(42), bcd_to_ascii(33:41),    & ! !, J-R
      & bcd_to_ascii(58), bcd_to_ascii(49:57) /), & ! ?, A-I
      & (/ 10,4 /) )
  end subroutine Init_Zoned

  subroutine ADDR_TO_NUM ( ADDR, NUM, INDEX )
    character(3), intent(in) :: ADDR
    integer, intent(out) :: NUM, INDEX
    integer :: I, J
    if ( addr == '###' ) go to 9
    num = 0
    call findIJ ( addr(1:1) ) ! hundreds digit
    if ( j < 0 ) go to 9
    num = 100*i + 1000*j
    call findIJ ( addr(2:2) ) ! tens digit
    if ( j < 0 ) go to 9
    num = num + 10*i
    index = j
    call findIJ ( addr(3:3) ) ! units digit
    if ( j < 0 ) go to 9
    num = num + i + 4000*j
    return
  9 continue
    num = -1
    index = 0    
  contains
    subroutine FindIJ ( C )
      character, intent(in) :: C
      do j = 0, 3
        do i = 0, 9
          if ( c == zoned(i,j) ) return
        end do
      end do
      j = -1
    end subroutine FindIJ
  end subroutine ADDR_TO_NUM

  subroutine NUM_TO_ADDR ( NUM, INDEX, ADDR, NEG )
    integer, intent(in) :: NUM, INDEX
    character(3), intent(out) :: ADDR
    logical, intent(out), optional :: NEG
    integer :: DIGIT, HIGH, MyNum
    if ( present(neg) ) neg = num < 0
    if ( num < -15999 ) then
      addr = '###'
    else
      myNum = mod(abs(num),16000)
      high = myNum / 1000
      digit = mod(myNum,10)
      addr(3:3) = zoned(digit,high/4)
      digit = mod(myNum/10,10)
      addr(2:2) = zoned(digit,index)
      digit = mod(myNum/100,10)
      addr(1:1) = zoned(digit,mod(high,4))
    end if
  end subroutine NUM_TO_ADDR

end module ZONE_M

!>> 2011-08-14 Added Addr_To_Num
