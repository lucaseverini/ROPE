               STACK
     START     NOP
     *         CALL THER ROUTINE NAMED FRED
               KALL FRED
     ************************************
     TOP       H    *-3
     ***************************************
     *
     FRED      MCW  @FRED HERE@,230
               W
               KALL SHAY
               RETRN
     *
     SHAY      MCW  @SHAY HERE@,230
               W
               KALL BILL
               RETRN
     *
     BILL      MCW  @BILL HERE@,230
               W
               RETRN
               END  START
