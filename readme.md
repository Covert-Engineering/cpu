# Following tutorial from:

http://labs.domipheus.com/blog/designing-a-cpu-in-vhdl-part-3-instruction-set-decoder-ram/

# Tool Chain
## [GHDL - compile and simulate](https://ghdl.readthedocs.io/en/latest/about.html)
## [GTK Wave - view waveform](http://gtkwave.sourceforge.net/)

# Process
## [analysis] ghdl -a --std=08 (file names or *).vhd
## [elaborate] ghdl -e (top level)
## [run] ghdl -r (top level) --vcd=(top level).vcd
## [open gtkwave] gtkwave (top level).vcd
