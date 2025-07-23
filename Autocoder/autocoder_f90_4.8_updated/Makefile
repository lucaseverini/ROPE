# --------
# Instruction to compile Autocoder on MacOS 10.6 and later
# use g95 fortran: www.g95.org
# compile without link: g95 -c -static INPUT_FILE(S)
# compile and link to produce an executable: g95 -Xlinker -macosx_version_min -Xlinker 10.6 -o OUTPUT_FILE INPUT_FILE(S)
# source file machine_XXX.f90 to be used: machine_non_lf95.f90 
# --------

# Fortran compiler
FC = lf95

# Suffix for machine
M = $(FC)

# Fortran compiler options
FOPTS = -g --chk --info

# C compiler
CC = gcc

# C compiler options
COPTS = -g

# Options for the compiler doing the linking
LDOPTS = -g --staticlink

# Extension for object files
O = o

# Extension for executable files
E =

# C compiler
CC = cc

# C compiler options
COPTS = -g

FAFTER = | hl
TAROPTS=
ZIPOPTS=-q

# For putting a version number on tar and zip files
VER=

OBJS = autocoder.$O bcd_to_ascii_m.$O Bootstrap_m.$O error_m.$O flags.$O \
       input_m.$O io_units.$O lexer.$O literals_m.$O machine_$M.$O \
       macro_pass_m.$O op_codes_m.$O Object_m.$O operand_m.$O parser.$O \
       pass_1_m.$O pass_2_m.$O pass_3_m.$O symtab_m.$O \
       zone_m.$O

# For creating tar and zip files
SRCS = autocoder.f90 bcd_to_ascii_m.f90 Bootstrap_m.f90 error_m.f90 flags.f90 \
       input_m.f90 io_units.f90 lexer.f90 literals_m.f90 machine*.f90 \
       macro_pass_m.f90 op_codes_m.f90 Object_m.f90 operand_m.f90 parser.f90 \
       pass_1_m.f90 pass_2_m.f90 pass_3_m.f90 symtab_m.f90 \
       zone_m.f90 \
       Link.f90 \
       ansi.c to_e11.f90 to_simh.f90 to_simh_direct.f90 to_simh.c tapedump.f90 \
       tpdump.c hl.c \
       MA OVLAY TOVLY \
       00README Makefile

.SUFFIXES:
.SUFFIXES: .f90 .$O

.f90.$O:
	$(FC) -c $(FOPTS) $< 2>&1 $(FAFTER)

.c.$O.:
	$(CC) -c $(COPTS) $< 2>&1

all: hl$E autocoder$E link$E tpdump$E to_e11$E to_simh$E

hl$E: hl.c
	$(CC) -o hl$E $(COPTS) hl.c

autocoder.$O: autocoder.f90 bcd_to_ascii_m.$O Bootstrap_m.$O error_m.$O \
        flags.$O input_m.$O io_units.$O literals_m.$O machine_$M.$O     \
        macro_pass_m.$O Object_m.$O op_codes_m.$O pass_1_m.$O           \
        pass_2_m.$O pass_3_m.$O symtab_m.$O zone_m.$O
Bootstrap_m.$O: Bootstrap_m.f90
error_m.$O: error_m.f90 input_m.$O io_units.$O
input_m.$O: input_m.f90
lexer.$O: lexer.f90 bcd_to_ascii_m.$O error_m.$O flags.$O
literals_m.$O: literals_m.f90 error_m.$O flags.$O io_units.$O \
        operand_m.$O symtab_m.$O
macro_pass_m.$O: macro_pass_m.f90 bcd_to_ascii_m.$O error_m.$O flags.$O \
        input_m.$O io_units.$O machine_$M.$O operand_m.$O \
        op_codes_m.$O parser.$O
Object_m.$O: Object_m.f90 bcd_to_ascii_m.$O io_units.$O symtab_m.$O zone_m.$O
operand_m.$O: operand_m.f90
op_codes_m.$O: op_codes_m.f90 bcd_to_ascii_m.$O
parser.$O: parser.f90 bcd_to_ascii_m.$O error_m.$O flags.$O lexer.$O \
        literals_m.$O operand_m.$O symtab_m.$O
pass_1_m.$O: pass_1_m.f90 bcd_to_ascii_m.$O error_m.$O input_m.$O io_units.$O \
        lexer.$O literals_m.$O machine_$M.$O operand_m.$O op_codes_m.$O parser.$O \
        symtab_m.$O
