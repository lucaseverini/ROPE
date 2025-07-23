               HEAD
     BUFFL     DCW  @1@                 *LEFT HAND SIDE OF BUFFER
     WORK      DC   #20                 *FILL
     BUFFR     DC   @9@                 *RIGHT HAND SIDE OF BUFFER
               DCW  @"@                 *GMWM
     *
     START     H                        *START WITH A HALT
     *          MCW  @HELLOW WORLD@,BUFFL+13  *MOVE TEXT TO BUFFER
     *          MCW  %T0,BUFFL,W         *SEND IT TO 1407
     *          H                        * JUST BE CAUSE
               MCW  %t0,201,R           *READ FROM 1407
               sw   209
               mcw  @"@,220
               sw   220
               W                        *PRINT IT
               H    START
               EXIT                     *LEAVE IN AN ORDERLY FASHION
               END  START
