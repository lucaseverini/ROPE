               JOB  DIVIDER
               CTL  6611
     *                                  A = DIVISOR
     *                                  B = DIVIDEN AND QUOTENT
     *                                  C = LAST ANSWER
     *                                  D = REMAINDER
               ORG  400
               dcw  @ a @
     A         DCW  00000              *DIVISOR [5]
               dcw  @ b @
     B         DCW  0000000000         *DIVIDEN [10]
               dcw  @ c @
     C         DCW  0000000000         *ANSWER [10]
               dcw  @ d @
     D         DCW  00000              *REMAINDER [5]
     *          
     *
     COUNT     DCW  0033               *LOOP COUNTER
     **************************************************************
               ORG  500
     START     ZA   COUNT,A           *lOAD THE A FIELD
               ZA   @12345@,B         *LOAD THE B FIELD
               DIVIDA,B,C,D           *DIVIDE THE NUMBERS
  
               MCW  @COUNT = @,210
               MCW  COUNT,220
               MCW  @BL = @,230
               MCW  BL,240  
               MCW  @A=@,250
               MZ   A-1,A
               MCS  A,256
               MCW  @B=@,260
               MZ   B-1,B
               MCW  B,270
               MCW  @C=@,275
               MCW  C,287
               MCW  @D=@,290
               MCW  D,296
               W 
               CS   299               *CLEAR PRINT BUFFER
               A    @1@,COUNT
               BCE  START,COUNT-3,0
               H    START
               H
               END  START
