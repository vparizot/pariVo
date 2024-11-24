-L work
-reflib pmi_work
-reflib ovi_ice40up


"C:/Users/vparizot/E155/pariVo/pariVo_fpga/modelsim/dsp.sv" 
"C:/Users/vparizot/E155/pariVo/pariVo_fpga/modelsim/recursiveFilter.sv" 
"C:/Users/vparizot/E155/pariVo/pariVo_fpga/hardware_test.sv" 
"C:/Users/vparizot/E155/pariVo/pariVo_fpga/spi.sv" 
"C:/Users/vparizot/E155/pariVo/pariVo_fpga/modelsim/recursiveFilter_tb.sv" 
-sv
-optionset VOPTDEBUG
+noacc+pmi_work.*
+noacc+ovi_ice40up.*

-vopt.options
  -suppress vopt-7033
-end

-gui
-top get_all_taps_tb
-vsim.options
  -suppress vsim-7033,vsim-8630,3009,3389
-end

-do "view wave"
-do "add wave /*"
-do "run 100 ns"
