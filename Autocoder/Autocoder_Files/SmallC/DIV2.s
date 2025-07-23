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
     
     V1        DCW  00000
     V2        DCW  00000
     
               ORG  1000
  
     START     NOP
     
     ****************************************************************  
     
               SBR  X2, 600            * SET THE STACK
               
               MCW  @00310@, V1        * OP1
               MCW  @00000@, V2        * OP2
               
               PUSH V2
               PUSH V1
               
               B    DIVIDE

               POP  V1                 * QUOTIENT
               POP  V2                 * REMAINDER
               
               MCW  V1, 210            * PRINT QUOTIENT
               MCW  V2, 220            * PRINT REMAINDER
               W

               H

     ** DIVISION SNIPPET **
     
     DIVIDE    SBR  DIV05+3             * SETUP RETURN ADDRESS
               
     * POP DIVIDEND
               SBR  X2, 15995+X2
               MCW  0+X2, DIV02

     * POP DIVISOR
               SBR  X2, 15995+X2
               MCW  0+X2, DIV01

               B    *+17
               
               DCW  @00000@                
               DC   @00000000000@        

               ZA   DIV02, *-7          * PUT DIVIDEND INTO WORKING BL
               D    DIV01, *-19         * DIVIDE
               MZ   *-22, *-21          * KILL THE ZONE BIT
               MZ   *-29, *-34          * KILL THE ZONE BIT
               MCW  *-41, DIV03         * PICK UP ANSWER
               SW   *-44                * SO I CAN PICKUP REMAINDER
               MCW  *-46, DIV04         * GET REMAINDER
               CW   *-55                * CLEAR THE WM
               MZ   DIV03-1, DIV03      * CLEANUP QUOTIENT BITZONE
               MZ   DIV04-1, DIV04      * CLEANUP REMAINDER BITZONE
               
     * PUSH REMAINDER
               MCW  DIV04, 0+X2
               SW   15996+X2
               SBR  X2, 5+X2
               
     * PUSH QUOTIENT
               MCW  DIV03, 0+X2
               SW   15996+X2
               SBR  X2, 5+X2

     DIV05     B    000                 * JUMP BACK
               
     DIV01     DCW  00000               * DIVISOR
     DIV02     DCW  00000               * DIVIDEND
     DIV03     DCW  00000               * QUOTIENT
     DIV04     DCW  00000               * REMAINDER

     ****************************************************************  

               END  START
