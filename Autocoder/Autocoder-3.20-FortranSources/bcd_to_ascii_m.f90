module BCD_TO_ASCII_M

  implicit NONE
  public

  integer :: ASCII_TO_BCD(0:255)
  data ASCII_TO_BCD / &
  ! 0000 - 0037: Control chars
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &

    o'00', o'52', o'77', o'13', o'53', o'34', o'60', o'32', &  ! o'040-0047:  !"#$%&'
    o'17', o'74', o'54', o'37', o'33', o'40', o'73', o'21', &  ! o'050-0057: ()*+,-./
    o'12', o'01', o'02', o'03', o'04', o'05', o'06', o'07', &  ! o'060-0067: 01234567
    o'10', o'11', o'15', o'56', o'76', o'35', o'16', o'72', &  ! o'070-0077: 89:;<=>?

    o'14', o'61', o'62', o'63', o'64', o'65', o'66', o'67', &  ! o'100-0107: @ABCDEFG
    o'70', o'71', o'41', o'42', o'43', o'44', o'45', o'46', &  ! o'110-0117: HIJKLMNO
    o'47', o'50', o'51', o'22', o'23', o'24', o'25', o'26', &  ! o'120-0127: PQRSTUVW
    o'27', o'30', o'31', o'75', o'36', o'55', o'20', o'57', &  ! o'130-0137: XYZ[\]^_

    o'00', o'61', o'62', o'63', o'64', o'65', o'66', o'67', &  ! o'140-0147: `abcdefg
    o'70', o'71', o'41', o'42', o'43', o'44', o'45', o'46', &  ! o'150-0157: hijklmno
    o'47', o'50', o'51', o'22', o'23', o'24', o'25', o'26', &  ! o'160-0167: pqrstuvw
    o'27', o'30', o'31', o'00', o'32', o'77', o'00', o'00', &  ! o'170-0177: xyz{|}~DEL
  ! 0200-0247: More control chars
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &

    o'00', o'20', o'00', o'00', o'74', o'00', o'00', o'00', &  ! o'240-0247:  ¡¢£¤¥¦§
    o'00', o'00', o'00', o'00', o'17', o'00', o'00', o'00', &  ! o'250-0257: ¨©ª«¬­®¯
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'260-0267: °±²³´µ¶·
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'270-0277: ¸¹º»¼½¾¿

    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'300-0307: ÀÁÂÃÄÅÆÇ
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'310-0317: ÈÉÊËÌÍÎÏ
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'320-0327: ÐÑÒÓÔÕÖ×
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'330-0337: ØÙÚÛÜÝÞß

    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'340-0347: àáâãäåæç
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'350-0357: èéêëìíîï
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00', &  ! o'360-0367: ðñòóôõö÷
    o'00', o'00', o'00', o'00', o'00', o'00', o'00', o'00'  &  ! o'370-0377: øùúûüýþÿ
  /

