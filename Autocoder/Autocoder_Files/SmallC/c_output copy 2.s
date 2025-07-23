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

     stack     DA   5x15               * 5 activation records of 15 chars
     retn           1,3                * See pages 16-19 of C24-3319
     arg1           4,6
     arg2           7,9
     sx2            10,12
     sx3            13,15
     stkptr    DSA  0
     rsize     EQU  15
     rsizec    EQU  15985
  
     ****************************************************************
 
               ORG  500
     
     STRING    DCW  @ABCDEFGH@     
     COUNT     DCW  6   
     TEST      DCW  000
     TMP       DCW  00000
     TMPADR    DCW  000
     AAA       DCW  @15999@
     BBB       DCW  00000
     ADR5      DCW  00000
     ADR3      DCW  0500
     ADR4      DCW  -128
     ADR6      DCW  -256
     
     START     NOP
     
     ****************************************************************  
     
     *          MCW  @00?@, OP1
     *          MCW  @00!@, OP2
     *          B    CBIG
     
     *          B    AND
               B    XOR  
          
               H
               B    *-3

               MCW  @000@, X2          CLEAR X2
               SBR  X2, 10000+X2       10000 in X2
     
               MCW  @6500@, ADR5       I want X2 to access a string at 500 so I do: 16000-9500 = 6500 / N!'
               MCW  @N!'@, ADR5        I want X2 to access a string at 500 so I do: 16000-9500 = 6500 / N!'
               MA   ADR5, X2           Subtract adr5 from x2
     
               MCW  5+X2, TMP          CONTENT OF LOCATION POINTED BY X1 COPIED INTO TMP
     
     * THIS WORKS FOR SUBTRACTING LESS THAN 1000          
               za   @16000@, adr5  Sets units zone to BA
               s    @500@, adr5    Leaves units zone as BA (pg 28 of Brownie Book)
               mz   adr5, adr5-2   Set hundreds zone to BA
               ma   adr5, X2       Subtract adr5 from x2    
     
               MCW  5+X2, TMP      CONTENT OF LOCATION POINTED BY X1 COPIED INTO TMP          
                        
               B    OUT
     
     L1        NOP
               MCW  CNT, PRINT+4
               W  
               CS   299
               MCW  X1, PRINT+2
               W  
               CS   299
               MCW  @-----@, PRINT+4
               W  
               CS   299              
               
               A    @1@, CNT
               SBR  X1, 1+X1
     
               C    @16000@, CNT
               BH   OUT
               B    L1
    
     CNT       DCW  00000
     OUT       NOP
               
               MCW  @BEFORE SUB1@,PRINT+10
               W  
               CS   299
     
               mcw  @Z@, STRING-6
     
               sbr  X1, TEST           * X1 POINTS TO TEST
               mcw  0+X1, TMP          * CONTENT OF LOCATION POINTED BY X1 COPIED INTO TMP
               mcw  @123@, TEST        * CHANGE CONTENT OF TEST
               mcw  X1, TMPADR         * ADDRESS OF LOCATION POINTED BY X1 COPIED INTO TMP
               mcw  0+X1, TMP          * CONTENT OF LOCATION POINTED BY X1 COPIED INTO TMP   
               mcw  @456@, 0+X1        * CHANGE CONTENT OF LOCATION POINTED BY X1
                         
               SBR  X1, COUNT          * X1 POINTS TO TEST
               MCW  X1, arg1+X3        * Copy X1 into stack arg1
               MCW  TEST, arg2+X3      * Copy TEST into stack arg2
               B    RECURS             * Jump to subroutine
  
               MCW  @AFTER SUB1@,PRINT+9
               W  
               CS   299
                    
               H
               B    *-3
     
     ****************************************************************
     ** SUBROUTINE WITH RECURSION (WORKS)
     ****************************************************************

     RECURS    SBR  *+7                * Copy return address from B-Address to next below
               SBR  X2, 000            * Return address to X2
               SBR  retn+X3, 0+X2      * Save return address to stack
               MCW  arg1+X3, LARG1
               MCW  arg2+X3, LARG2 
               B    *+7                * Jump over the local arguments
     LARG1     DCW  000
     LARG2     DCW  000
              
               MCW  LARG1, PRINT+2     * Print the arguments...
               W  
               CS   299
               MCW  LARG2, PRINT+2
               W  
               CS   299

               C    @?@, COUNT         * Compare to signed zero
               BE   *+54               * If equal to signed zero jump to NOP below
               S    @1@, COUNT         * COUNT--
     
               A    @1@, LARG1
               A    @100@, LARG2
     
               SBR  stkptr, rsize+X3   * Push the next record to stack 
               MCW  stkptr, X3         * X3 points to stack
               MCW  LARG1, arg1+X3     * Copy LARG1 into stack arg1
               MCW  LARG2, arg2+X3     * Copy LARG2 into stack arg2
               B    RECURS             * Jump same subroutine (recursion)
     
               NOP                     * Just a placeholder
     
               SBR  X3, rsizec+X3      * Adiust X3 to point to previous record
               SBR  stkptr, 0+X3       * Pop the stack
               MCW  retn+X3, *+4       * Set return address in branch instruction   
               B    000                * Return back to caller

     ****************************************************************
     ** SUBROUTINE WITHOUT RECURSION
     ****************************************************************
     
     SUB2      SBR  RTN2+3             * SAVE RETURN ADDRESS
                      
               MCW  @SUB2@, PRINT+3
               W  
               CS   299
     
               B    RTN2
               NOP
     
     RTN2      B    000                * BRANCH BACK
                    
     ****************************************************************
     ** AND for CHAR (3 DIGITS)
     ****************************************************************
     
     LOP       DCW  002
     ROP       DCW  001 
     RESULT    DCW  000
     SIZE      DCW  08
     IDX       DCW  00

     AND       SBR  END3+3             * Setup return address
     
     * Print some variables
               MCW  RESULT, PRINT+2
               W  
               CS   299
               MCW  LOP, PRINT+2
               W  
               CS   299
               MCW  ROP, PRINT+2
               W  
               CS   299
               MCW  @---@, PRINT+2
               W  
               CS   299

     LOOP2     C    SIZE, IDX          * Loop...
               BE   END3
     
               MCW  LOP, OP1
               MCW  @127@, OP2
               B    CBIG
               C    RES2, @1@
               BE   OV1   
               B    OV2
     OV1       A    -256, LOP
               B    OV4
     
     OV2       MCW  LOP, OP1
               MCW  -128, OP2
               B    CSMA
               C    RES2, @1@
               BE   OV3
               B    OV4
     OV3       A    @256@, LOP
     OV4       NOP
  
               MCW  ROP, OP1
               MCW  @127@, OP2
               B    CBIG
               C    RES2, @1@
               BE   OV5   
               B    OV6
     OV5       A    -256, ROP
               B    OV8
     
     OV6       MCW  ROP, OP1
               MCW  -128, OP2
               B    CSMA    
               C    RES2, @1@
               BE   OV7
               B    OV8
     OV7       A    @256@, ROP
     OV8       NOP

               A    RESULT, RESULT
     
               MCW  LOP, OP1
               MCW  @000@, OP2
               B    CSMA
               C    RES2, @1@
               BE   OV9
               B    OV11
     
     OV9       MCW  ROP, OP1
               MCW  @000@, OP2
               B    CSMA
               C    RES2, @1@
               BE   OV10
               B    OV11
     OV10      A    @1@, RESULT
     OV11      NOP
      
               A    LOP, LOP
               A    ROP, ROP
     
               A    @1@, IDX
     
               MCW  RESULT, PRINT+2
               W  
               CS   299
               MCW  LOP, PRINT+2
               W  
               CS   299
               MCW  ROP, PRINT+2
               W  
               CS   299
               MCW  @---@, PRINT+2
               W  
               CS   299
      
               B    LOOP2
     END3      B    000                * Jump back
                
     ****************************************************************
     ** XOR for CHAR (3 DIGITS)
     ****************************************************************
     
     XOR       SBR  XOR11+3            * Setup return address
     
     * Print some variables
               MCW  RESULT, PRINT+2
               W  
               CS   299
               MCW  LOP, PRINT+2
               W  
               CS   299
               MCW  ROP, PRINT+2
               W  
               CS   299
               MCW  @---@, PRINT+2
               W  
               CS   299

     XOR0      C    SIZE, IDX          * Loop...
               BE   XOR11
     
               MCW  LOP, OP1
               MCW  @127@, OP2
               B    CBIG
               C    RES2, @1@
               BE   XOR1   
               B    XOR2
     XOR1      A    -256, LOP
               B    XOR4
     
     XOR2      MCW  LOP, OP1
               MCW  -128, OP2
               B    CSMA
               C    RES2, @1@
               BE   XOR3
               B    XOR4
     XOR3      A    @256@, LOP
     XOR4      NOP
  
               MCW  ROP, OP1
               MCW  @127@, OP2
               B    CBIG
               C    RES2, @1@
               BE   XOR5   
               B    XOR6
     XOR5      A    -256, ROP
               B    XOR8
     
     XOR6      MCW  ROP, OP1
               MCW  -128, OP2
               B    CSMA    
               C    RES2, @1@
               BE   XOR7
               B    XOR8
     XOR7      A    @256@, ROP
     XOR8      NOP

               A    RESULT, RESULT
     
               MCW  LOP, OP1
               MCW  @000@, OP2
               B    CSMA
               C    RES2, @1@
               BU   XOR9
     
               MCW  ROP, OP1
               MCW  @000@, OP2
               B    CSMA
               C    RES2, @1@
               BE   XOR10
               A    @1@, RESULT
               B    XOR10
     
     XOR9      MCW  ROP, OP1
               MCW  @000@, OP2
               B    CSMA
               C    RES2, @1@
               BU   XOR10
               A    @1@, RESULT
        
     XOR10     A    LOP, LOP
               A    ROP, ROP
     
               A    @1@, IDX
     
               MCW  RESULT, PRINT+2
               W  
               CS   299
               MCW  LOP, PRINT+2
               W  
               CS   299
               MCW  ROP, PRINT+2
               W  
               CS   299
               MCW  @---@, PRINT+2
               W  
               CS   299
      
               B    XOR0
     XOR11     B    000                * Jump back

     ****************************************************************
     ** OR for CHAR (3 DIGITS)
     ****************************************************************
     
     OR        SBR  OR12+3             * Setup return address
     
     * Print some variables
               MCW  RESULT, PRINT+2
               W  
               CS   299
               MCW  LOP, PRINT+2
               W  
               CS   299
               MCW  ROP, PRINT+2
               W  
               CS   299
               MCW  @---@, PRINT+2
               W  
               CS   299

     OR0       C    SIZE, IDX          * Loop...
               BE   OR12
     
               MCW  LOP, OP1
               MCW  @127@, OP2
               B    CBIG
               C    RES2, @1@
               BE   OR1   
               B    OR2
     OR1       A    -256, LOP
               B    OR4
     
     OR2       MCW  LOP, OP1
               MCW  -128, OP2
               B    CSMA
               C    RES2, @1@
               BE   OR3
               B    OR4
     OR3       A    @256@, LOP
     OR4       NOP
  
               MCW  ROP, OP1
               MCW  @127@, OP2
               B    CBIG
               C    RES2, @1@
               BE   OR5   
               B    OR6
     OR5       A    -256, ROP
               B    OR8
     
     OR6       MCW  ROP, OP1
               MCW  -128, OP2
               B    CSMA    
               C    RES2, @1@
               BE   OR7
               B    OR8
     OR7       A    @256@, ROP
     OR8       NOP

               A    RESULT, RESULT
     
               MCW  LOP, OP1
               MCW  @000@, OP2
               B    CSMA
               C    RES2, @1@
               BE   OR9
               B    OR10
     
     OR9       A    @1@, RESULT
               B    OR11
     OR10      MCW  ROP, OP1
               MCW  @000@, OP2
               B    CSMA
               C    RES2, @1@
               BE   OR9
     OR11      NOP
      
               A    LOP, LOP
               A    ROP, ROP
     
               A    @1@, IDX
     
               MCW  RESULT, PRINT+2
               W  
               CS   299
               MCW  LOP, PRINT+2
               W  
               CS   299
               MCW  ROP, PRINT+2
               W  
               CS   299
               MCW  @---@, PRINT+2
               W  
               CS   299
      
               B    OR0
     OR12      B    000                * Jump back

     ****************************************************************
     ** CBIG: OP1 > OP2 returns False (0) or True (1)
     ** CSMA: OP1 < OP2 returns False (0) or True (1)
     ****************************************************************
  
     OP1       DCW  000                * Left operand (0-255)
     OP2       DCW  000                * Right operand (0-255)
     TMP2      DCW  000                
     RES2      DCW  0                  * Result (True or False)
       
     * OP1 > OP2 ?
     CBIG      SBR  CBIG3+3            * Setup return address
               B    CHKZER             * Check for zeros
               C    OP2, OP1           * Compare operands
               BE   CBIG3              * If equal bail out
               S    OP2, OP1           * Subtract operands
               BWZ  CBIG2, OP1, B      * OP1 > OP2 ?
               MCW  @0@, RES2          * Set result to False
               B    CBIG3              * If not bail out
     CBIG2     MCW  @1@, RES2          * Set result to True
     CBIG3     B    000                * Jump back
     
     ****************************************************************
  
     * OP1 < OP2 ?
     CSMA      SBR  CSMA3+3            * Setup return address
               B    CHKZER             * Check for zeros
               C    OP2, OP1           * Compare operands
               BE   CSMA3              * If equal bail out
               S    OP2, OP1           * Subtract operands
               BWZ  CSMA2, OP1, K      * OP1 < OP2 ?
               MCW  @0@, RES2          * Set result to False
               B    CSMA3              * If not bail out
     CSMA2     MCW  @1@, RES2          * Set result to True
     CSMA3     B    000                * Jump back

     ****************************************************************   
     ** CHECK SPECIAL CASE OF NEGATIVE ZEROS AND NORMALIZE THEM  
     ****************************************************************

     NEGZER    DCW  -000               * Negative Zero
            
     CHKZER    SBR  ISZER2+3           * Setup return address
               C    NEGZER, OP1        * Is OP1 a Negative Zero ?
               BU   ISZER1             * If is not go next check
               MCW  @?@, OP1           * Set OP1 to Normal Zero
     ISZER1    C    NEGZER, OP2        * Is OP2 a Negative Zero ?
               BU   ISZER2             * If is not jump over
               MCW  @?@, OP2           * Set OP2 to Normal Zero
     ISZER2    B    000                * Jump back

    ****************************************************************

               H
               B    *-3
     
               END  START
