# vhdl-exercise

Bob had to ship the ALU design to the hardware manufacturer by yesterday.
The project manager is angry about missed deadline.
Bob still hasn't figured out why the ALU is not working properly.
Help Bob by figuring out what's the problem.

If you're on Ubuntu install GHDL and GtkWave:

```
sudo add-apt-repository ppa:pgavin/ghdl
sudo apt-get update
sudo apt-get install ghdl gtkwave git
```

Clone the repository

```
git clone https://github.com/laurivosandi/vhdl-exercise
```

Use ```make``` to compile the components and run the testbench:

```
cd path/to/vhdl-exercise
make
```

Expected output of the testbench:

```
alu_testbench.vhd:77:9:@360ns:(report note): Finished testing addition operation of ALU
alu_testbench.vhd:106:9:@1us:(report note): Finished testing subtraction operation of ALU
alu_testbench.vhd:135:9:@1640ns:(report note): Finished testing NAND operation of ALU
alu_testbench.vhd:166:9:@2280ns:(report note): Finished testing NOR operation of ALU
```

However there are few bugs in ```alu.vhd```, find the bugs and correct them.
