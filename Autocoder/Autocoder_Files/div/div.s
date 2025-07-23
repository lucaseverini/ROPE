               JOB  DIVIDER
               CTL  6611
     *                                  A = DIVISOR
     *                                  B = DIVIDEN AND QUOTENT
     *                                  C = LAST ANSWER
     *                                  D = REMAINDER
               ORG  400
               dcw  @a@
     A         DCW  00000              *DIVISOR [5]
               dcw  @b@
     B         DCW  0000000000          *DIVIDEN [10]
               dcw  @c@
     C         DCW  0000000000         *ANSWER [10]
               dcw  @d@
     D         DCW  00000              *REMAINDER [5]
               dcw  @BH/BL@
     BH        DCW  00000              *HALF THE ANSWER [5]
     BL        DC   000000             *THE OTHER HALF + 1
     COUNT     DCW  003                *LOOP COUNTER
     **************************************************************8
               ORG  450
     START     ZA   COUNT,A           *lOAD THE A FIELD
               ZA   @1234567890@,B
               ZA   @0@,BL            *CLEAR THE BH AND BL FIELDS
               ZA   B,BL              *LOAD THE B FIELD
               D    A,BH              *DIVIDE
               MZ   BH-1,BH           *KILL THE ZONE BIT
               MZ   BL-1,BL           *KILL THE ZONE BIT
               MZ   BL-1,BL-6         *KILL THE ZONE BIT
               SW   BL-5              *SO I CAN PICKUP REMAINDER
               ZA   BL,D              *GET REMAINDER
               MZ   D-1,D             *CLEAR THE ZONE ON d
               CW   BL-5              *CLEAR THE WM
               ZA   BL-6,C            *PICK UP ANSWER
               MZ   C-1,C             *CLEAR THE ZONE BITS
  
               MCW  @COUNT = @,210
               MCW  COUNT,220
               MCW  @BL = @,230
               MCW  BL,240  
               MCW  @A=@,250
               MCW  A,256
               MCW  @B=@,260
               MCW  B,270
               MCW  @C=@,275
               MCW  C,287
               MCW  @D=@,290
               MCW  D,296
               W 
               CS   299               *CLEAR PRINT BUFFER
               A    @1@,COUNT
               H    START
               H
               END  START
