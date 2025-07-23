               BEGN
               DCW  @MACRO TEST PROGRAM@ 09-25-2011@
     A1        DCW  100
     A2        DCW  200
     L1I       DCW  000
     ****************************************************************
     *         CHAIN EXAMPLE    
     ****************************************************************
     T1        DCW  @MY @
     T2        DCW  @NAME @
     T3        DCW  @IS @
     T4        DCW  @FRED @
     START     NOP
               X123
               CS   332                 *CLEAR UPPER PRINT BUFFER
               CS   299                 *CLEAR LOWER PRINT BUFFER
               MAD  A1,A2             
               MCW  T4,230              *MOVE THE FIRST FIELD
               CHAIN3                   *CHAIN TWO MORE MCWS
     L1        W                        *PRINT IT
               WNOSP                    *PRINT WITHOUT SPACING
               LOOP L1,L1I,@024@	    *CALL MACRO TO FIND CARD
               EXIT                     *GOOD BYE
               END  START
