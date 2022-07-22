TOPNAME=mux21
BIN=./bin
EXE=$(addprefix V,$(TOPNAME))
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
INC_PATH = $(abspath ./obj_dir)
INCFLAGS = $(addprefix -I, $(INC_PATH))
V=verilator
F=-Wall --cc --exe --build --trace $(INCFLAGS)

default : $(VSRCS) $(CSRCS)
	$(V) $(F) $^
	$(shell if [ ! -d $(BIN) ];then mkdir $(BIN);fi)
	cp ./obj_dir/$(EXE) bin/$(EXE) 

clean :
	rm -rf obj_dir bin
