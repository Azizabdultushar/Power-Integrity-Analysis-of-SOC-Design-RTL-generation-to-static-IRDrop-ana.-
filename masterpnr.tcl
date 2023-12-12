
#FLOORPLAN

set step "floorplan"
set rpt_dir "./reports/$step"

setPinConstraint -side {top bottom} -layer {M2}
setPinConstraint -side {right left} -layer {M3}
floorPlan -r 1 0.7 30 30 30 30
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top metal5 bottom metal5 left metal6 right metal6} -width 12.6 -spacing 2.0 -offset 1.0
addStripe -set_to_set_distance 10 -spacing 10 -xleft_offset 0.7 -direction vertical -layer metal6 -width 0.7 -nets VSS
addStripe -set_to_set_distance 10 -spacing 10 -xleft_offset 5.7 -direction vertical -layer metal6 -width 0.7 -nets VDD
addStripe -set_to_set_distance 10 -spacing 10 -ybottom_offset 0.7 -direction horizontal -layer metal5 -width 0.7 -nets VSS
addStripe -set_to_set_distance 10 -spacing 10 -ybottom_offset 5.7 -direction horizontal -layer metal5 -width 0.7 -nets VDD
sroute
timeDesign -prePlace -outDir $rpt_dir -prefix $step
report_timing -format {instance pin cell net load slew delay arrival}

timeDesign -prePlace -expandedViews -numPaths 10 -outDir $rpt_dir -prefix $step
timeDesign -prePlace -hold -expandedViews -numPaths 10 -outDir $rpt_dir -prefix $step

timeDesign -prePlace -expandedViews -numPaths 10 -outDir $rpt_dir -prefix $step
reportGateCount -stdCellOnly -outfile $rpt_dir/stdGateCount.rpt
analyzeFloorplan -outfile $rpt_dir/analyzeFloorplan.rpt
verifyGeometry
saveDesign ./dataOut/designs/$step.enc

#PLACEMENT

set step "place" 
set rpt_dir "./reports/$step"
set_interactive_constraint_modes [all_constraint_modes -active]
setPlaceMode -fp false -placeIOPins 1 
place_opt_design
timeDesign -preCTS -outDir $rpt_dir -prefix $step
report_timing > reports/place/timing_report_postPlace.rpt
saveDesign ./dataOut/designs/$step.enc

#CTS

set step "CTS"
set rpt_dir "./reports/$step"
set_analysis_view -setup {worst_case} -hold {best_case}
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup 
cleanupSpecifyClockTree
add_ndr -name default_2x_space -spacing {metal1 0.38 metal2:metal5 0.42 metal6 0.84}

create_route_type -name leaf_rule  -non_default_rule default_2x_space -top_preferred_layer metal4 -bottom_preferred_layer metal2
create_route_type -name trunk_rule -non_default_rule default_2x_space -top_preferred_layer metal4 -bottom_preferred_layer metal2 -shield_net VSS -shield_side both_side
create_route_type -name top_rule   -non_default_rule default_2x_space -top_preferred_layer metal4 -bottom_preferred_layer metal2 -shield_net VSS -shield_side both_side

set_ccopt_property route_type -net_type leaf  leaf_rule
set_ccopt_property route_type -net_type trunk trunk_rule
set_ccopt_property route_type -net_type top   top_rule
set_ccopt_property target_max_trans 0.100
set_ccopt_property target_skew 0.150
set_ccopt_property max_fanout 20
set_ccopt_property update_io_latency 0

set_ccopt_property buffer_cells {CLKBUF_X2 CLKBUF_X3}
set_ccopt_property inverter_cells {INV_X4 INV_X8 INV_X16}

create_ccopt_clock_tree_spec -views {best_case} -file ./outData/fft16_ctsSpec.tcl
source ./outData/fft16_ctsSpec.tcl
ccopt_design

saveDesign ./dataOut/designs/$step.enc

#ROUTING

set step "Route"
set rpt_dir "./reports/$step"

set_analysis_view -setup {worst_case} -hold {best_case}
set_interactive_constraint_modes [ all_constraint_modes -active ]
set_propagated_clock [ all_clocks ]
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup
setFillerMode -doDRC false -corePrefix FILL -core "FILLCELL_X8 FILLCELL_X4 FILLCELL_X2 FILLCELL_X1" 
addFiller
setNanoRouteMode -routeWithSiDriven true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeAntennaCellName "ANTENNA"
setNanoRouteMode -routeWithTimingDriven true
routeDesign
saveDesign ./dataOut/designs/$step.enc

#OPTIMIZATION

set step "Optimization"
set rpt_dir "./reports/$step"
set dsgn_name [dbGet top.name]

#Timing options
set_analysis_view -setup {worst_case} -hold {best_case}
set_interactive_constraint_modes [ all_constraint_modes -active ]
set_propagated_clock [ all_clocks ]
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup

createBasicPathGroups
get_path_groups *

setDelayCalMode -reset
setDelayCalMode -engine Aae -SIAware true
setDelayCalMode -equivalent_waveform_model_type ecsm -equivalent_waveform_model_propagation true

# SI settings
setSIMode -reset
setSIMode -analysisType aae
setSIMode -detailedReports false
setSIMode -separate_delta_delay_on_data true
setSIMode -delta_delay_annotation_mode lumpedOnNet
setSIMode -num_si_iteration 3
setSIMode -enable_glitch_report true

#Routing options
setNanoRouteMode -routeWithSiDriven true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeAntennaCellName "ANTENNA"
setNanoRouteMode -routeWithTimingDriven true

#Filler removing
setFillerMode -doDRC false -corePrefix FILL -core "FILLCELL_X8 FILLCELL_X4 FILLCELL_X2 FILLCELL_X1"
deleteFiller

#Post route optimization
# Allow the usage of LVT cells for final setup fixing
#set_dont_use [get_lib_cells *LVT] false
# Allow the usage of Delay Cells for hold fixing
#set_dont_use   [get_lib_cells */DLY*] false
#set_dont_touch [get_lib_cells */DLY*] false
## Fix Setup and Hold ##
optDesign -postRoute -setup -hold -outDir $rpt_dir -prefix $step\_SetupHold -expandedViews

#Post route hold optimization
setOptMode -holdTargetSlack 0.075
setOptMode -fixHoldAllowSetupTnsDegrade false
optDesign -postRoute -hold -outDir $rpt_dir -prefix $step\HoldIncr -expandedViews

#Adding filler
addFiller


##Reporting 
timeDesign -postRoute -expandedViews -outDir $rpt_dir -prefix $step
timeDesign -postRoute -hold -expandedViews -outDir $rpt_dir -prefix $step\_hold

#Def exporting
defOut -floorplan -placement -netlist -routing ./outData/results/$step.def.gz
saveNetlist ./outDataresults/$dsgn_name\_$step.v -excludeLeafCell
saveNetlist ./outData/results/$dsgn_name\_$step.phys.v -excludeLeafCell -phys

##Design saving
saveDesign ./dataOut/designs/$step.enc
