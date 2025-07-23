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
               ORG  2000              * seed
               DCW  @69105@
               ORG  2005              * CONST_STR_LITERAL_1
               DCW  @0@
               DCW  @1@
               DCW  @2@
               DCW  @3@
               DCW  @4@
               DCW  @5@
               DCW  @6@
               DCW  @7@
               DCW  @8@
               DCW  @9@
               DCW  @A@
               DCW  @B@
               DCW  @C@
               DCW  @D@
               DCW  @E@
               DCW  @F@
               DCW  @'@
               ORG  2022              * __putchar_pos
               DCW  @201@
               ORG  2025              * __putchar_last
               DCW  @200@
               ORG  2028              * __getCharPosition
               DCW  @081@
               ORG  2031              * za
               DCW  @00000@
               ORG  2036              * zb
               DCW  @00000@
     * START POSITION OF PROGRAM CODE
               ORG  2041
     * SET X2 TO BE THE STACK POINTER (STACK GROWS UPWARD)
     START     SBR  X2,399            * Set X2 to stack pointer value
               MCW  X2,X3             * Copy stack pointer in X3
               H                      * Program executed. System halts
     ********************************************************************************
     * Function : escape
     ********************************************************************************
     LSDAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LTDAAA]
     * Push (28)
               MA   LYFAAA,X2         * Add 28 to stack pointer
     * If [if ((timeout == 0) then [Block ending at LUDAAA]]
     * Equal (timeout == 0)
     * Parameter Variable (timeout : 15987+X3)
     * Push (15987+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15987+X3,0+X2     * Load memory 15987+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               BE   LIEAAA            * Jump if equal
               B    LJEAAA            * Jump to End
     LIEAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LJEAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LVDAAA,5+X2,      * Jump when False
     ***************************************
     * Begin [Block ending at LUDAAA]
     * Return to LTDAAA with return value 0
     * Put on stack return value (0)
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
     * Pop (15982+X3:5)
               LCA  0+X2,15982+X3     * Load stack in 15982+X3
               MA   LBGAAA,X2         * Add -5 to stack pointer
               B    LTDAAA            * Jump to end of function block
     * End [Block ending at LUDAAA]
     ***************************************
     * End If [if ((timeout == 0) then [Block ending at LUDAAA]]
     * If [if (((((a < 0) || (a > 128)) || (b < 0)) || (b > 64)) then [Block ending at LWDAAA]]
     * Or (||) ((((a < 0) || (a > 128)) || (b < 0)) || (b > 64))
     * Push (@00000@:5)
     LVDAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
     * Or (||) (((a < 0) || (a > 128)) || (b < 0))
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
     * Or (||) ((a < 0) || (a > 128))
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
     * Less (a < 0)
     * Parameter Variable (a : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LAGAAA,0+X2       * Move 0 in stack
               BL   LQEAAA            * Jump if less
               B    LREAAA            * Jump to End
     LQEAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LREAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LOEAAA,5+X2,      * Jump to Second if equal to stack at 5
               MCW  LCGAAA,0+X2       * Move 1 in stack
               B    LPEAAA            * Jump to End
     * Greater (a > 128)
     * Parameter Variable (a : 15997+X3)
     * Push (15997+X3:5)
     LOEAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (128 : @00128@)
     * Push (@00128@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LDGAAA,0+X2       * Load data @00128@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LAGAAA,0+X2       * Move 0 in stack
               BH   LSEAAA            * Jump if greater
               B    LTEAAA            * Jump to End
     LSEAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LTEAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LPEAAA,5+X2,      * Jump to End if equal to stack at 5
               MCW  LCGAAA,0+X2       * Move 1 in stack
     LPEAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LMEAAA,5+X2,      * Jump to Second if equal to stack at 5
               MCW  LCGAAA,0+X2       * Move 1 in stack
               B    LNEAAA            * Jump to End
     * Less (b < 0)
     * Parameter Variable (b : 15992+X3)
     * Push (15992+X3:5)
     LMEAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LAGAAA,0+X2       * Move 0 in stack
               BL   LUEAAA            * Jump if less
               B    LVEAAA            * Jump to End
     LUEAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LVEAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LNEAAA,5+X2,      * Jump to End if equal to stack at 5
               MCW  LCGAAA,0+X2       * Move 1 in stack
     LNEAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LKEAAA,5+X2,      * Jump to Second if equal to stack at 5
               MCW  LCGAAA,0+X2       * Move 1 in stack
               B    LLEAAA            * Jump to End
     * Greater (b > 64)
     * Parameter Variable (b : 15992+X3)
     * Push (15992+X3:5)
     LKEAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (64 : @00064@)
     * Push (@00064@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LEGAAA,0+X2       * Load data @00064@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LAGAAA,0+X2       * Move 0 in stack
               BH   LWEAAA            * Jump if greater
               B    LXEAAA            * Jump to End
     LWEAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LXEAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LLEAAA,5+X2,      * Jump to End if equal to stack at 5
               MCW  LCGAAA,0+X2       * Move 1 in stack
     LLEAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LXDAAA,5+X2,      * Jump when False
     ***************************************
     * Begin [Block ending at LWDAAA]
     * Return to LTDAAA with return value 1
     * Put on stack return value (1)
     * Constant (1 : @00001@)
     * Push (@00001@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LCGAAA,0+X2       * Load data @00001@ in stack
     * Pop (15982+X3:5)
               LCA  0+X2,15982+X3     * Load stack in 15982+X3
               MA   LBGAAA,X2         * Add -5 to stack pointer
               B    LTDAAA            * Jump to end of function block
     * End [Block ending at LWDAAA]
     ***************************************
     * End If [if (((((a < 0) || (a > 128)) || (b < 0)) || (b > 64)) then [Block ending at LWDAAA]]
     * Addition ((((a * a) / 32) - (4 * a)) + 128)
     * Subtract (((a * a) / 32) - (4 * a))
     * Divide ((a * a) / 32)
     * Constant (32 : @00032@)
     * Push (@00032@:5)
     LXDAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LFGAAA,0+X2       * Load data @00032@ in stack
     * Multiply (a * a)
     * Parameter Variable (a : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
     * Parameter Variable (a : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               B    SNPDIV            * Jump to snippet SNIP_DIV
               MCW  0+X2,15995+X2     * Move stack in stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Multiply (4 * a)
     * Constant (4 : @00004@)
     * Push (@00004@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LGGAAA,0+X2       * Load data @00004@ in stack
     * Parameter Variable (a : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               S    0+X2,15995+X2     * Subtract stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Constant (128 : @00128@)
     * Push (@00128@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LDGAAA,0+X2       * Load data @00128@ in stack
               A    0+X2,15995+X2     * Add stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@008@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LIGAAA,0+X2       * Load data @008@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (a2 = ((((a * a) / 32) - (4 * a)) + 128))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (a2 = ((((a * a) / 32) - (4 * a)) + 128))
     * Addition ((((b * b) / 32) - (2 * b)) + 32)
     * Subtract (((b * b) / 32) - (2 * b))
     * Divide ((b * b) / 32)
     * Constant (32 : @00032@)
     * Push (@00032@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LFGAAA,0+X2       * Load data @00032@ in stack
     * Multiply (b * b)
     * Parameter Variable (b : 15992+X3)
     * Push (15992+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
     * Parameter Variable (b : 15992+X3)
     * Push (15992+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               B    SNPDIV            * Jump to snippet SNIP_DIV
               MCW  0+X2,15995+X2     * Move stack in stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Multiply (2 * b)
     * Constant (2 : @00002@)
     * Push (@00002@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LKGAAA,0+X2       * Load data @00002@ in stack
     * Parameter Variable (b : 15992+X3)
     * Push (15992+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               S    0+X2,15995+X2     * Subtract stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Constant (32 : @00032@)
     * Push (@00032@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LFGAAA,0+X2       * Load data @00032@ in stack
               A    0+X2,15995+X2     * Add stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@013@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LLGAAA,0+X2       * Load data @013@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (b2 = ((((b * b) / 32) - (2 * b)) + 32))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (b2 = ((((b * b) / 32) - (2 * b)) + 32))
     * Addition (((((a * b) / 32) - (2 * b)) - a) + 64)
     * Subtract ((((a * b) / 32) - (2 * b)) - a)
     * Subtract (((a * b) / 32) - (2 * b))
     * Divide ((a * b) / 32)
     * Constant (32 : @00032@)
     * Push (@00032@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LFGAAA,0+X2       * Load data @00032@ in stack
     * Multiply (a * b)
     * Parameter Variable (a : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
     * Parameter Variable (b : 15992+X3)
     * Push (15992+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               B    SNPDIV            * Jump to snippet SNIP_DIV
               MCW  0+X2,15995+X2     * Move stack in stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Multiply (2 * b)
     * Constant (2 : @00002@)
     * Push (@00002@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LKGAAA,0+X2       * Load data @00002@ in stack
     * Parameter Variable (b : 15992+X3)
     * Push (15992+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               S    0+X2,15995+X2     * Subtract stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Parameter Variable (a : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               S    0+X2,15995+X2     * Subtract stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Constant (64 : @00064@)
     * Push (@00064@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LEGAAA,0+X2       * Load data @00064@ in stack
               A    0+X2,15995+X2     * Add stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@018@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LMGAAA,0+X2       * Load data @018@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (ab = (((((a * b) / 32) - (2 * b)) - a) + 64))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (ab = (((((a * b) / 32) - (2 * b)) - a) + 64))
     * Addition ((a2 - b2) + za)
     * Subtract (a2 - b2)
     * Local Variable (a2 : 8+X3)
     * Push (8+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  8+X3,0+X2         * Load memory 8+X3 in stack
     * Local Variable (b2 : 13+X3)
     * Push (13+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  13+X3,0+X2        * Load memory 13+X3 in stack
               S    0+X2,15995+X2     * Subtract stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Static Variable (za : 2035)
     * Push (2035:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  2035,0+X2         * Load memory 2035 in stack
               A    0+X2,15995+X2     * Add stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@023@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LNGAAA,0+X2       * Load data @023@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (new_a = ((a2 - b2) + za))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (new_a = ((a2 - b2) + za))
     * Addition ((2 * ab) + zb)
     * Multiply (2 * ab)
     * Constant (2 : @00002@)
     * Push (@00002@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LKGAAA,0+X2       * Load data @00002@ in stack
     * Local Variable (ab : 18+X3)
     * Push (18+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  18+X3,0+X2        * Load memory 18+X3 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Static Variable (zb : 2040)
     * Push (2040:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  2040,0+X2         * Load memory 2040 in stack
               A    0+X2,15995+X2     * Add stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@028@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LYFAAA,0+X2       * Load data @028@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (new_b = ((2 * ab) + zb))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (new_b = ((2 * ab) + zb))
     * Put on stack return value (escape(new_a, new_b, (timeout - 1)))
     * Function Call escape(new_a, new_b, (timeout - 1))
     * Push (5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
     * Subtract (timeout - 1)
     * Parameter Variable (timeout : 15987+X3)
     * Push (15987+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15987+X3,0+X2     * Load memory 15987+X3 in stack
     * Constant (1 : @00001@)
     * Push (@00001@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LCGAAA,0+X2       * Load data @00001@ in stack
               S    0+X2,15995+X2     * Subtract stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Local Variable (new_b : 28+X3)
     * Push (28+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  28+X3,0+X2        * Load memory 28+X3 in stack
     * Local Variable (new_a : 23+X3)
     * Push (23+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  23+X3,0+X2        * Load memory 23+X3 in stack
     * Create a stack frame with X3 pointer to it
     * Push (X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  X3,0+X2           * Load X3 in stack
               MCW  X2,X3             * Move X2 in X3
               B    LSDAAA            * Jump to function escape
     * Pop (X3:3)
               LCA  0+X2,X3           * Load stack in X3
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Function Call escape(new_a, new_b, (timeout - 1))
     * Pop (15982+X3:5)
               LCA  0+X2,15982+X3     * Load stack in 15982+X3
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (28)
     LTDAAA    MA   LOGAAA,X2         * Add -28 to stack pointer
     * End [Block ending at LTDAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : escape
     ********************************************************************************
     ********************************************************************************
     * Function : genRand
     ********************************************************************************
     LBAAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LCAAAA]
     * Push (3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
     * Modulo (%) (((42 * seed) + 19) % 100000)
     * Constant (100000 : @100000@)
     * Push (@100000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LPGAAA,0+X2       * Load data @100000@ in stack
     * Addition ((42 * seed) + 19)
     * Multiply (42 * seed)
     * Constant (42 : @00042@)
     * Push (@00042@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LQGAAA,0+X2       * Load data @00042@ in stack
     * Static Variable (seed : 2004)
     * Push (2004:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  2004,0+X2         * Load memory 2004 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Constant (19 : @00019@)
     * Push (@00019@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LRGAAA,0+X2       * Load data @00019@ in stack
               A    0+X2,15995+X2     * Add stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               B    SNPDIV            * Jump to snippet SNIP_DIV
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@!04@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LSGAAA,0+X2       * Load data @!04@ in stack
     * Assignment (seed = (((42 * seed) + 19) % 100000))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (seed = (((42 * seed) + 19) % 100000))
     * Put on stack return value (seed)
     * Static Variable (seed : 2004)
     * Push (2004:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  2004,0+X2         * Load memory 2004 in stack
     * Pop (15997+X3:5)
               LCA  0+X2,15997+X3     * Load stack in 15997+X3
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (3)
     LCAAAA    MA   LJGAAA,X2         * Add -3 to stack pointer
     * End [Block ending at LCAAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : genRand
     ********************************************************************************
     ********************************************************************************
     * Function : itoa
     ********************************************************************************
     LYAAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LZAAAA]
               LCA  LTGAAA,9+X3       * Load *char 2005 into memory 9+X3
               LCA  LCGAAA,14+X3      * Load int 1 into memory 14+X3
     * Push (14)
               MA   LUGAAA,X2         * Add 14 to stack pointer
     * Parameter Variable (str : 15992+X3)
     * Push (15992+X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
     * Push (@006@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LVGAAA,0+X2       * Load data @006@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (start = str)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:3)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * End Assignment (start = str)
     * If [if ((value < 0) then [Block ending at LABAAA] else [if ((value == 0) then [Block ending at LBBAAA]]]
     * Less (value < 0)
     * Parameter Variable (value : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LAGAAA,0+X2       * Move 0 in stack
               BL   LYEAAA            * Jump if less
               B    LZEAAA            * Jump to End
     LYEAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LZEAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LDBAAA,5+X2,      * Jump when False
     ***************************************
     * Begin [Block ending at LABAAA]
     * Constant ('-' : @-@)
     * Push (@-@:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  LXGAAA,0+X2       * Load data @-@ in stack
     * PostIncrement (str++)
     * Push (@I9B@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LYGAAA,0+X2       * Load data @I9B@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
               MA   LWGAAA,0+X1       * Postincrement pointer at X1
     * Assignment ((*(str++)) = '-')
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * End Assignment ((*(str++)) = '-')
     * Negate (-value)
     * Parameter Variable (value : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               ZS   0+X2
               B    CLNNMN            * Jump to snippet clean_number
     * Push (@I9G@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LJGAAA,0+X2       * Load data @I9G@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (value = (-value))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (value = (-value))
     * End [Block ending at LABAAA]
     ***************************************
     LABAAA    B    LGBAAA            * Jump when true
     * If [if ((value == 0) then [Block ending at LBBAAA]]
     * Equal (value == 0)
     * Parameter Variable (value : 15997+X3)
     * Push (15997+X3:5)
     LDBAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               BE   LAFAAA            * Jump if equal
               B    LBFAAA            * Jump to End
     LAFAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LBFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LGBAAA,5+X2,      * Jump when False
     ***************************************
     * Begin [Block ending at LBBAAA]
     * Constant ('0' : @0@)
     * Push (@0@:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  LAHAAA,0+X2       * Load data @0@ in stack
     * SubScript (str[0])
     * Parameter Variable (str : 15992+X3)
     * Push (15992+X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
     * End SubScript (str[0])
     * Assignment ((str[0]) = '0')
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * End Assignment ((str[0]) = '0')
     * Constant ('\0' : EOS)
     * Push (EOS:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  EOS,0+X2          * Load memory EOS in stack
     * SubScript (str[1])
     * Parameter Variable (str : 15992+X3)
     * Push (15992+X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
               A    LCGAAA,0+X2       * Add offset 1 to point element 1
     * End SubScript (str[1])
     * Assignment ((str[1]) = '\0')
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * End Assignment ((str[1]) = '\0')
     * Return to LZAAAA with return value start
     * Put on stack return value (start)
     * Local Variable (start : 6+X3)
     * Push (6+X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  6+X3,0+X2         * Load memory 6+X3 in stack
     * Pop (15984+X3:3)
               LCA  0+X2,15984+X3     * Load stack in 15984+X3
               MA   LJGAAA,X2         * Add -3 to stack pointer
               B    LZAAAA            * Jump to end of function block
     * End [Block ending at LBBAAA]
     ***************************************
     * End If [if ((value == 0) then [Block ending at LBBAAA]]
     * End If [if ((value < 0) then [Block ending at LABAAA] else [if ((value == 0) then [Block ending at LBBAAA]]]
     * While [while ((exp <= (value / base))) [Block ending at LFBAAA] top:LGBAAA bottom:LHBAAA]
     * LessOrEqual (exp <= (value / base))
     * Local Variable (exp : 14+X3)
     * Push (14+X3:5)
     LGBAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  14+X3,0+X2        * Load memory 14+X3 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Divide (value / base)
     * Parameter Variable (base : 15989+X3)
     * Push (15989+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15989+X3,0+X2     * Load memory 15989+X3 in stack
     * Parameter Variable (value : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               B    SNPDIV            * Jump to snippet SNIP_DIV
               MCW  0+X2,15995+X2     * Move stack in stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LCGAAA,0+X2       * Move 1 in stack
               BH   LCFAAA            * Jump if less or equal
               B    LDFAAA            * Jump to End
     LCFAAA    MCW  LAGAAA,0+X2       * Move 0 in stack
     LDFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LJBAAA,5+X2,      * Jump to bottom of While
     ***************************************
     * Begin [Block ending at LFBAAA]
     * Multiply (exp * base)
     * Local Variable (exp : 14+X3)
     * Push (14+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  14+X3,0+X2        * Load memory 14+X3 in stack
     * Parameter Variable (base : 15989+X3)
     * Push (15989+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15989+X3,0+X2     * Load memory 15989+X3 in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@014@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LUGAAA,0+X2       * Load data @014@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (exp = (exp * base))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (exp = (exp * base))
     * End [Block ending at LFBAAA]
     ***************************************
     LFBAAA    B    LGBAAA            * Jump to top of While
     * End While [while ((exp <= (value / base))) [Block ending at LFBAAA] top:LGBAAA bottom:LHBAAA]
     * While [while (exp) [Block ending at LIBAAA] top:LJBAAA bottom:LKBAAA]
     * Local Variable (exp : 14+X3)
     * Push (14+X3:5)
     LJBAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  14+X3,0+X2        * Load memory 14+X3 in stack
               MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LKBAAA,5+X2,      * Jump to bottom of While
     ***************************************
     * Begin [Block ending at LIBAAA]
     * SubScript (digits[(value / exp)])
     * Local Variable (digits : 9+X3)
     * Push (9+X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  9+X3,0+X2         * Load memory 9+X3 in stack
     * Divide (value / exp)
     * Local Variable (exp : 14+X3)
     * Push (14+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  14+X3,0+X2        * Load memory 14+X3 in stack
     * Parameter Variable (value : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               B    SNPDIV            * Jump to snippet SNIP_DIV
               MCW  0+X2,15995+X2     * Move stack in stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Put raw index on the stack
     * Push (@00001@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LCGAAA,0+X2       * Load data @00001@ in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 in stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Stack top is now array index
               B    NMNPTR            * Jump to snippet number_to_pointer
               MA   0+X2,15997+X2     * Add stack to stack at -3
     * Pop (3)
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Stack top is location in array now
     * End SubScript (digits[(value / exp)])
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
     * PostIncrement (str++)
     * Push (@I9B@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LYGAAA,0+X2       * Load data @I9B@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
               MA   LWGAAA,0+X1       * Postincrement pointer at X1
     * Assignment ((*(str++)) = (digits[(value / exp)]))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * End Assignment ((*(str++)) = (digits[(value / exp)]))
     * Modulo (%) (value % exp)
     * Local Variable (exp : 14+X3)
     * Push (14+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  14+X3,0+X2        * Load memory 14+X3 in stack
     * Parameter Variable (value : 15997+X3)
     * Push (15997+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
               B    SNPDIV            * Jump to snippet SNIP_DIV
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@I9G@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LJGAAA,0+X2       * Load data @I9G@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (value = (value % exp))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (value = (value % exp))
     * Divide (exp / base)
     * Parameter Variable (base : 15989+X3)
     * Push (15989+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  15989+X3,0+X2     * Load memory 15989+X3 in stack
     * Local Variable (exp : 14+X3)
     * Push (14+X3:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  14+X3,0+X2        * Load memory 14+X3 in stack
               B    SNPDIV            * Jump to snippet SNIP_DIV
               MCW  0+X2,15995+X2     * Move stack in stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@014@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LUGAAA,0+X2       * Load data @014@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Assignment (exp = (exp / base))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (exp = (exp / base))
     * End [Block ending at LIBAAA]
     ***************************************
     LIBAAA    B    LJBAAA            * Jump to top of While
     * End While [while (exp) [Block ending at LIBAAA] top:LJBAAA bottom:LKBAAA]
     * Constant ('\0' : EOS)
     * Push (EOS:1)
     LKBAAA    MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  EOS,0+X2          * Load memory EOS in stack
     * Parameter Variable (str : 15992+X3)
     * Push (15992+X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  15992+X3,0+X2     * Load memory 15992+X3 in stack
     * Assignment ((*str) = '\0')
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * End Assignment ((*str) = '\0')
     * Put on stack return value (start)
     * Local Variable (start : 6+X3)
     * Push (6+X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  6+X3,0+X2         * Load memory 6+X3 in stack
     * Pop (15984+X3:3)
               LCA  0+X2,15984+X3     * Load stack in 15984+X3
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (14)
     LZAAAA    MA   LBHAAA,X2         * Add -14 to stack pointer
     * End [Block ending at LZAAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : itoa
     ********************************************************************************
     ********************************************************************************
     * Function : main
     ********************************************************************************
     LYDAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LZDAAA]
     * Push (3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
     * For [for ((zb = 0); (zb <= 64); (++zb)) [Block ending at LAEAAA] top:LFEAAA bottom:LGEAAA continue:LHEAAA]
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
     * Push (@!40@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LCHAAA,0+X2       * Load data @!40@ in stack
     * Assignment (zb = 0)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (zb = 0)
     * LessOrEqual (zb <= 64)
     * Static Variable (zb : 2040)
     * Push (2040:5)
     LFEAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  2040,0+X2         * Load memory 2040 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (64 : @00064@)
     * Push (@00064@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LEGAAA,0+X2       * Load data @00064@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LCGAAA,0+X2       * Move 1 in stack
               BH   LEFAAA            * Jump if less or equal
               B    LFFAAA            * Jump to End
     LEFAAA    MCW  LAGAAA,0+X2       * Move 0 in stack
     LFFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LGEAAA,5+X2,      * Jump to bottom of For
     ***************************************
     * Begin [Block ending at LAEAAA]
     * For [for ((za = 0); (za <= 128); (++za)) [Block ending at LBEAAA] top:LCEAAA bottom:LDEAAA continue:LEEAAA]
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
     * Push (@!35@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LDHAAA,0+X2       * Load data @!35@ in stack
     * Assignment (za = 0)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:5)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Assignment (za = 0)
     * LessOrEqual (za <= 128)
     * Static Variable (za : 2035)
     * Push (2035:5)
     LCEAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  2035,0+X2         * Load memory 2035 in stack
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (128 : @00128@)
     * Push (@00128@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LDGAAA,0+X2       * Load data @00128@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LCGAAA,0+X2       * Move 1 in stack
               BH   LGFAAA            * Jump if less or equal
               B    LHFAAA            * Jump to End
     LGFAAA    MCW  LAGAAA,0+X2       * Move 0 in stack
     LHFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LDEAAA,5+X2,      * Jump to bottom of For
     ***************************************
     * Begin [Block ending at LBEAAA]
     * Function Call putchar(((escape(za, zb, 10) == 0) ? 'X' : ' '))
     * Push (5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
     * Ternary (?:) ((escape(za, zb, 10) == 0) ? 'X' : ' ')
     * Equal (escape(za, zb, 10) == 0)
     * Function Call escape(za, zb, 10)
     * Push (5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
     * Constant (10 : @00010@)
     * Push (@00010@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LEHAAA,0+X2       * Load data @00010@ in stack
     * Static Variable (zb : 2040)
     * Push (2040:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  2040,0+X2         * Load memory 2040 in stack
     * Static Variable (za : 2035)
     * Push (2035:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  2035,0+X2         * Load memory 2035 in stack
     * Create a stack frame with X3 pointer to it
     * Push (X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  X3,0+X2           * Load X3 in stack
               MCW  X2,X3             * Move X2 in X3
               B    LSDAAA            * Jump to function escape
     * Pop (X3:3)
               LCA  0+X2,X3           * Load stack in X3
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Function Call escape(za, zb, 10)
               B    CLNNMN            * Jump to snippet clean_number
     * Constant (0 : @00000@)
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               BE   LKFAAA            * Jump if equal
               B    LLFAAA            * Jump to End
     LKFAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LLFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LIFAAA,5+X2,      * Jump if false
     * Constant ('X' : @X@)
     * Push (@X@:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  LFHAAA,0+X2       * Load data @X@ in stack
               B    LJFAAA            * Jump to end
     * Constant (' ' : @ @)
     * Push (@ @:1)
     LIFAAA    MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  LGHAAA,0+X2       * Load data @ @ in stack
     * Create a stack frame with X3 pointer to it
     * Push (X3:3)
     LJFAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  X3,0+X2           * Load X3 in stack
               MCW  X2,X3             * Move X2 in X3
               B    LLBAAA            * Jump to function putchar
     * Pop (X3:3)
               LCA  0+X2,X3           * Load stack in X3
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Function Call putchar(((escape(za, zb, 10) == 0) ? 'X' : ' '))
     * End [Block ending at LBEAAA]
     ***************************************
     * PreIncrement((++za)
     * Push (@!35@:3)
     LEEAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LDHAAA,0+X2       * Load data @!35@ in stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
               A    LCGAAA,0+X1       * Preincrement memory at X1
               B    LCEAAA            * Jump to top of For
     * End For [for ((za = 0); (za <= 128); (++za)) [Block ending at LBEAAA] top:LCEAAA bottom:LDEAAA continue:LEEAAA]
     * Function Call putchar('\n')
     * Push (5)
     LDEAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
     * Constant ('\n' : EOL)
     * Push (EOL:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  EOL,0+X2          * Load memory EOL in stack
     * Create a stack frame with X3 pointer to it
     * Push (X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  X3,0+X2           * Load X3 in stack
               MCW  X2,X3             * Move X2 in X3
               B    LLBAAA            * Jump to function putchar
     * Pop (X3:3)
               LCA  0+X2,X3           * Load stack in X3
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Function Call putchar('\n')
     * End [Block ending at LAEAAA]
     ***************************************
     * PreIncrement((++zb)
     * Push (@!40@:3)
     LHEAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LCHAAA,0+X2       * Load data @!40@ in stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
               A    LCGAAA,0+X1       * Preincrement memory at X1
               B    LFEAAA            * Jump to top of For
     * End For [for ((zb = 0); (zb <= 64); (++zb)) [Block ending at LAEAAA] top:LFEAAA bottom:LGEAAA continue:LHEAAA]
     * Put on stack return value (0)
     * Constant (0 : @00000@)
     * Push (@00000@:5)
     LGEAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
     * Pop (15997+X3:5)
               LCA  0+X2,15997+X3     * Load stack in 15997+X3
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (3)
     LZDAAA    MA   LJGAAA,X2         * Add -3 to stack pointer
     * End [Block ending at LZDAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : main
     ********************************************************************************
     ********************************************************************************
     * Function : putchar
     ********************************************************************************
     LLBAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LMBAAA]
     * Push (3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
     * If [if ((c != '\n') then [Block ending at LNBAAA] else [Block ending at LOBAAA]]
     * NotEqual (!=) (c != '\n')
     * Parameter Variable (c : 15997+X3)
     * Push (15997+X3:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
     * Constant ('\n' : EOL)
     * Push (EOL:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  EOL,0+X2          * Load memory EOL in stack
               C    0+X2,15999+X2     * Compare stack to stack at -1
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Push (@00001@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LCGAAA,0+X2       * Load data @00001@ in stack
               BE   LMFAAA            * Jump if equal
               B    LNFAAA            * Jump to End
     LMFAAA    MCW  LAGAAA,0+X2       * Move 0 in stack
     LNFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LQBAAA,5+X2,      * Jump when False
     ***************************************
     * Begin [Block ending at LNBAAA]
     * Parameter Variable (c : 15997+X3)
     * Push (15997+X3:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
     * PostIncrement (__putchar_pos++)
     * Push (@!24@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LHHAAA,0+X2       * Load data @!24@ in stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
               MA   LWGAAA,0+X1       * Postincrement pointer at X1
     * Assignment ((*(__putchar_pos++)) = c)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * End Assignment ((*(__putchar_pos++)) = c)
     * End [Block ending at LNBAAA]
     ***************************************
     LNBAAA    B    LTBAAA            * Jump when true
     ***************************************
     * Begin [Block ending at LOBAAA]
     * While [while ((((int) __putchar_last) >= ((int) __putchar_pos))) [Block ending at LPBAAA] top:LQBAAA bottom:LRBAAA]
     * Static Variable (__putchar_last : 2027)
     * Push (2027:3)
     LQBAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  2027,0+X2         * Load memory 2027 in stack
     * Cast Pointer(__putchar_last) to Number
               B    PTRNMN            * Jump to snippet pointer_to_number
     * Static Variable (__putchar_pos : 2024)
     * Push (2024:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  2024,0+X2         * Load memory 2024 in stack
     * Cast Pointer(__putchar_pos) to Number
               B    PTRNMN            * Jump to snippet pointer_to_number
     * GreaterOrEqual (((int) __putchar_last) >= ((int) __putchar_pos))
               B    CLNNMN            * Jump to snippet clean_number
               C    0+X2,15995+X2     * Compare stack to stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               MCW  LCGAAA,0+X2       * Move 1 in stack
               BL   LOFAAA            * Jump if greater or equal
               B    LPFAAA            * Jump to End
     LOFAAA    MCW  LAGAAA,0+X2       * Move 1 in stack
     LPFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LRBAAA,5+X2,      * Jump to bottom of While
     ***************************************
     * Begin [Block ending at LPBAAA]
     * Constant (' ' : @ @)
     * Push (@ @:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  LGHAAA,0+X2       * Load data @ @ in stack
     * PostDecrement (__putchar_last--)
     * Push (@!27@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LIHAAA,0+X2       * Load data @!27@ in stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
               MA   LZGAAA,0+X1       * Postdecrement pointer at X1
     * Assignment ((*(__putchar_last--)) = ' ')
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:1)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * End Assignment ((*(__putchar_last--)) = ' ')
     * End [Block ending at LPBAAA]
     ***************************************
     LPBAAA    B    LQBAAA            * Jump to top of While
     * End While [while ((((int) __putchar_last) >= ((int) __putchar_pos))) [Block ending at LPBAAA] top:LQBAAA bottom:LRBAAA]
     * Static Variable (__putchar_pos : 2024)
     * Push (2024:3)
     LRBAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  2024,0+X2         * Load memory 2024 in stack
     * Push (@!27@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LIHAAA,0+X2       * Load data @!27@ in stack
     * Assignment (__putchar_last = __putchar_pos)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:3)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * End Assignment (__putchar_last = __putchar_pos)
     * Constant (201 : @201@)
     * Push (@201@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LJHAAA,0+X2       * Load data @201@ in stack
     * Push (@!24@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LHHAAA,0+X2       * Load data @!24@ in stack
     * Assignment (__putchar_pos = 201)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:3)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * End Assignment (__putchar_pos = 201)
     * Start asm block
     * End asm block
     * End [Block ending at LOBAAA]
     ***************************************
     * End If [if ((c != '\n') then [Block ending at LNBAAA] else [Block ending at LOBAAA]]
     * If [if ((__putchar_pos == 333) then [Block ending at LUBAAA]]
     * Equal (__putchar_pos == 333)
     * Static Variable (__putchar_pos : 2024)
     * Push (2024:3)
     LTBAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  2024,0+X2         * Load memory 2024 in stack
     * Constant (333 : @333@)
     * Push (@333@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LKHAAA,0+X2       * Load data @333@ in stack
               C    0+X2,15997+X2     * Compare stack to stack at -3
     * Pop (3)
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (3)
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (@00000@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LAGAAA,0+X2       * Load data @00000@ in stack
               BE   LQFAAA            * Jump if equal
               B    LRFAAA            * Jump to End
     LQFAAA    MCW  LCGAAA,0+X2       * Move 1 in stack
     LRFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LMBAAA,5+X2,      * Jump when False
     ***************************************
     * Begin [Block ending at LUBAAA]
     * Static Variable (__putchar_pos : 2024)
     * Push (2024:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  2024,0+X2         * Load memory 2024 in stack
     * Push (@!27@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LIHAAA,0+X2       * Load data @!27@ in stack
     * Assignment (__putchar_last = __putchar_pos)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:3)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * End Assignment (__putchar_last = __putchar_pos)
     * Constant (201 : @201@)
     * Push (@201@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LJHAAA,0+X2       * Load data @201@ in stack
     * Push (@!24@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LHHAAA,0+X2       * Load data @!24@ in stack
     * Assignment (__putchar_pos = 201)
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (0+X1:3)
               LCA  0+X2,0+X1         * Load stack in 0+X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * End Assignment (__putchar_pos = 201)
     * Start asm block
     * End asm block
     * End [Block ending at LUBAAA]
     ***************************************
     * End If [if ((__putchar_pos == 333) then [Block ending at LUBAAA]]
     * Pop (3)
     LMBAAA    MA   LJGAAA,X2         * Add -3 to stack pointer
     * End [Block ending at LMBAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : putchar
     ********************************************************************************
     ********************************************************************************
     * Function : puts
     ********************************************************************************
     LWBAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LXBAAA]
     * Push (3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
     * While [while (((*s) != '\0')) [Block ending at LYBAAA] top:LZBAAA bottom:LACAAA]
     * NotEqual (!=) ((*s) != '\0')
     * DereferenceExpression (*s)
     * Parameter Variable (s : 15997+X3)
     * Push (15997+X3:3)
     LZBAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
     * End DereferenceExpression (*s)
     * Constant ('\0' : EOS)
     * Push (EOS:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  EOS,0+X2          * Load memory EOS in stack
               C    0+X2,15999+X2     * Compare stack to stack at -1
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Push (@00001@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LCGAAA,0+X2       * Load data @00001@ in stack
               BE   LSFAAA            * Jump if equal
               B    LTFAAA            * Jump to End
     LSFAAA    MCW  LAGAAA,0+X2       * Move 0 in stack
     LTFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LXBAAA,5+X2,      * Jump to bottom of While
     ***************************************
     * Begin [Block ending at LYBAAA]
     * Function Call putchar((*(s++)))
     * Push (5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
     * DereferenceExpression (*(s++))
     * PostIncrement (s++)
     * Push (@I9G@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LJGAAA,0+X2       * Load data @I9G@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
               MA   LWGAAA,0+X1       * Postincrement pointer at X1
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
     * End DereferenceExpression (*(s++))
     * Create a stack frame with X3 pointer to it
     * Push (X3:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  X3,0+X2           * Load X3 in stack
               MCW  X2,X3             * Move X2 in X3
               B    LLBAAA            * Jump to function putchar
     * Pop (X3:3)
               LCA  0+X2,X3           * Load stack in X3
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * End Function Call putchar((*(s++)))
     * End [Block ending at LYBAAA]
     ***************************************
     LYBAAA    B    LZBAAA            * Jump to top of While
     * End While [while (((*s) != '\0')) [Block ending at LYBAAA] top:LZBAAA bottom:LACAAA]
     * Pop (3)
     LXBAAA    MA   LJGAAA,X2         * Add -3 to stack pointer
     * End [Block ending at LXBAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : puts
     ********************************************************************************
     ********************************************************************************
     * Function : strcpy
     ********************************************************************************
     LJAAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LKAAAA]
     * Push (3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
     * While [while ((((*(dest++)) = (*(src++))) != '\0')) [] top:LLAAAA bottom:LMAAAA]
     * NotEqual (!=) (((*(dest++)) = (*(src++))) != '\0')
     * DereferenceExpression (*(src++))
     * PostIncrement (src++)
     * Push (@I9D@:3)
     LLAAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LLHAAA,0+X2       * Load data @I9D@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
               MA   LWGAAA,0+X1       * Postincrement pointer at X1
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
     * End DereferenceExpression (*(src++))
     * PostIncrement (dest++)
     * Push (@I9G@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LJGAAA,0+X2       * Load data @I9G@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
               MA   LWGAAA,0+X1       * Postincrement pointer at X1
     * Assignment ((*(dest++)) = (*(src++)))
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
               LCA  0+X2,0+X1         * Load stack in memory X1
     * End Assignment ((*(dest++)) = (*(src++)))
     * Constant ('\0' : EOS)
     * Push (EOS:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  EOS,0+X2          * Load memory EOS in stack
               C    0+X2,15999+X2     * Compare stack to stack at -1
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Push (@00001@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LCGAAA,0+X2       * Load data @00001@ in stack
               BE   LUFAAA            * Jump if equal
               B    LVFAAA            * Jump to End
     LUFAAA    MCW  LAGAAA,0+X2       * Move 0 in stack
     LVFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LKAAAA,5+X2,      * Jump to bottom of While
               B    LLAAAA            * Jump to top of While
     * End While [while ((((*(dest++)) = (*(src++))) != '\0')) [] top:LLAAAA bottom:LMAAAA]
     * Pop (3)
     LKAAAA    MA   LJGAAA,X2         * Add -3 to stack pointer
     * End [Block ending at LKAAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : strcpy
     ********************************************************************************
     ********************************************************************************
     * Function : strlen
     ********************************************************************************
     LFAAAA    SBR  3+X3              * Save return address in register B in stack frame (X3)
     * Set the right WM and clear the wrong ones
               SW   1+X3              * Set WM at 1+X3
               CW   2+X3              * Clear WM at 2+X3
               CW   3+X3              * Clear WM at 3+X3
     ***************************************
     * Begin [Block ending at LGAAAA]
               LCA  LMHAAA,8+X3       * Load int -1 into memory 8+X3
     * Push (8)
               MA   LIGAAA,X2         * Add 8 to stack pointer
     * While [while (((str[(++len)]) != '\0')) [] top:LHAAAA bottom:LIAAAA]
     * NotEqual (!=) ((str[(++len)]) != '\0')
     * SubScript (str[(++len)])
     * Parameter Variable (str : 15997+X3)
     * Push (15997+X3:3)
     LHAAAA    MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  15997+X3,0+X2     * Load memory 15997+X3 in stack
     * PreIncrement((++len)
     * Push (@008@:3)
               MA   LHGAAA,X2         * Add 3 to stack pointer
               LCA  LIGAAA,0+X2       * Load data @008@ in stack
               MA   X3,0+X2           * Add X3 to stack
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
               A    LCGAAA,0+X1       * Preincrement memory at X1
     * Push (0+X1:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
     * Put raw index on the stack
     * Push (@00001@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LCGAAA,0+X2       * Load data @00001@ in stack
               M    15995+X2,6+X2     * Multiply stack at -5 to stack at 6
               SW   2+X2              * Set WM in stack at 2
               LCA  6+X2,15995+X2     * Load stack at 6 in stack at -5
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Stack top is now array index
               B    NMNPTR            * Jump to snippet number_to_pointer
               MA   0+X2,15997+X2     * Add stack to stack at -3
     * Pop (3)
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Stack top is location in array now
     * End SubScript (str[(++len)])
     * Pop (X1:3)
               LCA  0+X2,X1           * Load stack in X1
               MA   LJGAAA,X2         * Add -3 to stack pointer
     * Push (0+X1:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  0+X1,0+X2         * Load memory 0+X1 in stack
     * Constant ('\0' : EOS)
     * Push (EOS:1)
               MA   LWGAAA,X2         * Add 1 to stack pointer
               LCA  EOS,0+X2          * Load memory EOS in stack
               C    0+X2,15999+X2     * Compare stack to stack at -1
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Pop (1)
               MA   LZGAAA,X2         * Add -1 to stack pointer
     * Push (@00001@:5)
               MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  LCGAAA,0+X2       * Load data @00001@ in stack
               BE   LWFAAA            * Jump if equal
               B    LXFAAA            * Jump to End
     LWFAAA    MCW  LAGAAA,0+X2       * Move 0 in stack
     LXFAAA    MCS  0+X2,0+X2         * Clear WM in stack
     * Pop (5)
               MA   LBGAAA,X2         * Add -5 to stack pointer
               BCE  LIAAAA,5+X2,      * Jump to bottom of While
               B    LHAAAA            * Jump to top of While
     * End While [while (((str[(++len)]) != '\0')) [] top:LHAAAA bottom:LIAAAA]
     * Put on stack return value (len)
     * Local Variable (len : 8+X3)
     * Push (8+X3:5)
     LIAAAA    MA   LZFAAA,X2         * Add 5 to stack pointer
               LCA  8+X3,0+X2         * Load memory 8+X3 in stack
     * Pop (15994+X3:5)
               LCA  0+X2,15994+X3     * Load stack in 15994+X3
               MA   LBGAAA,X2         * Add -5 to stack pointer
     * Pop (8)
     LGAAAA    MA   LYGAAA,X2         * Add -8 to stack pointer
     * End [Block ending at LGAAAA]
     ***************************************
               LCA  3+X3,X1           * Load return address in X1
               B    0+X1              * Jump back to caller in X1
     ********************************************************************************
     * End Function : strlen
     ********************************************************************************
 
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
               ZA   CDIV2,*-7         * PUT DIVIDEND INTO WORKING BL
               D    CDIV1,*-19        * DIVIDE
               MZ   *-22,*-21         * KILL THE ZONE BIT
               MZ   *-29,*-34         * KILL THE ZONE BIT
               MCW  *-41,CDIV3        * PICK UP ANSWER
               SW   *-44              * SO I CAN PICKUP REMAINDER
               MCW  *-46,CDIV4        * GET REMAINDER
               CW   *-55              * CLEAR THE WM
               MZ   CDIV3-1,CDIV3     *  CLEANUP QUOTIENT BITZONE
               MZ   CDIV4-1,CDIV4     *  CLEANUP REMAINDER BITZONE
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
     ****************************************************************
     ** CAST NUMBER TO POINTER SNIPPET **
     ****************************************************************
     NMNPTR    SBR  X1
     * Casts a 5-digit number to a 3-digit address
     * make a copy of the top of the stack
               SW   15998+X2
               LCA  0+X2,3+X2
               CW   15998+X2
     * zero out the zone bits of our copy
               MZ   @0@,3+X2
               MZ   @0@,2+X2
               MZ   @0@,1+X2
     * set the low-order digit's zone bits
               C    @04000@,0+X2
               BL   NPHIGH
               C    @08000@,0+X2
               BL   NPLOZ
               C    @12000@,0+X2
               BL   NPLZO
               S    @12000@,0+X2
               MZ   @A@,3+X2
               B    NPHIGH
     NPLZO     S    @08000@,0+X2
               MZ   @I@,3+X2
               B    NPHIGH
     NPLOZ     S    @04000@,0+X2
               MZ   @S@,3+X2
     * For some reason the zone bits get set - it still works though.
     NPHIGH    C    @01000@,0+X2
               BL   NMPTRE
               C    @02000@,0+X2
               BL   NPHOZ
               C    @03000@,0+X2
               BL   NPHZO
               MZ   @A@,1+X2
               B    NMPTRE
     NPHZO     MZ   @I@,1+X2
               B    NMPTRE
     NPHOZ     MZ   @S@,1+X2
     NMPTRE    LCA  3+X2,15998+X2
               SBR  X2,15998+X2
               B    0+X1
     ****************************************************************
     ****************************************************************
     ** CAST POINTER TO NUMBER SNIPPET **
     ****************************************************************
     PTRNMN    SBR  X1
     * Casts a 3-digit address to a 5-digit number
     * Make room on the stack for an int
               MA   @002@,X2
     * make a copy of the top of the stack
               LCA  15998+X2,3+X2
     * Now zero out the top of the stack
               LCA  @00000@,0+X2
     * Now copy back, shifted over 2 digits
               MCW  3+X2,0+X2
     * Now zero out the zone bits on the stack
               MZ   @0@,0+X2
               MZ   @0@,15999+X2
               MZ   @0@,15998+X2
     * check the high-order digit's zone bits
               BWZ  PNHOZ,1+X2,S
               BWZ  PNHZO,1+X2,K
               BWZ  PNHOO,1+X2,B
               B    PNLOW
     PNHOZ     A    @01000@,0+X2
               B    PNLOW
     PNHZO     A    @02000@,0+X2
               B    PNLOW
     PNHOO     A    @03000@,0+X2
     PNLOW     BWZ  PNLOZ,3+X2,S
               BWZ  PNLZO,3+X2,K
               BWZ  PNLOO,3+X2,B
               B    PTRNME
     PNLOZ     A    @04000@,0+X2
               B    PTRNME
     PNLZO     A    @08000@,0+X2
               B    PTRNME
     PNLOO     A    @12000@,0+X2
     PTRNME    B    0+X1
     ****************************************************************
     LDGAAA    DCW  @00128@
     LGHAAA    DCW  @ @
     LJGAAA    DCW  @I9G@
     LMHAAA    DCW  @0000J@
     LPGAAA    DCW  @100000@
     LQGAAA    DCW  @00042@
     LXGAAA    DCW  @-@
     LZGAAA    DCW  @I9I@
     LCHAAA    DCW  @!40@
     LGGAAA    DCW  @00004@
     LKGAAA    DCW  @00002@
     LEHAAA    DCW  @00010@
     LVGAAA    DCW  @006@
     LJHAAA    DCW  @201@
     LHHAAA    DCW  @!24@
     LIGAAA    DCW  @008@
     LAHAAA    DCW  @0@
     LNGAAA    DCW  @023@
     LYGAAA    DCW  @I9B@
     LEGAAA    DCW  @00064@
     LLGAAA    DCW  @013@
     LTGAAA    DCW  @!05@
     LLHAAA    DCW  @I9D@
     LAGAAA    DCW  @00000@
     LWGAAA    DCW  @001@
     LFHAAA    DCW  @X@
     LCGAAA    DCW  @00001@
     LMGAAA    DCW  @018@
     LIHAAA    DCW  @!27@
     LBHAAA    DCW  @I8F@
     LHGAAA    DCW  @003@
     LZFAAA    DCW  @005@
     LOGAAA    DCW  @I7B@
     LUGAAA    DCW  @014@
     LFGAAA    DCW  @00032@
     LBGAAA    DCW  @I9E@
     LRGAAA    DCW  @00019@
     LSGAAA    DCW  @!04@
     LYFAAA    DCW  @028@
     LKHAAA    DCW  @333@
     LDHAAA    DCW  @!35@
               END  START
