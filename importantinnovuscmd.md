# INNOVUS TERMINAL COMMAND REF
  1. Multi-Mode Analysis View Report:> report_analysis_view -type all
  2. verifying DRC:> verify_drc
  3. verifying connectivity:>> verify_connectivity
  4. physical layer name:>> dbGet head.layers.extName
  5. or >>dbGet head.layers.name
  6. current design name:>> current_design
  7. totall number of instances:>> sizeof_collection [get_cells -hier -filter "is_hierarchical == false"]
  8. total number of IO pin:>> sizeof_collection [get_ports *]
  9. total number of memory: get_cells -hier -filter "is_memory_cell ==true"
  10. suppress or omitting warning messege: > suppressMessage IMPOAX 124 332
11. view all analysis view setup during floorplan: all_analysis_view
12.  view ndr rules or to see existing rules: dbGet head.rules.name
13.  