!  SIMH 1401 BCD encoding:
!  
!  Numeric     b 1 2 3 4 5 6 7 8 9 0 3 4 5 6 7
!  Rows        b                     8 8 8 8 8
!  ===========================================
!  No zone       1 2 3 4 5 6 7 8 9 0 # @ : > (  000-017 = 00-0F
!  0  zone A   ^ / S T U V W X Y Z ' , % = \ +  020-037 = 10-1F
!  11 zone B   - J K L M N O P Q R ! $ * ] ; _  040-057 = 20-2F
!  12 zone BA  & A B C D E F G H I ? . ) [ < "  060-077 = 30-3F
!  
!  ' is 0-2-8, and ^ has no input punch
!  (it may punch as zero on output).
!  
!  Pierce's primary BCD encoding:
!  
!  Numeric     b 1 2 3 4 5 6 7 8 9 0 3 4 5 6 7
!  Rows        b                     8 8 8 8 8
!  ===========================================
!  No zone       1 2 3 4 5 6 7 8 9 0 # @ : > {  000-017 = 00-0F
!  0  zone A   ^ / S T U V W X Y Z | , % ~ \ "  020-037 = 10-1F
!  11 zone B   - J K L M N O P Q R ! $ * ] ; _  040-057 = 20-2F
!  12 zone BA  & A B C D E F G H I ? . ) [ < }  060-077 = 30-3F
!  
!  | is 0-2-8, and ^ has no input punch
!  (it may punch as zero on output).
!  
!  Pierce's alternate BCD encoding:
!  
!  Numeric     b 1 2 3 4 5 6 7 8 9 0 3 4 5 6 7
!  Rows        b                     8 8 8 8 8
!  ===========================================
!  No zone       1 2 3 4 5 6 7 8 9 0 = ' : > {  000-017 = 00-0F
!  0  zone A   ^ / S T U V W X Y Z | , ( ~ \ "  020-037 = 10-1F
!  11 zone B   - J K L M N O P Q R ! $ * ] ; _  040-057 = 20-2F
!  12 zone BA  + A B C D E F G H I ? . ) [ < }  060-077 = 30-3F
!  
!  | is 0-2-8, and ^ has no input punch
!  (it may punch as zero on output).
!  
!  Differences:     12  0        0  0     0 12
!                       2  3  4  4  5  7  7  7
!                       8  8  8  8  8  8  8  8
!  ===========================================
!              SIMH  &  '  #  @  %  =  (  +  "
!    Pierce Primary  &  |  #  @  %  ~  {  "  }
!  Pierce Alternate  +  |  =  '  (  ~  {  "  }

  integer, parameter :: Pierce_A_Encoding = 1 ! IBM A-chain %)#&@
  integer, parameter :: Pierce_H_Encoding = 2 ! IBM H-chain ()=+'
  integer, parameter :: SIMH_Encoding = 3
  character, parameter :: CodeCodes(3) = (/'A','H','S'/) ! Command-line options
  integer :: Encoding = Pierce_A_Encoding

  character(63) :: Encodings(pierce_a_encoding:simh_encoding) = (/      &
    '1234567890#@:>{^/STUVWXYZ|,%~\"-JKLMNOPQR!$*];_&ABCDEFGHI?.)[<}',  &
    '1234567890='':>{^/STUVWXYZ|,(~\"-JKLMNOPQR!$*];_+ABCDEFGHI?.)[<}', &
    '1234567890#@:>(^/STUVWXYZ'',%=\+-JKLMNOPQR!$*];_&ABCDEFGHI?.)[<"'/)

  character :: BCD_TO_ASCII(0:66) = (/ &
             !        Octal
             ! Alt.     BCD     Card                   1401
             ! ASCII  BA8421    Code             Note  NAME

    & ' ', & !          000     blank                  Blank
             !      001-011     1 - 9                  1-9
    & '1', '2', '3', '4', '5', '6', '7', '8', '9', &
    & '0', & !          012     0                      0
    & '#', & !          013     3-8                    #
    & '@', & !          014     4-8                    @
    & ':', & !          015     5-8                2   : Colon
    & '>', & !          016     6-8                2   > Greater than
    & '(', & !  '¬'     017     7-8                2   ¬ Tape mark
    & '^', & !  '¢'     020     none               3   Blank on even parity tape
    & '/', & !          021     0-1                    /
             !      022-031     0-2 - 0-9              S-Z
    & 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', &
    & "'", & !  '|'     032     0-2-8                  Record mark
    & ',', & !          033     0-3-8                  ,
    & '%', & !          034     0-4-8                  %
    & '=', & !          035     0-5-8              1   = Word separator
    & '\', & !  "'"     036     0-6-8              2   ' Apostrophe
    & '+', & !          037     0-7-8              2   " Tape segment mark
    & '-', & !          040     11                     -
             !      041-051     11-1 - 11-9            J-R
    & 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', &
    & '!', & !          052     11-0                   ! (Minus zero)
    & '$', & !          053     11-3-8                 $
    & '*', & !          054     11-4-8                 *
    & ']', & !  ')'     055     11-5-8             2   ) Right parenthesis
    & ';', & !          056     11-6-8             2   ;
    & '_', & !          057     11-7-8             2   Delta
    & '&', & !          060     12                     &
             !      061-071     12-1 - 12-9            A-I
    & 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', &  
    & '?', & !          072     12-0                   & Plus zero
    & '.', & !          073     12-3-8                 .
    & ')', & !  '¤'     074     12-4-8                 ¤ Lozenge
    & '[', & !  '('     075     12-5-8             2   ( Left parenthesis
    & '<', & !          076     12-6-8             2   < Less than
    & '"', & !  '}'     077     12-7-8             1   Group mark
    & ' ', & !       Used for OPT in OP_CODES
    & '~', & !       Used for PRO in OP_CODES
    & '{'  & !       Used for REQ in OP_CODES
    /)
             !  Notes:  1.  Non-printing on "A" chain
             !          2.  Special character + note 1
             !          3.  No card code + note 2


    integer, parameter :: &

