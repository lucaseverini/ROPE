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
               LCA  @69105@,2005
               LCA  @201@,2025
               LCA  @200@,2028
               LCA  @081@,2033
               LCA  EOS,2022
               LCA  @F@,2021
               LCA  @E@,2020
               LCA  @D@,2019
               LCA  @C@,2018
               LCA  @B@,2017
               LCA  @A@,2016
               LCA  @9@,2015
               LCA  @8@,2014
               LCA  @7@,2013
               LCA  @6@,2012
               LCA  @5@,2011
               LCA  @4@,2010
               LCA  @3@,2009
               LCA  @2@,2008
               LCA  @1@,2007
               LCA  @0@,2006
               LCA  EOS,2070
               LCA  EOL,2069
               LCA  @C@,2068
               LCA  @%@,2067
               LCA  @ @,2066
               LCA  @G@,2065
               LCA  @E@,2064
               LCA  @P@,2063
               LCA  @ @,2062
               LCA  @O@,2061
               LCA  @T@,2060
               LCA  @ @,2059
               LCA  @C@,2058
               LCA  @%@,2057
               LCA  @ @,2056
               LCA  @G@,2055
               LCA  @E@,2054
               LCA  @P@,2053
               LCA  @ @,2052
               LCA  @M@,2051
               LCA  @O@,2050
               LCA  @R@,2049
               LCA  @F@,2048
               LCA  @ @,2047
               LCA  @1@,2046
               LCA  @ @,2045
               LCA  @K@,2044
               LCA  @S@,2043
               LCA  @I@,2042
               LCA  @D@,2041
               LCA  @ @,2040
               LCA  @E@,2039
               LCA  @V@,2038
               LCA  @O@,2037
               LCA  @M@,2036
               LCA  EOS,2106
               LCA  EOL,2105
               LCA  @C@,2104
               LCA  @%@,2103
               LCA  @ @,2102
               LCA  @G@,2101
               LCA  @E@,2100
               LCA  @P@,2099
               LCA  @ @,2098
               LCA  @O@,2097
               LCA  @T@,2096
               LCA  @ @,2095
               LCA  @C@,2094
               LCA  @%@,2093
               LCA  @ @,2092
               LCA  @G@,2091
               LCA  @E@,2090
               LCA  @P@,2089
               LCA  @ @,2088
               LCA  @M@,2087
               LCA  @O@,2086
               LCA  @R@,2085
               LCA  @F@,2084
               LCA  @ @,2083
               LCA  @D@,2082
               LCA  @%@,2081
               LCA  @ @,2080
               LCA  @K@,2079
               LCA  @S@,2078
               LCA  @I@,2077
               LCA  @D@,2076
               LCA  @ @,2075
               LCA  @E@,2074
               LCA  @V@,2073
               LCA  @O@,2072
               LCA  @M@,2071
               LCA  EOS,2128
               LCA  EOL,2127
               LCA  @D@,2126
               LCA  @%@,2125
               LCA  @ @,2124
               LCA  @:@,2123
               LCA  @ @,2122
               LCA  @S@,2121
               LCA  @K@,2120
               LCA  @S@,2119
               LCA  @I@,2118
               LCA  @D@,2117
               LCA  @ @,2116
               LCA  @F@,2115
               LCA  @O@,2114
               LCA  @ @,2113
               LCA  @R@,2112
               LCA  @E@,2111
               LCA  @B@,2110
               LCA  @M@,2109
               LCA  @U@,2108
               LCA  @N@,2107
               LCA  EOS,2169
               LCA  EOL,2168
               LCA  @:@,2167
               LCA  @ @,2166
               LCA  @S@,2165
               LCA  @E@,2164
               LCA  @V@,2163
               LCA  @O@,2162
               LCA  @M@,2161
               LCA  @ @,2160
               LCA  @E@,2159
               LCA  @H@,2158
               LCA  @T@,2157
               LCA  @ @,2156
               LCA  @S@,2155
               LCA  @E@,2154
               LCA  @V@,2153
               LCA  @L@,2152
               LCA  @O@,2151
               LCA  @V@,2150
               LCA  @N@,2149
               LCA  @I@,2148
               LCA  @ @,2147
               LCA  @I@,2146
               LCA  @O@,2145
               LCA  @N@,2144
               LCA  @A@,2143
               LCA  @H@,2142
               LCA  @ @,2141
               LCA  @F@,2140
               LCA  @O@,2139
               LCA  @ @,2138
               LCA  @R@,2137
               LCA  @E@,2136
               LCA  @W@,2135
               LCA  @O@,2134
               LCA  @T@,2133
               LCA  @ @,2132
               LCA  @E@,2131
               LCA  @H@,2130
               LCA  @T@,2129
               LCA  EOS,2176
               LCA  EOL,2175
               LCA  @.@,2174
               LCA  @E@,2173
               LCA  @N@,2172
               LCA  @O@,2171
               LCA  @D@,2170
               B    LYBAAA
               H    
     * FunctionDefinition((20))
     LUAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LVAAAA:null:3)
               MA   @003@,X2
     * if(retree.statement.BlockStatement@21ba11bc:retree.statement.BlockStatement@3ee25ef0)
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
               BE   LCCAAA
               B    LDCAAA
     LCCAAA    MCW  @00000@,0+X2
     LDCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LACAAA,5+X2, 
     * BlockStatement(LWAAAA:LVAAAA:0)
     * Assignment(( *(__putchar_pos++) )=c)
     * VariableExpression(c:-3:false)
     * Push(15997+X3:1)
               MA   @001@,X2
               LCA  15997+X3,0+X2
     * PostIncrement(__putchar_pos)
     * Push(@!25@:3)
               MA   @003@,X2
               LCA  @!25@,0+X2
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
               B    LBCAAA
     LACAAA    NOP  
     * BlockStatement(LXAAAA:LVAAAA:0)
     LECAAA    NOP  
     * GreaterThanOrEqualExpression(((int) __putchar_last):((int) __putchar_pos))
     * VariableExpression(__putchar_last:2028:true)
     * Push(2028:3)
               MA   @003@,X2
               LCA  2028,0+X2
               B    LGCAAA
               B    LPCAAA
     * VariableExpression(__putchar_pos:2025:true)
     * Push(2025:3)
               MA   @003@,X2
               LCA  2025,0+X2
               B    LGCAAA
               B    LPCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00001@,0+X2
               BL   LRCAAA
               B    LSCAAA
     LRCAAA    MCW  @00000@,0+X2
     LSCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LFCAAA,5+X2, 
     * BlockStatement(LYAAAA:LXAAAA:0)
     * Assignment(( *(__putchar_last--) )=' ')
     * ConstantExpression(32)
     * Push(@ @:1)
               MA   @001@,X2
               LCA  @ @,0+X2
     * PostDecrement(__putchar_last)
     * Push(@!28@:3)
               MA   @003@,X2
               LCA  @!28@,0+X2
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
               B    LECAAA
     LFCAAA    NOP  
     * Assignment(__putchar_last=__putchar_pos)
     * VariableExpression(__putchar_pos:2025:true)
     * Push(2025:3)
               MA   @003@,X2
               LCA  2025,0+X2
     * Push(@!28@:3)
               MA   @003@,X2
               LCA  @!28@,0+X2
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
     * Push(@!25@:3)
               MA   @003@,X2
               LCA  @!25@,0+X2
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
     LBCAAA    NOP  
     * if(retree.statement.BlockStatement@72bfbd32:null)
     * EqualExpression(__putchar_pos:(333))
     * VariableExpression(__putchar_pos:2025:true)
     * Push(2025:3)
               MA   @003@,X2
               LCA  2025,0+X2
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
               BE   LUCAAA
               B    LVCAAA
     LUCAAA    MCW  @00001@,0+X2
     LVCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LTCAAA,5+X2, 
     * BlockStatement(LZAAAA:LVAAAA:0)
     * Assignment(__putchar_last=__putchar_pos)
     * VariableExpression(__putchar_pos:2025:true)
     * Push(2025:3)
               MA   @003@,X2
               LCA  2025,0+X2
     * Push(@!28@:3)
               MA   @003@,X2
               LCA  @!28@,0+X2
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
     * Push(@!25@:3)
               MA   @003@,X2
               LCA  @!25@,0+X2
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
     LTCAAA    NOP  
     LVAAAA    NOP  
               MA   @I9G@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((50))
     LYBAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LZBAAA:null:8)
               MA   @008@,X2
     * Assignment(n=10)
     * ConstantExpression(10)
     * Push(@00010@:5)
               MA   @005@,X2
               LCA  @00010@,0+X2
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
     * VariableExpression(n:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
     * ArrayNameExpresssion("Number of disks : %d\n":char [22])
     * Push(@J07@:3)
               MA   @003@,X2
               LCA  @J07@,0+X2
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
     * FunctionCallExpr((36))
     * Push(5)
               MA   @005@,X2
     * ArrayNameExpresssion("The Tower of Hanoi involves the moves :\n":char [41])
     * Push(@J29@:3)
               MA   @003@,X2
               LCA  @J29@,0+X2
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
     * FunctionCallExpr((47))
     * Push(5)
               MA   @005@,X2
     * ConstantExpression(66)
     * Push(@B@:1)
               MA   @001@,X2
               LCA  @B@,0+X2
     * ConstantExpression(67)
     * Push(@C@:1)
               MA   @001@,X2
               LCA  @C@,0+X2
     * ConstantExpression(65)
     * Push(@A@:1)
               MA   @001@,X2
               LCA  @A@,0+X2
     * VariableExpression(n:8:false)
     * Push(8+X3:5)
               MA   @005@,X2
               LCA  8+X3,0+X2
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
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     * FunctionCallExpr((36))
     * Push(5)
               MA   @005@,X2
     * ArrayNameExpresssion("Done.\n":char [7])
     * Push(@J70@:3)
               MA   @003@,X2
               LCA  @J70@,0+X2
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
               B    LZBAAA
     LZBAAA    NOP  
               MA   @I9B@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((26))
     LABAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LBBAAA:null:3)
               MA   @003@,X2
     LWCAAA    NOP  
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
               BE   LYCAAA
               B    LZCAAA
     LYCAAA    MCW  @00000@,0+X2
     LZCAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LXCAAA,5+X2, 
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
               B    LWCAAA
     LXCAAA    NOP  
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
               LCA  @!06@,9+X3
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
     * if(retree.statement.BlockStatement@6d176e5c:retree.statement.IfStatement@1d4e91f8)
     * LessThanExpression(value:0)
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LPCAAA
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               B    LPCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00000@,0+X2
               BL   LCDAAA
               B    LDDAAA
     LCDAAA    MCW  @00001@,0+X2
     LDDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LADAAA,5+X2, 
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
               B    LPCAAA
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
               B    LBDAAA
     LADAAA    NOP  
     * if(retree.statement.BlockStatement@11513fd0:null)
     * EqualExpression(value:0)
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LPCAAA
     * ConstantExpression(0)
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               B    LPCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LFDAAA
               B    LGDAAA
     LFDAAA    MCW  @00001@,0+X2
     LGDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LEDAAA,5+X2, 
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
               B    LHDAAA
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
               B    LHDAAA
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
     LEDAAA    NOP  
     LBDAAA    NOP  
     LODAAA    NOP  
     * LessThanOrEqualExpression(exp:retree.expression.DivideExpression@6f84a0b7)
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               B    LPCAAA
     * Divide(value/base)
     * VariableExpression(base:-11:false)
     * Push(15989+X3:5)
               MA   @005@,X2
               LCA  15989+X3,0+X2
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LQDAAA
               MCW  0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               B    LPCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               MCW  @00001@,0+X2
               BH   LWDAAA
               B    LXDAAA
     LWDAAA    MCW  @00000@,0+X2
     LXDAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LPDAAA,5+X2, 
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
               B    LODAAA
     LPDAAA    NOP  
     LYDAAA    NOP  
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LZDAAA,5+X2, 
     * BlockStatement(LTAAAA:LQAAAA:0)
     * Assignment(( *(str++) )=(digits[retree.expression.DivideExpression@6c538793]))
     * SubScriptEpression(digits:retree.expression.DivideExpression@6c538793)
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
               B    LQDAAA
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
               B    LHDAAA
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
     * Assignment(value=retree.expression.ModuloExpression@5fe9fb74)
     * ModuloExpression(value:exp)
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
     * VariableExpression(value:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LQDAAA
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
     * Assignment(exp=retree.expression.DivideExpression@7a7baddd)
     * Divide(exp/base)
     * VariableExpression(base:-11:false)
     * Push(15989+X3:5)
               MA   @005@,X2
               LCA  15989+X3,0+X2
     * VariableExpression(exp:14:false)
     * Push(14+X3:5)
               MA   @005@,X2
               LCA  14+X3,0+X2
               B    LQDAAA
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
               B    LYDAAA
     LZDAAA    NOP  
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
     * FunctionDefinition((7))
     LHAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LIAAAA:null:3)
               MA   @003@,X2
     LAEAAA    NOP  
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
               BE   LCEAAA
               B    LDEAAA
     LCEAAA    MCW  @00000@,0+X2
     LDEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LBEAAA,5+X2, 
               B    LAEAAA
     LBEAAA    NOP  
     LIAAAA    NOP  
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
     LEEAAA    NOP  
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
               BE   LGEAAA
               B    LHEAAA
     LGEAAA    MCW  @00000@,0+X2
     LHEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LFEAAA,5+X2, 
     * BlockStatement(LMBAAA:LLBAAA:0)
     * if(retree.statement.ExpressionStatement@1bdf2b92:retree.statement.BlockStatement@58a58c89)
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
               BE   LKEAAA
               B    LLEAAA
     LKEAAA    MCW  @00000@,0+X2
     LLEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LIEAAA,5+X2, 
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
               B    LJEAAA
     LIEAAA    NOP  
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
     * if(retree.statement.BlockStatement@5cada3d6:retree.statement.IfStatement@bdf6623)
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
               BE   LOEAAA
               B    LPEAAA
     LOEAAA    MCW  @00001@,0+X2
     LPEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LMEAAA,5+X2, 
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
               B    LNEAAA
     LMEAAA    NOP  
     * if(retree.statement.BlockStatement@77aa89eb:retree.statement.IfStatement@5d44e0ad)
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
               BE   LSEAAA
               B    LTEAAA
     LSEAAA    MCW  @00001@,0+X2
     LTEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LQEAAA,5+X2, 
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
               B    LREAAA
     LQEAAA    NOP  
     * if(retree.statement.BlockStatement@54faadb1:retree.statement.IfStatement@15a16b0d)
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
               BE   LWEAAA
               B    LXEAAA
     LWEAAA    MCW  @00001@,0+X2
     LXEAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LUEAAA,5+X2, 
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
               B    LVEAAA
     LUEAAA    NOP  
     * if(retree.statement.BlockStatement@187b2d93:retree.statement.ReturnStatement@3eed1a73)
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
               BE   LAFAAA
               B    LBFAAA
     LAFAAA    MCW  @00001@,0+X2
     LBFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LYEAAA,5+X2, 
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
               B    LZEAAA
     LYEAAA    NOP  
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LNBAAA
     LZEAAA    NOP  
     LVEAAA    NOP  
     LREAAA    NOP  
     LNEAAA    NOP  
     LNBAAA    NOP  
               BCE  LMBAAA,RF,R
     LJEAAA    NOP  
     LMBAAA    NOP  
               BCE  LLBAAA,RF,R
               B    LEEAAA
     LFEAAA    NOP  
     LLBAAA    NOP  
               MA   @I9C@,X2
               MCW  @ @,RF
               LCA  3+X3,X1
               B    0+X1
     * FunctionDefinition((47))
     LVBAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LWBAAA:null:3)
               MA   @003@,X2
     * if(retree.statement.BlockStatement@5c81cf46:null)
     * EqualExpression(n:1)
     * VariableExpression(n:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
               B    LPCAAA
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               B    LPCAAA
               C    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
     * Pop(5)
               MA   @I9E@,X2
     * Push(@00000@:5)
               MA   @005@,X2
               LCA  @00000@,0+X2
               BE   LDFAAA
               B    LEFAAA
     LDFAAA    MCW  @00001@,0+X2
     LEFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LCFAAA,5+X2, 
     * BlockStatement(LXBAAA:LWBAAA:0)
     * FunctionCallExpr((36))
     * Push(5)
               MA   @005@,X2
     * VariableExpression(topeg:-9:false)
     * Push(15991+X3:1)
               MA   @001@,X2
               LCA  15991+X3,0+X2
     * VariableExpression(frompeg:-8:false)
     * Push(15992+X3:1)
               MA   @001@,X2
               LCA  15992+X3,0+X2
     * ArrayNameExpresssion("Move disk 1 from peg %c to peg %c\n":char [35])
     * Push(@!36@:3)
               MA   @003@,X2
               LCA  @!36@,0+X2
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
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     * set the return flag, so we know do deallocate our stack
               MCW  @R@,RF
     * and branch
               B    LXBAAA
     LXBAAA    NOP  
               BCE  LWBAAA,RF,R
     LCFAAA    NOP  
     * FunctionCallExpr((47))
     * Push(5)
               MA   @005@,X2
     * VariableExpression(topeg:-9:false)
     * Push(15991+X3:1)
               MA   @001@,X2
               LCA  15991+X3,0+X2
     * VariableExpression(auxpeg:-10:false)
     * Push(15990+X3:1)
               MA   @001@,X2
               LCA  15990+X3,0+X2
     * VariableExpression(frompeg:-8:false)
     * Push(15992+X3:1)
               MA   @001@,X2
               LCA  15992+X3,0+X2
     * Subtraction(n-1)
     * VariableExpression(n:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               S    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
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
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     * FunctionCallExpr((36))
     * Push(5)
               MA   @005@,X2
     * VariableExpression(topeg:-9:false)
     * Push(15991+X3:1)
               MA   @001@,X2
               LCA  15991+X3,0+X2
     * VariableExpression(frompeg:-8:false)
     * Push(15992+X3:1)
               MA   @001@,X2
               LCA  15992+X3,0+X2
     * VariableExpression(n:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
     * ArrayNameExpresssion("Move disk %d from peg %c to peg %c\n":char [36])
     * Push(@!71@:3)
               MA   @003@,X2
               LCA  @!71@,0+X2
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
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     * FunctionCallExpr((47))
     * Push(5)
               MA   @005@,X2
     * VariableExpression(frompeg:-8:false)
     * Push(15992+X3:1)
               MA   @001@,X2
               LCA  15992+X3,0+X2
     * VariableExpression(topeg:-9:false)
     * Push(15991+X3:1)
               MA   @001@,X2
               LCA  15991+X3,0+X2
     * VariableExpression(auxpeg:-10:false)
     * Push(15990+X3:1)
               MA   @001@,X2
               LCA  15990+X3,0+X2
     * Subtraction(n-1)
     * VariableExpression(n:-3:false)
     * Push(15997+X3:5)
               MA   @005@,X2
               LCA  15997+X3,0+X2
     * ConstantExpression(1)
     * Push(@00001@:5)
               MA   @005@,X2
               LCA  @00001@,0+X2
               S    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
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
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(1)
               MA   @I9I@,X2
     * Pop(5)
               MA   @I9E@,X2
     LWBAAA    NOP  
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
     LFFAAA    NOP  
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
               B    LHDAAA
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
               BE   LHFAAA
               B    LIFAAA
     LHFAAA    MCW  @00000@,0+X2
     LIFAAA    NOP  
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               BCE  LGFAAA,5+X2, 
               B    LFFAAA
     LGFAAA    NOP  
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
     * FunctionDefinition((1))
     LBAAAA    SBR  3+X3
               SW   1+X3
               CW   2+X3
               CW   3+X3
     * BlockStatement(LCAAAA:null:3)
               MA   @003@,X2
     * Assignment(seed=retree.expression.ModuloExpression@2fd90a6e)
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
     * VariableExpression(seed:2005:true)
     * Push(2005:5)
               MA   @005@,X2
               LCA  2005,0+X2
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
               B    LQDAAA
     * Pop(5)
               MA   @I9E@,X2
     * Push(@!05@:3)
               MA   @003@,X2
               LCA  @!05@,0+X2
     * Pop(X1:3)
               LCA  0+X2,X1
               MA   @I9G@,X2
     * Pop(0+X1:5)
               LCA  0+X2,0+X1
               MA   @I9E@,X2
     * VariableExpression(seed:2005:true)
     * Push(2005:5)
               MA   @005@,X2
               LCA  2005,0+X2
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
     LPCAAA    SBR  X1
     * Normalizes the zone bits of a number, leaving either A=0B=0
     * for a positive or A=0B=1 for a negative
     * Do nothing on either no zone bits or only a b zone bit
               BWZ  LQCAAA,0+X2,2
               BWZ  LQCAAA,0+X2,K
     * else clear the zone bits, as it is positive
               MZ   @ @,0+X2
     LQCAAA    B    0+X1
    ****************************************************************  
    ** DIVISION SNIPPET                                           **
    ****************************************************************  
     
     LQDAAA    SBR  LRDAAA+3           * SETUP RETURN ADDRESS
     * POP DIVIDEND
               MCW  0+X2, LSDAAA
               SBR  X2, 15995+X2

     * POP DIVISOR
               MCW  0+X2, LTDAAA
               SBR  X2, 15995+X2


               B    *+17
               
               DCW  @00000@                
               DC   @00000000000@        

               ZA   LSDAAA, *-7         * PUT DIVIDEND INTO WORKING BL
               D    LTDAAA, *-19        * DIVIDE
               MZ   *-22, *-21          * KILL THE ZONE BIT
               MZ   *-29, *-34          * KILL THE ZONE BIT
               MCW  *-41, LUDAAA        * PICK UP ANSWER
               SW   *-44                * SO I CAN PICKUP REMAINDER
               MCW  *-46, LVDAAA        * GET REMAINDER
               CW   *-55                * CLEAR THE WM
               MZ   LUDAAA-1, LUDAAA    * CLEANUP QUOTIENT BITZONE
               MZ   LVDAAA-1, LVDAAA    * CLEANUP REMAINDER BITZONE
               
     * PUSH REMAINDER
               SBR  X2, 5+X2
               SW   15996+X2
               MCW  LVDAAA, 0+X2
               
     * PUSH QUOTIENT
               SBR  X2, 5+X2
               SW   15996+X2
               MCW  LUDAAA, 0+X2

     LRDAAA    B    000                 * JUMP BACK
               
     LTDAAA    DCW  00000               * DIVISOR
     LSDAAA    DCW  00000               * DIVIDEND
     LUDAAA    DCW  00000               * QUOTIENT
     LVDAAA    DCW  00000               * REMAINDER
     LHDAAA    SBR  X1
     * Casts a 5-digit number to a 3-digit address
     * make a copy of the top of the stack
               SW   15998+X2
               LCA  0+X2,3+X2
               CW   15998+X2
     * zero out the zone bits of our copy
               MZ   @0@,3+X2
               MZ   @0@,2+X2
               MZ   @0@,1+X2
     * set the low-order digit's zone bits
               C    @04000@,0+X2
               BL   LKDAAA
               C    @08000@,0+X2
               BL   LJDAAA
               C    @12000@,0+X2
               BL   LIDAAA
               S    @12000@,0+X2
               MZ   @A@,3+X2
               B    LKDAAA
     LIDAAA    S    @08000@,0+X2
               MZ   @I@,3+X2
               B    LKDAAA
     LJDAAA    S    @04000@,0+X2
               MZ   @S@,3+X2
     * For some reason the zone bits get set - it still works though.
     LKDAAA    C    @01000@,0+X2
               BL   LNDAAA
               C    @02000@,0+X2
               BL   LMDAAA
               C    @03000@,0+X2
               BL   LLDAAA
               MZ   @A@,1+X2
               B    LNDAAA
     LLDAAA    MZ   @I@,1+X2
               B    LNDAAA
     LMDAAA    MZ   @S@,1+X2
     LNDAAA    LCA  3+X2,15998+X2
               SBR  X2,15998+X2
               B    0+X1
     LGCAAA    SBR  X1
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
               BWZ  LHCAAA,1+X2,S
               BWZ  LICAAA,1+X2,K
               BWZ  LJCAAA,1+X2,B
               B    LKCAAA
     LHCAAA    A    @01000@,0+X2
               B    LKCAAA
     LICAAA    A    @02000@,0+X2
               B    LKCAAA
     LJCAAA    A    @03000@,0+X2
     LKCAAA    BWZ  LLCAAA,3+X2,S
               BWZ  LMCAAA,3+X2,K
               BWZ  LNCAAA,3+X2,B
               B    LOCAAA
     LLCAAA    A    @04000@,0+X2
               B    LOCAAA
     LMCAAA    A    @08000@,0+X2
               B    LOCAAA
     LNCAAA    A    @12000@,0+X2
     LOCAAA    B    0+X1
               END  START
