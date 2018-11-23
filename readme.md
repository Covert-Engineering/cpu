# Following tutorial from:

http://labs.domipheus.com/blog/designing-a-cpu-in-vhdl-part-3-instruction-set-decoder-ram/

# Tool Chain
## GHDL - compile and simulate
## GTK Wave - view waveform

# Process
## [analysis] ghdl -a <file names or *>.vhd
## [elaborate] ghdl -e <top level>
## [run] ghdl -r <top level> --vcd=<top level>.vcd
## [open gtkwave] gtkwave <top level>.vcd
