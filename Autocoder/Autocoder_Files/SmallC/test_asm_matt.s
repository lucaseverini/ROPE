     ****************************************************************
     READ      EQU  001               *  Read area
     PUNCH     EQU  101               *  Punch area
     PRINT     EQU  201               *  Print area
     PRCPOS    DCW  000               *  char position in print area
     PUCPOS    DCW  000               *  char position in punch area
     PUNSIZ    DCW  @080@             *  Size of punch area
     PRTSIZ    DCW  @132@             *  Size of print area
     EOS       DCW  @'@               *  End Of String char
     EOL       DCW  @;@               *  End Of Line char
               ORG  87
     X1        DSA  0                 *  Index Register 1
               ORG  92
     X2        DSA  0                 *  Index Register 2 (stack pointer)
               ORG  97
     X3        DSA  0                 *  Index Register 3 (stack frame pointer)
     ****************************************************************
     * GLOBAL/STATIC DATA AND VARIABLES
     * START POSITION OF PROGRAM CODE
               ORG  1000
     * SET X2 TO BE THE STACK POINTER (STACK GROWS UPWARD)
     START     SBR  X2,399            * Set X2 to stack pointer value
               MCW  X2,X3             * Copy stack pointer in X3
               B    LBAAAA            * Jump to function main
               H                      * Program executed. System halts
     ********************************************************************************
     * Function : main
     ********************************************************************************
     LBAAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LCAAAA]
     * print size:3 offset:3
     * i size:5 offset:6
     * j size:5 offset:11
     * c size:5 offset:16
     * r size:5 offset:21
               LCA  LLAAAA,6+X3       * Load *char 201 into memory 6+X3
               LCA  LMAAAA,11+X3      * Load int 232 into memory 11+X3
               LCA  LNAAAA,16+X3      * Load int 4 into memory 16+X3
               LCA  LOAAAA,21+X3      * Load int 0 into memory 21+X3
               LCA  LPAAAA,26+X3      * Load int 1 into memory 26+X3
     * Push (26)
               MA   LQAAAA,X2         * Add 26 to stack pointer
     * Addition (i + j)
     * Local Variable (i : 11+X3)
     * Push (11+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  11+X3,0+X2        * Load memory 11+X3 in stack
     * Local Variable (j : 16+X3)
     * Push (16+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  16+X3,0+X2        * Load memory 16+X3 in stack
               A    0+X2,15995+X2     * Add stack to stack at -5
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * Push (@021@:3)
               MA   LTAAAA,X2         * Add 3 to stack pointer
               LCA  LUAAAA,0+X2       * Load data @021@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (c = (i + j))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LVAAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * End Assignment (c = (i + j))
     * While [while (((r * 10) < c)) [Block ending at LDAAAA] top:LEAAAA bottom:LFAAAA]
     * Less ((r * 10) < c)
     * Multiply (r * 10)
     * Local Variable (r : 26+X3)
     * Push (26+X3:5)
     LEAAAA    MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  26+X3,0+X2        * Load memory 26+X3 in stack
     * Constant (10 : @00010@)
     * Push (@00010@:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  LWAAAA,0+X2       * Load data @00010@ in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
               B    CLNNMN            * Jump to snippet clean_number
     * Local Variable (c : 21+X3)
     * Push (21+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  21+X3,0+X2        * Load memory 21+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
               MCW  LOAAAA,0+X2       * Move 0 in stack
               BL   LJAAAA            * Jump if less
               B    LKAAAA            * Jump to End
     LJAAAA    MCW  LPAAAA,0+X2       * Move 1 in stack
     LKAAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
               BCE  LHAAAA,5+X2       * Jump to bottom of While
     ***************************************
     * Begin [Block ending at LDAAAA]
     * Multiply (r * 10)
     * Local Variable (r : 26+X3)
     * Push (26+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  26+X3,0+X2        * Load memory 26+X3 in stack
     * Constant (10 : @00010@)
     * Push (@00010@:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  LWAAAA,0+X2       * Load data @00010@ in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * Push (@026@:3)
               MA   LTAAAA,X2         * Add 3 to stack pointer
               LCA  LQAAAA,0+X2       * Load data @026@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (r = (r * 10))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LVAAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * End Assignment (r = (r * 10))
     * End [Block ending at LDAAAA]
     ***************************************
     LDAAAA    B    LEAAAA            * Jump to top of While
     * End While [while (((r * 10) < c)) [Block ending at LDAAAA] top:LEAAAA bottom:LFAAAA]
     * While [while (c) [Block ending at LGAAAA] top:LHAAAA bottom:LIAAAA]
     * Local Variable (c : 21+X3)
     * Push (21+X3:5)
     LHAAAA    MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  21+X3,0+X2        * Load memory 21+X3 in stack
               MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
               BCE  LIAAAA,5+X2       * Jump to bottom of While
     ***************************************
     * Begin [Block ending at LGAAAA]
     * d size:1 offset:26
               LCA  LXAAAA,27+X3      * Load char 48 into memory 27+X3
     * Push (1)
               MA   LYAAAA,X2         * Add 1 to stack pointer
     * Addition (((char) (c / r)) + '0')
     * Divide (c / r)
     * Local Variable (r : 26+X3)
     * Push (26+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  26+X3,0+X2        * Load memory 26+X3 in stack
     * Local Variable (c : 21+X3)
     * Push (21+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  21+X3,0+X2        * Load memory 21+X3 in stack
               B    SNPDIV            * Jump to snippet SNIP_DIV
               MCW  0+X2,15995+X2     * Move stack in stack at -5
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * Cast Number((c / r)) to Char
               B    NUMCHR            * Jump to snippet number_to_char
     * Constant ('0' : @0@)
     * Push (@0@:1)
               MA   LYAAAA,X2         * Add 1 to stack pointer
               LCA  LXAAAA,0+X2       * Load data @0@ in stack
               A    0+X2,15999+X2     * Add stack to stack at -1
     * Pop (1)
               MA   LZAAAA,X2         * Add -1 to stack pointer
     * Push (@027@:3)
               MA   LTAAAA,X2         * Add 3 to stack pointer
               LCA  LABAAA,0+X2       * Load data @027@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (d = (((char) (c / r)) + '0'))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LVAAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZAAAA,X2         * Add -1 to stack pointer
     * End Assignment (d = (((char) (c / r)) + '0'))
     * Local Variable (d : 27+X3)
     * Push (27+X3:1)
               MA   LYAAAA,X2         * Add 1 to stack pointer
               LCA  27+X3,0+X2        * Load memory 27+X3 in stack
     * Local Variable (print : 6+X3)
     * Push (6+X3:3)
               MA   LTAAAA,X2         * Add 3 to stack pointer
               LCA  6+X3,0+X2         * Load memory 6+X3 in stack
     * Assignment ((*print) = d)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LVAAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZAAAA,X2         * Add -1 to stack pointer
     * End Assignment ((*print) = d)
     * PostIncrement (print++)
     * Push (@006@:3)
               MA   LTAAAA,X2         * Add 3 to stack pointer
               LCA  LBBAAA,0+X2       * Load data @006@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LVAAAA,X2         * Add -3 to stack pointer
               MA   LYAAAA,0+X1       * Postincrement pointer at X1
     * Modulo (%) (c % r)
     * Local Variable (r : 26+X3)
     * Push (26+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  26+X3,0+X2        * Load memory 26+X3 in stack
     * Local Variable (c : 21+X3)
     * Push (21+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  21+X3,0+X2        * Load memory 21+X3 in stack
               B    SNPDIV            * Jump to snippet SNIP_DIV
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * Push (@021@:3)
               MA   LTAAAA,X2         * Add 3 to stack pointer
               LCA  LUAAAA,0+X2       * Load data @021@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (c = (c % r))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LVAAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * End Assignment (c = (c % r))
     * Divide (r / 10)
     * Constant (10 : @00010@)
     * Push (@00010@:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  LWAAAA,0+X2       * Load data @00010@ in stack
     * Local Variable (r : 26+X3)
     * Push (26+X3:5)
               MA   LRAAAA,X2         * Add 5 to stack pointer
               LCA  26+X3,0+X2        * Load memory 26+X3 in stack
               B    SNPDIV            * Jump to snippet SNIP_DIV
               MCW  0+X2,15995+X2     * Move stack in stack at -5
     * Pop (5)
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * Push (@026@:3)
               MA   LTAAAA,X2         * Add 3 to stack pointer
               LCA  LQAAAA,0+X2       * Load data @026@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (r = (r / 10))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LVAAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LSAAAA,X2         * Add -5 to stack pointer
     * End Assignment (r = (r / 10))
     * Pop (1)
     LGAAAA    MA   LZAAAA,X2         * Add -1 to stack pointer
     * End [Block ending at LGAAAA]
     ***************************************
               B    LHAAAA            * Jump to top of While
     * End While [while (c) [Block ending at LGAAAA] top:LHAAAA bottom:LIAAAA]
     LIAAAA    W    
     * Pop (26)
     LCAAAA    MA   LCBAAA,X2         * Add -26 to stack pointer
     * End [Block ending at LCAAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : main
     ********************************************************************************
     ****************************************************************
     ** CAST INTEGER TO CHAR SNIPPET **
     ****************************************************************
     NUMCHR    SBR  X1
     * Casts a 5-digit number to a 1-digit char
     * Copy the byte in last position of integer in the first position
               SW   0+X2
               LCA  0+X2,15996+X2
     * Make space on stack for a char instead of an int by subtracting 2 bytes to X2
               MA   @I9H@,X2
     * Jumps back to caller
               SBR  X2,15998+X2
               B    0+X1
     ****************************************************************
     ****************************************************************
     ** CLEAN NUMBER SNIPPET **
     ****************************************************************
     * Normalizes the zone bits of a number, leaving either A=0B=0
     * for a positive or A=0B=1 for a negative
     CLNNMN    SBR  X1
     * Do nothing on either no zone bits or only a b zone bit
               BWZ  CLNNME,0+X2,2
               BWZ  CLNNME,0+X2,K
     * else clear the zone bits, as it is positive
               MZ   @ @,0+X2
     CLNNME    B    0+X1
     ****************************************************************
     ****************************************************************
     ** DIVISION SNIPPET **
     ****************************************************************
     * SETUP RETURN ADDRESS
     SNPDIV    SBR  DIVEND+3
     * POP DIVIDEND
               MCW  0+X2,CDIV2
               SBR  X2,15995+X2
     * POP DIVISOR
               MCW  0+X2,CDIV1
               SBR  X2,15995+X2
               B    *+17              * Branch 17 places down?
               DCW  @00000@
               DC   @00000000000@
               ZA   CDIV2,*-7
               D    CDIV1,*-19
               MZ   *-22,*-21
               MZ   *-29,*-34
               MCW  *-41,CDIV3
               SW   *-44              * SO I CAN PICKUP REMAINDER
               MCW  *-46,CDIV4
               CW   *-55              * CLEAR THE WM
               MZ   CDIV3-1,CDIV3
               MZ   CDIV4-1,CDIV4
     * PUSH REMAINDER
               SBR  X2,5+X2
               SW   15996+X2
               MCW  CDIV4,0+X2
     * PUSH QUOTIENT
               SBR  X2,5+X2
               SW   15996+X2
               MCW  CDIV3,0+X2
     * JUMP BACK
     DIVEND    B    000
     * DIVISOR
     CDIV1     DCW  00000
     * DIVIDEND
     CDIV2     DCW  00000
     * QUOTIENT
     CDIV3     DCW  00000
     * REMAINDER
     CDIV4     DCW  00000
     ****************************************************************
     LYAAAA    DCW  @001@
     LPAAAA    DCW  @00001@
     LVAAAA    DCW  @I9G@
     LZAAAA    DCW  @I9I@
     LNAAAA    DCW  @00004@
     LTAAAA    DCW  @003@
     LRAAAA    DCW  @005@
     LWAAAA    DCW  @00010@
     LBBAAA    DCW  @006@
     LLAAAA    DCW  @201@
     LCBAAA    DCW  @I7D@
     LXAAAA    DCW  @0@
     LMAAAA    DCW  @00232@
     LABAAA    DCW  @027@
     LSAAAA    DCW  @I9E@
     LUAAAA    DCW  @021@
     LOAAAA    DCW  @00000@
     LQAAAA    DCW  @026@
               END  START             * End of program code.
