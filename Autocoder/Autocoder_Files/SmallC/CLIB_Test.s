               JOB  AUTOCODER PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD
               
     *         BEGN                    * MACRO           
     
               DCW  @MACRO TEST PROGRAM@ 09-25-2011@
               
     READ      EQU  001
     PUNCH     EQU  101
     PRINT     EQU  201 
     
     ****************************************************************
     

               ORG  400

     TEXT      DCW  @HELLO WORLD@
     TEXT2     DCW  @CIAO LUCA@
     TEXT3     DCW  999
     COUNT     DCW  10                 * THE LOOP COUNTER
     
     LIMIT     DCW  0000000001         * LIMIT VALUE
     STEP      DCW  1                  * STEP AMOUNT (CAN BE POSITIVE OR NEGATIVE)
     X1        DCW  0000000005         * COUNTER
     X2        DCW  @005@
     
               DCW  @::@               * JUST TO FIND DATA EASILY IN MEMORY WINDOW
     OP1       DCW  998
               DCW  @::@
     OP2       DCW  999
               DCW  @::@
     TMP1      DCW  000
               DCW  @::@
     TMP2      DCW  000
               DCW  @::@
     NEGZER    DCW  -000
               DCW  @::@
     LONGOP    DCW  0009999999
               DCW  @::@
     SHOROP    DCW  00333
               DCW  @::@
     BLANK     DCW  @0@
               DCW  @::@    
     
     **************************
     ** MACROS
     **************************
     * SP      STACK POINTER
     * AND     AND
     * OR      OR
     * XOR     EXCLUSIVE OR
     * SHL     SHIFT LEFT
     * SHR     SHIFT RIGHT
     * SHRA    SHIFT RIGHT ARITHMETICALLY
     * CMPE    COMPARE IF EQUAL
     * CMPB    COMPARE IF BIGGER
     * CMPS    COMPARE IF SMALLER
     * CMPEB   COMPARE IF EQUAL OR BIGGER
     * CMPES   COMPARE IF EQUAL OR SMALLER
     * MOVS    COPY STRING
     
     JMPTAB    DCW  0000
               DCW  0000
               DCW  0000
     
     IDX       DCW  003
     
     BOOL      DCW  0                  * 0-1 0-1
     CHAR      DCW  000                * 0-255 00-FF
     SHORT     DCW  00000              * 0-65535 0000-FFFF
     INT       DCW  00000              * 0-65535 0000-FFFF
     LONG      DCW  0000000000         * 0-4294967295 00000000-FFFFFFFF
               DCW  @::@
     STRING    DCW  12300000000000000000
               DCW  @::@
     EMPTY     DCW  @00000000000000000000@
               DCW  @::@
     
     START     NOP                     * A LABEL CANT STAY ALONE
     
               MCS  @0@,BLANK
               SW   BLANK
          
               C    BLANK,STRING-10
               BE   END3
     
               MCS  @0@,STRING-10 

               C    STRING-10,BLANK
               BE   END3     
     
               MLCWA@LUCA@,STRING-16
  
               MCW  STRING,PRINT+19
               W
               CS   299
     
     ****************************************************************
     ** JUMP TABLE
     ****************************************************************

               MCW  @B530@,JMPTAB      * FILL THE FIRST ENTRY WITH THE INSTRUCTION ADDRESS
               B    JMPTAB-3           * JUMP TO FIRST ENTRY OF JUMP TABLE 
            
               B    JMPTAB+1           * JUMP TO SECOND ENTRY OF JUMP TABLE        
               B    JMPTAB+5           * JUMP TO THIRD ENTRY OF JUMP TABLE        
    
     ****************************************************************
     ** MOVING DATA (NO NEEDS OF CASTING OR SIGN EXTENSION BECAUSE OF 1401 CHARACTERISTIC)
     ****************************************************************
     
               ZA   SHOROP,LONGOP      * NUMERICAL MOVE OF SHORT OPERATOR INTO LONG ONE (LEFTMOST POSITIONS ARE ZEROED)
               ZA   LONGOP,SHOROP      * NUMERICAL MOVE OF LONG OPERATOR INTO SHORT ONE (LEFTMOST POSITIONS ARE ZEROED)

               MCW  SHOROP,LONGOP      * CHAR MOVE OF SHORT OPERATOR INTO LONG ONE (LEFTMOST POSITIONS ARE UNCHANGED
  
     ****************************************************************
     ** EQUALITY TEST == > < 
     ****************************************************************
  
     * PRINT OPERANDS        
               MCW  OP1,PRINT+2
               W
               CS   299
               MCW  OP2,PRINT+2
               W
               CS   299
   
     * COPY OPERANDS IN TEMP STORAGE SETTING THE BIT-ZONE
               ZA   OP1,TMP1
               ZA   OP2,TMP2   
 
     * CHECK SPECIAL CASE OF NEGATIVE ZEROS AND NORMALIZE THEM        
               C    NEGZER,TMP1        * IS TMP1 A NEGATIVE ZERO ?
               BU   ISZER1             * IF IS NOT THEN JUMP OVER
               MCW  @?@,TMP1           * SET TMP1 TO NORMAL ZERO
     ISZER1    C    NEGZER,TMP2        * IS TMP2 A NEGATIVE ZERO ?
               BU   ISZER2             * IF IS NOT THEN JUMP OVER
               MCW  @?@,TMP2           * SET TMP2 TO NORMAL ZERO
     ISZER2    NOP
       
     * CHECK IF OP1 IS EQUAL TO OP2
               C    TMP2,TMP1          
               BE   EQUAL              * EQUAL ?
     
     * CHECK FOR IF OP1 IS BIGGER OR SMALLER THAN OP2
               S    TMP2,TMP1 
               BWZ  OP1BIG,TMP1,B      * OP1 > OP2 ?
               BWZ  OP2BIG,TMP1,K      * OP2 > OP1 ?
       
     * PRINT RESULT        
               MCW  @SOMETHING WRONG!!@,PRINT+16
               W
               B    END3
     OP1BIG    MCW  @OP1 > OP2@,PRINT+8
               W
               B    END3
     OP2BIG    MCW  @OP1 < OP2@,PRINT+8
               W
               B    END3
     EQUAL     MCW  @OP1 == OP2@,PRINT+9
               W
          
     END3      H       
      
     ****************************************************************
     ** SIGN CHECK AND CONVERSION
     ****************************************************************
     
     * PRINT OPERANDS        
               MCW  OP1,PRINT+2
               W
               CS   299
               MCW  OP2,PRINT+2
               W
               CS   299

     * OPERATION
     *         A    OP1,OP2
               S    OP1,OP2
     
     * PRINT OPERANDS        
               MCW  OP1,PRINT+2
               W
               CS   299
               MCW  OP2,PRINT+2
               W
               CS   299
     
     ****************************************************************
     ** CHECK OP2 WHICH CONTAINS THE RESULT AND CONVERT IT IF NECESSARY (REMOVE ZONE AND, IN CASE, PUT MINUS SIGN IN FRONT) 
     ** A NEGATIVE NUMBER HAS THE 11-ZONE SET. D-CHAR = K (PAGE 33)  
     ****************************************************************
      
               BWZ  NOZONE,OP2,2    * JUMP IF NO ZONE (OP2 IS POSITIVE, NO CONVERSION)
               BWZ  REMOVE,OP2,B    * JUMP IF B ZONE (OP2 IS POSITIVE, BUT ZONE MUST BE REMOVED)
               MCW  @-@,OP2-2	    * OP2 IS NEGATIVE, PUT THE MINUS SIGN IN FRONT
     REMOVE    MZ   OP2-1,OP2       * REMOVE ZONE
     NOZONE    NOP
     
     * PRINT OP2        
               MCW  OP2,PRINT+2
               W
               CS   299
      
               H
               H
     
     ****************************************************************
     * REMOVING THE ZONE CORRESPOND TO ABS() FUNCTION
     ****************************************************************

               MZ   OP1-1,OP1       * REMOVE ZONE IN OP1 IS LIKE ABS(OP1)
          
     ****************************************************************
  
     LOOP2     NOP
     *         A    STEP,X1            * ADD STEP TO COUNTER   
               S    STEP,X1            * SUB STEP TO COUNTER
               MZ   X1-1,X1            * CONVERT THE VALUE OF X1 BACK TO TRUE DECIMAL FORM REMOVING THE SIGN (ABS)
 
               MCW  X1,PRINT+9         * MOVE TEXT TO PRINT BUFFER
               W                       * PRINT
               CS   299                * CLEAR 299-201   
    
               C    X1,LIMIT           * IF COUNTER == LIMIT (BOTH OPERANDS MUST BE SAME LENGTH)
               BH   ENDL2              * GO TO END
          
               B    LOOP2              * LOOPING
     ENDL2     NOP                     * END LOOP
               H
       
     ****************************************************************

               MCW  TEXT,PRINT+10      * MOVE TEXT TO PRINT BUFFER
               W                       * PRINT
               CS   299                * CLEAR 299-201 
               CS   332                * CLEAR UNTIL 332 THIS CAN BE AVOIDED IF PRINT ONLY IN 201-299
     
               MCW  TEXT2,PRINT+8      * MOVE TEXT TO PRINT BUFFER
               W                       * PRINT
               CS   299                * CLEAR 299-201   

    ****************************************************************

     LOOP      NOP                     * BEGIN OF LOOP
               C    &08,COUNT          * IF COUNT == 0 CONSTANT (BOTH OPERANDS MUST BE SAME LENGTH)
               C    LIMIT,COUNT        * IF COUNT == LIMIT (BOTH OPERANDS MUST BE SAME LENGTH)
               BE   ENDL               *    THEN END LOOP (PAGE 30 - BE IS ==, BL IS <, BH IS >)
               S    STEP,COUNT         * COUNT = COUNT - STEP
     *         S    @1@,COUNT          * COUNT = COUNT - @1@ CONSTANT

     *** LOOP BODY ***
     
               MCW  TEXT3,PRINT+2      * MOVE TEXT TO PRINT BUFFER
               W                       * PRINT
               CS   299                * CLEAR 299-201   
               S    @1@,TEXT3          * TEXT3 = TEXT3 - 1
     
     *** END LOOP BODY ***

               B    LOOP               * JUMP TO BEGIN OF LOOP
     ENDL      NOP                     * END OF LOOP

               S    @1@,COUNT          * NUMBER = NUMBER - 1
               A    @1@,COUNT          * NUMBER = NUMBER + 1

               H
               H
     *         EXIT                    * MACRO GOODBYE
               END  START
