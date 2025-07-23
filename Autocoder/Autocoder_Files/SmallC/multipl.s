               JOB  SAMPLE OF MULTIPLY INSTRUCTION
               CTL  6611
     *
               ORG  340                  *JUST ABOVE PRINT BUFFER
     PRINT     EQU  201                  *FIRST POSITION OF PRINT BUFFER
     M1        DCW  @2000000@                 *MUPLIPLIER
     M2        DCW  @4000000@                *MULTIPLICAN
     ANS       DCW  @0000000000000000000000000000@
     *
     
     START     H
               MULTPM1,M2,ANS
               MCS  M1,PRINT&15           *MOVE M1 TO PRINT
               MCS  M2,PRINT&25           *MOVE M2 TO PRINT
               MCS  ANS,PRINT&60          *MOVE ANSWER TO PRINT
               W                          *PRINT
               CS   PRINT&132             *CLEAR PRINT BUFFER
               CS                         *CLEAR PRINT BUFFER
               B    START                 *DO IT AGAIN
               NOP                        *NEED A WM HERE
               NOP                        *NEED A WM HERE
               END  START
