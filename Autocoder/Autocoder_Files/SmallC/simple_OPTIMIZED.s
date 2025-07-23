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
     
     VAL4      DCW  @00004@
     VAL5      DCW  @00005@

               ORG  87
     X1        DSA  0                  * INDEX REGISTER 1
               ORG  92
     X2        DSA  0                  * INDEX REGISTER 2
               ORG  97
     X3        DSA  0                  * INDEX REGISTER 3
     
     * I need a single digit flag - should I replace this with a DA?
     RF        EQU  150

               ORG  3000
  
     START     NOP
     
     ****************************************************************  
     
               SBR  X2, 400            * SET THE STACK
               MCW  X2, X3
               B    LBAAAA
               H    
     LBAAAA    SBR  3+X3
               SW   1+X3
               SW   24+X3
               SW   19+X3
               SW   14+X3
               SW   9+X3
               SW   4+X3
     *         SW   29+X3
               LCA  VAL4,33+X3
     *         SW   34+X3
               LCA  VAL5,38+X3
     *         SW   39+X3
               LCA  VAL4,43+X3
               MA   @043@,X2
     * Push(33+X3:5)
     *         SW   1+X2
               MA   @005@,X2
               LCA  33+X3,0+X2
     * Push(38+X3:5)
     *         SW   1+X2
               MA   @005@,X2
               LCA  38+X3,0+X2
               A    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     *         CW   1+X2
     * Push(@043@:3)
     *         SW   1+X2
               MA   @003@,X2
               LCA  @043@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     *         CW   1+X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     *         CW   1+X2
     * Push(@00000@:5)
     *         SW   1+X2
               MA   @005@,X2
               LCA  @00000@,0+X2
     * Pop(15997+X3:5)
               MCW  0+X2,15997+X3
               MA   @I9E@,X2
     *         CW   1+X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LCAAAA
     LCAAAA    NOP  
               MA   @I5G@,X2
     *         CW   1+X3
     *         CW   24+X3
     *         CW   19+X3
     *         CW   14+X3
     *         CW   9+X3
     *         CW   4+X3
     *         CW   29+X3
     *         CW   34+X3
     *         CW   39+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
               END  START
