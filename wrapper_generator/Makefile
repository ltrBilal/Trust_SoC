GHDL=ghdl

all:
	@$(GHDL) -a rules_array.vhd wrapper.vhd 
	@$(GHDL) -a interface_AXI.vhd
	@$(GHDL) -a Interface_AXI_tb.vhd
	@$(GHDL) -e Interface_AXI_tb
	@$(GHDL) -r Interface_AXI_tb --vcd=Interface_AXI.vcd --stop-time=1000us --wave=Interface_AXI.ghw

	gtkwave Interface_AXI.vcd waveform.gtkw