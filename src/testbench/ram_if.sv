interface ram_if(input bit clk,reset);
  logic[7:0] data_in,data_out;
  logic      write_enb,read_enb;
  logic[4:0] address;

  clocking drv_cb@(posedge clk);
    default input #0 output #0;
    output write_enb,read_enb,data_in,address;
    input reset;
  endclocking

  clocking mon_cb@(posedge clk);
    default input #0 output #0;
    input data_out,address,reset;
  endclocking

  clocking ref_cb@(posedge clk);
    default input #0 output #0;
  endclocking

  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);
  modport REF_SB(clocking ref_cb);
endinterface

