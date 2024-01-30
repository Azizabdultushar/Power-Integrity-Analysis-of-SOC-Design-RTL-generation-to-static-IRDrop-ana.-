#######################
### innoRailAnalysis ##
#######################

#######################
## Load floorplan dB ##
#######################
source ./scripts/innoGlobal.tcl
source ../DesignDataIn/dbs/floorplan.enc

##########################
## Setup Timing options ##
##########################
set_analysis_view -setup {AV_fast_mode_wc_rc125_setup} -hold {AV_fast_mode_bc_rc0_hold}
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup

####################
## Fast Placement ##
####################
setPlaceMode -fp true
placeDesign -noPrePlaceOpt
refinePlace
fit
clearDrc

###########################################
## Pre Rail Analysis Structural Analysis ##
###########################################
verifyGeometry
#verifyConnectivity -noAntenna -noUnroutedNet
verifyPowerVia

####################
## Power Analysis ##
####################

set_power_analysis_mode -method static -analysis_view AV_fast_mode_wc_rc125_setup \
	-corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_power_output_dir ./PowerAnalysis
set_default_switching_activity -input_activity 0.75 -period 3.0 -global_activity 0.75
report_power -rail_analysis_format VS -outfile ./PowerAnalysis/sparc_exu_alu.rpt

######################################
## Setup Rail Analysis mode for VDD ##
######################################
set_rail_analysis_mode -method era_static -accuracy xd -power_grid_library  {../Library/pgv/techonly.cl ../Library/pgv/stdcells.cl}

set_pg_nets -net VDD -voltage 1.080 -threshold [expr 1.080 * 0.975]
set_power_data -reset
set_power_data -format current -scale 1 PowerAnalysis/static_VDD.ptiavg
set_power_pads -reset
set_power_pads -net VDD -format xy -file ../DesignDataIn/misc/Gemmini.VDD.1point.pp
set_package -reset
set_package -spice {} -mapping {}
set_net_group -reset
set_advanced_rail_options -reset
analyze_rail -type net -results_directory ./ VDD

######################################
## Setup Rail Analysis mode for VSS ##
######################################
## MANUAL TASK
##############

###################################
## Analyze Rail Analysis Results ##
###################################
## MANUAL TASK
##############


#exit


#################################################################################################################









############################
### innovus cmd file   #####
############################
#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Tue Jan 30 22:04:55 2024                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.35-s114_1 (64bit) 10/13/2022 12:11 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.35-s114_1 NR220912-2004/21_15-UB (database version 18.20.592_1) {superthreading v2.17}
#@(#)CDS: AAE 21.15-s039 (64bit) 10/13/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.15-s038_1 () Sep 20 2022 11:42:13 ( )
#@(#)CDS: SYNTECH 21.15-s012_1 () Sep  5 2022 10:25:51 ( )
#@(#)CDS: CPE v21.15-s076
#@(#)CDS: IQuantus/TQuantus 21.1.1-s867 (64bit) Sun Jun 26 22:12:54 PDT 2022 (Linux 3.10.0-693.el7.x86_64)

