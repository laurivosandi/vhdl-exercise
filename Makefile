run: build
	./alu_testbench

build:
	ghdl -a full_adder.vhd  carry_ripple_adder.vhd  alu.vhd alu_testbench.vhd
	ghdl -e alu_testbench

clean:
	rm -fv *.o e~* work-obj93.cf
