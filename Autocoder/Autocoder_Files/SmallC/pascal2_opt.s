     ****************************************************************

     READ      EQU  001                * Read area
     PUNCH     EQU  101                * Punch area
     PRINT     EQU  201                * Print area
     
     PRCPOS    DCW  000                * char position in print area
     PUCPOS    DCW  000                * char position in punch area
     PUNSIZ    DCW  @080@              * Size of punch area
     PRTSIZ    DCW  @132@              * Size of print area
     EOS       DCW  @'@                * End Of String char (string terminator)
     EOL       DCW  @;@                * End Of Line char

               ORG  87
     X1        DSA  0                  * INDEX REGISTER 1
               ORG  92
     X2        DSA  0                  * INDEX REGISTER 2
               ORG  97
     X3        DSA  0                  * INDEX REGISTER 3
     
     * I need a single digit flag - should I replace this with a DA?
     RF        EQU  150

               ORG  3000
  
     START     NOP
     
     ****************************************************************  
     
               SBR  X2, 400            * SET THE STACK
               MCW  X2, X3
               SW   1001
               MCW  @69105@,1005
               SW   1023
               MCW  @201@,1025
               SW   1026
               MCW  @200@,1028
               SW   1031
               MCW  @081@,1033
               SW   1022
               MCW  EOS,1022
               SW   1021
               MCW  @F@,1021
               SW   1020
               MCW  @E@,1020
               SW   1019
               MCW  @D@,1019
               SW   1018
               MCW  @C@,1018
               SW   1017
               MCW  @B@,1017
               SW   1016
               MCW  @A@,1016
               SW   1015
               MCW  @9@,1015
               SW   1014
               MCW  @8@,1014
               SW   1013
               MCW  @7@,1013
               SW   1012
               MCW  @6@,1012
               SW   1011
               MCW  @5@,1011
               SW   1010
               MCW  @4@,1010
               SW   1009
               MCW  @3@,1009
               SW   1008
               MCW  @2@,1008
               SW   1007
               MCW  @1@,1007
               SW   1006
               MCW  @0@,1006
               SW   1040
               MCW  EOS,1040
               SW   1039
               MCW  @C@,1039
               SW   1038
               MCW  @%@,1038
               SW   1037
               MCW  @D@,1037
               SW   1036
               MCW  @%@,1036
               B    LBCAAA
               H    
     * FunctionDefinition((26))
     LABAAA    SBR  3+X3
     * BlockStatement(LBBAAA:null:3)
               SW   1+X3
               MA   @003@,X2
     LDCAAA    NOP  
     * NotEqualExpression(( *s ):'\0')
     * DereferenceExpression(s)
     * VariableExpression(s:-3:false)
     * Push(15997+X3:3)
               MA   @003@,X2
               LCA  15997+X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * ConstantExpression(0)
     * Push(EOS:1)
               MA   @001@,X2
               LCA  EOS,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               BE   LFCAAA
               B    LGCAAA
     LFCAAA    MCW  @00000@,0+X2
     LGCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LECAAA,5+X2, 
     * BlockStatement(LCBAAA:LBBAAA:0)
     * FunctionCallExpr((20))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * DereferenceExpression((s++))
     * PostIncrement(s)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LUAAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     LCBAAA    NOP  
               BCE  LBBAAA,RF,R
               B    LDCAAA
     LECAAA    NOP  
     LBBAAA    NOP  
               MA   @I9G@,X2
               CW   1+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     * FunctionDefinition((15))
     LPAAAA    SBR  3+X3
     * BlockStatement(LQAAAA:null:14)
               SW   1+X3
               SW   4+X3
               SW   7+X3
               MCW  @'06@,9+X3
               SW   10+X3
               MCW  @00001@,14+X3
               MA   @014@,X2
     * Assignment(start=str)
     * VariableExpression(str:-8:false)
     * Push(15992+X3:3)
               MA   @003@,X2
               LCA  15992+X3,0+X2
     * Push(@006@:3)
               MA   @003@,X2
               LCA  @006@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
     * if(retree.statement.BlockStatement@4df090d:retree.statement.IfStatement@4ecb36fa)
     * LessThanExpression(value:0)
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LJCAAA
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               B    LJCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00000@,0+X2
               BL   LLCAAA
               B    LMCAAA
     LLCAAA    MCW  @00001@,0+X2
     LMCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LHCAAA,5+X2, 
     * BlockStatement(LRAAAA:LQAAAA:0)
     * Assignment(( *(str++) )='-')
     * ConstantExpression(45)
     * Push(@-@:1)
               MA   @001@,X2
               LCA  @-@,0+X2
     * PostIncrement(str)
     * Push(@I9B@:3)
               MA   @003@,X2
               LCA  @I9B@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
     * Assignment(value=(-value))
     * NegExpression(value)
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               ZS   0+X2
               B    LJCAAA
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     LRAAAA    NOP  
               BCE  LQAAAA,RF,R
               B    LICAAA
     LHCAAA    NOP  
     * if(retree.statement.BlockStatement@45715c20:null)
     * EqualExpression(value:0)
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LJCAAA
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               B    LJCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LOCAAA
               B    LPCAAA
     LOCAAA    MCW  @00001@,0+X2
     LPCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LNCAAA,5+X2, 
     * BlockStatement(LSAAAA:LQAAAA:0)
     * Assignment((str[0])='0')
     * ConstantExpression(48)
     * Push(@0@:1)
               MA   @001@,X2
               LCA  @0@,0+X2
     * VariableExpression(str:-8:false)
     * Push(15992+X3:3)
               MA   @003@,X2
               LCA  15992+X3,0+X2
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * raw index on the stack
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
     * Assignment((str[1])='\0')
     * ConstantExpression(0)
     * Push(EOS:1)
               MA   @001@,X2
               LCA  EOS,0+X2
     * VariableExpression(str:-8:false)
     * Push(15992+X3:3)
               MA   @003@,X2
               LCA  15992+X3,0+X2
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
     * raw index on the stack
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
     * VariableExpression(start:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * Pop(15984+X3:3)
               MCW  0+X2,15984+X3
               MA   @I9G@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LSAAAA
     LSAAAA    NOP  
               BCE  LQAAAA,RF,R
     LNCAAA    NOP  
     LICAAA    NOP  
     LXCAAA    NOP  
     * LessThanOrEqualExpression(exp:retree.expression.DivideExpression@15575c7e)
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               B    LJCAAA
     * Divide(value/base)
     * VariableExpression(base:-11:false)
     * Push(15989+X3:5)
               MA   @005@,X2
               LCA  15989+X3,0+X2
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LZCAAA
               MCW  0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               B    LJCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00001@,0+X2
               BH   LFDAAA
               B    LGDAAA
     LFDAAA    MCW  @00000@,0+X2
     LGDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LYCAAA,5+X2, 
     * Assignment(exp=(exp * base))
     * Multiplication(exp*base)
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
     * VariableExpression(base:-11:false)
     * Push(15989+X3:5)
               MA   @005@,X2
               LCA  15989+X3,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@014@:3)
               MA   @003@,X2
               LCA  @014@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
               B    LXCAAA
     LYCAAA    NOP  
     LHDAAA    NOP  
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LIDAAA,5+X2, 
     * BlockStatement(LTAAAA:LQAAAA:0)
     * Assignment(( *(str++) )=(digits[retree.expression.DivideExpression@16554210]))
     * SubScriptEpression(digits:retree.expression.DivideExpression@16554210)
     * VariableExpression(digits:9:false)
     * Push(9+X3:3)
               MA   @003@,X2
               LCA  9+X3,0+X2
     * Divide(value/exp)
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LZCAAA
               MCW  0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * raw index on the stack
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * PostIncrement(str)
     * Push(@I9B@:3)
               MA   @003@,X2
               LCA  @I9B@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
     * Assignment(value=retree.expression.ModuloExpression@376433e4)
     * ModuloExpression(value:exp)
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LZCAAA
     * Pop(5)
               MA   @I9E@,X2
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment(exp=retree.expression.DivideExpression@138ada25)
     * Divide(exp/base)
     * VariableExpression(base:-11:false)
     * Push(15989+X3:5)
               MA   @005@,X2
               LCA  15989+X3,0+X2
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               B    LZCAAA
               MCW  0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@014@:3)
               MA   @003@,X2
               LCA  @014@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     LTAAAA    NOP  
               BCE  LQAAAA,RF,R
               B    LHDAAA
     LIDAAA    NOP  
     * Assignment(( *str )='\0')
     * ConstantExpression(0)
     * Push(EOS:1)
               MA   @001@,X2
               LCA  EOS,0+X2
     * VariableExpression(str:-8:false)
     * Push(15992+X3:3)
               MA   @003@,X2
               LCA  15992+X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
     * VariableExpression(start:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * Pop(15984+X3:3)
               MCW  0+X2,15984+X3
               MA   @I9G@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LQAAAA
     LQAAAA    NOP  
               MA   @I8F@,X2
               CW   1+X3
               CW   4+X3
               CW   7+X3
               CW   10+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     * FunctionDefinition((1))
     LBAAAA    SBR  3+X3
     * BlockStatement(LCAAAA:null:3)
               SW   1+X3
               MA   @003@,X2
     * Assignment(seed=retree.expression.ModuloExpression@8a3cf3e)
     * ModuloExpression(((42 * seed) + 19):100000)
     * ConstantExpression(100000)
     * Push(@100000@:5)
               MA   @005@,X2
               LCA  @100000@,0+X2
     * Addition((42 * seed)+19)
     * Multiplication(42*seed)
     * ConstantExpression(42)
     * Push(@00042@:5)
               MA   @005@,X2
               LCA  @00042@,0+X2
     * VariableExpression(seed:1005:true)
     * Push(1005:5)
               MA   @005@,X2
               LCA  1005,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * ConstantExpression(19)
     * Push(@00019@:5)
               MA   @005@,X2
               LCA  @00019@,0+X2
               A    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               B    LZCAAA
     * Pop(5)
               MA   @I9E@,X2
     * Push(@'05@:3)
               MA   @003@,X2
               LCA  @'05@,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * VariableExpression(seed:1005:true)
     * Push(1005:5)
               MA   @005@,X2
               LCA  1005,0+X2
     * Pop(15997+X3:5)
               MCW  0+X2,15997+X3
               MA   @I9E@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LCAAAA
     LCAAAA    NOP  
               MA   @I9G@,X2
               CW   1+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     * FunctionDefinition((36))
     LKBAAA    SBR  3+X3
     * BlockStatement(LLBAAA:null:7)
               SW   1+X3
               SW   4+X3
               SW   7+X3
               MA   @007@,X2
     * Assignment(arg=((*char) (( &cformat_str ) + (15997))))
     * Addition(( &cformat_str )+(15997))
     * AddressOfExpression(cformat_str)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * ConstantExpression(15997)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * Push(@006@:3)
               MA   @003@,X2
               LCA  @006@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
     LJDAAA    NOP  
     * NotEqualExpression((c = ( *(cformat_str++) )):'\0')
     * Assignment(c=( *(cformat_str++) ))
     * DereferenceExpression((cformat_str++))
     * PostIncrement(cformat_str)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * Push(@007@:3)
               MA   @003@,X2
               LCA  @007@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               MCW  0+X2,0+X1
     * ConstantExpression(0)
     * Push(EOS:1)
               MA   @001@,X2
               LCA  EOS,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               BE   LLDAAA
               B    LMDAAA
     LLDAAA    MCW  @00000@,0+X2
     LMDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LKDAAA,5+X2, 
     * BlockStatement(LMBAAA:LLBAAA:0)
     * if(retree.statement.ExpressionStatement@3a7af3e0:retree.statement.BlockStatement@5e21151e)
     * NotEqualExpression(c:'%')
     * VariableExpression(c:7:false)
     * Push(7+X3:1)
               MA   @001@,X2
               LCA  7+X3,0+X2
     * ConstantExpression(37)
     * Push(@%@:1)
               MA   @001@,X2
               LCA  @%@,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               BE   LPDAAA
               B    LQDAAA
     LPDAAA    MCW  @00000@,0+X2
     LQDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LNDAAA,5+X2, 
     * FunctionCallExpr((20))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * VariableExpression(c:7:false)
     * Push(7+X3:1)
               MA   @001@,X2
               LCA  7+X3,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LUAAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
               B    LODAAA
     LNDAAA    NOP  
     * BlockStatement(LNBAAA:LMBAAA:0)
     * Assignment(c=( *(cformat_str++) ))
     * DereferenceExpression((cformat_str++))
     * PostIncrement(cformat_str)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * Push(@007@:3)
               MA   @003@,X2
               LCA  @007@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
     * if(retree.statement.BlockStatement@27c94e11:retree.statement.IfStatement@1124527f)
     * EqualExpression(c:'%')
     * VariableExpression(c:7:false)
     * Push(7+X3:1)
               MA   @001@,X2
               LCA  7+X3,0+X2
     * ConstantExpression(37)
     * Push(@%@:1)
               MA   @001@,X2
               LCA  @%@,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LTDAAA
               B    LUDAAA
     LTDAAA    MCW  @00001@,0+X2
     LUDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LRDAAA,5+X2, 
     * BlockStatement(LOBAAA:LNBAAA:0)
     * FunctionCallExpr((20))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * ConstantExpression(37)
     * Push(@%@:1)
               MA   @001@,X2
               LCA  @%@,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LUAAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     LOBAAA    NOP  
               BCE  LNBAAA,RF,R
               B    LSDAAA
     LRDAAA    NOP  
     * if(retree.statement.BlockStatement@67a418a3:retree.statement.IfStatement@464daa7d)
     * EqualExpression(c:'C')
     * VariableExpression(c:7:false)
     * Push(7+X3:1)
               MA   @001@,X2
               LCA  7+X3,0+X2
     * ConstantExpression(67)
     * Push(@C@:1)
               MA   @001@,X2
               LCA  @C@,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LXDAAA
               B    LYDAAA
     LXDAAA    MCW  @00001@,0+X2
     LYDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LVDAAA,5+X2, 
     * BlockStatement(LPBAAA:LNBAAA:0)
     * FunctionCallExpr((20))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * DereferenceExpression((arg--))
     * PostDecrement(arg)
     * Push(@006@:3)
               MA   @003@,X2
               LCA  @006@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @I9I@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LUAAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     LPBAAA    NOP  
               BCE  LNBAAA,RF,R
               B    LWDAAA
     LVDAAA    NOP  
     * if(retree.statement.BlockStatement@14f4189a:retree.statement.IfStatement@257b3135)
     * EqualExpression(c:'S')
     * VariableExpression(c:7:false)
     * Push(7+X3:1)
               MA   @001@,X2
               LCA  7+X3,0+X2
     * ConstantExpression(83)
     * Push(@S@:1)
               MA   @001@,X2
               LCA  @S@,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LBEAAA
               B    LCEAAA
     LBEAAA    MCW  @00001@,0+X2
     LCEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LZDAAA,5+X2, 
     * BlockStatement(LQBAAA:LNBAAA:0)
     * FunctionCallExpr((26))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * DereferenceExpression(((**char) arg))
     * VariableExpression(arg:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LABAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Assignment(arg=(arg + (15997)))
     * Addition(arg+(15997))
     * VariableExpression(arg:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * ConstantExpression(15997)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * Push(@006@:3)
               MA   @003@,X2
               LCA  @006@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
     LQBAAA    NOP  
               BCE  LNBAAA,RF,R
               B    LAEAAA
     LZDAAA    NOP  
     * if(retree.statement.BlockStatement@3adba1cc:retree.statement.ReturnStatement@295b7644)
     * EqualExpression(c:'D')
     * VariableExpression(c:7:false)
     * Push(7+X3:1)
               MA   @001@,X2
               LCA  7+X3,0+X2
     * ConstantExpression(68)
     * Push(@D@:1)
               MA   @001@,X2
               LCA  @D@,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LFEAAA
               B    LGEAAA
     LFEAAA    MCW  @00001@,0+X2
     LGEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LDEAAA,5+X2, 
     * BlockStatement(LRBAAA:LNBAAA:7)
               SW   14+X3
               SW   13+X3
               SW   12+X3
               SW   11+X3
               SW   10+X3
               SW   9+X3
               SW   8+X3
               MA   @007@,X2
     * FunctionCallExpr((15))
     * Push(3)
               SW   1+X2
               MA   @003@,X2
     * ConstantExpression(10)
     * Push(@00010@:5)
               MA   @005@,X2
               LCA  @00010@,0+X2
     * ArrayNameExpresssion(a:char [7])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * DereferenceExpression(((*int) arg))
     * VariableExpression(arg:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:5)
               MA   @005@,X2
               LCA  0+X1,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LPAAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(3)
               MA   @I9G@,X2
     * FunctionCallExpr((26))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * ArrayNameExpresssion(a:char [7])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LABAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Assignment(arg=(arg + (15995)))
     * Addition(arg+(15995))
     * VariableExpression(arg:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * ConstantExpression(15995)
     * Push(@I9E@:3)
               MA   @003@,X2
               LCA  @I9E@,0+X2
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * Push(@006@:3)
               MA   @003@,X2
               LCA  @006@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
     LRBAAA    NOP  
               MA   @I9C@,X2
               CW   14+X3
               CW   13+X3
               CW   12+X3
               CW   11+X3
               CW   10+X3
               CW   9+X3
               CW   8+X3
               BCE  LNBAAA,RF,R
               B    LEEAAA
     LDEAAA    NOP  
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LNBAAA
     LEEAAA    NOP  
     LAEAAA    NOP  
     LWDAAA    NOP  
     LSDAAA    NOP  
     LNBAAA    NOP  
               BCE  LMBAAA,RF,R
     LODAAA    NOP  
     LMBAAA    NOP  
               BCE  LLBAAA,RF,R
               B    LJDAAA
     LKDAAA    NOP  
     LLBAAA    NOP  
               MA   @I9C@,X2
               CW   1+X3
               CW   4+X3
               CW   7+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     * FunctionDefinition((20))
     LUAAAA    SBR  3+X3
     * BlockStatement(LVAAAA:null:3)
               SW   1+X3
               MA   @003@,X2
     * if(retree.statement.BlockStatement@2bd8e0f3:retree.statement.BlockStatement@2b988802)
     * NotEqualExpression(c:'\n')
     * VariableExpression(c:-3:false)
     * Push(15997+X3:1)
               MA   @001@,X2
               LCA  15997+X3,0+X2
     * ConstantExpression(10)
     * Push(EOL:1)
               MA   @001@,X2
               LCA  EOL,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               BE   LJEAAA
               B    LKEAAA
     LJEAAA    MCW  @00000@,0+X2
     LKEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LHEAAA,5+X2, 
     * BlockStatement(LWAAAA:LVAAAA:0)
     * Assignment(( *(__putchar_pos++) )=c)
     * VariableExpression(c:-3:false)
     * Push(15997+X3:1)
               MA   @001@,X2
               LCA  15997+X3,0+X2
     * PostIncrement(__putchar_pos)
     * Push(@'25@:3)
               MA   @003@,X2
               LCA  @'25@,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
     LWAAAA    NOP  
               BCE  LVAAAA,RF,R
               B    LIEAAA
     LHEAAA    NOP  
     * BlockStatement(LXAAAA:LVAAAA:0)
     LLEAAA    NOP  
     * GreaterThanOrEqualExpression(((int) __putchar_last):((int) __putchar_pos))
     * VariableExpression(__putchar_last:1028:true)
     * Push(1028:3)
               MA   @003@,X2
               LCA  1028,0+X2
               B    LNEAAA
               B    LJCAAA
     * VariableExpression(__putchar_pos:1025:true)
     * Push(1025:3)
               MA   @003@,X2
               LCA  1025,0+X2
               B    LNEAAA
               B    LJCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00001@,0+X2
               BL   LWEAAA
               B    LXEAAA
     LWEAAA    MCW  @00000@,0+X2
     LXEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LMEAAA,5+X2, 
     * BlockStatement(LYAAAA:LXAAAA:0)
     * Assignment(( *(__putchar_last--) )=' ')
     * ConstantExpression(32)
     * Push(@ @:1)
               MA   @001@,X2
               LCA  @ @,0+X2
     * PostDecrement(__putchar_last)
     * Push(@'28@:3)
               MA   @003@,X2
               LCA  @'28@,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @I9I@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               MCW  0+X2,0+X1
               MA   @I9I@,X2
     LYAAAA    NOP  
               BCE  LXAAAA,RF,R
               B    LLEAAA
     LMEAAA    NOP  
     * Assignment(__putchar_last=__putchar_pos)
     * VariableExpression(__putchar_pos:1025:true)
     * Push(1025:3)
               MA   @003@,X2
               LCA  1025,0+X2
     * Push(@'28@:3)
               MA   @003@,X2
               LCA  @'28@,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
     * Assignment(__putchar_pos=(201))
     * ConstantExpression(201)
     * Push(@201@:3)
               MA   @003@,X2
               LCA  @201@,0+X2
     * Push(@'25@:3)
               MA   @003@,X2
               LCA  @'25@,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
     * Start asm block
               W    
     * End asm block
     LXAAAA    NOP  
               BCE  LVAAAA,RF,R
     LIEAAA    NOP  
     * if(retree.statement.BlockStatement@2b0951aa:null)
     * EqualExpression(__putchar_pos:(333))
     * VariableExpression(__putchar_pos:1025:true)
     * Push(1025:3)
               MA   @003@,X2
               LCA  1025,0+X2
     * ConstantExpression(333)
     * Push(@333@:3)
               MA   @003@,X2
               LCA  @333@,0+X2
               C    0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LZEAAA
               B    LAFAAA
     LZEAAA    MCW  @00001@,0+X2
     LAFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LYEAAA,5+X2, 
     * BlockStatement(LZAAAA:LVAAAA:0)
     * Assignment(__putchar_last=__putchar_pos)
     * VariableExpression(__putchar_pos:1025:true)
     * Push(1025:3)
               MA   @003@,X2
               LCA  1025,0+X2
     * Push(@'28@:3)
               MA   @003@,X2
               LCA  @'28@,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
     * Assignment(__putchar_pos=(201))
     * ConstantExpression(201)
     * Push(@201@:3)
               MA   @003@,X2
               LCA  @201@,0+X2
     * Push(@'25@:3)
               MA   @003@,X2
               LCA  @'25@,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               MCW  0+X2,0+X1
               MA   @I9G@,X2
     * Start asm block
               W    
     * End asm block
     LZAAAA    NOP  
               BCE  LVAAAA,RF,R
     LYEAAA    NOP  
     LVAAAA    NOP  
               MA   @I9G@,X2
               CW   1+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     * FunctionDefinition((7))
     LHAAAA    SBR  3+X3
     * BlockStatement(LIAAAA:null:3)
               SW   1+X3
               MA   @003@,X2
     LBFAAA    NOP  
     * NotEqualExpression((( *(dest++) ) = ( *(src++) )):'\0')
     * Assignment(( *(dest++) )=( *(src++) ))
     * DereferenceExpression((src++))
     * PostIncrement(src)
     * Push(@I9D@:3)
               MA   @003@,X2
               LCA  @I9D@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * PostIncrement(dest)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               MCW  0+X2,0+X1
     * ConstantExpression(0)
     * Push(EOS:1)
               MA   @001@,X2
               LCA  EOS,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               BE   LDFAAA
               B    LEFAAA
     LDFAAA    MCW  @00000@,0+X2
     LEFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LCFAAA,5+X2, 
               B    LBFAAA
     LCFAAA    NOP  
     LIAAAA    NOP  
               MA   @I9G@,X2
               CW   1+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     * FunctionDefinition((53))
     LBCAAA    SBR  3+X3
     * BlockStatement(LCCAAA:null:103)
               SW   1+X3
               SW   49+X3
               SW   44+X3
               SW   39+X3
               SW   34+X3
               SW   29+X3
               SW   24+X3
               SW   19+X3
               SW   14+X3
               SW   9+X3
               SW   4+X3
               SW   99+X3
               SW   94+X3
               SW   89+X3
               SW   84+X3
               SW   79+X3
               SW   74+X3
               SW   69+X3
               SW   64+X3
               SW   59+X3
               SW   54+X3
               MA   @103@,X2
     * Assignment((x[0])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[1])=1)
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[2])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(2)
     * Push(@00002@:5)
               MA   @005@,X2
               LCA  @00002@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[3])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(3)
     * Push(@00003@:5)
               MA   @005@,X2
               LCA  @00003@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[4])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(4)
     * Push(@00004@:5)
               MA   @005@,X2
               LCA  @00004@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[5])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(5)
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[6])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(6)
     * Push(@00006@:5)
               MA   @005@,X2
               LCA  @00006@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[7])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(7)
     * Push(@00007@:5)
               MA   @005@,X2
               LCA  @00007@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[8])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(8)
     * Push(@00008@:5)
               MA   @005@,X2
               LCA  @00008@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((x[9])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * ConstantExpression(9)
     * Push(@00009@:5)
               MA   @005@,X2
               LCA  @00009@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[0])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[1])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[2])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(2)
     * Push(@00002@:5)
               MA   @005@,X2
               LCA  @00002@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[3])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(3)
     * Push(@00003@:5)
               MA   @005@,X2
               LCA  @00003@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[4])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(4)
     * Push(@00004@:5)
               MA   @005@,X2
               LCA  @00004@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[5])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(5)
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[6])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(6)
     * Push(@00006@:5)
               MA   @005@,X2
               LCA  @00006@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[7])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(7)
     * Push(@00007@:5)
               MA   @005@,X2
               LCA  @00007@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[8])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(8)
     * Push(@00008@:5)
               MA   @005@,X2
               LCA  @00008@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment((y[9])=0)
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ConstantExpression(9)
     * Push(@00009@:5)
               MA   @005@,X2
               LCA  @00009@,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     * FunctionCallExpr((47))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * ArrayNameExpresssion(y:int [10])
     * Push(@058@:3)
               MA   @003@,X2
               LCA  @058@,0+X2
               MA   X3,0+X2
     * ArrayNameExpresssion(x:int [10])
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LVBAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(15997+X3:5)
               MCW  0+X2,15997+X3
               MA   @I9E@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LCCAAA
     LCCAAA    NOP  
               MA   @H9G@,X2
               CW   1+X3
               CW   49+X3
               CW   44+X3
               CW   39+X3
               CW   34+X3
               CW   29+X3
               CW   24+X3
               CW   19+X3
               CW   14+X3
               CW   9+X3
               CW   4+X3
               CW   99+X3
               CW   94+X3
               CW   89+X3
               CW   84+X3
               CW   79+X3
               CW   74+X3
               CW   69+X3
               CW   64+X3
               CW   59+X3
               CW   54+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     * FunctionDefinition((47))
     LVBAAA    SBR  3+X3
     * BlockStatement(LWBAAA:null:8)
               SW   1+X3
               SW   4+X3
               MA   @008@,X2
     * ForStatement((i = 1),(i < d)'(i++):retree.statement.BlockStatement@1a3ae8ac:LYBAAA:LZBAAA:LACAAA)
     * Assignment(i=1)
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               MCW  0+X2,0+X1
               MA   @I9E@,X2
     LYBAAA    NOP  
     * LessThanExpression(i:d)
     * VariableExpression(i:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
               B    LJCAAA
     * VariableExpression(d:-9:false)
     * Push(15991+X3:5)
               MA   @005@,X2
               LCA  15991+X3,0+X2
               B    LJCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00000@,0+X2
               BL   LFFAAA
               B    LGFAAA
     LFFAAA    MCW  @00001@,0+X2
     LGFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LZBAAA,5+X2, 
     * BlockStatement(LXBAAA:LWBAAA:0)
     * FunctionCallExpr((36))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * TernaryExpression((i < (d - 1)):' ':'\n')
     * LessThanExpression(i:(d - 1))
     * VariableExpression(i:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
               B    LJCAAA
     * Subtraction(d-1)
     * VariableExpression(d:-9:false)
     * Push(15991+X3:5)
               MA   @005@,X2
               LCA  15991+X3,0+X2
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               S    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               B    LJCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00000@,0+X2
               BL   LJFAAA
               B    LKFAAA
     LJFAAA    MCW  @00001@,0+X2
     LKFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LHFAAA,5+X2, 
     * ConstantExpression(32)
     * Push(@ @:1)
               MA   @001@,X2
               LCA  @ @,0+X2
               B    LIFAAA
     LHFAAA    NOP  
     * ConstantExpression(10)
     * Push(EOL:1)
               MA   @001@,X2
               LCA  EOL,0+X2
     LIFAAA    NOP  
     * Assignment((y[i])=((x[(i - 1)]) + (x[i])))
     * Addition((x[(i - 1)])+(x[i]))
     * SubScriptEpression(x:(i - 1))
     * VariableExpression(x:-3:false)
     * Push(15997+X3:3)
               MA   @003@,X2
               LCA  15997+X3,0+X2
     * Subtraction(i-1)
     * VariableExpression(i:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               S    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:5)
               MA   @005@,X2
               LCA  0+X1,0+X2
     * SubScriptEpression(x:i)
     * VariableExpression(x:-3:false)
     * Push(15997+X3:3)
               MA   @003@,X2
               LCA  15997+X3,0+X2
     * VariableExpression(i:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:5)
               MA   @005@,X2
               LCA  0+X1,0+X2
               A    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * VariableExpression(y:-6:false)
     * Push(15994+X3:3)
               MA   @003@,X2
               LCA  15994+X3,0+X2
     * VariableExpression(i:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
     * raw index on the stack
     * Push(@00005@:5)
               MA   @005@,X2
               LCA  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               MCW  0+X2,0+X1
     * ArrayNameExpresssion("%d%c":char [5])
     * Push(@'36@:3)
               MA   @003@,X2
               LCA  @'36@,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LKBAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     LXBAAA    NOP  
               BCE  LWBAAA,RF,R
     LACAAA    NOP  
     * PostIncrement(i)
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               A    @00001@,0+X1
               B    LYBAAA
     LZBAAA    NOP  
     * TernaryExpression((10 > d):(47( y x (d + 1))):0)
     * GreaterThanExpression(10:d)
     * ConstantExpression(10)
     * Push(@00010@:5)
               MA   @005@,X2
               LCA  @00010@,0+X2
               B    LJCAAA
     * VariableExpression(d:-9:false)
     * Push(15991+X3:5)
               MA   @005@,X2
               LCA  15991+X3,0+X2
               B    LJCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00000@,0+X2
               BH   LNFAAA
               B    LOFAAA
     LNFAAA    MCW  @00001@,0+X2
     LOFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LLFAAA,5+X2, 
     * FunctionCallExpr((47))
     * Push(5)
               SW   1+X2
               MA   @005@,X2
     * Addition(d+1)
     * VariableExpression(d:-9:false)
     * Push(15991+X3:5)
               MA   @005@,X2
               LCA  15991+X3,0+X2
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               A    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * VariableExpression(x:-3:false)
     * Push(15997+X3:3)
               MA   @003@,X2
               LCA  15997+X3,0+X2
     * VariableExpression(y:-6:false)
     * Push(15994+X3:3)
               MA   @003@,X2
               LCA  15994+X3,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LVBAAA
     * Pop(X3:3)
               MCW  0+X2,X3
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
               B    LMFAAA
     LLFAAA    NOP  
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     LMFAAA    NOP  
     * Pop(15986+X3:5)
               MCW  0+X2,15986+X3
               MA   @I9E@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LWBAAA
     LWBAAA    NOP  
               MA   @I9B@,X2
               CW   1+X3
               CW   4+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     * FunctionDefinition((5))
     LFAAAA    SBR  3+X3
     * BlockStatement(LGAAAA:null:8)
               SW   1+X3
               SW   4+X3
               MCW  @0000J@,8+X3
               MA   @008@,X2
     LPFAAA    NOP  
     * NotEqualExpression((str[(++len)]):'\0')
     * SubScriptEpression(str:(++len))
     * VariableExpression(str:-3:false)
     * Push(15997+X3:3)
               MA   @003@,X2
               LCA  15997+X3,0+X2
     * PreIncrement(len)
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               A    @00001@,0+X1
     * Push(0+X1:5)
               MA   @005@,X2
               LCA  0+X1,0+X2
     * raw index on the stack
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LQCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * ConstantExpression(0)
     * Push(EOS:1)
               MA   @001@,X2
               LCA  EOS,0+X2
               C    0+X2,15999+X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               BE   LRFAAA
               B    LSFAAA
     LRFAAA    MCW  @00000@,0+X2
     LSFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LQFAAA,5+X2, 
               B    LPFAAA
     LQFAAA    NOP  
     * VariableExpression(len:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
     * Pop(15994+X3:5)
               MCW  0+X2,15994+X3
               MA   @I9E@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LGAAAA
     LGAAAA    NOP  
               MA   @I9B@,X2
               CW   1+X3
               CW   4+X3
               MCW  @ @,RF
               MCW  3+X3,X1
               B    0+X1
     LJCAAA    SBR  X1
     * Normalizes the zone bits of a number, leaving either A=0B=0
     * for a positive or A=0B=1 for a negative
     * Do nothing on either no zone bits or only a b zone bit
               BWZ  LKCAAA,0+X2,2
               BWZ  LKCAAA,0+X2,K
     * else clear the zone bits, as it is positive
               MZ   @ @,0+X2
     LKCAAA    B    0+X1
    ****************************************************************  
    ** DIVISION SNIPPET                                           **
    ****************************************************************  
     
     LZCAAA    SBR  LADAAA+3           * SETUP RETURN ADDRESS
               
     * POP DIVIDEND
               MCW  0+X2, LBDAAA
               SBR  X2, 15995+X2

     * POP DIVISOR
               MCW  0+X2, LCDAAA
               SBR  X2, 15995+X2


               B    *+17
               
               DCW  @00000@                
               DC   @00000000000@        

               ZA   LBDAAA, *-7         * PUT DIVIDEND INTO WORKING BL
               D    LCDAAA, *-19        * DIVIDE
               MZ   *-22, *-21          * KILL THE ZONE BIT
               MZ   *-29, *-34          * KILL THE ZONE BIT
               MCW  *-41, LDDAAA        * PICK UP ANSWER
               SW   *-44                * SO I CAN PICKUP REMAINDER
               MCW  *-46, LEDAAA        * GET REMAINDER
               CW   *-55                * CLEAR THE WM
               MZ   LDDAAA-1, LDDAAA    * CLEANUP QUOTIENT BITZONE
               MZ   LEDAAA-1, LEDAAA    * CLEANUP REMAINDER BITZONE
               
     * PUSH REMAINDER
               SBR  X2, 5+X2
               SW   15996+X2
               MCW  LEDAAA, 0+X2
               
     * PUSH QUOTIENT
               SBR  X2, 5+X2
               SW   15996+X2
               MCW  LDDAAA, 0+X2

     LADAAA    B    000                 * JUMP BACK
               
     LCDAAA    DCW  00000               * DIVISOR
     LBDAAA    DCW  00000               * DIVIDEND
     LDDAAA    DCW  00000               * QUOTIENT
     LEDAAA    DCW  00000               * REMAINDER
     LQCAAA    SBR  X1
     * Casts a 5-digit number to a 3-digit address
     * make a copy of the top of the stack
               SW   1+X2
               MCW  0+X2,3+X2
     * zero out the zone bits of our copy
               MZ   @0@,3+X2
               MZ   @0@,2+X2
               MZ   @0@,1+X2
     * set the low-order digit's zone bits
               C    @04000@,0+X2
               BL   LTCAAA
               C    @08000@,0+X2
               BL   LSCAAA
               C    @12000@,0+X2
               BL   LRCAAA
               S    @12000@,0+X2
               MZ   @A@,3+X2
               B    LTCAAA
     LRCAAA    S    @08000@,0+X2
               MZ   @I@,3+X2
               B    LTCAAA
     LSCAAA    S    @04000@,0+X2
               MZ   @S@,3+X2
     * For some reason the zone bits get set - it still works though.
     LTCAAA    C    @01000@,0+X2
               BL   LWCAAA
               C    @02000@,0+X2
               BL   LVCAAA
               C    @03000@,0+X2
               BL   LUCAAA
               MZ   @A@,1+X2
               B    LWCAAA
     LUCAAA    MZ   @I@,1+X2
               B    LWCAAA
     LVCAAA    MZ   @S@,1+X2
     LWCAAA    MCW  3+X2,15998+X2
               CW   1+X2
               SBR  X2,15998+X2
               B    0+X1
     LNEAAA    SBR  X1
     * Casts a 3-digit address to a 5-digit number
     * Make room on the stack for an int
               MA   @002@,X2
     * make a copy of the top of the stack
               SW   1+X2
               MCW  15998+X2,3+X2
     * Now zero out the top of the stack
               MCW  @00000@,0+X2
     * Now copy back, shifted over 2 digits
               MCW  3+X2,0+X2
               CW   1+X2
     * Now zero out the zone bits on the stack
               MZ   @0@,0+X2
               MZ   @0@,15999+X2
               MZ   @0@,15998+X2
     * check the high-order digit's zone bits
               BWZ  LOEAAA,1+X2,S
               BWZ  LPEAAA,1+X2,K
               BWZ  LQEAAA,1+X2,B
               B    LREAAA
     LOEAAA    A    @01000@,0+X2
               B    LREAAA
     LPEAAA    A    @02000@,0+X2
               B    LREAAA
     LQEAAA    A    @03000@,0+X2
     LREAAA    BWZ  LSEAAA,3+X2,S
               BWZ  LTEAAA,3+X2,K
               BWZ  LUEAAA,3+X2,B
               B    LVEAAA
     LSEAAA    A    @04000@,0+X2
               B    LVEAAA
     LTEAAA    A    @08000@,0+X2
               B    LVEAAA
     LUEAAA    A    @12000@,0+X2
     LVEAAA    B    0+X1
               END  START
