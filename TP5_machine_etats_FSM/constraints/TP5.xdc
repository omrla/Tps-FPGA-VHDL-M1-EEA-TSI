
set_property PACKAGE_PIN E3       [get_ports clk]
set_property IOSTANDARD  LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## BOUTONS
set_property PACKAGE_PIN P17      [get_ports un_dollar]
set_property IOSTANDARD  LVCMOS33 [get_ports un_dollar]

set_property PACKAGE_PIN M17      [get_ports deux_dollars]
set_property IOSTANDARD  LVCMOS33 [get_ports deux_dollars]

## LEDs
set_property PACKAGE_PIN H17      [get_ports film]
set_property IOSTANDARD  LVCMOS33 [get_ports film]

set_property PACKAGE_PIN K15      [get_ports monnaie]
set_property IOSTANDARD  LVCMOS33 [get_ports monnaie]

## ANODES 7 segments
set_property PACKAGE_PIN J17      [get_ports {an[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {an[0]}]

set_property PACKAGE_PIN J18      [get_ports {an[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {an[1]}]

set_property PACKAGE_PIN T9       [get_ports {an[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {an[2]}]

set_property PACKAGE_PIN J14      [get_ports {an[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {an[3]}]

set_property PACKAGE_PIN P14      [get_ports {an[4]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {an[4]}]

set_property PACKAGE_PIN T14      [get_ports {an[5]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {an[5]}]

set_property PACKAGE_PIN K2       [get_ports {an[6]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {an[6]}]

set_property PACKAGE_PIN U13      [get_ports {an[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {an[7]}]

## SEGMENTS 7 segments
set_property PACKAGE_PIN T10      [get_ports {seg[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {seg[0]}]

set_property PACKAGE_PIN R10      [get_ports {seg[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {seg[1]}]

set_property PACKAGE_PIN K16      [get_ports {seg[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {seg[2]}]

set_property PACKAGE_PIN K13      [get_ports {seg[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {seg[3]}]

set_property PACKAGE_PIN P15      [get_ports {seg[4]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {seg[4]}]

set_property PACKAGE_PIN T11      [get_ports {seg[5]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {seg[5]}]

set_property PACKAGE_PIN L18      [get_ports {seg[6]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {seg[6]}]

## Point decimal
set_property PACKAGE_PIN H15      [get_ports dp]
set_property IOSTANDARD  LVCMOS33 [get_ports dp]