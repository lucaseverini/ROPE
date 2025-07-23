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
               LCA  @69105@,1005
               LCA  @201@,1025
               LCA  @200@,1028
               LCA  @081@,1033
               LCA  EOS,1022
               LCA  @F@,1021
               LCA  @E@,1020
               LCA  @D@,1019
               LCA  @C@,1018
               LCA  @B@,1017
               LCA  @A@,1016
               LCA  @9@,1015
               LCA  @8@,1014
               LCA  @7@,1013
               LCA  @6@,1012
               LCA  @5@,1011
               LCA  @4@,1010
               LCA  @3@,1009
               LCA  @2@,1008
               LCA  @1@,1007
               LCA  @0@,1006
               LCA  EOS,1046
               LCA  EOL,1045
               LCA  @.@,1044
               LCA  @D@,1043
               LCA  @%@,1042
               LCA  @ @,1041
               LCA  @:@,1040
               LCA  @E@,1039
               LCA  @N@,1038
               LCA  @O@,1037
               LCA  @D@,1036
               B    LXBAAA
               H    
     * FunctionDefinition((26))
     LABAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LBBAAA:null:3)
               MA   @003@,X2
     LZBAAA    NOP  
     * NotEqualExpression(( *s ):'\0')
     * DereferenceExpression(s)
     * VariableExpression(s:-3:false)
     * Push(15997+X3:3)
               MA   @003@,X2
               LCA  15997+X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
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
               BE   LBCAAA
               B    LCCAAA
     LBCAAA    MCW  @00000@,0+X2
     LCCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LACAAA,5+X2, 
     * BlockStatement(LCBAAA:LBBAAA:0)
     * FunctionCallExpr((20))
     * Push(5)
               MA   @005@,X2
     * DereferenceExpression((s++))
     * PostIncrement(s)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
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
               LCA  0+X2,X3
               MA   @I9G@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     LCBAAA    NOP  
               BCE  LBBAAA,RF,R
               B    LZBAAA
     LACAAA    NOP  
     LBBAAA    NOP  
               MA   @I9G@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((15))
     LPAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LQAAAA:null:14)
               LCA  @'06@,9+X3
               LCA  @00001@,14+X3
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               LCA  0+X2,0+X1
               MA   @I9G@,X2
     * if(retree.statement.BlockStatement@35371c0c:retree.statement.IfStatement@3512731f)
     * LessThanExpression(value:0)
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LFCAAA
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               B    LFCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00000@,0+X2
               BL   LHCAAA
               B    LICAAA
     LHCAAA    MCW  @00001@,0+X2
     LICAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LDCAAA,5+X2, 
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               LCA  0+X2,0+X1
               MA   @I9I@,X2
     * Assignment(value=(-value))
     * NegExpression(value)
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               ZS   0+X2
               B    LFCAAA
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               LCA  0+X2,0+X1
               MA   @I9E@,X2
     LRAAAA    NOP  
               BCE  LQAAAA,RF,R
               B    LECAAA
     LDCAAA    NOP  
     * if(retree.statement.BlockStatement@5f260643:null)
     * EqualExpression(value:0)
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LFCAAA
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               B    LFCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LKCAAA
               B    LLCAAA
     LKCAAA    MCW  @00001@,0+X2
     LLCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LJCAAA,5+X2, 
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
               LCA  6+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LMCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               LCA  0+X2,0+X1
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
               LCA  6+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LMCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               LCA  0+X2,0+X1
               MA   @I9I@,X2
     * VariableExpression(start:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * Pop(15984+X3:3)
               LCA  0+X2,15984+X3
               MA   @I9G@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LSAAAA
     LSAAAA    NOP  
               BCE  LQAAAA,RF,R
     LJCAAA    NOP  
     LECAAA    NOP  
     LTCAAA    NOP  
     * LessThanOrEqualExpression(exp:retree.expression.DivideExpression@39654982)
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               B    LFCAAA
     * Divide(value/base)
     * VariableExpression(base:-11:false)
     * Push(15989+X3:5)
               MA   @005@,X2
               LCA  15989+X3,0+X2
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LVCAAA
               MCW  0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               B    LFCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00001@,0+X2
               BH   LBDAAA
               B    LCDAAA
     LBDAAA    MCW  @00000@,0+X2
     LCDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LUCAAA,5+X2, 
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
               LCA  6+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@014@:3)
               MA   @003@,X2
               LCA  @014@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               LCA  0+X2,0+X1
               MA   @I9E@,X2
               B    LTCAAA
     LUCAAA    NOP  
     LDDAAA    NOP  
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LEDAAA,5+X2, 
     * BlockStatement(LTAAAA:LQAAAA:0)
     * Assignment(( *(str++) )=(digits[retree.expression.DivideExpression@153a6057]))
     * SubScriptEpression(digits:retree.expression.DivideExpression@153a6057)
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
               B    LVCAAA
               MCW  0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * raw index on the stack
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               LCA  6+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LMCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               LCA  0+X2,X1
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               LCA  0+X2,0+X1
               MA   @I9I@,X2
     * Assignment(value=retree.expression.ModuloExpression@2b8afaa4)
     * ModuloExpression(value:exp)
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LVCAAA
     * Pop(5)
               MA   @I9E@,X2
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               LCA  0+X2,0+X1
               MA   @I9E@,X2
     * Assignment(exp=retree.expression.DivideExpression@314d3b51)
     * Divide(exp/base)
     * VariableExpression(base:-11:false)
     * Push(15989+X3:5)
               MA   @005@,X2
               LCA  15989+X3,0+X2
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               B    LVCAAA
               MCW  0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@014@:3)
               MA   @003@,X2
               LCA  @014@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               LCA  0+X2,0+X1
               MA   @I9E@,X2
     LTAAAA    NOP  
               BCE  LQAAAA,RF,R
               B    LDDAAA
     LEDAAA    NOP  
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               LCA  0+X2,0+X1
               MA   @I9I@,X2
     * VariableExpression(start:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * Pop(15984+X3:3)
               LCA  0+X2,15984+X3
               MA   @I9G@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LQAAAA
     LQAAAA    NOP  
               MA   @I8F@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((47))
     LVBAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LWBAAA:null:18)
               LCA  @00000@,8+X3
               LCA  @00006@,13+X3
               LCA  @00003@,18+X3
               MA   @018@,X2
     * Assignment(a=retree.expression.DivideExpression@15575c7e)
     * Divide(b/c)
     * VariableExpression(c:18:false)
     * Push(18+X3:5)
               MA   @005@,X2
               LCA  18+X3,0+X2
     * VariableExpression(b:13:false)
     * Push(13+X3:5)
               MA   @005@,X2
               LCA  13+X3,0+X2
               B    LVCAAA
               MCW  0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@008@:3)
               MA   @003@,X2
               LCA  @008@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               LCA  0+X2,0+X1
               MA   @I9E@,X2
     * FunctionCallExpr((36))
     * Push(5)
               MA   @005@,X2
     * VariableExpression(a:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
     * ArrayNameExpresssion("done: %d.\n":char [11])
     * Push(@'36@:3)
               MA   @003@,X2
               LCA  @'36@,0+X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LKBAAA
     * Pop(X3:3)
               LCA  0+X2,X3
               MA   @I9G@,X2
     * Pop(3)
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(5)
               MA   @I9E@,X2
     LWBAAA    NOP  
               MA   @I8B@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((1))
     LBAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LCAAAA:null:3)
               MA   @003@,X2
     * Assignment(seed=retree.expression.ModuloExpression@1a795f24)
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
               LCA  6+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * ConstantExpression(19)
     * Push(@00019@:5)
               MA   @005@,X2
               LCA  @00019@,0+X2
               A    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               B    LVCAAA
     * Pop(5)
               MA   @I9E@,X2
     * Push(@'05@:3)
               MA   @003@,X2
               LCA  @'05@,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               LCA  0+X2,0+X1
               MA   @I9E@,X2
     * VariableExpression(seed:1005:true)
     * Push(1005:5)
               MA   @005@,X2
               LCA  1005,0+X2
     * Pop(15997+X3:5)
               LCA  0+X2,15997+X3
               MA   @I9E@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LCAAAA
     LCAAAA    NOP  
               MA   @I9G@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((36))
     LKBAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LLBAAA:null:7)
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               LCA  0+X2,0+X1
               MA   @I9G@,X2
     LFDAAA    NOP  
     * NotEqualExpression((c = ( *(cformat_str++) )):'\0')
     * Assignment(c=( *(cformat_str++) ))
     * DereferenceExpression((cformat_str++))
     * PostIncrement(cformat_str)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * Push(@007@:3)
               MA   @003@,X2
               LCA  @007@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
               LCA  0+X2,0+X1
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
               BE   LHDAAA
               B    LIDAAA
     LHDAAA    MCW  @00000@,0+X2
     LIDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LGDAAA,5+X2, 
     * BlockStatement(LMBAAA:LLBAAA:0)
     * if(retree.statement.ExpressionStatement@16554210:retree.statement.BlockStatement@376433e4)
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
               BE   LLDAAA
               B    LMDAAA
     LLDAAA    MCW  @00000@,0+X2
     LMDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LJDAAA,5+X2, 
     * FunctionCallExpr((20))
     * Push(5)
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
               LCA  0+X2,X3
               MA   @I9G@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
               B    LKDAAA
     LJDAAA    NOP  
     * BlockStatement(LNBAAA:LMBAAA:0)
     * Assignment(c=( *(cformat_str++) ))
     * DereferenceExpression((cformat_str++))
     * PostIncrement(cformat_str)
     * Push(@I9G@:3)
               MA   @003@,X2
               LCA  @I9G@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:1)
               MA   @001@,X2
               LCA  0+X1,0+X2
     * Push(@007@:3)
               MA   @003@,X2
               LCA  @007@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               LCA  0+X2,0+X1
               MA   @I9I@,X2
     * if(retree.statement.BlockStatement@f7bd29:retree.statement.IfStatement@8a3cf3e)
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
               BE   LPDAAA
               B    LQDAAA
     LPDAAA    MCW  @00001@,0+X2
     LQDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LNDAAA,5+X2, 
     * BlockStatement(LOBAAA:LNBAAA:0)
     * FunctionCallExpr((20))
     * Push(5)
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
               LCA  0+X2,X3
               MA   @I9G@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     LOBAAA    NOP  
               BCE  LNBAAA,RF,R
               B    LODAAA
     LNDAAA    NOP  
     * if(retree.statement.BlockStatement@3a7af3e0:retree.statement.IfStatement@5e21151e)
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
               BE   LTDAAA
               B    LUDAAA
     LTDAAA    MCW  @00001@,0+X2
     LUDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LRDAAA,5+X2, 
     * BlockStatement(LPBAAA:LNBAAA:0)
     * FunctionCallExpr((20))
     * Push(5)
               MA   @005@,X2
     * DereferenceExpression((arg--))
     * PostDecrement(arg)
     * Push(@006@:3)
               MA   @003@,X2
               LCA  @006@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @I9I@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
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
               LCA  0+X2,X3
               MA   @I9G@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     LPBAAA    NOP  
               BCE  LNBAAA,RF,R
               B    LSDAAA
     LRDAAA    NOP  
     * if(retree.statement.BlockStatement@4df194d9:retree.statement.IfStatement@2f635a89)
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
               BE   LXDAAA
               B    LYDAAA
     LXDAAA    MCW  @00001@,0+X2
     LYDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LVDAAA,5+X2, 
     * BlockStatement(LQBAAA:LNBAAA:0)
     * FunctionCallExpr((26))
     * Push(5)
               MA   @005@,X2
     * DereferenceExpression(((**char) arg))
     * VariableExpression(arg:6:false)
     * Push(6+X3:3)
               MA   @003@,X2
               LCA  6+X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
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
               LCA  0+X2,X3
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               LCA  0+X2,0+X1
               MA   @I9G@,X2
     LQBAAA    NOP  
               BCE  LNBAAA,RF,R
               B    LWDAAA
     LVDAAA    NOP  
     * if(retree.statement.BlockStatement@23ccf0ad:retree.statement.ReturnStatement@63cd0037)
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
               BE   LBEAAA
               B    LCEAAA
     LBEAAA    MCW  @00001@,0+X2
     LCEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LZDAAA,5+X2, 
     * BlockStatement(LRBAAA:LNBAAA:7)
               MA   @007@,X2
     * FunctionCallExpr((15))
     * Push(3)
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
               LCA  0+X2,X1
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
               LCA  0+X2,X3
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
               LCA  0+X2,X3
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               LCA  0+X2,0+X1
               MA   @I9G@,X2
     LRBAAA    NOP  
               MA   @I9C@,X2
               BCE  LNBAAA,RF,R
               B    LAEAAA
     LZDAAA    NOP  
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LNBAAA
     LAEAAA    NOP  
     LWDAAA    NOP  
     LSDAAA    NOP  
     LODAAA    NOP  
     LNBAAA    NOP  
               BCE  LMBAAA,RF,R
     LKDAAA    NOP  
     LMBAAA    NOP  
               BCE  LLBAAA,RF,R
               B    LFDAAA
     LGDAAA    NOP  
     LLBAAA    NOP  
               MA   @I9C@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((20))
     LUAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LVAAAA:null:3)
               MA   @003@,X2
     * if(retree.statement.BlockStatement@1124527f:retree.statement.BlockStatement@67a418a3)
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
               BE   LFEAAA
               B    LGEAAA
     LFEAAA    MCW  @00000@,0+X2
     LGEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LDEAAA,5+X2, 
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               LCA  0+X2,0+X1
               MA   @I9I@,X2
     LWAAAA    NOP  
               BCE  LVAAAA,RF,R
               B    LEEAAA
     LDEAAA    NOP  
     * BlockStatement(LXAAAA:LVAAAA:0)
     LHEAAA    NOP  
     * GreaterThanOrEqualExpression(((int) __putchar_last):((int) __putchar_pos))
     * VariableExpression(__putchar_last:1028:true)
     * Push(1028:3)
               MA   @003@,X2
               LCA  1028,0+X2
               B    LJEAAA
               B    LFCAAA
     * VariableExpression(__putchar_pos:1025:true)
     * Push(1025:3)
               MA   @003@,X2
               LCA  1025,0+X2
               B    LJEAAA
               B    LFCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00001@,0+X2
               BL   LSEAAA
               B    LTEAAA
     LSEAAA    MCW  @00000@,0+X2
     LTEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LIEAAA,5+X2, 
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @I9I@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:1)
               LCA  0+X2,0+X1
               MA   @I9I@,X2
     LYAAAA    NOP  
               BCE  LXAAAA,RF,R
               B    LHEAAA
     LIEAAA    NOP  
     * Assignment(__putchar_last=__putchar_pos)
     * VariableExpression(__putchar_pos:1025:true)
     * Push(1025:3)
               MA   @003@,X2
               LCA  1025,0+X2
     * Push(@'28@:3)
               MA   @003@,X2
               LCA  @'28@,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               LCA  0+X2,0+X1
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               LCA  0+X2,0+X1
               MA   @I9G@,X2
     * Start asm block
               W    
     * End asm block
     LXAAAA    NOP  
               BCE  LVAAAA,RF,R
     LEEAAA    NOP  
     * if(retree.statement.BlockStatement@14f4189a:null)
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
               BE   LVEAAA
               B    LWEAAA
     LVEAAA    MCW  @00001@,0+X2
     LWEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LUEAAA,5+X2, 
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               LCA  0+X2,0+X1
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:3)
               LCA  0+X2,0+X1
               MA   @I9G@,X2
     * Start asm block
               W    
     * End asm block
     LZAAAA    NOP  
               BCE  LVAAAA,RF,R
     LUEAAA    NOP  
     LVAAAA    NOP  
               MA   @I9G@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((7))
     LHAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LIAAAA:null:3)
               MA   @003@,X2
     LXEAAA    NOP  
     * NotEqualExpression((( *(dest++) ) = ( *(src++) )):'\0')
     * Assignment(( *(dest++) )=( *(src++) ))
     * DereferenceExpression((src++))
     * PostIncrement(src)
     * Push(@I9D@:3)
               MA   @003@,X2
               LCA  @I9D@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
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
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Push(0+X1:3)
               MA   @003@,X2
               LCA  0+X1,0+X2
               MA   @001@,0+X1
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
               LCA  0+X2,0+X1
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
               BE   LZEAAA
               B    LAFAAA
     LZEAAA    MCW  @00000@,0+X2
     LAFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LYEAAA,5+X2, 
               B    LXEAAA
     LYEAAA    NOP  
     LIAAAA    NOP  
               MA   @I9G@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((49))
     LXBAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LYBAAA:null:3)
               MA   @003@,X2
     * FunctionCallExpr((47))
     * Push(5)
               MA   @005@,X2
     * Push(X3:3)
               MA   @003@,X2
               LCA  X3,0+X2
               MCW  X2,X3
               B    LVBAAA
     * Pop(X3:3)
               LCA  0+X2,X3
               MA   @I9G@,X2
     * Pop(5)
               MA   @I9E@,X2
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
     * Pop(15997+X3:5)
               LCA  0+X2,15997+X3
               MA   @I9E@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LYBAAA
     LYBAAA    NOP  
               MA   @I9G@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((5))
     LFAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LGAAAA:null:8)
               LCA  @0000J@,8+X3
               MA   @008@,X2
     LBFAAA    NOP  
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
               LCA  0+X2,X1
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
               LCA  6+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LMCAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
     * STACK top is location in array now.
     * Pop(X1:3)
               LCA  0+X2,X1
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
     * VariableExpression(len:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
     * Pop(15994+X3:5)
               LCA  0+X2,15994+X3
               MA   @I9E@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LGAAAA
     LGAAAA    NOP  
               MA   @I9B@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     LFCAAA    SBR  X1
     * Normalizes the zone bits of a number, leaving either A=0B=0
     * for a positive or A=0B=1 for a negative
     * Do nothing on either no zone bits or only a b zone bit
               BWZ  LGCAAA,0+X2,2
               BWZ  LGCAAA,0+X2,K
     * else clear the zone bits, as it is positive
               MZ   @ @,0+X2
     LGCAAA    B    0+X1
    ****************************************************************  
    ** DIVISION SNIPPET                                           **
    ****************************************************************  
     
     LVCAAA    SBR  LWCAAA+3           * SETUP RETURN ADDRESS
     * POP DIVIDEND
               MCW  0+X2, LXCAAA
               SBR  X2, 15995+X2

     * POP DIVISOR
               MCW  0+X2, LYCAAA
               SBR  X2, 15995+X2


               B    *+17
               
               DCW  @00000@                
               DC   @00000000000@        

               ZA   LXCAAA, *-7         * PUT DIVIDEND INTO WORKING BL
               D    LYCAAA, *-19        * DIVIDE
               MZ   *-22, *-21          * KILL THE ZONE BIT
               MZ   *-29, *-34          * KILL THE ZONE BIT
               MCW  *-41, LZCAAA        * PICK UP ANSWER
               SW   *-44                * SO I CAN PICKUP REMAINDER
               MCW  *-46, LADAAA        * GET REMAINDER
               CW   *-55                * CLEAR THE WM
               MZ   LZCAAA-1, LZCAAA    * CLEANUP QUOTIENT BITZONE
               MZ   LADAAA-1, LADAAA    * CLEANUP REMAINDER BITZONE
               
     * PUSH REMAINDER
               SBR  X2, 5+X2
               SW   15996+X2
               MCW  LADAAA, 0+X2
               
     * PUSH QUOTIENT
               SBR  X2, 5+X2
               SW   15996+X2
               MCW  LZCAAA, 0+X2

     LWCAAA    B    000                 * JUMP BACK
               
     LYCAAA    DCW  00000               * DIVISOR
     LXCAAA    DCW  00000               * DIVIDEND
     LZCAAA    DCW  00000               * QUOTIENT
     LADAAA    DCW  00000               * REMAINDER
     LMCAAA    SBR  X1
     * Casts a 5-digit number to a 3-digit address
     * make a copy of the top of the stack
               SW   15998+X2
               LCA  0+X2,3+X2
     * zero out the zone bits of our copy
               MZ   @0@,3+X2
               MZ   @0@,2+X2
               MZ   @0@,1+X2
     * set the low-order digit's zone bits
               C    @04000@,0+X2
               BL   LPCAAA
               C    @08000@,0+X2
               BL   LOCAAA
               C    @12000@,0+X2
               BL   LNCAAA
               S    @12000@,0+X2
               MZ   @A@,3+X2
               B    LPCAAA
     LNCAAA    S    @08000@,0+X2
               MZ   @I@,3+X2
               B    LPCAAA
     LOCAAA    S    @04000@,0+X2
               MZ   @S@,3+X2
     * For some reason the zone bits get set - it still works though.
     LPCAAA    C    @01000@,0+X2
               BL   LSCAAA
               C    @02000@,0+X2
               BL   LRCAAA
               C    @03000@,0+X2
               BL   LQCAAA
               MZ   @A@,1+X2
               B    LSCAAA
     LQCAAA    MZ   @I@,1+X2
               B    LSCAAA
     LRCAAA    MZ   @S@,1+X2
     LSCAAA    LCA  3+X2,15998+X2
               SBR  X2,15998+X2
               B    0+X1
     LJEAAA    SBR  X1
     * Casts a 3-digit address to a 5-digit number
     * Make room on the stack for an int
               MA   @002@,X2
     * make a copy of the top of the stack
               LCA  15998+X2,3+X2
     * Now zero out the top of the stack
               LCA  @00000@,0+X2
     * Now copy back, shifted over 2 digits
               LCA  3+X2,0+X2
     * Now zero out the zone bits on the stack
               MZ   @0@,0+X2
               MZ   @0@,15999+X2
               MZ   @0@,15998+X2
     * check the high-order digit's zone bits
               BWZ  LKEAAA,1+X2,S
               BWZ  LLEAAA,1+X2,K
               BWZ  LMEAAA,1+X2,B
               B    LNEAAA
     LKEAAA    A    @01000@,0+X2
               B    LNEAAA
     LLEAAA    A    @02000@,0+X2
               B    LNEAAA
     LMEAAA    A    @03000@,0+X2
     LNEAAA    BWZ  LOEAAA,3+X2,S
               BWZ  LPEAAA,3+X2,K
               BWZ  LQEAAA,3+X2,B
               B    LREAAA
     LOEAAA    A    @04000@,0+X2
               B    LREAAA
     LPEAAA    A    @08000@,0+X2
               B    LREAAA
     LQEAAA    A    @12000@,0+X2
     LREAAA    B    0+X1
               END  START
