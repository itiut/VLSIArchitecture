set search_path [concat  {/usr/cad/LIB/syn .} ]
set target_library [list "vdec_lin.db" "vdecio_lin.db"]
set link_path [list "vdec_lin.db" "vdecio_lin.db"]
set symbol_library [list "EXD.sdb"]

set designer {Designers Name}
set company {VLSI Architecture 2013}
set verilogout_no_tri "true"
set verilogout_single_bit "false"

read_file -format verilog [list "des1.v"]
current_design "des"

create_clock -period 90 ck
set_max_area 0

set_clock_uncertainty 0.5 ck
set_clock_transition 0.5 ck
set_dont_touch_network ck
set_driving_cell  -lib_cell NAND2  -pin Y [all_inputs]
set_load 0.2 [all_outputs]
set_input_delay -max 2 -clock ck [all_inputs]
set_output_delay -max 2 -clock ck [all_outputs]
compile -map_effort high
define_name_rules verilog -case_insensitive -type net
change_names -rules verilog -hierarchy
current_design "des"
write -format verilog -hierarchy -output "des_out.v" [list "des"]
report_timing -path full_clock -nworst 1 -nets -transition_time -capacitance -attributes -sort_by slack
report_area
quit
