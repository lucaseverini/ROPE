# Fortran compiler
FC = g95

# Fortran compiler options
FOPTS = -O

# Options for the compiler doing the linking
LDOPTS = -g --staticlink

# Extension for object files
O = o

# C compiler
CC = cc

# C compiler options
COPTS = -g

TAROPTS=
ZIPOPTS=-q

OBJS = autocoder.$O bcd_to_ascii_m.$O error_m.$O flags.$O input_m.$O \
       io_units.$O lexer.$O literals_m.$O machine.$O \
       macro_pass_m.$O op_codes_m.$O operand_m.$O parser.$O \
       pass_1_m.$O pass_2_m.$O pass_3_m.$O symtab_m.$O zone_m.$O

SRCS = autocoder.f90 bcd_to_ascii_m.f90 error_m.f90 flags.f90 input_m.f90 \
       io_units.f90 lexer.f90 literals_m.f90 machine.f90 \
       macro_pass_m.f90 op_codes_m.f90 operand_m.f90 parser.f90 \
       pass_1_m.f90 pass_2_m.f90 pass_3_m.f90 symtab_m.f90 zone_m.f90

.SUFFIXES:
.SUFFIXES: .f90 .$O

.f90.$O:
	$(FC) -c $(FOPTS) $<

all: autocoder

autocoder.$O: autocoder.f90 error_m.$O flags.$O input_m.$O io_units.$O \
        literals_m.$O machine.$O macro_pass_m.$O pass_1_m.$O pass_2_m.$O \
        pass_3_m.$O symtab_m.$O
error_m.$O: error_m.f90 input_m.$O io_units.$O
input_m.$O: input_m.f90
lexer.$O: lexer.f90 bcd_to_ascii_m.$O error_m.$O flags.$O
literals_m.$O: literals_m.f90 error_m.$O flags.$O io_units.$O lexer.$O \
        operand_m.$O symtab_m.$O
macro_pass_m.$O: macro_pass_m.f90 error_m.$O input_m.$O io_units.$O \
        lexer.$O machine.$O operand_m.$O op_codes_m.$O parser.$O
operand_m.$O: operand_m.f90
op_codes_m.$O: op_codes_m.f90 bcd_to_ascii_m.$O
parser.$O: parser.f90 error_m.$O flags.$O lexer.$O literals_m.$O operand_m.$O \
        symtab_m.$O
pass_1_m.$O: pass_1_m.f90 bcd_to_ascii_m.$O error_m.$O input_m.$O io_units.$O \
        lexer.$O literals_m.$O machine.$O op_codes_m.$O operand_m.$O parser.$O \
        symtab_m.$O
pass_2_m.$O: pass_2_m.f90 error_m.$O io_units.$O literals_m.$O operand_m.$O \
        symtab_m.$O
pass_3_m.$O: pass_3_m.f90 bcd_to_ascii_m.$O error_m.$O io_units.$O literals_m.$O \
        op_codes_m.$O operand_m.$O symtab_m.$O zone_m.$O
symtab_m.$O: symtab_m.f90
zone_m.$O: zone_m.f90 bcd_to_ascii_m.$O

autocoder: $(OBJS)
	$(FC) $(LDOPTS) -o autocoder $(OBJS)

test_macro_pass.$O: input_m.$O macro_pass_m.$O

TOBJ = test_macro_pass.$O bcd_to_ascii_m.$O error_m.$O flags.$O \
        input_m.$O io_units.$O lexer.$O literals_m.$O macro_pass_m.$O \
        machine.$O operand_m.$O op_codes_m.$O parser.$O symtab_m.$O

test_macro_pass: $(TOBJ)
	$(FC) $(LDOPTS) -o test_macro_pass $(TOBJ)

#to_simh: to_simh.$O bcd_to_ascii_m.$O machine.$O
#	$(FC) $(LDOPTS) -o to_simh to_simh.$O bcd_to_ascii_m.$O machine.$O

ascii_to_simh: ascii_to_simh.c
	$(CC) $(COPTS) -o ascii_to_simh ascii_to_simh.c

to_simh: to_simh.c
	$(CC) $(COPTS) -o to_simh to_simh.c

to_e11: to_e11.$O bcd_to_ascii_m.$O machine.$O
	$(FC) $(LDOPTS) -o to_e11 \
           to_e11.$O bcd_to_ascii_m.$O machine.$O

clean:
	rm -f *.$O *.mod autocoder autocoder.tar

tapedump: tapedump.f90
	$(FC) -o tapedump $(FOPTS) tapedump.f90

tar:
	tar czf autocoder_f90.tgz $(TAROPTS) 00README Makefile $(SRCS) \
          tapedump.f90 to_simh.c to_simh.f90 to_e11.f90

zip:
	zip $(ZIPOPTS) autocoder_f90.zip 00README Makefile $(SRCS) \
          tapedump.f90 to_simh.c to_simh.f90 to_e11.f90
