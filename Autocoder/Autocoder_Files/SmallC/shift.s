               JOB  AUTOCODER PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD

               DCW  @C-OUTPUT@		* 12-2-2014
          
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

               ORG  400
 
     ****************************************************************
    
               ORG  500
      
     V1        DCW  000
     V2        DCW  000

     START     NOP
     
     ****************************************************************  
                           
               ZA   @1@, OP1
               ZA   @5@, OP2     
               B    SHLB

               ZA   @1@, OP1
               ZA   @7@, OP2     
               B    SHLB
     
               MCW  RESULT, OP1
               B    PRTB

               H
               B    *-3

               MCW  @001@, V1
               MCW  @002@, V2
               MCW  V1, OP1
               MCW  V2, OP2     
               B    ANDB
     
               MCW  @SHRB@, PRINT+3
               W  
               CS   299
               MCW  V1, PRINT+2
               W  
               CS   299
               MCW  V2, PRINT+2
               W  
               CS   299
               MCW  RESULT, PRINT+2
               W  
               CS   299
  
               H
               B    *-3
     
     A$A@      NOP
      
     * CALL LIBRARY
               CLIB
     
               END  START
