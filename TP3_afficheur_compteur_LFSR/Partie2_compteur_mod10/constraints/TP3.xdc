## Horloge 100 MHz
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports { Clk }];
create_clock -add -name sys_clk_pin -period 10.00 [get_ports { Clk }];

## Boutons
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { BTNC }];
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { BTNU }];
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { BTND }];
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { BTNL }];
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { BTNR }];

## Cathodes 7-segments
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { Seg[0] }]; -- a
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { Seg[1] }]; -- b
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { Seg[2] }]; -- c
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { Seg[3] }]; -- d
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { Seg[4] }]; -- e
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { Seg[5] }]; -- f
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports { Seg[6] }]; -- g

## Anodes AN0 à AN7 
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports { Digit[0] }]; -- AN0
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { Digit[1] }]; -- AN1
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { Digit[2] }]; -- AN2
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { Digit[3] }]; -- AN3
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { Digit[4] }]; -- AN4
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { Digit[5] }]; -- AN5
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports { Digit[6] }]; -- AN6
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { Digit[7] }]; -- AN7