## Nexys A7-100T - XDC Codeur_7Seg

##---------------------------------------------------------

## Horloge 100 MHz
set_property -dict { PACKAGE_PIN E3   IOSTANDARD LVCMOS33 } [get_ports { Clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { Clk }];

##---------------------------------------------------------

## Switches
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33 } [get_ports { SW[0] }];
set_property -dict { PACKAGE_PIN L16  IOSTANDARD LVCMOS33 } [get_ports { SW[1] }];
set_property -dict { PACKAGE_PIN M13  IOSTANDARD LVCMOS33 } [get_ports { SW[2] }];
set_property -dict { PACKAGE_PIN R15  IOSTANDARD LVCMOS33 } [get_ports { SW[3] }];

##---------------------------------------------------------

## Segments (actif bas)
set_property -dict { PACKAGE_PIN T10  IOSTANDARD LVCMOS33 } [get_ports { Seg[0] }];  ## CA ? a
set_property -dict { PACKAGE_PIN R10  IOSTANDARD LVCMOS33 } [get_ports { Seg[1] }];  ## CB ? b
set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports { Seg[2] }];  ## CC ? c
set_property -dict { PACKAGE_PIN K13  IOSTANDARD LVCMOS33 } [get_ports { Seg[3] }];  ## CD ? d
set_property -dict { PACKAGE_PIN P15  IOSTANDARD LVCMOS33 } [get_ports { Seg[4] }];  ## CE ? e
set_property -dict { PACKAGE_PIN T11  IOSTANDARD LVCMOS33 } [get_ports { Seg[5] }];  ## CF ? f
set_property -dict { PACKAGE_PIN L18  IOSTANDARD LVCMOS33 } [get_ports { Seg[6] }];  ## CG ? g

##---------------------------------------------------------

## Afficheurs
set_property -dict { PACKAGE_PIN J17  IOSTANDARD LVCMOS33 } [get_ports { Digit[0] }];  ## AN0
set_property -dict { PACKAGE_PIN J18  IOSTANDARD LVCMOS33 } [get_ports { Digit[1] }];  ## AN1
set_property -dict { PACKAGE_PIN T9   IOSTANDARD LVCMOS33 } [get_ports { Digit[2] }];  ## AN2
set_property -dict { PACKAGE_PIN J14  IOSTANDARD LVCMOS33 } [get_ports { Digit[3] }];  ## AN3
set_property -dict { PACKAGE_PIN P14  IOSTANDARD LVCMOS33 } [get_ports { Digit[4] }];  ## AN4
set_property -dict { PACKAGE_PIN T14  IOSTANDARD LVCMOS33 } [get_ports { Digit[5] }];  ## AN5
set_property -dict { PACKAGE_PIN K2   IOSTANDARD LVCMOS33 } [get_ports { Digit[6] }];  ## AN6
set_property -dict { PACKAGE_PIN U13  IOSTANDARD LVCMOS33 } [get_ports { Digit[7] }];  ## AN7

##---------------------------------------------------------