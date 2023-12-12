#+LANGUAGE: en
#+SELECT_TAGS: export
#+HTML_HEAD: <link rel="stylesheet" type="text/css" href="http://www.pirilampo.org/styles/readtheorg/css/htmlize.css"/>
#+HTML_HEAD: <link rel="stylesheet" type="text/css" href="http://www.pirilampo.org/styles/readtheorg/css/readtheorg.css"/>
#+HTML_HEAD: <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
#+HTML_HEAD: <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
#+HTML_HEAD: <script type="text/javascript" src="http://www.pirilampo.org/styles/lib/js/jquery.stickytableheaders.js"></script>
#+HTML_HEAD: <script type="text/javascript" src="http://www.pirilampo.org/styles/readtheorg/js/readtheorg.js"></script>



+ viewDefinition file: Analysis view setup

# From viewDefinition.tcl

create_library_set -name LS_bc\
   -timing\
    [list ../data/libs/fast.lib_ecsm\
    ../data/libs/pll.lib\
    ../data/libs/bufao.lib\
    ../data/libs/pso_header.lib\
    ../data/libs/pso_ring.lib]

create_library_set -name LS_wc\
   -timing\
    [list ../data/libs/slow.lib_ecsm\
    ../data/libs/pll.lib\
    ../data/libs/bufao.lib\
    ../data/libs/pso_header.lib\
    ../data/libs/pso_ring.lib]

create_op_cond -name OC_wc -library_file ../data/libs/slow.lib_ecsm -P 1 -V 0.9 -T 125
create_op_cond -name OC_bc -library_file ../data/libs/fast.lib_ecsm -P 1 -V 1.1 -T 0

create_rc_corner -name RC_bc_0\
   -T 0\
   -qx_tech_file ../data/qrc/gpdk090_9l.tch

create_rc_corner -name RC_wc_125\
   -T 125\
   -qx_tech_file ../data/qrc/gpdk090_9l.tch

create_delay_corner -name DC_wc\
   -rc_corner RC_wc_125\
   -library_set LS_wc\
   -opcond_library slow\
   -opcond OC_wc

update_delay_corner -name DC_wc -power_domain PD_external\
   -library_set LS_wc\
   -opcond_library slow\
   -opcond OC_wc
update_delay_corner -name DC_wc -power_domain PD_ring\
   -library_set LS_wc\
   -opcond_library slow\
   -opcond OC_wc
update_delay_corner -name DC_wc -power_domain PD_column\
   -library_set LS_wc\
   -opcond_library slow\
   -opcond OC_wc
update_delay_corner -name DC_wc -power_domain PD_AO\
   -library_set LS_wc\
   -opcond_library slow\
   -opcond OC_wc

create_delay_corner -name DC_bc\
   -library_set LS_bc\
   -rc_corner RC_bc_0\
   -opcond_library fast\
   -opcond OC_bc

update_delay_corner -name DC_bc -power_domain PD_external\
   -library_set LS_wc\
   -opcond_library slow\
   -opcond OC_bc
update_delay_corner -name DC_bc -power_domain PD_ring\
   -library_set LS_wc\
   -opcond_library slow\
   -opcond OC_bc
update_delay_corner -name DC_bc -power_domain PD_column\
   -library_set LS_wc\
   -opcond_library slow\
   -opcond OC_bc
update_delay_corner -name DC_bc -power_domain PD_AO\
   -library_set LS_bc\
   -opcond_library fast\
   -opcond OC_bc

# define constraints
create_constraint_mode -name CM_base\
   -sdc_files\
    [list ../design/base.sdc]
create_constraint_mode -name PM_off\
   -sdc_files\
    [list ../design/base.sdc]
create_constraint_mode -name PM_on\
   -sdc_files\
    [list ../design/base.sdc]

# define views
create_analysis_view -name AV_bc_off -constraint_mode PM_off -delay_corner DC_bc
create_analysis_view -name AV_bc_on  -constraint_mode PM_on  -delay_corner DC_bc
create_analysis_view -name AV_wc_off -constraint_mode PM_off -delay_corner DC_wc
create_analysis_view -name AV_wc_on  -constraint_mode PM_on  -delay_corner DC_wc

# active views
set_analysis_view -setup [list AV_wc_on ] -hold [list AV_wc_on ]
