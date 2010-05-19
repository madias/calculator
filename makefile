SHELL := bash

MPWD := $(shell pwd)
QUARTUS := $(MPWD)/quartus/


QUMACRO := unset LS_COLORS; cd $(QUARTUS); export LD_LIBRARY_PATH=/opt/quartus/quartus/linux64; export LM_LICENSE_FILE=26888@quartus; 


all: $(QUARTUS) 
	@clear
	@echo "	Quartus start Compilation"
	@$(QUMACRO) quartus_sh --flow compile calculator_top

#olderror: $(QUARTUS)
#	@clear
#	@echo " MAP ERRORS: "
#	@grep -i 'error:' 'error (' $(QUARTUS)*map*.rpt
	
#oldwarn: $(QUARTUS)
#	@clear
#	@echo " MAP WARNINGS: "
#	@grep -i "warning:' 'warning(" ${QUARTUS}*rpt

warn: $(QUARTUS)
	@clear
	@echo " WARNINGs: "
	@grep -ih "warning: " ${QUARTUS}*rpt
	@grep -ih "warning (" ${QUARTUS}*rpt

error: $(QUARTUS)
	@clear
	@echo " ERRORs: "
	@grep -ih "error: " ${QUARTUS}*rpt
	@grep -ih "error (" ${QUARTUS}*rpt

prj: $(QUARTUS)
	@clear
	@echo "	make projekt"
	@quartus_sh -t $(QUARTUS)/calculator_top.tcl
	@mv calculator_top.qpf $(QUARTUS)
	@mv calculator_top.qsf $(QUARTUS)
	@mv -f db/* $(QUARTUS)/db/
	@rmdir db

qflow: $(QUARTUS)
	@clear
	@echo " Quartus QFLOW"
	@$(QUMACRO) quartus_sh -g	

.PHONY: clean
clean:
	@rm -rf $(QUARTUS)*

