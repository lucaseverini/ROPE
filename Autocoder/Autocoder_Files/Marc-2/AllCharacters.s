               JOB  ALLCHARACTERS.S 04/06/17 23:04:26                      -5066
               HEAD
     NOZONE    DCW  @ 1234567890#@:>(@     *NO ZONE  SIMH ENCODING
     AZONE     DCW  @^/STUVWXYZ',%=\+@     * A ZONE
     BZONE     DCW  @-JKLMNOPQR!$*];_@     * B ZONE
     ABZONE    DCW  @&ABCDEFGHI?.)[<"@     *AB ZONE
     START     H
               MZ   AZONE-1,AZONE          *FIX BECAUSE + GETS CHANGED TO &
               MN   BZONE,AZONE            *FIX BECAUSE + GETS CHANGED TO &    
               MCW  @THIRD PROGRAM@,215
               W
               CS   299                    *CLEAR PRINT STORAGE
               MCW  NOZONE,216
               W
               MCW  @000@,X1
     TAG1      MZ   @ @,201+X1
               MA   @001@,X1
               C    X1,@016@
               BH   TAG1
               W
               CS   299
               W
               MCW  AZONE,216
               W
               MCW  @000@,X1
     TAG2      MZ   @ @,201+X1
               MA   @001@,X1
               C    X1,@016@
               BH   TAG2
               W
               CS   299
               W 
               MCW  BZONE,216
               W
               MCW  @000@,X1
     TAG3      MZ   @ @,201+X1
               MA   @001@,X1
               C    X1,@016@
               BH   TAG3
               W
               CS   299
               W    
               MCW  ABZONE,216
               W
               MCW  @000@,X1
     TAG4      MZ   @ @,201+X1
               MA   @001@,X1
               C    X1,@016@
               BH   TAG4
               W
               CS   299  
               W
               B    START
               NOP
               END  START
