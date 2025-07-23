     
     ****************************************************************

     READ      EQU  001                * Read area
     PUNCH     EQU  101                * Punch area
     PRINT     EQU  201                * Print area
     
     PRCPOS    DCW  000                * char position in print area
     PUCPOS    DCW  000                * char position in punch area
     PUNSIZ    DCW  @080@              * Size of punch area
     PRTSIZ    DCW  @132@              * Size of print area
     EOS       DCW  @'@                * End Of String char (string terminator)
     EOL       DCW  @;@                * End Of Line char

               ORG  87
     X1        DSA  0                  * INDEX REGISTER 1
               ORG  92
     X2        DSA  0                  * INDEX REGISTER 2
               ORG  97
     X3        DSA  0                  * INDEX REGISTER 3
     
     * I need a single digit flag - should I replace this with a DA?
     RF        EQU  150

               ORG  6000
  
     START     NOP
     
     ****************************************************************  
     
               SBR  X2, 400            * SET THE STACK
               MCW  X2, X3
               SW   1012
               MCW  EOS,1012
               SW   1011
               MCW  @D@,1011
               SW   1010
               MCW  @L@,1010
               SW   1009
               MCW  @R@,1009
               SW   1008
               MCW  @O@,1008
               SW   1007
               MCW  @W@,1007
               SW   1006
               MCW  @ @,1006
               SW   1005
               MCW  @O@,1005
               SW   1004
               MCW  @L@,1004
               SW   1003
               MCW  @L@,1003
               SW   1002
               MCW  @E@,1002
               SW   1001
               MCW  @H@,1001
               SW   1023
               MCW  EOS,1023
               SW   1022
               MCW  @Y@,1022
               SW   1021
               MCW  @A@,1021
               SW   1020
               MCW  @P@,1020
               SW   1019
               MCW  @A@,1019
               SW   1018
               MCW  @P@,1018
               SW   1017
               MCW  @ @,1017
               SW   1016
               MCW  @N@,1016
               SW   1015
               MCW  @A@,1015
               SW   1014
               MCW  @E@,1014
               SW   1013
               MCW  @S@,1013
               SW   1034
               MCW  EOS,1034
               SW   1033
               MCW  @A@,1033
               SW   1032
               MCW  @V@,1032
               SW   1031
               MCW  @E@,1031
               SW   1030
               MCW  @L@,1030
               SW   1029
               MCW  @P@,1029
               SW   1028
               MCW  @ @,1028
               SW   1027
               MCW  @T@,1027
               SW   1026
               MCW  @T@,1026
               SW   1025
               MCW  @A@,1025
               SW   1024
               MCW  @M@,1024
               SW   1048
               MCW  EOS,1048
               SW   1047
               MCW  @I@,1047
               SW   1046
               MCW  @N@,1046
               SW   1045
               MCW  @I@,1045
               SW   1044
               MCW  @R@,1044
               SW   1043
               MCW  @E@,1043
               SW   1042
               MCW  @V@,1042
               SW   1041
               MCW  @E@,1041
               SW   1040
               MCW  @S@,1040
               SW   1039
               MCW  @ @,1039
               SW   1038
               MCW  @A@,1038
               SW   1037
               MCW  @C@,1037
               SW   1036
               MCW  @U@,1036
               SW   1035
               MCW  @L@,1035
               SW   1050
               MCW  EOS,1050
               SW   1049
               MCW  @W@,1049
               SW   1059
               MCW  EOS,1059
               SW   1058
               MCW  @9@,1058
               SW   1057
               MCW  @9@,1057
               SW   1056
               MCW  @2@,1056
               SW   1055
               MCW  @ @,1055
               SW   1054
               MCW  @ @,1054
               SW   1053
               MCW  @ @,1053
               SW   1052
               MCW  @S@,1052
               SW   1051
               MCW  @C@,1051
               B    LBAAAA
               H    
     LBAAAA    SBR  3+X3
               SW   1+X3
               SW   4+X3
               MCW  @00201@,6+X3
               SW   7+X3
               MCW  @'01@,9+X3
               SW   10+X3
               MCW  @'13@,12+X3
               SW   13+X3
               MCW  @'24@,15+X3
               SW   16+X3
               MCW  @'35@,18+X3
               SW   19+X3
               SW   24+X3
               MA   @028@,X2
     * Push(@00000@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00000@,0+X2
     * Push(@023@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @023@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
               CW   1+X2
     LEAAAA    NOP  
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
               B    LTAAAA
     * Push(@00011@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00011@,0+X2
               B    LTAAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               MCW  @00000@,0+X2
               BL   LVAAAA
               B    LWAAAA
     LVAAAA    MCW  @00001@,0+X2
     LWAAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               BCE  LFAAAA,5+X2, 
     * Push(9+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  9+X3,0+X2
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
     * Push(9+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  9+X3,0+X2
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:1)
               SW   1+X2
               MA   @001@,X2
               MCW  0+X1,0+X2
     * Push(6+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  6+X3,0+X2
     * Push(@028@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @028@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:5)
               SW   1+X2
               MA   @005@,X2
               MCW  0+X1,0+X2
               A    @00001@,0+X1
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
               CW   1+X2
     LDAAAA    NOP  
               BCE  LCAAAA,RF,R
     LGAAAA    NOP  
     * Push(@023@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @023@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
               A    @00001@,0+X1
               B    LEAAAA
     LFAAAA    NOP  
     * Inserting ASM snippet from code
               W    
               CS   299
     * Finish inserting ASM snippet from code
     * Inserting ASM snippet from code
               W    
               CS   299
     * Finish inserting ASM snippet from code
     * Push(@00000@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00000@,0+X2
     * Push(@023@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @023@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
               CW   1+X2
     LIAAAA    NOP  
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
               B    LTAAAA
     * Push(@00010@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00010@,0+X2
               B    LTAAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               MCW  @00000@,0+X2
               BL   LEBAAA
               B    LFBAAA
     LEBAAA    MCW  @00001@,0+X2
     LFBAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               BCE  LJAAAA,5+X2, 
     * Push(12+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  12+X3,0+X2
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
     * Push(12+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  12+X3,0+X2
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:1)
               SW   1+X2
               MA   @001@,X2
               MCW  0+X1,0+X2
     * Push(6+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  6+X3,0+X2
     * Push(@028@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @028@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:5)
               SW   1+X2
               MA   @005@,X2
               MCW  0+X1,0+X2
               A    @00001@,0+X1
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
               CW   1+X2
     LHAAAA    NOP  
               BCE  LCAAAA,RF,R
     LKAAAA    NOP  
     * Push(@023@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @023@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
               A    @00001@,0+X1
               B    LIAAAA
     LJAAAA    NOP  
     * Push(@ @:1)
               SW   1+X2
               MA   @001@,X2
               MCW  @ @,0+X2
     * Push(6+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  6+X3,0+X2
     * Push(@028@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @028@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:5)
               SW   1+X2
               MA   @005@,X2
               MCW  0+X1,0+X2
               A    @00001@,0+X1
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
               CW   1+X2
     * Push(@00000@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00000@,0+X2
     * Push(@023@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @023@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
               CW   1+X2
     LMAAAA    NOP  
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
               B    LTAAAA
     * Push(@00010@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00010@,0+X2
               B    LTAAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               MCW  @00000@,0+X2
               BL   LGBAAA
               B    LHBAAA
     LGBAAA    MCW  @00001@,0+X2
     LHBAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               BCE  LNAAAA,5+X2, 
     * Push(15+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  15+X3,0+X2
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
     * Push(15+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  15+X3,0+X2
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:1)
               SW   1+X2
               MA   @001@,X2
               MCW  0+X1,0+X2
     * Push(6+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  6+X3,0+X2
     * Push(@028@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @028@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:5)
               SW   1+X2
               MA   @005@,X2
               MCW  0+X1,0+X2
               A    @00001@,0+X1
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
               CW   1+X2
     LLAAAA    NOP  
               BCE  LCAAAA,RF,R
     LOAAAA    NOP  
     * Push(@023@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @023@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
               A    @00001@,0+X1
               B    LMAAAA
     LNAAAA    NOP  
     * Push(@ @:1)
               SW   1+X2
               MA   @001@,X2
               MCW  @ @,0+X2
     * Push(6+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  6+X3,0+X2
     * Push(@028@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @028@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:5)
               SW   1+X2
               MA   @005@,X2
               MCW  0+X1,0+X2
               A    @00001@,0+X1
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
               CW   1+X2
     * Push(@00000@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00000@,0+X2
     * Push(@023@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @023@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
               CW   1+X2
     LQAAAA    NOP  
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
               B    LTAAAA
     * Push(@00013@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00013@,0+X2
               B    LTAAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               MCW  @00000@,0+X2
               BL   LIBAAA
               B    LJBAAA
     LIBAAA    MCW  @00001@,0+X2
     LJBAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               BCE  LRAAAA,5+X2, 
     * Push(18+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  18+X3,0+X2
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
     * Push(18+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  18+X3,0+X2
     * Push(23+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  23+X3,0+X2
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:1)
               SW   1+X2
               MA   @001@,X2
               MCW  0+X1,0+X2
     * Push(6+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  6+X3,0+X2
     * Push(@028@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @028@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:5)
               SW   1+X2
               MA   @005@,X2
               MCW  0+X1,0+X2
               A    @00001@,0+X1
     * raw index on the stack
     * Push(@00001@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LXAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
               CW   1+X2
     LPAAAA    NOP  
               BCE  LCAAAA,RF,R
     LSAAAA    NOP  
     * Push(@023@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @023@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
               A    @00001@,0+X1
               B    LQAAAA
     LRAAAA    NOP  
     * Inserting ASM snippet from code
               W    
               CS   299
     * Finish inserting ASM snippet from code
     * Inserting ASM snippet from code
               W    
               CS   299
     * Finish inserting ASM snippet from code
     LCAAAA    NOP  
               MA   @I7B@,X2
               CW   1+X3
               CW   4+X3
               CW   7+X3
               CW   10+X3
               CW   13+X3
               CW   16+X3
               CW   19+X3
               CW   24+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     LTAAAA    SBR  X1
     * Normalizes the zone bits of a number, leaving either A=0B=0
     * for a positive or A=0B=1 for a negative
     * Do nothing on either no zone bits or only a b zone bit
               BWZ  LUAAAA,0+X2,2
               BWZ  LUAAAA,0+X2,K
     * else clear the zone bits, as it is positive
               MZ   @ @,0+X2
     LUAAAA    B    0+X1
     LXAAAA    SBR  X1
     * Casts a 5-digit number to a 3-digit address
     * make a copy of the top of the stack
               SW   1+X2
               MCW  0+X2,3+X2
     * zero out the zone bits of our copy
               MZ   @0@,3+X2
               MZ   @0@,2+X2
               MZ   @0@,1+X2
     * set the low-order digit's zone bits
               C    @04000@,0+X2
               BL   LABAAA
               C    @08000@,0+X2
               BL   LZAAAA
               C    @12000@,0+X2
               BL   LYAAAA
               S    @12000@,0+X2
               MZ   @A@,3+X2
               B    LABAAA
     LYAAAA    S    @08000@,0+X2
               MZ   @I@,3+X2
               B    LABAAA
     LZAAAA    S    @04000@,0+X2
               MZ   @S@,3+X2
     * For some reason the zone bits get set - it still works though.
     LABAAA    C    @01000@,0+X2
               BL   LDBAAA
               C    @02000@,0+X2
               BL   LCBAAA
               C    @03000@,0+X2
               BL   LBBAAA
               MZ   @A@,1+X2
               B    LDBAAA
     LBBAAA    MZ   @I@,1+X2
               B    LDBAAA
     LCBAAA    MZ   @S@,1+X2
     LDBAAA    MCW  3+X2,15998+X2
               CW   1+X2
               SBR  X2,15998+X2
               B    0+X1
               END  START
