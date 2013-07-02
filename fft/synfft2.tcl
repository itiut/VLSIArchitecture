# Written by : DC-Transcript, Version Z-2007.03-SP4 -- Aug 29, 2007
# Date       : Wed Dec 19 02:32:33 2007
#

#
# Translation of script: synStage1.cmd
#


set search_path [concat  {/usr/cad/LIB/syn .} $search_path]
set target_library [list "vdec_lin.db" "vdecio_lin.db"]
set link_path [list "vdec_lin.db" "vdecio_lin.db"]
set symbol_library [list "EXD.sdb"]

set designer {Designers Name}
set company {VLSI Architecture 2010}
set verilogout_no_tri "true"
set verilogout_single_bit "false"

read_file -format verilog [list "fft2.v"]
current_design "fft"
clock -period 25 ck
set_max_area 0.0
set_driving_cell  -lib_cell NAND2  -pin Y [all_inputs]
compile -map_effort high
define_name_rules verilog -case_insensitive -type net
change_names -rules verilog -hierarchy


current_design "fft"
report_timing -path full_clock -nworst 10 -nets -transition_time -capacitance -attributes -sort_by slack
report_area

current_design "fft"

write -format verilog -hierarchy -output "fftout.v" [list "fft"]

quit
