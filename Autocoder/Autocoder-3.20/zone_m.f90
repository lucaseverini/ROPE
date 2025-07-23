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

  subroutine NUM_TO_ADDR ( NUM, INDEX, ADDR )
    integer, intent(in) :: NUM, INDEX
    character(3), intent(out) :: ADDR
    integer :: DIGIT, HIGH, MyNum
    myNum = num
    if ( myNum < 0 ) myNum = 16000 + myNum
    if ( num < 0 .or. num > 15999 ) then
      addr = '###'
    else
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
