`include "defines.sv"
class ram_monitor;
    ram_transaction mon_trans;
    mailbox #(ram_transaction) mbx_ms;
    virtual ram_if.MON vif;

  covergroup mon_cg;
    DATA_OUT: coverpoint mon_trans.data_out {bins  dout ={[0:255]};}
  endgroup

  function new( virtual ram_if.MON vif,
                mailbox #(ram_transaction) mbx_ms);
    this.vif=vif;
    this.mbx_ms=mbx_ms;
    mon_cg=new();
  endfunction

  task start();
   repeat(4) @(vif.mon_cb); 
    for(int i=0;i<`no_of_trans;i++)
      begin
        mon_trans=new();
        repeat(1) @(vif.mon_cb)
             begin
              mon_trans.data_out=vif.mon_cb.data_out;
              mon_trans.address=vif.mon_cb.address;
             end
        $display("[%0t]MONITOR PASSING THE DATA TO SCOREBOARD data_out=%d",$time,mon_trans.data_out);
        mbx_ms.put(mon_trans);
        mon_cg.sample();
        $display("OUTPUT FUNCTIONAL COVERAGE = %0d", mon_cg.get_coverage());
        repeat(1) @(vif.mon_cb);
      end
  endtask
endclass      
