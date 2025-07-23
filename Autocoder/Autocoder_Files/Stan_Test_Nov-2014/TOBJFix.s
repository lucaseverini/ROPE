               JOB  TOBJFIX.S 03/28/17 23:36:18                            -9378
               ORG  350
     *
     FRED      DCW  @(EOF)@ 
     FRED2     DCW  @1=1@            
     *
     START     H
               CS   201&132  *CLEAR(& == +)
               H
               B    START               *BRANCH TO START
               NOP                      * ((((
               END  START               * =====
