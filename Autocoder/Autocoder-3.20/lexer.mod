G95 module created on Fri Apr 15 21:33:46 2011 from lexer.f90
If you edit this, you'll get what you deserve.
module-version 6
(() () () () () () () () () () () () () () () () () () () () ())

()

()

()

(('bcd_to_ascii_m' (VARIABLE (CHARACTER 1 ()) 0 2 ((ARRAY (ELEMENT 1 (
CONSTANT (INTEGER 4) 0 '48') 1)))) 'bcd_to_ascii_m' (VARIABLE (
CHARACTER 1 ()) 0 3 ())) ('bcd_to_ascii_m' (VARIABLE (CHARACTER 1 ()) 0
2 ((ARRAY (ELEMENT 1 (CONSTANT (INTEGER 4) 0 '11') 1)))) 'bcd_to_ascii_m'
(VARIABLE (CHARACTER 1 ()) 0 4 ())) ('bcd_to_ascii_m' (VARIABLE (
CHARACTER 1 ()) 0 2 ((ARRAY (ELEMENT 1 (CONSTANT (INTEGER 4) 0 '28') 1))))
'bcd_to_ascii_m' (VARIABLE (CHARACTER 1 ()) 0 5 ())) ('bcd_to_ascii_m' (
VARIABLE (CHARACTER 1 ()) 0 2 ((ARRAY (ELEMENT 1 (CONSTANT (INTEGER 4) 0
'12') 1)))) 'bcd_to_ascii_m' (VARIABLE (CHARACTER 1 ()) 0 6 ())) ('flags'
(VARIABLE (CHARACTER 1 ()) 0 7 ((SUBSTRING (CONSTANT (INTEGER 4) 0 '5')
(CONSTANT (INTEGER 4) 0 '5') ()))) 'flags' (VARIABLE (CHARACTER 1 ()) 0
8 ())) ('flags' (VARIABLE (CHARACTER 1 ()) 0 7 ((SUBSTRING (CONSTANT (
INTEGER 4) 0 '4') (CONSTANT (INTEGER 4) 0 '4') ()))) 'flags' (VARIABLE (
CHARACTER 1 ()) 0 9 ())) ('flags' (VARIABLE (CHARACTER 1 ()) 0 7 ((
SUBSTRING (CONSTANT (INTEGER 4) 0 '3') (CONSTANT (INTEGER 4) 0 '3') ())))
'flags' (VARIABLE (CHARACTER 1 ()) 0 10 ())) ('flags' (VARIABLE (
CHARACTER 1 ()) 0 7 ((SUBSTRING (CONSTANT (INTEGER 4) 0 '2') (CONSTANT (
INTEGER 4) 0 '2') ()))) 'flags' (VARIABLE (CHARACTER 1 ()) 0 11 ())) (
'flags' (VARIABLE (CHARACTER 1 ()) 0 7 ((SUBSTRING (CONSTANT (INTEGER 4)
0 '1') (CONSTANT (INTEGER 4) 0 '1') ()))) 'flags' (VARIABLE (CHARACTER 1
()) 0 12 ())))

(13 'lex' 'lexer' 1 ((PROCEDURE UNKNOWN MODULE-PROC DECL NONE NONE
SUBROUTINE) (PROCEDURE 0) 0 0 (14 NONE 15 NONE 16 NONE 17 NONE 18 NONE)
() '' () ())
19 't_at' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '1') () '' () ())
20 't_chars' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '2') () '' () ())
21 't_comma' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '3') () '' () ())
22 't_device' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '4') () '' () ())
23 't_done' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '5') () '' () ())
24 't_hash' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '6') () '' () ())
25 't_minus' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '7') () '' () ())
26 't_name' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '8') () '' () ())
27 't_number' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '9') () '' () ())
28 't_other' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '10') () '' () ())
29 't_plus' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '11') () '' () ())
30 't_star' 'lexer' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '12') () '' () ())
31 'tokennames' 'lexer' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DIMENSION) (CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '6'))) 0 0 () (1
EXPLICIT (CONSTANT (INTEGER 4) 0 '1') (CONSTANT (INTEGER 4) 0 '12')) ''
() ())
18 'nosign' '' 32 ((VARIABLE IN UNKNOWN UNKNOWN NONE NONE OPTIONAL DUMMY)
(LOGICAL 4) 0 0 () () '' () ())
17 'token' '' 32 ((VARIABLE OUT UNKNOWN UNKNOWN NONE NONE DUMMY) (
INTEGER 4) 0 0 () () '' () ())
16 'end' '' 32 ((VARIABLE OUT UNKNOWN UNKNOWN NONE NONE DUMMY) (INTEGER
4) 0 0 () () '' () ())
15 'start' '' 32 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE DUMMY) (
INTEGER 4) 0 0 () () '' () ())
14 'line' '' 32 ((VARIABLE IN UNKNOWN UNKNOWN NONE NONE DUMMY) (
CHARACTER 1 (())) 0 0 () () '' () ())
12 'at' 'flags' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
11 'dev' 'flags' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
10 'gm' 'flags' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
9 'hash' 'flags' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
8 'plus' 'flags' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
7 'encodings' 'flags' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '5'))) 0 0 () () '' () ())
6 'at' 'bcd_to_ascii_m' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
5 'dev' 'bcd_to_ascii_m' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
4 'hash' 'bcd_to_ascii_m' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
3 'plus' 'bcd_to_ascii_m' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 () () '' () ())
2 'bcd_to_ascii' 'bcd_to_ascii_m' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN
NONE NONE DIMENSION) (CHARACTER 1 ((CONSTANT (INTEGER 4) 0 '1'))) 0 0 ()
(1 EXPLICIT (CONSTANT (INTEGER 4) 0 '0') (CONSTANT (INTEGER 4) 0 '66')) ''
() ())
)

('lex' 0 13 't_at' 0 19 't_chars' 0 20 't_comma' 0 21 't_device' 0 22
't_done' 0 23 't_hash' 0 24 't_minus' 0 25 't_name' 0 26 't_number' 0 27
't_other' 0 28 't_plus' 0 29 't_star' 0 30 'tokennames' 0 31)
