               JOB  BIGGERPI.S 11/24/17 14:21:37                           -2097
     * OK - THE 3800 CHARACTER VERSION WORKS, 13069 CHARACTERS  :-)
     * SO, CAN WE GO FOR 5090 CHARACTERS?
               CTL       6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD
     *   1         2         3         4         5         6         7         8
     *78901234567890123456789012345678901234567890123456789012345678901234567890
     * label   | op | OPERATION                                         |xxxxxxx
               ORG  87
     X1        DSA  0                  index register 1
               ORG  92
     X2        DSA  0                  index register 2
               ORG  97
               DSA  0                  index register 3
     *
     * start storage areas
     *  small areas
               ORG  100     * PUT SMALL STUFF IN PUNCH AREA
     ITCNT     DCW  000000    * ITERATION COUNTER, STARTS AT ZERO
     *DIVBAS   DCW  000000   * DIVISOR FOR BASET
     IX2P1     DCW  000000   * ITCNT times 2 plus 1, DIVISOR FOR INTER
     C0        DCW  000000
     C1        DCW  000001
     C2        DCW  000002
               DCW  000005
     C25       DCW  000025
               DCW  000239
     C239P2    DCW  057121
     CNTZRO    DCW  000000  * COUNT LEADING ZEROS, DONE YET?
     CF        DCW  1         *  "1"=ADD, "0" OR OTHER = SUBTRACT
     LC0L9     DCW  000000000
     *
     *         ORG  200
     * OVERLAY PRINT AREA
     START     MCW  @000000@,ITCNT  * ZERO ITERATION CNTR
               MCW  @000001@,IX2P1  * INIT INTER DIVISOR
               MCW  @+@,ACCUM&5049  * ZERO ACCUMULATOR
               MCW  @0@,ACCUM&5048
               MCW  ACCUM&5048,ACCUM&5047 
               MCW  @0@,BASET&5048
               MCW  BASET&5048,BASET&5047
               MCW  @80@,BASET&8  * SET A HIGH ORDER TO 1*5*16
     PH1L      MCW  @+@,BASET&5049  * SET POSITIVE SIGN
               D    C25,BASET&6     * TRIAL ARITH
               MCW  BASET&5042,BASET&5049  * SHIFT QUOTIENT
               MCW  LC0L9,BASET&6      * REMOVE UNSHIFTED
               MCW  BASET&5049,INTER&5049  * MOVE QUOTIENT TO NEXT
               MCW  @+@,INTER&5049     * SET POSITIVE SIGN
               D    IX2P1,INTER&6    DIVIDE INTERMEDIATE
               MCW  INTER&5042,INTER&5049   * SHIFT INTERMEDIATE
               MCW  LC0L9,INTER&6        * REMOVE UNSHIFTED
               MCW  @+@,INTER&5049  * SET UP BASE
               BCE  PH1ADD,CF,1        * COMPARE FOR ADD
               MCW  @1@,CF              * SET NEXT ADD
               S    INTER&5049,ACCUM&5049   * DO THE SUBTRACTION
               B    PH1W                * GO TO WRAP-UP
     PH1ADD    A    INTER&5049,ACCUM&5049   * ADD TO ACCUMULATOR
               MCW  @0@,CF              * SET NEXT SUBTRACT
     PH1W      A    C1,ITCNT            * INC ITERATION COUNT
               A    C2,IX2P1            * FORM NEXT DIVISOR
     PH1BCE    BCE  PH1X1,BASET&X1,0   * CHAR = 0, DONE?
               B    PH1L                * GO DO ANOTHER LOOP PASS
     PH1X1     A    C1,CNTZRO           * INCREMENT # LEADING ZEROS
               SBR  X1,1&X1             * INCREMENT X1
               C    CNTZRO,@5049@         * CHECK END
               BU   PH1BCE              * NO, CHECK MORE ZEROS
     *          B    START2                * DONE WITH PASS 1 
     *   
     * -------------------------------------------------------------
               MCW  @000000@,ITCNT  * ZERO ITERATION CNTR
               MCW  @000001@,IX2P1  * INIT INTER DIVISOR
               MCW  C0,CNTZRO       * CLEAR LEADING ZERO COUNTER
     * DO NOT ZERO ACCUMULATOR
               MCW  @0@,BASET&5048
               MCW  BASET&5048,BASET&5047
               MCW  @956@,BASET&8  * SET A HIGH ORDER TO 1*4*239
               MCW  @0@,CF              * SET NEXT SUBTRACT
     PH2L      MCW  @+@,BASET&5049  * SET POSITIVE SIGN
               D    C239P2,BASET&6     * TRIAL ARITH
               MCW  BASET&5042,BASET&5049  * SHIFT QUOTIENT
               MCW  LC0L9,BASET&6      * REMOVE UNSHIFTED
               MCW  BASET&5049,INTER&5049  * MOVE QUOTIENT TO NEXT
               MCW  @+@,INTER&5049     * SET POSITIVE SIGN
               D    IX2P1,INTER&6       DIVIDE INTERMEDIATE
               MCW  INTER&5042,INTER&5049   * SHIFT INTERMEDIATE
               MCW  LC0L9,INTER&6        * REMOVE UNSHIFTED
               MCW  @+@,INTER&5049  * SET UP BASE
               BCE  PH2ADD,CF,1        * COMPARE FOR ADD
               MCW  @1@,CF              * SET NEXT ADD
               S    INTER&5049,ACCUM&5049   * DO THE SUBTRACTION
               B    PH2W                * GO TO WRAP-UP
     PH2ADD    A    INTER&5049,ACCUM&5049   * ADD TO ACCUMULATOR
               MCW  @0@,CF              * SET NEXT SUBTRACT
     PH2W      A    C1,ITCNT            * INC ITERATION COUNT
               A    C2,IX2P1            * FORM NEXT DIVISOR
     PH2BCE    BCE  PH2X2,BASET&X2,0   * CHAR = 0, DONE?
               B    PH2L                * GO DO ANOTHER LOOP PASS
     PH2X2     A    C1,CNTZRO           * INCREMENT # LEADING ZEROS
               SBR  X2,1&X2             * INCREMENT X1
               C    CNTZRO,@5049@         * CHECK END
               BU   PH2BCE              * NO, CHECK MORE ZEROS
     *          B    PRINTD                * DONE WITH PASS 2
     *  NOW WE PRINT THAT BABY OUT :-))
     * PROPOSED FORMAT
     * 2
     * 0        1         2         3         4         5         6         7         8
     * 12345678901234567890123456789012345678901234567890123456789012345678901234567890  
     *                                                        3. * 10E-00000
     * + NNNNNNNNNN NNNNNNNNNN NNNNNNNNNN NNNNNNNNNN NNNNNNNNNN  * 10E-00050
     * + NNNNNNNNNN NNNNNNNNNN NNNNNNNNNN NNNNNNNNNN NNNNNNNNNN  * 10E-00100
               MCW  @008@,X1   * CLEAR PICKUP X
               MCW  C0,ITCNT   * CLEAR TOTAL CH MOVED
               CS   332    * start clearing down to 200, PRINT AREA
               CS
               MCW  @. * 10E-00000@,269
               SW   265        * SET WORD MARK IN EXPONENT FIELD
               MCW  ACCUM&X1,256  MOVE 5TH FIELD
               SBR  X1,10&X1     * STEP X1
               W           *write the print area to the printer
     *
     PR1LOP    CS   252        * CLEAR PREVIOUS NUMERICS
               SW   203,214    * SET WORD MARKS FOR B FIELD
               SW   225,236
               SW   247,265
               A    @00050@,269  * ADD 50 TO EXPONENT
               MCW  ACCUM&X1,212  MOVE 1ST FIELD
               SBR  X1,10&X1     * STEP X1
               MCW  ACCUM&X1,223  MOVE 2ND FIELD
               SBR  X1,10&X1     * STEP X1
               MCW  ACCUM&X1,234  MOVE 3RD FIELD
               SBR  X1,10&X1     * STEP X1
               MCW  ACCUM&X1,245  MOVE 4TH FIELD
               SBR  X1,10&X1     * STEP X1
               MCW  ACCUM&X1,256  MOVE 5TH FIELD
               SBR  X1,10&X1     * STEP X1
               W           *write the print area to the printer
               A    @000050@,ITCNT   * ADD 50 TO TOTAL DIGITS
               C    @005000@,ITCNT   * TEST FOR END
               BL   PR1LOP         * END IS HIGHER THAN COUNT
     *
     HALT3     H    HALT3        * END EXPERIMENT
     *
     *  large areas Ron Mak says that blanks process as zeros
               ORG  780
     *FLDLEN    EQU  5050      * LENGTH OF THE 3 BIG FIELDS
     BASET     DA   1X5050,C  * BASE, 1ST DIVISION HERE
     INTER     DA   1X5050,C  * INTERMEDIATE BUFFER, 2ND DIVISION HERE
     ACCUM     DA   1X5050,C  * ACCUMULATOR, ANSWER IS FORMED HERE
     *   1         2         3         4         5         6         7         8
     *78901234567890123456789012345678901234567890123456789012345678901234567890
     * label   | op | OPERATION                                         |xxxxxxx
     *
     *** Nov 15
     * Machin's method -
     * PI = 16arctan(1/5) - 4arctan(1/239)
     * An arctan series is 1/n - 1/(3xn^3) + 1/(5xn^5) - ...
     *   
     *** Nov 16
     * In any case,
     *Lets do arctan(x),  x = 1/5
     *   0.19739555984988075837004976519479
     *then  16ARCTAN(1/5)
     *   3.1583289575980921339207962431166
     * then aectan(1/239)
     *   0.0041840760020747238645382149592855
     * times 4
     *   0.016736304008298895458152859837142
     * Pi = 
     *    3.1415926535897932384626433832795
     * :-))
     *
     * Set N to 1/x = 5      (this is the fancy footwork :-))
     *
     * 1) a) form three large as practical equal sized areas in memory. 
     *       lets call them "Accumulator",       ACCUM
     *                      "Intermediate",      INTER
     *                      "Base of next term"  BASET
     *     b) form smaller working areas
     *          iteration counter ITCNT    used for observation
     *                  starts at zero, counts up after a pass
     *          divisor of BASET, DIVBAS,   usually 5^2 or 239^2
     *                  5^2 = 25,   239^2 = 57121
     *          add/subtract control flag, CF , toggled after a pass
     *                0 means add, other is subtract
     *          divisor of INTER is IX2P1 , ITCNT times 2 plus 1
     *   
     * 2) figure where the decimal point will be
     *     (same relative place in each area)
     *     ( several characters or words to the "right" of 
     *       the top significance.)
     *
     * 3) a) zero the  ACCUM
     *     b) ( INTER does not need initialization)
     *    c) set X (5.0 in our example) into BASET
     *    d) set counter N to 1
     *
     * 4) While BASET is non-zero
     *    a) Divide BASET by X^2  ( 25 in our example ) giving BASET
     *    b) Divide BASET by (2xN - 1) giving INTER
     *    c) If N is odd, add Intermediate to Accumulator
     *           else, subtract Intermediate from Accumulator 
     *    d) Add 1 to N (assure that machine can divide by 2N)
     *
     * 5) Accumulator is a fine approximation of arctan(x)   ;-))
               END  START  * LAST CARD IN DECK, TRANSFER ADDRESS