#######################################################
setDesignMode -process 45
setRouteMode -earlyGlobalMaxRouteLayer 4
setPinAssignMode -maxLayer 4
setNanoRouteMode -routeTopRoutingLayer 4
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup
set_global report_timing_format {instance pin cell net fanout load slew delay arrival edge incr_delay user_derate }
is_common_ui_mode
restoreDesign /usrf06/home/agids/stu/s_ids118/Project_wi23_24/Gemmini/gemminiwith45nm/DesignDataIn/dbs/floorplan.enc.dat Gemmini
set_analysis_view -setup {AV_fast_mode_wc_rc125_setup} -hold {AV_fast_mode_bc_rc0_hold}
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup
sroute
setPlaceMode -fp true
getPlaceMode -place_hierarchical_flow -quiet
report_message -start_cmd
getRouteMode -maxRouteLayer -quiet
getRouteMode -user -maxRouteLayer
getPlaceMode -place_global_place_io_pins -quiet
getPlaceMode -user -maxRouteLayer
getPlaceMode -quiet -adaptiveFlowMode
getPlaceMode -timingDriven -quiet
getPlaceMode -adaptive -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getPlaceMode -quiet -place_global_exp_enable_3d
getPlaceMode -exp_slack_driven -quiet
um::push_snapshot_stack
getDesignMode -quiet -flowEffort
getDesignMode -highSpeedCore -quiet
getPlaceMode -quiet -adaptive
set spgFlowInInitialPlace 1
getPlaceMode -sdpAlignment -quiet
getPlaceMode -softGuide -quiet
getPlaceMode -useSdpGroup -quiet
getPlaceMode -sdpAlignment -quiet
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -sdpPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -sdpPlace -quiet
getPlaceMode -groupHighLevelClkGate -quiet
setvar spgRptErrorForScanConnection 0
getPlaceMode -place_global_exp_allow_missing_scan_chain -quiet
getPlaceMode -ignoreScan -quiet
setvar spgRptErrorForScanConnection 1
getPlaceMode -place_design_floorplan_mode -quiet
getPlaceMode -place_check_library -quiet
getPlaceMode -trimView -quiet
getPlaceMode -expTrimOptBeforeTDGP -quiet
getPlaceMode -quiet -useNonTimingDeleteBufferTree
getPlaceMode -congEffort -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -congEffort -quiet
getPlaceMode -fp -quiet
getPlaceMode -timingDriven -quiet
getPlaceMode -user -timingDriven
getPlaceMode -fastFp -quiet
getPlaceMode -clusterMode -quiet
get_proto_model -type_match {flex_module flex_instgroup} -committed -name -tcl
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getPlaceMode -ultraCongEffortFlow -quiet
getPlaceMode -forceTiming -quiet
getPlaceMode -fp -quiet
getPlaceMode -fp -quiet
getExtractRCMode -quiet -engine
getAnalysisMode -quiet -clkSrcPath
getAnalysisMode -quiet -clockPropagation
getAnalysisMode -quiet -cppr
setExtractRCMode -engine preRoute
setAnalysisMode -clkSrcPath false -clockPropagation forcedIdeal
getPlaceMode -exp_slack_driven -quiet
isAnalysisModeSetup
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -quiet -NMPsuppressInfo
getPlaceMode -quiet -place_global_exp_wns_focus_v2
getPlaceMode -quiet -place_incr_exp_isolation_flow
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_buffer_chain
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_pipeline
getPlaceMode -place_global_exp_balance_buffer_chain -quiet
getPlaceMode -place_global_exp_balance_pipeline -quiet
getPlaceMode -tdgpMemFlow -quiet
getPlaceMode -user -resetCombineRFLevel
getPlaceMode -quiet -resetCombineRFLevel
setPlaceMode -resetCombineRFLevel 1000
setvar spgSpeedupBuildVSM 1
getPlaceMode -tdgpResetCteTG -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -place_global_replace_QP -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -expNewFastMode
setPlaceMode -expHiddenFastMode 1
setPlaceMode -reset -ignoreScan
getPlaceMode -quiet -place_global_exp_auto_finish_floorplan
colorizeGeometry
getPlaceMode -quiet -IOSlackAdjust
getPlaceMode -exp_slack_driven -quiet
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -ignoreUnproperPowerInit -quiet
getPlaceMode -quiet -expSkipGP
setDelayCalMode -engine feDc
setDelayCalMode -engine aae
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
get_ccopt_clock_trees *
getPlaceMode -exp_insert_guidance_clock_tree -quiet
getPlaceMode -exp_cluster_based_high_fanout_buffering -quiet
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getPlaceMode -exp_slack_driven -quiet
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -quiet -cong_repair_commit_clock_net_route_attr
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
setPlaceMode -reset -improveWithPsp
getPlaceMode -quiet -debugGlobalPlace
getPlaceMode -congRepair -quiet
getPlaceMode -fp -quiet
getPlaceMode -nrgrAware -quiet
getPlaceMode -fp -quiet
getPlaceMode -enableCongRepairV3 -quiet
getPlaceMode -user -rplaceIncrNPClkGateAwareMode
getPlaceMode -user -congRepairMaxIter
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -rplaceIncrNPClkGateAwareMode 4
getPlaceMode -quiet -expCongRepairPDOneLoop
setPlaceMode -congRepairMaxIter 1
getPlaceMode -quiet -congRepair
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -reset -rplaceIncrNPClkGateAwareMode
setPlaceMode -reset -congRepairMaxIter
getPlaceMode -congRepairCleanupPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getPlaceMode -tdgpDumpStageTiming -quiet
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
setvar spgRptErrorForScanConnection 0
getPlaceMode -trimView -quiet
getOptMode -quiet -viewOptPolishing
getOptMode -quiet -fastViewOpt
spInternalUse deleteViewOptManager
spInternalUse tdgp clearSkpData
setAnalysisMode -clkSrcPath false -clockPropagation forcedIdeal
getPlaceMode -exp_slack_driven -quiet
setExtractRCMode -engine preRoute
setPlaceMode -reset -relaxSoftBlockageMode
setPlaceMode -reset -ignoreScan
setPlaceMode -reset -repairPlace
getPlaceMode -quiet -NMPsuppressInfo
setvar spgSpeedupBuildVSM 0
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -place_global_replace_QP -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -tdgpMemFlow -quiet
setPlaceMode -reset -resetCombineRFLevel
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -enableDistPlace -quiet
setPlaceMode -reset -expHiddenFastMode
getPlaceMode -tcg2Pass -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -fp -quiet
getPlaceMode -quickCTS -quiet
set spgFlowInInitialPlace 0
getPlaceMode -user -maxRouteLayer
spInternalUse TDGP resetIgnoreNetLoad
getPlaceMode -place_global_exp_balance_pipeline -quiet
getDesignMode -quiet -flowEffort
report_message -end_cmd
um::create_snapshot -name final -auto min
um::pop_snapshot_stack
um::create_snapshot -name place_design
getPlaceMode -exp_slack_driven -quiet