!  BCD characters              Octal Card    ASCII / Name
!                                    Code
      & B_BLANK   = 0    , &  ! 000  Blank   Blank
      & B_ONE     = 1    , &  ! 001  1       1
      & B_TWO     = 2    , &  ! 002  2       2
      & B_THREE   = 3    , &  ! 003  3       3
      & B_FOUR    = 4    , &  ! 004  4       4
      & B_FIVE    = 5    , &  ! 005  5       5
      & B_SIX	  = 6    , &  ! 006  6       6
      & B_SEVEN   = 7    , &  ! 007  7       7
      & B_EIGHT   = 8    , &  ! 010  8       8
      & B_NINE    = 9    , &  ! 011  9       9
      & B_ZERO    = 10   , &  ! 012  0       0
      & B_HASH    = 11   , &  ! 013  3-8     #
      & B_AT      = 12   , &  ! 014  4-8     @
      & B_COLON   = 13   , &  ! 015  5-8     :
      & B_GREATER = 14   , &  ! 016  6-8     >
      & B_TM      = 15   , &  ! 017  7-8     (¬ Tape Mark
      & B_ALT	  = 16   , &  ! 020  None    ^¢ Blank on even parity tape
      & B_SLASH   = 17   , &  ! 021  0-1     /
      & B_S	  = 18   , &  ! 022  0-2     S
      & B_T       = 19   , &  ! 023  0-3     T
      & B_U	  = 20   , &  ! 024  0-4     U
      & B_V       = 21   , &  ! 025  0-5     V
      & B_W	  = 22   , &  ! 026  0-6     W
      & B_X       = 23   , &  ! 027  0-7     X
      & B_Y       = 24   , &  ! 030  0-8     Y
      & B_Z       = 25   , &  ! 031  0-9     Z
      & B_RECMRK  = 26   , &  ! 032  0-2-8   '|
      & B_COMMA   = 27   , &  ! 033  0-3-8   ,
      & B_PERCNT  = 28   , &  ! 034  0-4-8   %
      & B_WM	  = 29   , &  ! 035  0-5-8   = Word separator, word mark on tape
      & B_BS	  = 30   , &  ! 036  0-6-8   \' Apostrophe
      & B_TS	  = 31   , &  ! 037  0-7-8   + Tape segment mark
      & B_MINUS   = 32   , &  ! 040  11      -
      & B_J       = 33   , &  ! 041  11-1    J
      & B_K       = 34   , &  ! 042  11-2    K
      & B_L       = 35   , &  ! 043  11-3    L
      & B_M	  = 36   , &  ! 044  11-3    M
      & B_N       = 37   , &  ! 045  11-4    N
      & B_O       = 38   , &  ! 046  11-6    O
      & B_P       = 39   , &  ! 047  11-7    P
      & B_Q       = 40   , &  ! 050  11-8    Q
      & B_R	  = 41   , &  ! 051  11-9    R
      & B_BANG    = 42   , &  ! 052  11-0    ! Minus zero
      & B_DOLLAR  = 43   , &  ! 053  11-3-8  $
      & B_ASTER   = 44   , &  ! 054  11-4-8  *
      & B_RPAREN  = 45   , &  ! 055  11-5-8  )]
      & B_SEMIC   = 46   , &  ! 056  11-6-8  ;
      & B_DELTA   = 47   , &  ! 057  11-7-8  _ Delta
      & B_AMPER   = 48   , &  ! 060  12      &
      & B_A       = 49   , &  ! 061  12-1    A
      & B_B	  = 50   , &  ! 062  12-2    B
      & B_C	  = 51   , &  ! 063  12-3    C
      & B_D       = 52   , &  ! 064  12-4    D
      & B_E	  = 53   , &  ! 065  12-5    E
      & B_F       = 54   , &  ! 066  12-6    F
      & B_G       = 55   , &  ! 067  12-7    G
      & B_H       = 56   , &  ! 070  12-8    H
      & B_I       = 57   , &  ! 071  12-9    I
      & B_QMARK   = 58   , &  ! 072  12-0    ? Plus zero
      & B_DECIMAL = 59   , &  ! 073  12-3-8  .
      & B_SQUARE  = 60   , &  ! 074  12-4-8  ¤ Lozenge
      & B_LPAREN  = 61   , &  ! 075  12-5-8  ([
      & B_LESS    = 62   , &  ! 076  12-6-8  <
      & B_GRPMRK  = 63        ! 077  12-7-8  "}

  ! Mutable encodings the Lexer cares about:
  !                      A   H   S
  character :: At     !  @   '   @
  character :: Dev    !  %   (   %
  character :: Hash   !  #   =   #
  character :: Plus   !  &   +   $
  equivalence ( bcd_to_ascii(b_at), at )
  equivalence ( bcd_to_ascii(b_percnt), dev )
  equivalence ( bcd_to_ascii(b_hash), hash )
  equivalence ( bcd_to_ascii(b_amper), plus )

contains

  integer function Char_To_Digit ( Char ) result ( Num )
    ! Convert a character to a signed digit
    character, intent(in) :: Char
    character(40) :: Ch = '0123456789|/STUVWXYZ!JKLMNOPQR?ABCDEFGHI'
    integer, parameter :: S(0:3) = (/ 1, 1, -1, 1 /) ! Sign
    ch(11:11) = bcd_to_ascii(b_recmrk)
    num = index(ch,char)
    if ( num == 0 ) then
      num = -100000
    else
      num = mod(num-1,10) * s((num-1)/10)
    end if
  end function Char_To_Digit 
     
end module BCD_TO_ASCII_M
