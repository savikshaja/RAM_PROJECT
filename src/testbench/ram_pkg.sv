/************************************************************************
Copyright 2013-2014 - RV-VLSI. All Rights Reserved.
*************************************************************************
Author:         gerard@rv-vlsi.com

Filename:	ram_pkg.sv   

Date:   	1st July 2014

Version:	1.0
************************************************************************/
//This package includes all the files in the testbench architecture 
//which will be imported in the top module
`include "defines.sv"
package ram_pkg;
  `include "ram_transaction.sv"
  `include "ram_generator.sv"
  `include "ram_driver.sv"
  `include "ram_monitor.sv"
  `include "ram_reference_model.sv"
  `include "ram_scoreboard.sv"
  `include "ram_environment.sv"
  `include "ram_test.sv"
endpackage

