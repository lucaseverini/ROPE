     ****************************************************************

     READ      EQU  001
     PUNCH     EQU  101
     PRINT     EQU  201

               ORG  87
     X1        DSA  0                  * INDEX REGISTER 1
               ORG  92
     X2        DSA  0                  * INDEX REGISTER 2
               ORG  97
     X3        DSA  0                  * INDEX REGISTER 3

               ORG  600
  
     START     NOP
     
     ****************************************************************  
     
               SBR  X2, 400            * SET THE STACK
               MCW  X2, X3
               SW   1001
               MCW  @00000@,1005
               SW   1006
               MCW  @A@,1006
               SW   1007
               B    LCAAAA
               H    
     LAAAAA    SBR  3+X3
               SW   1+X3
               SW   4+X3
               SW   4+X3
               SW   4+X3
               SW   17+X3
               SW   17+X3
               SW   17+X3
               MA   @023@,X2
               MA   @I7G@,X2
               CW   1+X3
               CW   4+X3
               CW   4+X3
               CW   4+X3
               CW   17+X3
               CW   17+X3
               CW   17+X3
               B    3+X3
     LBAAAA    SBR  3+X3
               SW   1+X3
               SW   4+X3
               MCW  @00314@,8+X3
               SW   9+X3
               SW   10+X3
               MA   @012@,X2
     * Push(@I9G@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(1006:1)
               SW   1+X2
               MA   @001@,X2
               MCW  1006,0+X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
               CW   1+X2
     * Push(@012@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @012@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(@008@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @008@,0+X2
               MA   X3,0+X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * Push(12+X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  12+X3,0+X2
     * Push(15997+X3:1)
               SW   1+X2
               MA   @001@,X2
               MCW  15997+X3,0+X2
     * Push(8+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  8+X3,0+X2
     * Push(X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  X3,0+X2
               MCW  X2,X3
               B    LAAAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
               CW   1+X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(3)
               MA   @I9G@,X2
               MA   @I8H@,X2
               CW   1+X3
               CW   4+X3
               CW   9+X3
               CW   10+X3
               B    3+X3
     LCAAAA    SBR  3+X3
               SW   1+X3
               SW   4+X3
               MCW  @00011@,8+X3
               SW   9+X3
               MCW  @A@,9+X3
               SW   10+X3
               MCW  @00022@,14+X3
               MA   @014@,X2
     * Push(@'09@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @'09@,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(@'05@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @'05@,0+X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * Push(9+X3:1)
               SW   1+X2
               MA   @001@,X2
               MCW  9+X3,0+X2
     * Push(X3:3)
               SW   1+X2
               MA   @003@,X2
               MCW  X3,0+X2
               MCW  X2,X3
               B    LBAAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
               CW   1+X2
     * Pop(1)
               MA   @I9I@,X2
               MA   @I8F@,X2
               CW   1+X3
               CW   4+X3
               CW   9+X3
               CW   10+X3
               B    3+X3
               END  START
