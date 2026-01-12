# Author: Hai Cao -- cxhai.sdh221@hcmut.edu.vn
# Copyright 2024

sim:
	@xrun -access +rwc -f ./flist

.PHONY: gui
gui:
	@xrun -gui -access +rwc -f ./flist -input restore.tcl


.PHONY: clean
clean:
	@echo "-> CLEAN"
	@rm -rf x* *.vcd
