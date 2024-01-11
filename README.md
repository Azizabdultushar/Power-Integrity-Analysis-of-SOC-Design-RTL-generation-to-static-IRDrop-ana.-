# Documentation
![Logo](./img/logo.jpeg) 

### Important tasks, 2023s – 2024s

- [ ] Good understanding of CPF file
- [x] Basics of verilog code
- [x] Fault analysis of tcl code


These pages provide the documentation of OpenRAM. You can use the links below to
navigate through the documentation.



## Table of Contents
1. [Advanced PnR process](#Advanced-PnR-process)
1. [Conformal:Verification](#Conformal:Verification)
1. [Online Playground](./OpenRAM.ipynb)
1. [Basic Setup](./basic_setup.md#go-back)
1. [Basic SRAM Usage](./basic_usage.md#go-back)
1. [Basic ROM Usage](./basic_rom_usage.md#go-back)
1. [Python Library](./python_library.md#go-back)
1. [Bitcells](./bitcells.md#go-back)
1. [Architecture](./architecture.md#go-back)
1. [Implementation](#implementation)
1. [Technology and Tool Portability](#technology-and-tool-portability)
1. [Tutorials](./tutorials.md#go-back)
1. [Debugging and Unit Testing](./debug.md#go-back)
1. [Technology Setup](./technology_setup.md#go-back)
1. [Library Cells](./library_cells.md#go-back)
1. [Base Data Structures](./base_data_structures.md#go-back)
1. [Hierarchical Design Modules](./design_modules.md#go-back)
1. [Control Logic and Timing](./control_logic.md#go-back)
1. [Routing](./routing.md#go-back)
1. [Characterization](./characterization.md#go-back)
1. [Results](./results.md#go-back)
1. [FAQ](./FAQ.md#go-back)
1. [Contributors/Collaborators](#contributorscollaborators)



## Advanced PnR process
* CPF is important for power intent design and this will automatically take care of the P/G pins connections and previously it was describe manually
  in the time of place and routing flow.
* a proper CPF file will ensure the proper automatic insertion of retention flip-flop, level shifters, isolation cells also always on buffers.
* Here we are using PDK45( a total 2K std cells) with 6 metal (***where in this PDK,11 metal layers are avaiable***) layers(4 metal for std cell routing and 2 metal for P/G routing).
* Design details
     * Block name: sparc_exu_alu consists of (adder + logic operation)
     * This block have a total 341 inputs and 192 outputs
     * Clock speed is 330MHz
* The goal is to run low power physical implementation on the design.

* POWER DOMAIN: Each part of the design with different voltage corresponds to a power domain.
* Design: TOP =sparc_exu_alu² which is contains three power domain: **TOP; KERNEL_LO; and KERNEL_PSO**;
* TOP: **Always on domain**, KERNEL_PSO:**Power shutdown domain**, KERNEL_LO: **able to operate the same volt or lower voltage level**
* So all these different power domain must be define in CPF file as **Power_mode** definition.
     * So far here we have 3 power mode as we have three power domain
       1.**Fast** = top:1.2v, Kernel_pso:1.2v, kernel_Lo:1.2v
       2.**Eco** = top:1.2v, Kernel_pso:1.2v, kernel_Lo:1.0v
       3.**Sleep** = top:1.2v, Kernel_pso:0 v(shutoff), kernel_Lo:1.0v

⛺
* **Power shut off** is the most recent developed, an effective tecnique to reduced leakge current. It is using **power gating**, **sleep transistors**, to shut off the domain. Sleep transistor could be PMOS or NMOS.
* PMOS sleep transistor used to switch ==VDD suppy==, hence name is **header cell switch**
* NMOS sleep transistor used to control ==VSS supply==, hence name is **footer cell switch**
* Optimal sleep transistors designs and implementations are challenging due various effects as like design performence,area, routability,performance,power, signal/power integrity.
* Since this is multi voltage design we choose VDD, VDD1
* **important** Since we are using different power domains means we have different voltage domains, so clock frequency also modified according to multi domain area.
* Since here we have 3 power mode so we will get 3 different timing constraint sets ***(SDC)***
    * fast_mode(sparce_exu_alu_fastmode.sdc)
    * eco_mode(sparce_exu_alu_ecomode.sdc)
    * sleep_mode(sparce_exu_alu_sleepmode)
* These 3 modes of operations combined with 2 library corners 1. ***worst case*** 2. ***Best case*** and with 2 check type: 1. ***Setup*** 2. ***Hold***
* As we have different power supplies so we need level shifters.
    * so far, in KERNEL_LO domain needs to go Low to High (LVLLH ***level shifter cell***)
    * and sometimes we need to go to High to Low (LVLHL ***level shifter cell***)
    * To turn on KERNEL_PSO we need to insert ***Isolation cell*** by using naddsub_on signal.
    * For the switchable power domain we need ***Retention sequential element*** and ***Always ON*** cells
    * Retention logic needs two pins VDD and ExtVDD. VDD can be **UP** /**DOWN**.
    * AO buffer is needed for alway on powered.
    * ***IMPORTANT*** Another way to saving power is adding clock gating function. **2** ways we can change general RTL
      code into gated clock RTL 1. Changing RTL code with ANDED gate with clock 2. In the time of synthesis, we can set
       `set_attribute lp_insert_clock_gating true /` this type of clock gated cell can easily changed into **integrated Gating cell**
  ***TECHNOLOGY***
* **Libraries** Following std cells libraries is required:
* gsclib045_hvt:High voltage threshold:slow, low leakage
* svt: standard voltage threshold
* lvt: low voltage threshold
* ***Important*** in order to limit the routing layer we can use this code snippet `M1: Width 0.06µm / Thickness 1500Å` and `M2-M6: Width 0.08 µm /Thickness 1800Å`
* ***important*** to use linux command type `sh` to use innovus command `innovus`  or `exit`
# LAB: Understanding CPF (Common Power Format) file.
* Goal is, where do we want to place Isolation cell, level shifter cell, retention ff, swith logic and so on. In CPF file we have to describe them. ***CPF*** file format was developed by
  **Cadence design system**  but therer is another power format, name is UPF (***United Power Format***) develop by Synopsys and it becomes an IEEE standard
  format.
* Now We are going to study on ***CPF*** which is ASCII file meand its a human readable file and tcl based script.
* **CPF**: It is common practice to check the CPF file before use is in PnR. We are going to use cadence conformal Low Power Verification tool to check cpf file.
* 

* What's MCMM
MCMM stands for: Multi-Corner Multi-Mode (static timing analysis used in the design of digital ICs)

* What's a Mode

A mode is defined by a set of clocks, supply voltages, timing constraints, and libraries. It can also have annotation data, such as SDF or parasitics files.
Many chip have multiple modes such as functional modes, test mode, sleep mode, and etc.

* What's a Corner
A corner is defined as a set of libraries characterized for process, voltage, and temperature variations.
Corners are not dependent on functional settings; they are meant to capture variations in the manufacturing process, along with expected variations in the voltage and temperature of the environment in which the chip will operate.

Example:
Multi-mode multi-corner (MMMC) analysis refers to performing STA across multiple operating modes, PVT corners and parasitic interconnect corners at the same time. For example, consider a DUA that has four operating modes (Normal, Sleep, Scan shift, Jtag), and is being analyzed at three PVT corners (WCS, BCF, WCL) and three parasitic interconnect corners (Typical, Min C, Min RC)


There are a total of thirty six possible scenarios at which all timing checks, such as setup, hold, slew, and clock gating checks can be performed. Running STA for all thirty six scenarios at the same time can be prohibitive in terms of runtime depending upon the size of the design. It is possible that a scenario may not be necessary as it may be included within another scenario, or a scenario may not be required. For example, the designer may determine
that scenarios 4, 6, 7 and 9 are not relevant and thus are not required. Also, it may not be necessary to run all modes in one corner, such as Scan shift or Jtag modes may not be needed in scenario 5. STA could be run on a single scenario or on multiple scenarios concurrently if multi-mode multicorner capability is available.

```
[s_ids118@item0110 ~]$ cat .cshrc
# license
setenv LM_LICENSE_FILE "28211@item0096"
#Innovus
source /eda/cadence/2022-23/scripts/INNOVUSEXPORT_21.35.000_RHELx86.csh
#genus
source /eda/cadence/2022-23/scripts/GENUS_21.14.000_RHELx86.csh
#quantus
source /eda/cadence/2022-23/scripts/QUANTUS_21.11.000_RHELx86.csh
#tempus
source /eda/cadence/2022-23/scripts/SSV_22.11.000_RHELx86.csh
#conformal
source /eda/cadence/2022-23/scripts/CONFRML_22.10.200_RHELx86.csh 
#xrun
source /eda/cadence/2022-23/scripts/XCELIUM_22.03.005_RHELx86.csh
```
## Conformal:Verification
* Before starting any implementation, It´s always good practice to check the quality of the inputs for low power flow, especially the CPF file.
* **Conformal LowPower Verification tool**
  ***Library Power information Checking***
  ***Power Intent Creation***
  ***Power Intent Quality Cehcking***
  ***Design Power structure verification***
    - Need sanity check of CPF file
    - read both RTL netlist🍀 and CPF🍎 file
* RTL and CPF sanity checking in conformal scripts
```
\\##############
\\## Settings ##
\\##############
tclmode
set_case_sensitivity on
set_lowpower_option -netlist_style logical
\\#Ignore identify_always_on_driver for RTL
vpx set rule handling CPF_DES10 -Ignore
\\#vpx set rule handling CPF_LIB41 -Ignore

\\###################
\\## Library Setup ##
\\###################
\\#LEF needed for power pin definition
read_lef_file \
../Library/lef/gsclib045_macro.lef \
../Library/lef/gsclib045_hvt_macro.lef

read_library -cpf ../DesignDataIn/cpf/sparc_exu_alu.cpf

\\##################
\\## Design Setup ##
\\##################
 read_design -verilog2k -noelab \
../DesignDataIn/src/lib/u1/u1.behV \
../DesignDataIn/src/lib/m1/m1.behV \
../DesignDataIn/src/common/swrvr_clib.v \
../DesignDataIn/src/common/swrvr_dlib.v \
../DesignDataIn/src/rtl/sparc_exu_aluor32.v \
../DesignDataIn/src/rtl/sparc_exu_aluadder64.v \
../DesignDataIn/src/rtl/sparc_exu_aluspr.v \
../DesignDataIn/src/rtl/sparc_exu_alu_16eql.v \
../DesignDataIn/src/rtl/sparc_exu_alulogic.v \
../DesignDataIn/src/rtl/sparc_exu_aluzcmp64.v \
../DesignDataIn/src/rtl/sparc_exu_aluaddsub.v \
../DesignDataIn/src/rtl/sparc_exu_alu.v
elaborate_design -root sparc_exu_alu

report_floating_signals > ./reports/float.rpt
report_tied_signals > ./reports/tied.rpt

\\#########################
\\## Power Intent Checks ##
\\#########################
read_power_intent -pre_synthesis -cpf ../DesignDataIn/cpf/sparc_exu_alu.cpf
\\#commit_power_intent -insert_isolation -functional_insertion
commit_power_intent -functional_insertion
analyze_power_domain

#exit
```



* **Power Intent**✳️ power intent describes the partitioning of a design into power domains. In some cases those are active power domains that are being turned on and turned off. In some cases they are simply voltage domains, which is different supply voltages used in the same chip.”

Power intent also sometimes describes the control signals that are used to control these power domains. It describes special cells that are required to implement such a design such as level shifters, retention cells and so on, various rules that the architecture of the chip and the usage of these cells should contain—things like ‘this domain is always on,’ or ‘this domain is off under certain conditions,’ or ‘this particular cell is used between these domains


## Implementation
* cpf file (low power)🪚:sample
```
set_cpf_version 2.0
set_hierarchy_separator /
set_design sparc_exu_alu

############################
## Define WC library sets ##
## SS/0.9*VDD/125C        ##
############################
define_library_set -name gpdk045_wc_hi_lib  -libraries {\   # 👨‍🔧
 ../Library/timing/slow_vdd1v2_basicCells.lib \
 ../Library/timing/slow_vdd1v2_extvdd1v2.lib \
 ../Library/timing/slow_vdd1v2_extvdd1v0.lib \
 ../Library/timing/slow_vdd1v0_extvdd1v2.lib \
 ../Library/timing/slow_vdd1v2_basicCells_lvt.lib }

define_library_set -name gpdk045_wc_lo_lib  -libraries {\    # 👨‍🔧
 ../Library/timing/slow_vdd1v0_basicCells.lib \
 ../Library/timing/slow_vdd1v0_extvdd1v0.lib \
 ../Library/timing/slow_vdd1v0_extvdd1v2.lib \
 ../Library/timing/slow_vdd1v0_basicCells_lvt.lib }
 
############################
## Define BC library sets ##
##  FF/1.1*VDD/0C         ##
############################
define_library_set -name gpdk045_bc_hi_lib  -libraries {\    # 👨‍🔧
 ../Library/timing/fast_vdd1v2_basicCells.lib \
 ../Library/timing/fast_vdd1v2_extvdd1v2.lib \
 ../Library/timing/fast_vdd1v2_extvdd1v0.lib \
 ../Library/timing/fast_vdd1v0_extvdd1v2.lib \
 ../Library/timing/fast_vdd1v2_basicCells_lvt.lib }

define_library_set -name gpdk045_bc_lo_lib  -libraries {\    # 👨‍🔧
 ../Library/timing/fast_vdd1v0_basicCells.lib \
 ../Library/timing/fast_vdd1v0_extvdd1v0.lib \
 ../Library/timing/fast_vdd1v0_extvdd1v2.lib \
 ../Library/timing/fast_vdd1v0_basicCells_lvt.lib }

############################
## Defining Power Domains ##
############################
# default one, always on
create_power_domain -name TOP -default -boundary_ports *

# virtual one, VDD1 container
create_power_domain -name virtual_PDaon

# switchable one
create_power_domain -name KERNEL_PSO -instances { addsub/spr_sw addsub/sub_dff_sw } -base_domains TOP -shutoff_condition {nsleep_in}
create_power_domain -name KERNEL_LO -instances { addsub/spr_lo addsub/sub_dff_lo } -base_domains virtual_PDaon

#################################
### Defining Power/Ground Nets ##
#################################
create_power_nets  -nets VDD -voltage {1.2}
create_power_nets  -nets VDD1 -voltage {1.0:1.2}
create_power_nets  -nets VDDSW -internal -voltage {0.0:1.2}
create_ground_nets -nets VSS

update_power_domain -name TOP -primary_power_net VDD -primary_ground_net VSS
update_power_domain -name KERNEL_PSO -primary_power_net VDDSW -primary_ground_net VSS
update_power_domain -name KERNEL_LO -primary_power_net VDD1 -primary_ground_net VSS
update_power_domain -name virtual_PDaon -primary_power_net VDD1 -primary_ground_net VSS

create_global_connection -net VDD -pins VDD -domain TOP
create_global_connection -net VSS -pins VSS -domain TOP
create_global_connection -net VDDSW -pins VDD -domain KERNEL_PSO
create_global_connection -net VSS -pins VSS -domain KERNEL_PSO
create_global_connection -net VDD1 -pins VDD -domain KERNEL_LO
create_global_connection -net VSS -pins VSS -domain KERNEL_LO
#######
#Define instance power domains (virtual domains) to avoid following ERROR
#floorplan.log:**ERROR: (ENCMSMV-3502):  Power net VDD1 is not associated with any power domain. 
#It is probably because this power net is not specified as any domain's primary power net. 
#You need to modify CPF to create a virtual power domain using 'create_power_domain' without 
#-instances and -default options then specify this power net as its primary power net using 'update_power_domain'.
#######
#place.log:**ERROR: (ENCDB-1221):        A global net connection rule for connecting P/G pins of the pattern 'VDD1' was specified.  But the connections cannot be made because there is no such pin in any cell.  Check the pin name pattern and make sure it is correct.
#

##############################
## Define Nominal Condition ##
##############################
create_nominal_condition -name high -voltage 1.2 -state on
update_nominal_condition -name high -library_set gpdk045_wc_hi_lib
create_nominal_condition -name low  -voltage 1.0 -state on
update_nominal_condition -name low  -library_set gpdk045_wc_lo_lib
create_nominal_condition -name off  -voltage 0.0 -state off

#######################
## Define Power Mode ##
#######################
create_power_mode -name fast_mode  -domain_conditions { TOP@high virtual_PDaon@high KERNEL_PSO@high KERNEL_LO@high} -default    # 👨‍🔧
update_power_mode -name fast_mode  -sdc_files "../DesignDataIn/sdc/sparc_exu_alu_fastmode.sdc"
create_power_mode -name eco_mode   -domain_conditions { TOP@high virtual_PDaon@low KERNEL_PSO@high KERNEL_LO@low}
update_power_mode -name eco_mode   -sdc_files "../DesignDataIn/sdc/sparc_exu_alu_ecomode.sdc"
create_power_mode -name sleep_mode -domain_conditions { TOP@high virtual_PDaon@low KERNEL_PSO@off KERNEL_LO@low}
update_power_mode -name sleep_mode -sdc_files "../DesignDataIn/sdc/sparc_exu_alu_sleepmode.sdc"

#############################
## Define Operation Corner ##
#############################
create_operating_corner -name fast_wc_rc125   -library_set gpdk045_wc_hi_lib  -process 1  -voltage 1.08   -temperature 125
create_operating_corner -name fast_bc_rc0   -library_set gpdk045_bc_hi_lib  -process 1  -voltage 1.32   -temperature 0
create_operating_corner -name eco_wc_rc125    -library_set gpdk045_wc_lo_lib  -process 1  -voltage 0.9    -temperature 125
create_operating_corner -name eco_bc_rc0     -library_set gpdk045_bc_lo_lib  -process 1  -voltage 1.1    -temperature 0
create_operating_corner -name sleep_wc_rc125  -library_set gpdk045_wc_hi_lib  -process 1  -voltage 0.0    -temperature 125
create_operating_corner -name sleep_bc_rc0  -library_set gpdk045_bc_hi_lib  -process 1  -voltage 0.0    -temperature 0

##########################
## Define Analysis View ##
##########################
## SETUP                                # 👨‍🔧
create_analysis_view -name AV_fast_mode_wc_rc125_setup      -mode fast_mode  -domain_corners {TOP@fast_wc_rc125 KERNEL_PSO@fast_wc_rc125 KERNEL_LO@fast_wc_rc125}
create_analysis_view -name AV_eco_mode_wc_rc125_setup       -mode eco_mode   -domain_corners {TOP@fast_wc_rc125 KERNEL_PSO@eco_wc_rc125 KERNEL_LO@eco_wc_rc125}
create_analysis_view -name AV_sleep_mode_wc_rc125_setup     -mode sleep_mode -domain_corners {TOP@fast_wc_rc125 KERNEL_PSO@sleep_wc_rc125 KERNEL_LO@sleep_wc_rc125}


## HOLD ##                      # 👨‍🔧
create_analysis_view -name AV_fast_mode_wc_rc125_hold       -mode fast_mode  -domain_corners {TOP@fast_wc_rc125 KERNEL_PSO@fast_wc_rc125 KERNEL_LO@fast_wc_rc125}
create_analysis_view -name AV_eco_mode_wc_rc125_hold 	    -mode eco_mode   -domain_corners {TOP@fast_wc_rc125 KERNEL_PSO@eco_wc_rc125 KERNEL_LO@eco_wc_rc125}
create_analysis_view -name AV_sleep_mode_wc_rc125_hold      -mode sleep_mode -domain_corners {TOP@fast_wc_rc125 KERNEL_PSO@sleep_wc_rc125 KERNEL_LO@sleep_wc_rc125}

create_analysis_view -name AV_fast_mode_bc_rc0_hold 	    -mode fast_mode  -domain_corners {TOP@fast_bc_rc0 KERNEL_PSO@fast_bc_rc0 KERNEL_LO@fast_bc_rc0}
create_analysis_view -name AV_eco_mode_bc_rc0_hold 	    -mode eco_mode   -domain_corners {TOP@fast_bc_rc0 KERNEL_PSO@eco_bc_rc0 KERNEL_LO@eco_bc_rc0}
create_analysis_view -name AV_sleep_mode_bc_rc0_hold      -mode sleep_mode -domain_corners {TOP@fast_bc_rc0 KERNEL_PSO@sleep_bc_rc0 KERNEL_LO@sleep_bc_rc0}

###############################
## Define Power Switch cells ##
###############################
define_power_switch_cell -power_switchable VDD -power ExtVDD -stage_1_enable !PSO -stage_1_output PSO_out -type header -cells "HSWX1"
create_power_switch_rule -name pd_addsub_sw -domain KERNEL_PSO -external_power_net VDD
update_power_switch_rule -name pd_addsub_sw -enable_condition_1 {!nsleep_in} -acknowledge_receiver_1 nsleep_out -cells "HSWX1"

##########################
## Define Level Shifter ##
##########################
define_level_shifter_cell -input_voltage_range 1.08:1.32 -output_voltage_range 0.90:1.32 -power VDD -direction down -ground VSS -cells "LSHLX1_TO" -valid_location either
create_level_shifter_rule -name pd_addsub_lvlin -from TOP -to KERNEL_LO
update_level_shifter_rules -names pd_addsub_lvlin -cells "LSHLX1_TO" -location to
define_level_shifter_cell -input_voltage_range 0.90:1.32 -output_voltage_range 1.08:1.32 -direction bidir -input_power_pin ExtVDD -output_power_pin VDD -ground VSS -cells "LSLHX1_TO" -valid_location to
create_level_shifter_rule -name pd_addsub_lvlout -from KERNEL_LO -to TOP
update_level_shifter_rules -names pd_addsub_lvlout -cells "LSLHX1_TO"

############################
## Define Isolation cells ##
############################
define_isolation_cell -power VDD -ground VSS -enable ISO -valid_location to -cells "ISOLX1_ON"
create_isolation_rule -name pd_addsub_iso -isolation_condition {!naddsub_on} -from KERNEL_PSO -to TOP -exclude {nsleep_out} -isolation_output low
update_isolation_rules -names pd_addsub_iso -location to

##########################
## Desfine Retention FF ##
##########################
#define_state_retention_cell -cells {RDFF*} -ground VSS -power ExtVDD -power_switchable VDD -clock_pin CK -save_function SAVE -restore_function !NRESTORE
define_state_retention_cell -cells {RDFF* SRDFF*} -ground VSS -power ExtVDD -power_switchable VDD -save_function !RT -restore_function RT
#create_state_retention_rule -name pd_addsub_ret -domain KERNEL -save_level {save} -restore_level {!nrestore} -secondary_domain "virtual_PDaon"
create_state_retention_rule -name pd_addsub_ret -domain KERNEL_PSO -save_edge {nrestore} -restore_edge {!nrestore} -secondary_domain TOP
update_state_retention_rules -names pd_addsub_ret -cells {RDFF* SRDFF*}

#############################
## Define AON Buffer cells ##
#############################
define_always_on_cell -cells "PBUFX2" -power_switchable VDD -power ExtVDD -ground VSS 
identify_always_on_driver -pins {save nrestore}

end_design
```



## Technology and Tool Portability
* OpenRAM is technology independent by using a technology directory that
  includes:
    * Technology's specific information
    * Technology's rules such as DRC rules and the GDS layer map
    * Custom designed library cells (6T, sense amp, DFF) to improve the SRAM
      density.
* For technologies that have specific design requirements, such as specialized
  well contacts, the user can include helper functions in the technology
  directory.
* Verification wrapper scripts
    * Uses a wrapper interface with DRC and LVS tools that allow flexibility
    * DRC and LVS can be performed at all levels of the design hierarchy to
      enhance bug tracking.
    * DRC and LVS can be disabled completely for improved run-time or if
      licenses are not available.



## Contributors/Collaborators
<img align="right" height="120" src="../assets/images/logos/okstate.png">

* Prof. Matthew Guthaus (UCSC)
* Prof. James Stine & Dr. Samira Ataei (Oklahoma State University)
* UCSC students:
    * Bin Wu
    * Hunter Nichols
    * Michael Grimes
    * Jennifer Sowash
    * Jesse Cirimelli-Low
    <img align="right" height="100" src="../assets/images/logos/vlsida.png">https://www.youtube.com/watch?v=rd5j8mG24H4&t=0s
* Many other past students:
    * Jeff Butera
    * Tom Golubev
    * Marcelo Sero
    * Seokjoong Kim
    * Sage Walker







Please, keep distance from my personal project/study area. :)
