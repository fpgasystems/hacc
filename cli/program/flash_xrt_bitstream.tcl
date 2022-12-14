set serveraddr [lindex $::argv 0]
set boardsn [lindex $::argv 1]
set devicename  [lindex $::argv 2]
#set bitpath [lindex $::argv 3]

#connect to device
open_hw_manager
connect_hw_server -url ${serveraddr}:3121 -allow_non_jtag
current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/${boardsn}]
set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Xilinx/${boardsn}]
open_hw_target
current_hw_device [get_hw_devices ${devicename}]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices ${devicename}] 0]

#boot from memory
boot_hw_device  [lindex [get_hw_devices ${devicename}] 0]
refresh_hw_device [lindex [get_hw_devices ${devicename}] 0]

#close device
close_hw_target ${serveraddr}:3121/xilinx_tcf/Xilinx/${boardsn}
close_hw_manager
