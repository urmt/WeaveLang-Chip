# weavechip_synth.tcl
# Description: Synopsys Design Compiler script for synthesizing WeaveChip to TSMC N7
# Usage: dc_shell -f weavechip_synth.tcl

# Setup TSMC N7 libraries
set_target_library tsmc_n7_std.db
set_link_library {tsmc_n7_std.db tsmc_n7_io.db}
set_symbol_library tsmc_n7_std.sdb
set_synthetic_library dw_foundation.sdb

# Define design paths
set search_path [list . ../netlists ../process]
set verilog_files [list "weavechip_top.va" "weave_core.va" "memristor.va" "pbit_mtj.va"]
set top_module weavechip_top

# Read and elaborate design
read_verilog $verilog_files
link_design $top_module
uniquify

# Set constraints
set_max_area 1.2e6  ;# 1.2 mm^2 in um^2
set_max_power 0.5   ;# 0.5 W target
set_clock clk_ext -period 1e-9 ;# 1 GHz optional clock
set_input_delay 0.2 -clock clk_ext [all_inputs]
set_output_delay 0.2 -clock clk_ext [all_outputs]

# Map analog components to custom macros
set_dont_touch [get_cells *memristor*]
set_dont_touch [get_cells *pbit_mtj*]
set_attribute [get_cells *memristor*] is_analog true
set_attribute [get_cells *pbit_mtj*] is_analog true

# Synthesize and optimize
compile -map_effort high -area_effort high
optimize_netlist -area

# Generate reports
report_area > reports/area.rpt
report_power > reports/power.rpt
report_timing > reports/timing.rpt

# Output netlist
write -format verilog -hierarchy -output weavechip_synth.v
write_sdc -nosplit weavechip_sdc.sdc

# Save design
save_design weavechip.ddc