help:
	@echo "comp  : Compile code."
	@echo "sim   : simulate code."
	@echo "wave  : Show waveform."
	@echo "clean : Clean files."

comp:
	iverilog -f bench.list -f design.list -s tb_top -o tb_top.exe

sim:
	vvp tb_top.exe

wave:
	gtkwave wave.vcd &

clean:
	rm -rf *.exe *.vcd