refinePlace
fit
clearDrc
verifyPowerVia

set_power_analysis_mode -method static -analysis_view AV_fast_mode_wc_rc125_setup -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_power_output_dir ./PowerAnalysis
set_default_switching_activity -input_activity 0.75 -period 3.0 -global_activity 0.75
report_power -rail_analysis_format VS -outfile ./PowerAnalysis/sparc_exu_alu.rpt

set_rail_analysis_mode -method era_static -accuracy xd -power_grid_library {../Library/pgv/techonly.cl ../Library/pgv/stdcells.cl}
set_pg_nets -net VDD -voltage 1.080 -threshold 1.053
set_power_data -reset
set_power_data -format current -scale 1 PowerAnalysis/static_VDD.ptiavg
set_power_pads -reset
set_power_pads -net VDD -format xy -file ../DesignDataIn/misc/Gemmini.VDD.1point.pp
set_package -reset
set_package -spice {} -mapping {}
set_net_group -reset
set_advanced_rail_options -reset
analyze_rail -type net -results_directory ./ VDD

setDrawView fplan
setLayerPreference powerNet -color {#0000FF #0010DE #0020BD #00319C #00417B #00525A #006239 #007318 #088300 #299400 #4AA400 #6AB400 #8BC500 #ACD500 #CDE600 #EEF600 #FFF900 #FFED00 #FFE200 #FFD600 #FFCB00 #FFBF00 #FFB400 #FFA800 #FF9500 #FF8000 #FF6A00 #FF5500 #FF4000 #FF2A00 #FF1500 #FF0000}
set_power_rail_display -plot none
setLayerPreference powerNet -color {#0000ff #0010de #0020bd #00319c #00417b #00525a #006239 #007318 #088300 #299400 #4aa400 #6ab400 #8bc500 #acd500 #cde600 #eef600 #fff900 #ffed00 #ffe200 #ffd600 #ffcb00 #ffbf00 #ffb400 #ffa800 #ff9500 #ff8000 #ff6a00 #ff5500 #ff4000 #ff2a00 #ff1500 #ff0000}
set_power_rail_display -enable_voltage_sources 0
set_power_rail_display -enable_percentage_range 0
fit
set_power_rail_display -plot none
setLayerPreference powerNet -color {#0000ff #0010de #0020bd #00319c #00417b #00525a #006239 #007318 #088300 #299400 #4aa400 #6ab400 #8bc500 #acd500 #cde600 #eef600 #fff900 #ffed00 #ffe200 #ffd600 #ffcb00 #ffbf00 #ffb400 #ffa800 #ff9500 #ff8000 #ff6a00 #ff5500 #ff4000 #ff2a00 #ff1500 #ff0000}
::read_power_rail_results -rail_directory VDD_25C_avg_1 -instance_voltage_window { timing  whole  } -instance_voltage_method {  worst  best  avg  worstavg worstslidingavg bestslidingavg }
set_power_rail_display -plot ir
setLayerPreference powerNet -color {#0000ff #0010de #0020bd #00319c #00417b #00525a #006239 #007318 #088300 #299400 #4aa400 #6ab400 #8bc500 #acd500 #cde600 #eef600 #fff900 #ffed00 #ffe200 #ffd600 #ffcb00 #ffbf00 #ffb400 #ffa800 #ff9500 #ff8000 #ff6a00 #ff5500 #ff4000 #ff2a00 #ff1500 #ff0000}
uiSetTool defineArea ps::measure_region

set_power_rail_display -enable_result_browser 1
uiSetTool select
fit
setLayerPreference node_cell -isVisible 1
setLayerPreference net -isVisible 0
setLayerPreference power -isVisible 0
setLayerPreference pgPower -isVisible 0
setLayerPreference pgGround -isVisible 0
setLayerPreference clock -isVisible 0
setLayerPreference node_net -isVisible 1

set_power_rail_display -enable_result_browser 0
fit
saveDesign Gemmini_era2.enc
