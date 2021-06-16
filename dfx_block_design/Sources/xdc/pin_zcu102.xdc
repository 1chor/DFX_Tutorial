#####
## Constraints for ZCU102
## Version 1.0
#####


#####
## Pins
#####

#####
## Reset (Switch West / SW14)
set_property PACKAGE_PIN AF15 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
#####

#####
## Misc
#GPIO_LEDs

set_property PACKAGE_PIN AG14 [get_ports {LED[0]}]
set_property PACKAGE_PIN AF13 [get_ports {LED[1]}]
set_property PACKAGE_PIN AE13 [get_ports {LED[2]}]
set_property PACKAGE_PIN AJ14 [get_ports {LED[3]}]           
set_property PACKAGE_PIN AJ15 [get_ports {LED[4]}]           
set_property PACKAGE_PIN AH13 [get_ports {LED[5]}]           
set_property PACKAGE_PIN AH14 [get_ports {LED[6]}]           
set_property PACKAGE_PIN AL12 [get_ports {LED[7]}]                 

set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
#####
   

#####
## End
#####

