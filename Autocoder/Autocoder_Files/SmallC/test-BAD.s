     ****************************************************************
     ***  test.s
     ***  Generated by Small-C Compiler on 16-Mar-2015 3:01:09 AM
     ****************************************************************
     ****************************************************************

     READ      EQU  001                * Read area
     PUNCH     EQU  101                * Punch area
     PRINT     EQU  201                * Print area
     
     PRCPOS    DCW  000                * char position in print area
     PUCPOS    DCW  000                * char position in punch area
     PUNSIZ    DCW  @080@              * Size of punch area
     PRTSIZ    DCW  @132@              * Size of print area
     EOS       DCW  @'@                * End Of String char
     EOL       DCW  @;@                * End Of Line char

               ORG  87
     X1        DSA  0                  * INDEX REGISTER 1
               ORG  92
     X2        DSA  0                  * INDEX REGISTER 2
               ORG  97
     X3        DSA  0                  * INDEX REGISTER 3
     
     * I need a single digit flag - should I replace this with a DA?
     RF        EQU  340
     
     ****************************************************************
     
     * SET THE START POSITION OF VARIABLES INITIALIZATION DATA

               ORG  600
               DCW  @00100@

               ORG  605
               DCW  @00200@

               ORG  610
               DCW  @00000@

               ORG  615
               DCW  @618@

               ORG  618
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @'@

               ORG  630
               DCW  @633@

               ORG  633
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @A@
               DCW  @'@

               ORG  642
               DCW  @00001@

               ORG  647
               DCW  @650@

               ORG  650
               DCW  @B@
               DCW  @B@
               DCW  @B@
               DCW  @B@
               DCW  @B@
               DCW  @B@
               DCW  @B@
               DCW  @B@
               DCW  @'@

               ORG  659
               DCW  @A@
               DCW  @B@
               DCW  @C@
               DCW  @D@
               DCW  @E@
               DCW  @F@
               DCW  @G@
               DCW  @H@
               DCW  @'@

     * SET THE START POSITION OF CODE
               ORG  800
     START     NOP  

     * SET THE STACK POINTER (STACK GROWS UPWARD)
               SBR  X2,399
               MCW  X2,X3

               B    LBAAAA             * Jump to function main
               H                       * Program executed. System halted.

     ********************************************************************************
     * Function : main
     ********************************************************************************
     LBAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3

     ***************************************
     * BeginBlock [Block LCAAAA:null]
               LCA  @00100@,8+X3
               LCA  @659@,11+X3
               MA   @011@,X2
     * Assignment (x3 = (x0 + x1))
     * Addition (x0 + x1)
     * Static Variable (x0 : 604)
     * Push (604:5)
               MA   @005@,X2
               LCA  604,0+X2
     * Static Variable (x1 : 609)
     * Push (609:5)
               MA   @005@,X2
               LCA  609,0+X2
               A    0+X2,15995+X2
     * Pop (5)
               MA   @I9E@,X2
     * Push (@614@:3)
               MA   @003@,X2
               LCA  @614@,0+X2
     * Pop (X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop (0+X1:5)
               LCA  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment (c1 = c0)
     * Static Variable (c0 : 617)
     * Push (617:3)
               MA   @003@,X2           * 3
               LCA  617,0+X2           * 617
     * Push (@629@:3)
               MA   @003@,X2           * 3
               LCA  @629@,0+X2         * @629@
     * Pop (X1:3)
               LCA  0+X2,X1            * X1
               MA   @I9G@,X2           * -3
     * Pop (0+X1:3)
               LCA  0+X2,0+X1          * 0+X1
               MA   @I9G@,X2           * -3
     * Assignment (c1 = c4)
     * Local Variable (c4 : 11+X3)
     * Push (11+X3:3)
               MA   @003@,X2           * 3
               LCA  11+X3,0+X2         * 11+X3
     * Push (@629@:3)
               MA   @003@,X2           * 3
               LCA  @629@,0+X2         * @629@
     * Pop (X1:3)
               LCA  0+X2,X1            * X1
               MA   @I9G@,X2           * -3
     * Pop (0+X1:3)
               LCA  0+X2,0+X1          * 0+X1
               MA   @I9G@,X2           * -3
     * Assignment (x3 = x4)
     * Local Variable (x4 : 8+X3)
     * Push (8+X3:5)
               MA   @005@,X2           * 5
               LCA  8+X3,0+X2          * 8+X3
     * Push (@614@:3)
               MA   @003@,X2           * 3
               LCA  @614@,0+X2         * @614@
     * Pop (X1:3)
               LCA  0+X2,X1            * X1
               MA   @I9G@,X2           * -3
     * Pop (0+X1:5)
               LCA  0+X2,0+X1          * 0+X1
               MA   @I9E@,X2           * -5
     LCAAAA    NOP                     * Return
               MA   @I8I@,X2
               MCW  @ @,RF             * Clear the Return Flag
     * EndBlock [Block LCAAAA:null]
     ***************************************

               LCA  3+X3,X1
               B    0+X1               * Jump back to caller

     ********************************************************************************
     * End Function : main
     ********************************************************************************


               END  START              * End of program code.
