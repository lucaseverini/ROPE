               JOB  FIFTH.S 05/24/17 12:49:21                              -5361
               HEAD
     NOZONE    DCW  @ 1234567890#@:>(@     *NO ZONE
     AZONE     DCW  @^/STUVWXYZ',%=\+@     * A ZONE
     BZONE     DCW  @-JKLMNOPQR!$*];_@     * B ZONE
     ABZONE    DCW  @&ABCDEFGHI?.)[<"@     *AB ZONE
     START     H
               MCW  @FIFTH PROGRAM@,216
               W
               CS   299                    *CLEAR PRINT STORAGE
               MCW  NOZONE,216
               W
               MCW  @000@,X1
     TAG1      MZ   @ @,201&X1
               MA   @001@,X1
               C    X1,@016@
               BH   TAG1
               W
               CS   299
               W
               MCW  AZONE,216
               W
               MCW  @000@,X1
     TAG2      MZ   @ @,201&X1
               MA   @001@,X1
               C    X1,@016@
               BH   TAG2
               W
               CS   299
               W 
               MCW  BZONE,216
               W
               MCW  @000@,X1
     TAG3      MZ   @ @,201&X1
               MA   @001@,X1
               C    X1,@016@
               BH   TAG3
               W
               CS   299
               W    
               MCW  ABZONE,216
               W
               MCW  @000@,X1
     TAG4      MZ   @ @,201&X1
               MA   @001@,X1
               C    X1,@016@
               BH   TAG4
               W
               CS   299  
               W
               B    START
               NOP
               END  START
