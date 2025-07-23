     * test_overwrite_error.s
     * Test program to check a simulator error reported by Stan Paddock:
     * Overwrite of memory location 202 when the second consecutive W is executed
     * By Luca Severini lucaseverini@mac.com
     * Last edit: 4-4-2014
     *
               ORG  400               PUT NEXT INSTRUCTIONS IN 100
     R1        DSA  0                 CREATE REGISTER R1
     *
     START     MCW  VALUE,R1
               MCW  @ABCDEFGH@,208    STORE ABCDEFGH IN WRITE AREA (201)
     *
     LOOP      W                      PRINT IT
               S    @1@,R1     	      R1--
               C    @00?@,R1          IF R1 > 0
               BH   LOOP              THEN LOOP
     *
               H    *-3               HALT AND BRANCH TO SELF TO BE SAFE        
               NOP                    INSURES A WM AFTER THE HALT                  
     *
     VALUE     DCW  10                NUMBER OF LINES TO PRINT
     *
               END  START