pass_2_m.$O: pass_2_m.f90 error_m.$O flags.$O io_units.$O literals_m.$O \
        operand_m.$O symtab_m.$O
pass_3_m.$O: pass_3_m.f90 bcd_to_ascii_m.$O Bootstrap_m.$O error_m.$O \
        io_units.$O literals_m.$O Object_m.$O operand_m.$O op_codes_m.$O \
        symtab_m.$O zone_m.$O
symtab_m.$O: symtab_m.f90 bcd_to_ascii_m.$O
zone_m.$O: zone_m.f90 bcd_to_ascii_m.$O

autocoder$E: $(OBJS)
	$(FC) $(LDOPTS) -o autocoder$E $(OBJS)

Link.$O: Link.f90 Bootstrap_m.$O io_units.$O Object_m.$O zone_m.$O

link$E: Link.$O bcd_to_ascii_m.$O Bootstrap_m.$O io_units.$O machine_$M.$O \
        Object_m.$O symtab_m.$O zone_m.$O
	$(FC) $(LDOPTS) -o link$E Link.$O bcd_to_ascii_m.$O Bootstrap_m.$O \
              io_units.$O machine_$M.$O Object_m.$O symtab_m.$O zone_m.$O

to_e11$E: to_e11.f90 bcd_to_ascii_m.$O machine_$M.$O
	$(FC) -o to_e11 $(FOPTS) to_e11.f90 bcd_to_ascii_m.$O machine_$M.$O

tpdump$E: tpdump.c
	$(CC) -o tpdump$E $(COPTS) tpdump.c

test_macro_pass.$O: input_m.$O macro_pass_m.$O

TOBJ = test_macro_pass.$O bcd_to_ascii_m.$O error_m.$O flags.$O \
        input_m.$O io_units.$O lexer.$O literals_m.$O macro_pass_m.$O \
        machine_$M.$O operand_m.$O op_codes_m.$O parser.$O symtab_m.$O

test_macro_pass$E: $(TOBJ)
	$(FC) $(LDOPTS) -o test_macro_pass$E $(TOBJ)

to_simh_f.$O: to_simh.f90 bcd_to_ascii_m.$O machine_$M.$O
	$(FC) $(FOPTS) -c -o to_simh_f.$O to_simh.f90

to_simh_f$E: to_simh_f.$O bcd_to_ascii_m.$O machine_$M.$O
	$(FC) $(LDOPTS) -o to_simh_f to_simh.$O bcd_to_ascii_m.$O machine_$M.$O

to_simh_d.$O: to_simh_direct.f90 bcd_to_ascii_m.$O machine_$M.$O
	$(FC) $(FOPTS) -c -o to_simh_d.$O to_simh_direct.f90

to_simh_d$E: to_simh_d.$O bcd_to_ascii_m.$O machine_$M.$O
	$(FC) $(LDOPTS) -o to_simh_d to_simh_d.$O bcd_to_ascii_m.$O machine_$M.$O

ascii_to_simh$E: ascii_to_simh.c
	$(CC) $(COPTS) -o ascii_to_simh$E ascii_to_simh.c

to_simh$E: to_simh.c
	$(CC) $(COPTS) -o to_simh$E to_simh.c

tapedump.$O: tapedump.f90 bcd_to_ascii_m.$O

tapedump$E: tapedump.$O bcd_to_ascii_m.$O
	$(FC) -o tapedump$E tapedump.$O bcd_to_ascii_m.$O

Autocoder_doc.pdf: Autocoder_doc.tex
	pdflatex Autocoder_doc
	pdflatex Autocoder_doc

Autocoder_doc.dvi: Autocoder_doc.tex
	latex Autocoder_doc
	latex Autocoder_doc

clean:
	rm -f *.$O *.mod autocoder link autocoder_f90.tgz autocoder_f90.zip \
           *.aux *.dvi *.log, Autocoder_doc.out Autocoder_doc.*pdf

tar: Autocoder_doc.pdf
	tar czfh autocoder_f90$(VER).tgz $(TAROPTS) $(SRCS) \
            Autocoder_doc.tex Autocoder_doc.pdf Reloc_Notes.txt

zip: Autocoder_doc.pdf
	zip $(ZIPOPTS) autocoder_f90$(VER).zip $(SRCS) \
            Autocoder_doc.tex Autocoder_doc.pdf Reloc_Notes.txt
