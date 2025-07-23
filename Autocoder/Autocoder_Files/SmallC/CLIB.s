     *********************************************************************
     ** CLIB.MAC - AUTOCODER MACRO CONTAINING VARIOUS FUNCTIONS USED BY **
     **            C-COMPILER CROSS-COMPILER FOR IBM 1401               **
     *********************************************************************

     * TO BE DONE:
     * MEMCPY

     ****************************************************************
     
     OP1       DCW  00000
     OP2       DCW  00000
     RESULT    DCW  00000
     RES3      DCW  000
     LOP       DCW  00000
     ROP       DCW  00000
     TMP1      DCW  00000
     TMP2      DCW  00000
     TMP3      DCW  00000
     TMPSTR    DCW  000
     COUNT     DCW  000
     SHIFTS    DCW  00
     SIZE      DCW  00
     IDX       DCW  00
     IDX3      DCW  000
     REMAIN    DCW  00000
     QUOT      DCW  00000
     CH        DCW  0                  * 1-digit char
     CHPOS     DCW  000                * char position 
     CH1       DCW  0
     CH3       DCW  000                * 3-digit char
     LEN       DCW  000                * String length
     TMPC      DCW  0
     LENA      DCW  000                * String-A length
     LENB      DCW  000                * String-B length     
     TOTRD     DCW  000                * Counter of read chars
     TABLEN    DCW  095                * Length of CHTAB 
     CHTAB     DCW  0                                      * Table for 3-digit char to ASCII char
               DC   @ ###$%&'()*+,-./0123456789:;<=>?#@    *
               DC   @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`@     *
               DC   @ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~ @      * Letters on this row should be lowercase
 
     ****************************************************************
     ** STRCMP - Compare String-A and String-B
     **          Returns >0 if A > B , 0 -> if A == B , <0 if A < B         
     ****************************************************************

     STRCMP    SBR  STRCM9+3           * Setup return address

               MCW  X1, TMP1           * Save index registers...
               MCW  X3, TMP3
  
               POP  X1                 * String-A address in X1    
               MCW  2+X1, LENA         * String-A length in LENA

               POP  X3                 * String-B address in X3
               MCW  2+X3, LENB         * String-B length in LENB
     
               C    LENA, LENB
               BH   STRCM0
               MCW  LENB, LEN
               B    STRCM1
     STRCM0    MCW  LENA, LEN
     
     STRCM1    MCW  @000@, IDX3, 
     
     STRCM2    C    IDX3, LEN
               BE   STRCM3
               
               SBR  X1, 3+X1           * X1 points to next 3-digit char of String-A
               SBR  X3, 3+X3           * X3 points to next 3-digit char of String-B

               PUSH 2+X1
               PUSH 2+X3   
               B    CMPB
               POP  RES3
          
               C    @001@, RES3
               BE   ABIG
               C    @002@, RES3
               BE   BBIG
                   
               A    @1@, IDX3          * Increment IDX3
               B    STRCM2             * Do it again...
     
     STRCM3    C    LENA, LENB
               BL   ABIG2
               BH   BBIG2
               MCW  @000@, RES3
               B    STRCM8
     
     ABIG2     SBR  X1, 3+X1
               MCW  2+X1, RES3
               B    STRCM8
 
     BBIG2     SBR  X3, 3+X3
               MCW  2+X3, RES3
               MZ   @!@, RES3
               B    STRCM8
    
     ABIG      MCW  @001@, RES3
               B    STRCM8

     BBIG      MCW  -001, RES3
               B    STRCM8
 
     STRCM8    MCW  TMP1, X1           * Restore index registers...
               MCW  TMP3, X3
     
               PUSH RES3
   
     STRCM9    B    000                * Jump back

     ****************************************************************
     ** STRCPY - Copy String-A into String-B
     ****************************************************************

     STRCPY    SBR  STRCP9+3           * Setup return address

               MCW  X1, TMP1           * Save index registers...
               MCW  X3, TMP3
 
               POP  X3                 * String-B address in X3
 
               POP  X1                 * String-A address in X1    
               MCW  2+X1, LENA         * String-A length in LENA
               A    @1@, LENA          * Copy also the length
     
     STRCP1    MZ   LENA-1, LENA       * Remove bit-zone to get a real decimal number
               C    LENA, @000@        * Check if LEN is 0
               BE   STRCP8             * If it is then jump over
               
               MCW  2+X1, 2+X3         * Copy char of String-A into String-B 
               SBR  X1, 3+X1           * X1 points to next 3-digit char
               SBR  X3, 3+X3           * X3 points to next 3-digit char
              
               S    @1@, LENA          * Decrement LEN
               B    STRCP1             * Do it again...  
 
     STRCP8    MCW  TMP1, X1           * Restore index registers...
               MCW  TMP3, X3
   
     STRCP9    B    000                * Jump back

     ****************************************************************
     ** STRCAT - Append String-A to String-B
     ****************************************************************
     
     STRCAT    SBR  STRC10+3           * Setup return address
     
               MCW  X1, TMP1           * Save index registers...
               MCW  X3, TMP3
 
               POP  X3                 * String-B address in X3
               MCW  2+X3, LENB         * String-B length in LENB

               POP  X1                 * String-A address in X1    
               MCW  2+X1, LENA         * String-A length in LENA
               A    LENB, 2+X1         * Update length of String-A
    
               MUL  LENA, @3@, LENA    * Multiply LENA by 3 to point to the first available char position    
               A    LENA, X1           * Set index register to point to first available char position 
     
     STRC1     MZ   LENB-1, LENB       * Remove bit-zone to get a real decimal number
               C    LENB, @000@        * Check if LEN is 0
               BE   STRC9              * If it is then jump over
               
               SBR  X1, 3+X1           * X1 points to next 3-digit char
               SBR  X3, 3+X3           * X3 points to next 3-digit char
               MCW  2+X3, 2+X1         * Append char of String-B to String-A 
               
               S    @1@, LENB          * Decrement LEN
               B    STRC1              * Do it again...
                                          
     STRC9     MCW  TMP1, X1           * Restore index registers...
               MCW  TMP3, X3
   
     STRC10    B    000                * Jump back
    
     ****************************************************************
     ** STRLEN - Copy the string length on stack
     ** X1 is not preserved    
     ****************************************************************
     
     STRLEN    SBR  STRL9+3            * Setup return address
 
               POP  X1                 * String address in X1
               PUSH 2+X1               * String length onto stack
     
     STRL9     B    000                * Jump back
    
     ****************************************************************
     ** GETS - Read then copy the data in read area to string whose pointer 
     **        is on stack until the end of the string or the read area
     **        Argument passed on stack: String pointer and String Max Length        
     ****************************************************************
     
     GETS      SBR  GETS9+3            * Setup return address
 
               R                       * Read a card
     
               MCW  X1, TMP1           * Save index registers...
               MCW  X3, TMP3
 
               POP  LEN                * Max length in LEN
               POP  TMPSTR             * String address in X1
     
               C    @000@, TMPSTR      * Check for null pointer
               BE   GETS8              * If null, bail out
               
               MZ   LEN-1, LEN         * Remove bit-zone to get a real decimal number
               C    @000@, LEN         * Check string max length
               BE   GETS8              * If LEN == 0 then bail out
     
               MCW  @000@, TOTRD
     
               SBR  X3, READ
               MCW  X1, TMPSTR
               SBR  X1, 3+X1

     GETS1     C    TOTRD, LEN         * Check if max num of chars has been read
               BE   GETS7              * If it is then jump over
     
               MCW  0+X3, CH
     
               PUSH CH
               B    C1TOC3             * Converts 1-digit char to 3-digit char
               POP  CH3
               MCW  CH3, 2+X1
     
               SBR  X3, 1+X3
               SBR  X1, 3+X1
               
               A    @1@, TOTRD         * Increment TOTRD
               B    GETS1              * Do it again...
     
     GETS7     MCW  TMPSTR, X1         * Set String length...
               MCW  TOTRD, 2+X1
    
     GETS8     MCW  TMP1, X1           * Restore index registers...
               MCW  TMP3, X3

     GETS9     B    000                * Jump back
    
     **************************************************************** 
     ** C1TOC3 - Convert a 1-digit char to a 3-digit char
     ****************************************************************
     
     C1TOC3    SBR  CONVC7+3           * Setup return address     

               POP  CH                 * Get the char to convert from stack
     
               PUSH X1                 * Save X1
     
               SBR  X1, CHTAB          * X1 points to Conversion Table
               SBR  X1, 1+X1           * Adjust pointer
               MCW  @000@, COUNT       * Set count to 0
 
     CONVC3    C    COUNT, TABLEN      * Check if COUNT = to length of cobversion table
               BE   BADC1              * If it is then jump over
          
               MCW  0+x1, CH1
               C    CH, CH1            * Compare char to char in table
               BE   FOUNDC             * If found jump away
               
               A    @1@, COUNT         * Increment COUNT
               SBR  X1, 1+X1           * Increment pointer to next char in table

               B    CONVC3             * Do it again...       

     FOUNDC    NOP
               POP  X1                 * Restore X1
               A    @32@, COUNT        * Add 32 to char code
               PUSH COUNT              * Put char code onto stack
               B    CONVC7             * Jump out
          
     BADC1     NOP
               POP  X1                 * Restore X1
               PUSH @033@              * What is the best one to represent unprintable chars ?
      
     CONVC7    B    000                * Jump back
     
     ****************************************************************
     ** PUTS - Copy a String made of 3-digit chars to storage area and prints it when full  
     ** X1 is not preserved    
     ****************************************************************
     
     PUTS      SBR  PUTS9+3            * Setup return address
         
               POP  X1                 * String address in X1
               MCW  2+X1, LEN          * String length in LEN
     
     PUTS1     MZ   LEN-1, LEN         * Remove bit-zone to get a real decimal number
               C    LEN, @000@         * Check if LEN is 0
               BE   PUTS9              * If it is then jump over
     
               SBR  X1, 3+X1           * X1 points to next 3-digit char
               PUSH 2+X1               * Push the char onto stack
               B    PUTC               * Put char in print area
               
               S    @1@, LEN           * Decrement LEN
               B    PUTS1              * Do it again...
                                       
     PUTS9     B    000                * Jump back
     
     ****************************************************************
     ** PUTC - Copy a CHAR (3 digits) to storage area and prints it when full      
     ****************************************************************
     
     PUTC      SBR  PUTC9+3            * Setup return address
     
               B    C3TOC1             * Converts 3-digit char to 1-digit char to be printed

               POP  CH                 * Gets converted 1-digit char from stack
     
               PUSH X1                 * Save index reg X1
     
               MCW  CHPOS, X1          * Put char in the right place...
               MCW  CH, PRINT+X1
           
               POP  X1                 * Restore index reg X1
     
               A    @1@, CHPOS         * Increment position for next char
     
               C    CHPOS, @132@       * Check if print area is full
               BU   PUTC9              * If not jump over
     
               B    PFLUSH             * Prints everything
    
     PUTC9     B    000                * Jump back
          
     **************************************************************** 
     ** C3TOC1 - Convert a 3-digit char to a 1-digit char
     ****************************************************************
     
     C3TOC1    SBR  CONVC9+3           * Setup return address     

               POP  CH3                * Get the char to convert from stack
               MCW  CH3, TMPC          * Copy on temp storage
    
               S    @32@, TMPC
               MN   @1@, TMPC
               BCE  BADC, TMPC, J      * If negative is an umprintable char <32
     
               S    @32@, CH3  
               MZ   CH3-1, CH3    
               C    CH3, TABLEN         * If > TABLEN is an unsupported extended ASCII code
               BL   BADC               *
     
               PUSH X1                 * Save X1
         
               MCW  CH3, X1            * normalized 0-based char code in X1
               MCW  CHTAB+X1+1, CH1    * +1 to jump the o used in DCW 0 where CHTAB label is defined
     
               POP  X1                 * Restore X1
     
               PUSH CH1                * Copy converted char onto stack

               B    CONVC9             * Go to exit
     
     BADC      NOP
               PUSH @#@                * What is the best one to represent unprintable chars ?
     
     CONVC9    B    000                * Jump back
     
     **************************************************************** 
     ** PFLUSH - Prints and resets print area and character position
     ****************************************************************
     
     PFLUSH    SBR  FLUSH9+3           * Setup return address     
     
               W                       * Prints
               CS   332
               CS   299                * Clear area
               MCW  @000@, CHPOS       * Reset position for next char
     
     FLUSH9    B    000                * Jump back
     
     ****************************************************************
     ** AND for INTEGER (5 DIGITS)
     ****************************************************************

     ANDI      SBR  ANDI13+3           * Setup return address

               POP  OP2
               POP  OP1

               ZA   OP1, LOP
               ZA   OP2, ROP
               ZA   @0@, RESULT
               ZA   @0@, IDX
               ZA   @16@, SIZE

     ANDI0     C    SIZE, IDX          * Loop...
               BE   ANDI12
               
               B    ADOPI              * Adjust values

               A    RESULT

               ZA   LOP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   ANDI9
               B    ANDI11

     ANDI9     ZA   ROP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   ANDI10
               B    ANDI11
     ANDI10    A    @1@, RESULT
     ANDI11    NOP

               A    LOP
               A    ROP

               A    @1@, IDX

               B    ANDI0

     ANDI12    NOP
               PUSH RESULT

     ANDI13    B    000                * Jump back

     ****************************************************************

     ADOPI     SBR  ADOPI9+3
     
               ZA   LOP, OP1
               ZA   @32767@, OP2
               B    CBIG
               C    RES2, @1@
               BE   ADOPI1   
               B    ADOPI2
     ADOPI1    A    -65536, LOP
               B    ADOPI4

     ADOPI2    ZA   LOP, OP1
               ZA   -32768, OP2
               B    CSMA
               C    RES2, @1@
               BE   ADOPI3
               B    ADOPI4
     ADOPI3    A    @65536@, LOP
     ADOPI4    NOP

               ZA   ROP, OP1
               ZA   @32767@, OP2
               B    CBIG
               C    RES2, @1@
               BE   ADOPI5   
               B    ADOPI6
     ADOPI5    A    -65536, ROP
               B    ADOPI8

     ADOPI6    ZA   ROP, OP1
               ZA   -32768, OP2
               B    CSMA    
               C    RES2, @1@
               BE   ADOPI7
               B    ADOPI8
     ADOPI7    A    @65536@, ROP
     ADOPI8    NOP
     
     ADOPI9    B    000

     ****************************************************************
     ** AND for CHAR (3 DIGITS)
     ****************************************************************

     ANDB      SBR  ANDB13+3           * Setup return address

               POP  OP2
               POP  OP1

               ZA   OP1, LOP
               ZA   OP2, ROP
               ZA   @0@, RESULT
               ZA   @0@, IDX
               ZA   @8@, SIZE

     ANDB0     C    SIZE, IDX          * Loop...
               BE   ANDB12
               
               B    ADOPB              * Adjust values

               A    RESULT

               ZA   LOP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   ANDB9
               B    ANDB11

     ANDB9     ZA   ROP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   ANDB10
               B    ANDB11
     ANDB10    A    @1@, RESULT
     ANDB11    NOP

               A    LOP
               A    ROP

               A    @1@, IDX

               B    ANDB0

     ANDB12    NOP
               PUSH RESULT
               
     ANDB13    B    000                * Jump back

     ****************************************************************

     ADOPB     SBR  ADOPB9+3
     
               ZA   LOP, OP1
               ZA   @127@, OP2
               B    CBIG
               C    RES2, @1@
               BE   ADOPB1   
               B    ADOPB2
     ADOPB1    A    -256, LOP
               B    ADOPB4

     ADOPB2    ZA   LOP, OP1
               ZA   -128, OP2
               B    CSMA
               C    RES2, @1@
               BE   ADOPB3
               B    ADOPB4
     ADOPB3    A    @256@, LOP
     ADOPB4    NOP

               ZA   ROP, OP1
               ZA   @127@, OP2
               B    CBIG
               C    RES2, @1@
               BE   ADOPB5   
               B    ADOPB6
     ADOPB5    A    -256, ROP
               B    ADOPB8

     ADOPB6    ZA   ROP, OP1
               ZA   -128, OP2
               B    CSMA    
               C    RES2, @1@
               BE   ADOPB7
               B    ADOPB8
     ADOPB7    A    @256@, ROP
     ADOPB8    NOP
     
     ADOPB9    B    000

     ****************************************************************
     ** XOR for INTEGER (5 DIGITS)
     ****************************************************************

     XORI      SBR  XORI12+3           * Setup return address

               POP  OP2
               POP  OP1

               ZA   OP1, LOP
               ZA   OP2, ROP

               ZA   @0@, RESULT
               ZA   @0@, IDX
               ZA   @16@, SIZE

     XORI0     C    SIZE, IDX          * Loop...
               BE   XORI11

               B    ADOPI              * Adjust values

               A    RESULT
     
               ZA   LOP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BU   XORI9
     
               ZA   ROP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   XORI10
               A    @1@, RESULT
               B    XORI10
     
     XORI9     ZA   ROP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BU   XORI10
               A    @1@, RESULT
        
     XORI10    A    LOP
               A    ROP
     
               A    @1@, IDX
          
               B    XORI0
     
     XORI11    NOP
               PUSH RESULT
               
     XORI12    B    000                * Jump back

     ****************************************************************
     ** XOR for CHAR (3 DIGITS)
     ****************************************************************

     XORB      SBR  XORB12+3           * Setup return address

               POP  OP2
               POP  OP1

               ZA   OP1, LOP
               ZA   OP2, ROP

               ZA   @0@, RESULT
               ZA   @0@, IDX
               ZA   @8@, SIZE

     XORB0     C    SIZE, IDX          * Loop...
               BE   XORB11

               B    ADOPB              * Adjust values

               A    RESULT
     
               ZA   LOP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BU   XORB9
     
               ZA   ROP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   XORB10
               A    @1@, RESULT
               B    XORB10
     
     XORB9     ZA   ROP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BU   XORB10
               A    @1@, RESULT
        
     XORB10    A    LOP
               A    ROP
     
               A    @1@, IDX
          
               B    XORB0
     
     XORB11    NOP
               PUSH RESULT

     XORB12    B    000                * Jump back

     ****************************************************************
     ** OR for INTEGER (5 DIGITS)
     ****************************************************************
     
     ORI       SBR  ORI13+3            * Setup return address

               POP  OP2
               POP  OP1

               ZA   OP1, LOP
               ZA   OP2, ROP

               ZA   @0@, RESULT
               ZA   @0@, IDX
               ZA   @16@, SIZE
 
     ORI0      C    SIZE, IDX          * Loop...
               BE   ORI12
     
               B    ADOPI              * Adjust values
               
               A    RESULT
     
               ZA   LOP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   ORI9
               B    ORI10
     
     ORI9      A    @1@, RESULT
               B    ORI11
     ORI10     ZA   ROP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   ORI9
     ORI11     NOP
      
               A    LOP
               A    ROP
     
               A    @1@, IDX
           
               B    ORI0
               
     ORI12     NOP
               PUSH RESULT
               
     ORI13     B    000                * Jump back

     ****************************************************************
     ** OR for CHAR (3 DIGITS)
     ****************************************************************
     
     ORB       SBR  ORB13+3            * Setup return address

               POP  OP2
               POP  OP1

               ZA   OP1, LOP
               ZA   OP2, ROP

               ZA   @0@, RESULT
               ZA   @0@, IDX
               ZA   @8@, SIZE
 
     ORB0      C    SIZE, IDX          * Loop...
               BE   ORB12
     
               B    ADOPB              * Adjust values
               
               A    RESULT
     
               ZA   LOP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   ORB9
               B    ORB10
     
     ORB9      A    @1@, RESULT
               B    ORB11
     ORB10     ZA   ROP, OP1
               ZA   @0@, OP2
               B    CSMA
               C    RES2, @1@
               BE   ORB9
     ORB11     NOP
      
               A    LOP
               A    ROP
     
               A    @1@, IDX
           
               B    ORB0

     ORB12     NOP
               PUSH RESULT

     ORB13     B    000                * Jump back

     ****************************************************************
     ** SHIFT LEFT for INTEGER (5 digits)
     ****************************************************************
     
     SHLI      SBR  SHLI11+3

               POP  OP2
               POP  OP1

               ZA   OP1, RESULT
               ZA   OP2, SHIFTS
               ZA   @16@, SIZE
     
               ZA   SHIFTS, OP1
               ZA   @1@, OP2
               B    CSMA
               C    RES2, @1@
               BE   SHLI10

               ZA   SHIFTS, OP1
               ZA   SIZE, OP2
               B    CBIG
               C    RES2, @1@
               BE   SHLI9  
               ZA   SHIFTS, OP1
               ZA   SIZE, OP2
               B    CEQU
               BE   SHLI9  
     
               ZA   @0@, IDX
     SHLI2     C    SHIFTS, IDX          * Loop...
               BE   SHLI10
               
               A    RESULT               * Shift left one position
     
               A    @1@, IDX
     
               B    SHLI2
     
     SHLI9     ZA   @0@, RESULT

     SHLI10    NOP
               PUSH RESULT
               
     SHLI11    B    000

     ****************************************************************
     ** SHIFT LEFT for CHAR (3 digits)
     ****************************************************************
     
     SHLB      SBR  SHLB11+3

               POP  OP2
               POP  OP1

               ZA   OP1, RESULT
               ZA   OP2, SHIFTS
               ZA   @8@, SIZE
     
               ZA   SHIFTS, OP1
               ZA   @1@, OP2
               B    CSMA
               C    RES2, @1@
               BE   SHLB10

               ZA   SHIFTS, OP1
               ZA   SIZE, OP2
               B    CBIG
               C    RES2, @1@
               BE   SHLB9  
               ZA   SHIFTS, OP1
               ZA   SIZE, OP2
               B    CEQU
               BE   SHLB9  
     
               ZA   @0@, IDX
     SHLB2     C    SHIFTS, IDX          * Loop...
               BE   SHLB10
               
               A    RESULT               * Shift left one position
     
               A    @1@, IDX
     
               B    SHLB2
     
     SHLB9     ZA   @0@, RESULT

     SHLB10    NOP
               PUSH RESULT
               
     SHLB11    B    000

     ****************************************************************
     ** SHIFT RIGHT for INTEGER (5 digits)
     ****************************************************************
     
     SHRI      SBR  SHRI11+3

               POP  OP2
               POP  OP1

               ZA   OP1, RESULT
               ZA   OP2, SHIFTS
               ZA   @16@, SIZE
     
               ZA   SHIFTS, OP1
               ZA   @1@, OP2
               B    CSMA
               C    RES2, @1@
               BE   SHRI10

               ZA   SHIFTS, OP1
               ZA   SIZE, OP2
               B    CBIG
               C    RES2, @1@
               BE   SHRI9  
               ZA   SHIFTS, OP1
               ZA   SIZE, OP2
               B    CEQU
               BE   SHRI9  
     
               ZA   @0@, IDX
     SHRI2     C    SHIFTS, IDX          * Loop...
               BE   SHRI10
               
               S    RESULT               * Shift rigt one position
     
               A    @1@, IDX
     
               B    SHRI2
     
     SHRI9     ZA   @0@, RESULT

     SHRI10    NOP
               PUSH RESULT
               
     SHRI11    B    000
     
     ****************************************************************
     ** SHIFT RIGHT for CHAR (3 digits)
     ****************************************************************
     
     SHRB      SBR  SHRB11+3

               POP  OP2
               POP  OP1

               ZA   OP1, RESULT
               ZA   OP2, SHIFTS
               ZA   @8@, SIZE
     
               ZA   SHIFTS, OP1
               ZA   @1@, OP2
               B    CSMA
               C    RES2, @1@
               BE   SHRB10

               ZA   SHIFTS, OP1
               ZA   SIZE, OP2
               B    CBIG
               C    RES2, @1@
               BE   SHRB9  
               ZA   SHIFTS, OP1
               ZA   SIZE, OP2
               B    CEQU
               BE   SHRB9  
     
               ZA   @0@, IDX
     SHRB2     C    SHIFTS, IDX          * Loop...
               BE   SHRB10
               
               S    RESULT               * Shift rigt one position
     
               A    @1@, IDX
     
               B    SHRB2
     
     SHRB9     ZA   @0@, RESULT

     SHRB10    NOP
               PUSH RESULT
               
     SHRB11    B    000
     
     ****************************************************************
     ** PRINT UNSIGNED INTEGER (5 digits) ON STACK
     ****************************************************************
     
     PRTI      SBR  PRTI4+3            * Setup return address
     
               POP  OP1
               
               BWZ  PRTI2, OP1,2       * JUMP IF NO ZONE (OP1 IS POSITIVE, NO CONVERSION)
               BWZ  PRTI1, OP1,B       * JUMP IF B ZONE (OP1 IS POSITIVE, BUT ZONE MUST BE REMOVED)
               MCW  @-@, PRINT         * OP1 IS NEGATIVE, PUT THE MINUS SIGN IN FRONT               
               MZ   OP1-1, OP1              
               MCW  OP1, PRINT+5
               B    PRTI3
     PRTI1     MZ   OP1-1, OP1         * REMOVE ZONE
     PRTI2     MCW  OP1, PRINT+4
     PRTI3     W
               CS   299
     PRTI4     B    000

     ****************************************************************
     ** PRINT SIGNED INTEGER (5 digits) ON STACK WITH SIGN IF NEGATIVE
     ****************************************************************
     
     PRTIS     SBR  PRTIS4+3           * Setup return address

               POP  OP1

               BWZ  PRTIS2, OP1,2      * JUMP IF NO ZONE (OP1 IS POSITIVE, NO CONVERSION)
               BWZ  PRTIS1, OP1,B      * JUMP IF B ZONE (OP1 IS POSITIVE, BUT ZONE MUST BE REMOVED)
               MCW  @-@, PRINT         * OP1 IS NEGATIVE, PUT THE MINUS SIGN IN FRONT               
               MZ   OP1-1, OP1              
               MCW  OP1, PRINT+5
               B    PRTIS3
     PRTIS1    MZ   OP1-1, OP1         * REMOVE ZONE
     PRTIS2    MCW  OP1, PRINT+4
     PRTIS3    W
               CS   299
     PRTIS4    B    000

     ****************************************************************
     ** PRINT CHAR (3 digits) ON STACK WITH SIGN IF NEGATIVE
     ****************************************************************
     
     PRTB      SBR  PRTB4+3            * Setup return address
     
               POP  OP1

               SW   OP1-2              * Set WM to 3rd digit
               BWZ  PRTB2, OP1,2       * JUMP IF NO ZONE (OP1 IS POSITIVE, NO CONVERSION)
               BWZ  PRTB1, OP1,B       * JUMP IF B ZONE (OP1 IS POSITIVE, BUT ZONE MUST BE REMOVED)
               MCW  @-@, PRINT         * OP1 IS NEGATIVE, PUT THE MINUS SIGN IN FRONT 
               MZ   OP1-1, OP1              
               MCW  OP1, PRINT+3
               B    PRTB3
     PRTB1     MZ   OP1-1, OP1         * REMOVE ZONE
     PRTB2     MCW  OP1, PRINT+2
     PRTB3     W
               CS   299
               SW   OP1-4              * Restore WM to 5th digit
                 
     PRTB4     B    000

     ****************************************************************
     ** CMPB COMPARE for CHAR (3 DIGITS)
     ** If OP1 > OP2, RESULT = 1
     ** If OP2 < OP1, RESULT = 2
     ** if OP1 == OP2, RESULT = 3
     ****************************************************************

     CMPB      SBR  CMPB6+3            * Setup return address
     
               POPI OP2
               POPI OP1

               MCW  @3@, RESULT        * Pre-set RESULT for EQUAL
               B    CHKZI              * Check for negative zeros
               ZA   OP2, TMP           * Move OP2 to TMP
               S    OP1, TMP           * SUBTRACT OP1 FROM TMP
               MN   @1@, TMP           * SET TO 1 SO NEGATIVE IS A j
               BCE  CMPB1, TMP, J      * If LSD of TMP is a J, OP1 > OP2
               B    CMPB3              * Next check
     CMPB1     MCW  @1@, RESULT        * set RESULT to 1 if op1 > op2
     CMPB3     ZA   OP1, TMP           * Move OP2 to TMP
               S    OP2, TMP           * SUBTRACT OP2 FROM TMP
               MN   @1@, TMP           * SET TO 1 SO NEGATIVE IS A j
               BCE  CMPB4, TMP, J      * If LSD of TMP is a J, OP1 > OP2 otherwise OP1 == OP2
               B    CMPB5              * Go out
     CMPB4     MCW  @2@, RESULT        * Set RESULT to 2 if op2 > op1
     
     CMPB5     NOP
               PUSHB RESULT
     
     CMPB6     B    000                * Jump back

     OP1       DCW  00000
     OP2       DCW  00000
     TMP       DCW  00000
     RESULT    DCW  0
  
     ****************************************************************   
     ** CHECK SPECIAL CASE OF NEGATIVE ZEROS AND NORMALIZE THEM  
     ****************************************************************

     NEGZB     DCW  -000               * Negative Zero

     CHKZB     SBR  CHKZB4+3           * Setup return address
               C    NEGZB, OP1         * Is OP1 a Negative Zero ?
               BU   CHKZB2             * If is not go next check
               MCW  @?@, OP1           * Set OP1 to Normal Zero
     CHKZB2    C    NEGZB, OP2         * Is OP2 a Negative Zero ?
               BU   CHKZB4             * If is not jump over
               MCW  @?@, OP2           * Set OP2 to Normal Zero
     CHKZB4    B    000                * Jump back

     ****************************************************************

     NEGZI     DCW  -00000             * Negative Zero

     CHKZI     SBR  CHKZI4+3           * Setup return address
               C    NEGZI, OP1         * Is OP1 a Negative Zero ?
               BU   CHKZI2             * If is not go next check
               MCW  @?@, OP1           * Set OP1 to Normal Zero
     CHKZI2    C    NEGZI, OP2         * Is OP2 a Negative Zero ?
               BU   CHKZI4             * If is not jump over
               MCW  @?@, OP2           * Set OP2 to Normal Zero
     CHKZI4    B    000                * Jump back

     ****************************************************************
     ** CEQU: OP1 == OP2 returns True (1) or False (0)
     ** CBIG: OP1 > OP2 returns True (1) or False (0)
     ** CSMA: OP1 < OP2 returns True (1) or False (0)
     ****************************************************************
  
     RES2      DCW  0                  * Result (True or False)
       
     * OP1 == OP2 ?
     CEQU      SBR  CEQU3+3            * Setup return address
               B    CHKZI              * Check for zeros
               C    OP2, OP1           * Compare operands
               BE   CEQU2              * If equal bail out
               MCW  @0@, RES2          * Set result to False
               B    CEQU3              * If not bail out
     CEQU2     MCW  @1@, RES2          * Set result to True
     CEQU3     B    000                * Jump back

     ****************************************************************

     * OP1 > OP2 ?
     CBIG      SBR  CBIG3+3            * Setup return address
               MCW  @0@, RES2          * Set result to False
               B    CHKZI              * Check for zeros
               C    OP2, OP1           * Compare operands
               BE   CBIG3              * If equal bail out
               S    OP2, OP1           * Subtract operands
               BWZ  CBIG2, OP1, B      * OP1 > OP2 ?
               B    CBIG3              * If not bail out
     CBIG2     MCW  @1@, RES2          * Set result to True
     CBIG3     B    000                * Jump back
     
     ****************************************************************
  
     * OP1 < OP2 ?
     CSMA      SBR  CSMA3+3            * Setup return address
               MCW  @0@, RES2          * Set result to False
               B    CHKZI              * Check for zeros
               C    OP2, OP1           * Compare operands
               BE   CSMA3              * If equal bail out
               S    OP2, OP1           * Subtract operands
               BWZ  CSMA2, OP1, K      * OP1 < OP2 ?
               B    CSMA3              * If not bail out
     CSMA2     MCW  @1@, RES2          * Set result to True
     CSMA3     B    000                * Jump back
