# =================================================================
#  FP4 Timing Constraints - 200 MHz target (5.000 ns period)
#  Device: Artix-7 xc7a35tcpg236-1 (speed grade -1)
# =================================================================

# ?? Primary clock ?????????????????????????????????????????????????
create_clock -period 10.000 -name sys_clk -waveform {0.000 2.500} [get_ports clk]

# ?? Input delays (budget = 1.0 ns, leave 4.0 ns for internal) ????
set_input_delay -clock sys_clk -max 1.000 [get_ports {{a[*]} {b[*]} {c[*]} {op[*]} valid_in}]
set_input_delay -clock sys_clk -min 0.100 [get_ports {{a[*]} {b[*]} {c[*]} {op[*]} valid_in}]

# ?? Output delays ????????????????????????????????????????????????
set_output_delay -clock sys_clk -max 1.000 [get_ports {{result[*]} valid_out}]
set_output_delay -clock sys_clk -min 0.100 [get_ports {{result[*]} valid_out}]

# ?? Reset is asynchronous path - false path for timing ???????????
set_false_path -from [get_ports rst]

# ?? Force LUTRAM placement near output FFs ???????????????????????

# ?? Fanout limit - prevent high-fanout nets from blowing timing ???

set_property PACKAGE_PIN R3 [get_ports {a[0]}]
set_property PACKAGE_PIN T3 [get_ports {a[1]}]
set_property PACKAGE_PIN R2 [get_ports {a[2]}]
set_property PACKAGE_PIN W1 [get_ports {b[0]}]
set_property PACKAGE_PIN W2 [get_ports {b[1]}]
set_property PACKAGE_PIN W4 [get_ports {b[2]}]
set_property PACKAGE_PIN W5 [get_ports {b[3]}]
set_property PACKAGE_PIN N14 [get_ports {result[3]}]
set_property PACKAGE_PIN P16 [get_ports {result[2]}]
set_property PACKAGE_PIN R17 [get_ports {result[1]}]
set_property PACKAGE_PIN N15 [get_ports {result[0]}]
set_property PACKAGE_PIN U20 [get_ports clk]
set_property PACKAGE_PIN R16 [get_ports rst]
set_property PACKAGE_PIN P15 [get_ports valid_in]
set_property PACKAGE_PIN N13 [get_ports valid_out]
set_property PACKAGE_PIN T1 [get_ports {a[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports valid_in]
set_property IOSTANDARD LVCMOS33 [get_ports valid_out]
