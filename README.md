# fpga_nexys_a7_dram

This is a DDR2 SDRAM (**MT47H64M16HR-25E**) sample project for Nexys A7 FPGA board.
Please use **Vivado 2024.1**. 
When creating a Vivado project, please select **xc7a100tcsg324-1** as an FPGA. 

## Clocking Wizard

- Clocking Options, Input Clock Information : **100.000** MHz Input Frequency
- Output Clocks, clk_out1 : **200** MHz Output Freq is Requested
- Output Clocks: disable **reset**, power_down, input_clk_stopped, **locked**, clksbstopped

## VIO (Virtual Input/Output)

- Component Name, General Options, Input Probe Count: **2**
- Component Name, General Options, Output Probe Count: **0**
- Component Name, PROBE_IN_Ports, PROBE_IN1 : **27**
- Component Name, PROBE_IN_Ports, PROBE_IN2 : **32**


## MIG (Memory Interface Generator)

- (1) MIG Output Options: check **Create Design**
- (1) MIG Output Options, Component Name: **mig_7series_0**
- (1) MIG Output Options, Multi-Controller: **1**
- (1) MIG Output Options, AXI4 Interface: **uncheck**
- (2) Pin Compatible FPGAs: **uncheck** 
- (3) Memory Selection: check **DDR2 SDRAM**
- (4) Options for Controller 0, Clock Period: **3077**
- (4) Options for Controller 0, Memory Type: **MT41H64M16HR-25E**
- (4) Options for Controller 0, Memory Type: Create Custom Part
- (4) Options for Controller 0, Data Width: **16**
- (4) Options for Controller 0, Data Mask: **check**
- (4) Options for Controller 0, Number of Bank Machines: **2**
- (4) Options for Controller 0, Ordering: **Strict**
- (5) Memory Options C0, Input Clock Period: **5000 ps**
- (5) Memory Options C0, Read Burst Type and Length: **Sequential**
- (5) Memory Options C0, Output Drive Strength: **Fullstrength**
- (5) Memory Options C0, RTT-ODT: **50ohms**
- (5) Memory Options C0, Controller Chip Select Pin: **Enable**
- (5) Memory Options C0, Memory Address Mapping Selection: check **below (BANK, ROW, COKUMN)**
- (6) FPGA Options, System Clock: **No Buffer**
- (6) FPGA Options, Reference Clock: **Use System Clock**
- (6) FPGA Options, System Reset Polarity: **ACTIVE HIGH**
- (6) FPGA Options, Debug Signals for Memory Controller: **OFF**
- (6) FPGA Options, Internal Vref: **Check**
- (6) FPGA Options, IO Power Reduction: **ON**
- (6) FPGA Options, XADC Instantiation: **Disabled**
- (7) Extended FPGA Options, Internal Termination Impedance: **50 Ohms**
- (8) IO Planning Options: check **Fixed Pin Out: Pre-existing pin out is known and fixed**
- (9) Pin Selection: click **Read XDC/UCF**, and select a file named **nexys_a7_mig.ucf**, and click **Validate**
- (10) System Signals Selection, sys_rst: **No connect**
- (10) System Signals Selection, init_calib_complete: **No connect**
- (10) System Signals Selection, tg_compare_error: **No connect**

