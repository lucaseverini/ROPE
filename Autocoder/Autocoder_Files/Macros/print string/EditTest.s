     *00000000011111111112222222222333333333344444444445555555555666666666677777777778
     *12345678901234567890123456789012345678901234567890123456789012345678901234567890
     *PPPPPPPPPPPPPPPPPPPPSVVVVVVVVVVVXXXXXXXSBSBSBSBSBSBSBSBSBSBSCCCCCCCCCCCCCCCCCCCC
     ***************************************************************************
     *     SSSSS = CARD SEQUENCE NUMBER          ********** = LABEL
     *     OPER- = OPERATION                     OPERATION--- = OPERATION
SSSSS**********OPER-OPERANDS----------------------------------------------------     **********|****|***********************************************************
               JOB  FIRST PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD     
     *
     PATT      EQU  020                 *CARD PATTERN FIELD (1-20)
     SIGN      EQU  021                 *SIGN FIELD (21) - = NEGATIVE ANYTHING ELSE IS POSITIVE
     VALUE     EQU  032                 *NUMERICIAL VALUE(22-32)
     SB        EQU  060                 *SHOULD BE (40-60)
     TEXT      EQU  080                 *COMMENT (60-80)
     *
               ORG  87
     X1        DCW  000                 *INDEX REGISTER 1
               DCW  11                  *IDENTIFING FILLER
     X2        DCW  000                 *INDEX REGISTER 2
               DCW  22                  *IDENTIFING FILLER
     X3        DCW  000                 *INDEX REGISTER 3
               DCW  33                  *IDENTIFING FILLER
     *
               ORG  340                 *ORG JUST AFTER PRINT BUFFER
     *
     IDENT     DCW  @Edit Test program 06/04/2009@  *ID THE PROGRAM DECK
     HOLD      DCW  0000000000
     *
     START     NOP                      *HALT FOR SINGLE STEP
               CS   80                  *CLEAR CARD STORAGE
               SW   1,21                *DEFINE FIELDS
               SW   22,40               *DEFINE FIELDS
               SW   61                  *DEFINE FIELD
               R                        *READ OVER PATTERN CARD
               CS   332                 *CLEAR 332 TO 300
               CS                       *CLEAR 299 TO 200 
               MCW  @AS GENERATED @,221 *TITLE
               MCW  @AS SHOULD BE@,245  *TITLE
               MCW  @COMMENT@,257       *TITLE
               W    s                   *PRINT IT
     READ      R                        *READ A CARD
               C    @EOF  @,005         *SEE IF END
               BE   EXIT                *YUP
               CS   332                 *CLEAR 332 TO 300
               CS                       *CLEAR 299 TO 200            
               MLCWAPATT,221            *PUT THE PATTERN IN THE PRINT BUFFER
               BCE  NEGN,SIGN,-         *IS IT A NEGATIVE NUMBER?
               ZA   VALUE,HOLD          *SET THE VALUE
               B    PRINT               *BRANCH TO PRINT
     NEGN      ZS   VALUE,HOLD          *PUT AS A MINUS
     PRINT     MCE  HOLD,221            *USE THE EDIT
               MCW  SB,245              *MOVE SHOULD BE TO PRINT
               MCW  TEXT,270            *PUT TEXT ON PRINT LINE
               W                        *PRINT IT
               CS   332                 *CLEAR 332 TO 300
               CS                       *CLEAR 299 TO 200 
               B    READ                *LETS DO ANOTHER ONE
     EXIT      CS   332                 *CLEAR 332 TO 300
               CS                       *CLEAR 299 TO 200 
               W                        *PRINT BLANK LINE
               NOP  999,999             *PUT 999 IN A * AND B *
               H                        *HALT BEFORE GOING TO THE NEXT PROGRAM
               CC   1                   *EJECT THE PAGE
               CS   332                 *CLEAR UPPER PRINT BUFFER
               CS                       *CLEAR LOWER PRINT BUFFER
               CS                       *CLEAR PUNCH BUFFER
               CS                       *CLEAR READ BUFFER
               SW   001                 *SET FIRST WM
     MORE      R                        *READ ANOTHER CARD
               BCE  001,001,,           *IF IT IS A COMMA, GO TO THE CODE
               B    MORE                *READ ANOTHER
               NOP                      *TRAILER WITH A WM
               END  START
