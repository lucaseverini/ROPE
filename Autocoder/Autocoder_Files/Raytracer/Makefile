
.PHONY: all clean assemble run show thumb

TOOLS=$(HOME)/others/ROPE/dist/tools/mac
AUTOCODER=$(TOOLS)/autocoder
IBM1401=$(TOOLS)/ibm1401
RUN_SIM=run.sim
PROGRAM=ray
USB=/Volumes/LAWRENCEUSB

all: ray
	./ray

ray: ray.c Makefile
	cc -Wall ray.c -o ray -lm

assemble: $(PROGRAM).aut Makefile
	$(AUTOCODER) -e S -o $(PROGRAM).cd -l $(PROGRAM).lst $(PROGRAM).aut
	$(AUTOCODER) -e A -t $(PROGRAM).mt1 $(PROGRAM).aut

run: assemble
	echo "attach cdr $(PROGRAM).cd" > $(RUN_SIM)
	echo "attach lpt $(PROGRAM).out" >> $(RUN_SIM)
	echo "boot cdr" >> $(RUN_SIM)
	$(IBM1401) < $(RUN_SIM)
	rm -f $(RUN_SIM)

show: run
	cat $(PROGRAM).out

thumb: assemble
	@if [ ! -d $(USB) ]; then echo --------------------- Insert USB drive ---------------------; exit 1; fi
	cp $(PROGRAM).mt1 $(PROGRAM).cd $(USB)
	diskutil eject $(USB)

clean:
	rm -f $(PROGRAM) *.out *.lst *.cd *.cdr *.brk *.mt1
