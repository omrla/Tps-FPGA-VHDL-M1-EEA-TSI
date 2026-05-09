## Horloge 100 MHz - Pin R4
set_property -dict { PACKAGE_PIN R4  IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -period 10.000 -name clk [get_ports clk]

## Boutons - LVCMOS12
set_property -dict { PACKAGE_PIN D14  IOSTANDARD LVCMOS12 } [get_ports {boutons[0]}]
set_property -dict { PACKAGE_PIN D22  IOSTANDARD LVCMOS12 } [get_ports {boutons[1]}]
set_property -dict { PACKAGE_PIN C22  IOSTANDARD LVCMOS12 } [get_ports {boutons[2]}]
set_property -dict { PACKAGE_PIN B22  IOSTANDARD LVCMOS12 } [get_ports {boutons[3]}]
set_property -dict { PACKAGE_PIN F15  IOSTANDARD LVCMOS12 } [get_ports {boutons[4]}]

## LEDs - LVCMOS33
set_property -dict { PACKAGE_PIN T14  IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN T15  IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN T16  IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS33 } [get_ports {leds[4]}]