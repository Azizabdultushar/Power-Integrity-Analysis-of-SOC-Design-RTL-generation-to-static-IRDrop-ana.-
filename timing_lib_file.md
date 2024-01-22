```

library (fast_vdd1v0) {
  /* Models written by Liberate 12.1 from Cadence Design Systems, Inc. on Mon Apr 22 15:24:32 PDT 2013 */
  comment : "";
  date : "$Date: Fri Sep 26 12:16:27 2014 $";
  revision : "1.0";
  delay_model : table_lookup;
  capacitive_load_unit (1,pf);
  current_unit : "1mA";
  leakage_power_unit : "1pW";
  pulling_resistance_unit : "1kohm";
  time_unit : "1ns";
  voltage_unit : "1V";
  voltage_map (VDD, 1.1);
  voltage_map (VSS, 0);
  voltage_map (ExtVDD, 1.1);
  voltage_map (GND, 0);
  voltage_map (ExtVSS, 0);
  default_cell_leakage_power : 0;
  default_fanout_load : 1;
  default_max_transition : 0.28;
  default_output_pin_cap : 0;
  in_place_swap_mode : match_footprint;
  input_threshold_pct_fall : 50;
  input_threshold_pct_rise : 50;
  nom_process : 1;
  nom_temperature : 0;
  nom_voltage : 1.1;
  output_threshold_pct_fall : 50;
  output_threshold_pct_rise : 50;
  slew_derate_from_library : 0.5;
  slew_lower_threshold_pct_fall : 30;
  slew_lower_threshold_pct_rise : 30;
  slew_upper_threshold_pct_fall : 70;
  slew_upper_threshold_pct_rise : 70;
  operating_conditions (PVT_1P1V_0C) {
    process : 1;
    temperature : 0;
    voltage : 1.1;
  }
  default_operating_conditions : PVT_1P1V_0C;
  lu_table_template (constraint_template_2x2) {
    variable_1 : constrained_pin_transition;
    variable_2 : related_pin_transition;
    index_1 ("0.008, 0.28");
    index_2 ("0.008, 0.28");
  }
  lu_table_template (constraint_template_7x7) {
    variable_1 : constrained_pin_transition;
    variable_2 : related_pin_transition;
    index_1 ("0.008, 0.04, 0.08, 0.12, 0.16, 0.224, 0.28");
    index_2 ("0.008, 0.04, 0.08, 0.12, 0.16, 0.224, 0.28");
  }
  lu_table_template (delay_template_2x2) {
    variable_1 : input_net_transition;
    variable_2 : total_output_net_capacitance;
    index_1 ("0.008, 0.28");
    index_2 ("0.01, 0.3");
  }
  lu_table_template (delay_template_7x7) {
    variable_1 : input_net_transition;
    variable_2 : total_output_net_capacitance;
    index_1 ("0.008, 0.04, 0.08, 0.12, 0.16, 0.224, 0.28");
    index_2 ("0.01, 0.06, 0.1, 0.15, 0.2, 0.25, 0.3");
  }
  lu_table_template (mpw_constraint_template_2x2) {
    variable_1 : constrained_pin_transition;
    index_1 ("0.008, 0.28");
  }
  lu_table_template (mpw_constraint_template_7x7) {
    variable_1 : constrained_pin_transition;
    index_1 ("0.008, 0.04, 0.08, 0.12, 0.16, 0.224, 0.28");
  }
  power_lut_template (passive_power_template_2x1) {
    variable_1 : input_transition_time;
    index_1 ("0.008, 0.28");
  }
  power_lut_template (passive_power_template_7x1) {
    variable_1 : input_transition_time;
    index_1 ("0.008, 0.04, 0.08, 0.12, 0.16, 0.224, 0.28");
  }
  power_lut_template (power_template_2x2) {
    variable_1 : input_transition_time;
    variable_2 : total_output_net_capacitance;
    index_1 ("0.008, 0.28");
    index_2 ("0.01, 0.3");
  }
  power_lut_template (power_template_7x7) {
    variable_1 : input_transition_time;
    variable_2 : total_output_net_capacitance;
    index_1 ("0.008, 0.04, 0.08, 0.12, 0.16, 0.224, 0.28");
    index_2 ("0.01, 0.06, 0.1, 0.15, 0.2, 0.25, 0.3");
  }
  cell (ACHCONX2) {
    area : 12.654;
    pg_pin (VDD) {
      pg_type : primary_power;
      voltage_name : "VDD";
    }
    pg_pin (VSS) {
      pg_type : primary_ground;
      voltage_name : "VSS";
    }
    leakage_power () {
      value : 552.953;
      when : "(A&B&CI)";
      related_pg_pin : VDD;
    }
    leakage_power () {
      value : 596.195;
      when : "(A&B&!CI)";
      related_pg_pin : VDD;
    }
    leakage_power () {
      value : 628.259;
      when : "(A&!B&CI)";
      related_pg_pin : VDD;
    }
    leakage_power () {
      value : 648.741;
      when : "(A&!B&!CI)";
      related_pg_pin : VDD;
    }
    leakage_power () {
      value : 579.513;
      when : "(!A&B&CI)";
      related_pg_pin : VDD;
    }
    leakage_power () {
      value : 658.199;
      when : "(!A&B&!CI)";
      related_pg_pin : VDD;
    }
    leakage_power () {
      value : 690.263;
      when : "(!A&!B&CI)";
      related_pg_pin : VDD;
    }
    leakage_power () {
      value : 675.301;
      when : "(!A&!B&!CI)";
      related_pg_pin : VDD;
    }
    leakage_power () {
      value : 628.678;
      related_pg_pin : VDD;
    }
    pin (CON) {
      direction : "output";
      function : "(!(((A B)+(B CI))+(CI A)))";
      related_ground_pin : VSS;
      related_power_pin : VDD;
      max_capacitance : 0.3;
      timing () {
        related_pin : "A";
        timing_sense : negative_unate;
        timing_type : combinational;
        cell_rise (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0682893, 0.952669", \
            "0.124727, 1.00911" \
          );
        }
        rise_transition (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0751211, 1.90045", \
            "0.0748892, 1.90092" \
          );
        }
        cell_fall (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0764209, 1.12744", \
            "0.145791, 1.19665" \
          );
        }
        fall_transition (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0939736, 2.39349", \
            "0.093595, 2.39534" \
          );
        }
      }
      timing () {
        related_pin : "B";
        timing_sense : negative_unate;
        timing_type : combinational;
        cell_rise (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0543407, 0.941196", \
            "0.118232, 1.03961" \
          );
        }
        rise_transition (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0745949, 1.90045", \
            "0.102756, 1.90274" \
          );
        }
        cell_fall (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0597012, 1.11353", \
            "0.138995, 1.22957" \
          );
        }
        fall_transition (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.09333, 2.39359", \
            "0.126375, 2.39673" \
          );
        }
      }
      timing () {
        related_pin : "CI";
        timing_sense : negative_unate;
        timing_type : combinational;
        cell_rise (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0430658, 0.932782", \
            "0.111876, 1.03666" \
          );
        }
        rise_transition (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0733171, 1.90022", \
            "0.108092, 1.90246" \
          );
        }
        cell_fall (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0514442, 1.10797", \
            "0.134237, 1.22794" \
          );
        }
        fall_transition (delay_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.0923676, 2.39358", \
            "0.131079, 2.39685" \
          );
        }
      }
      internal_power () {
        related_pin : "A";
        related_pg_pin : VDD;
        rise_power (power_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.00669384, 0.00645652", \
            "0.00683297, 0.00651702" \
          );
        }
        fall_power (power_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.00549998, 0.00520603", \
            "0.00561897, 0.00525317" \
          );
        }
      }
      internal_power () {
        related_pin : "B";
        related_pg_pin : VDD;
        rise_power (power_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.00724306, 0.0071932", \
            "0.00806178, 0.00786353" \
          );
        }
        fall_power (power_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.00351364, 0.003521", \
            "0.00420382, 0.00420951" \
          );
        }
      }
      internal_power () {
        related_pin : "CI";
        related_pg_pin : VDD;
        rise_power (power_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.00235724, 0.00238632", \
            "0.0023888, 0.00248509" \
          );
        }
        fall_power (power_template_2x2) {
          index_1 ("0.008, 0.28");
          index_2 ("0.01, 0.3");
          values ( \
            "0.00126293, 0.00127407", \
            "0.00129607, 0.00132778" \
          );
        }
      }
    }
    pin (A) {
      direction : "input";
      related_ground_pin : VSS;
      related_power_pin : VDD;
      max_transition : 0.28;
      capacitance : 0.000867751;
      rise_capacitance : 0.000867751;
      rise_capacitance_range (0.00084909, 0.000886884);
      fall_capacitance : 0.000716081;
      fall_capacitance_range (0.000696947, 0.000735097);
      internal_power () {
        related_pg_pin : VDD;
        rise_power (passive_power_template_2x1) {
          index_1 ("0.008, 0.28");
          values ( \
            "0.00437208, 0.00440465" \
          );
        }
        fall_power (passive_power_template_2x1) {
          index_1 ("0.008, 0.28");
          values ( \
            "0.00564761, 0.00567081" \
          );
        }
      }
    }
    pin (B) {
      direction : "input";
      related_ground_pin : VSS;
      related_power_pin : VDD;
      max_transition : 0.28;
      capacitance : 0.002902;
      rise_capacitance : 0.002902;
      rise_capacitance_range (0.00275025, 0.00304075);
      fall_capacitance : 0.00245728;
      fall_capacitance_range (0.00230995, 0.00259233);
      internal_power () {
        related_pg_pin : VDD;
        rise_power (passive_power_template_2x1) {
          index_1 ("0.008, 0.28");
          values ( \
            "0.00310275, 0.00391623" \
          );
        }
        fall_power (passive_power_template_2x1) {
          index_1 ("0.008, 0.28");
          values ( \
            "0.00647419, 0.00709168" \
          );
        }
      }
    }
    pin (CI) {
      direction : "input";
      related_ground_pin : VSS;
      related_power_pin : VDD;
      max_transition : 0.28;
      capacitance : 0.000862252;
      rise_capacitance : 0.000862252;
      rise_capacitance_range (0.000817414, 0.000897662);
      fall_capacitance : 0.00071449;
      fall_capacitance_range (0.000673371, 0.000758517);
      internal_power () {
        related_pg_pin : VDD;
        rise_power (passive_power_template_2x1) {
          index_1 ("0.008, 0.28");
          values ( \
            "0.000301625, 0.000500909" \
          );
        }
        fall_power (passive_power_template_2x1) {
          index_1 ("0.008, 0.28");
          values ( \
            "0.00138209, 0.00158484" \
          );
        }
      }
    }
  }

```
