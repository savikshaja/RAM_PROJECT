`include "defines.sv"
class ram_reference_model;
   ram_transaction ref_trans;
   mailbox #(ram_transaction) mbx_rs;
   mailbox #(ram_transaction) mbx_dr;
   virtual ram_if.REF_SB vif;
   bit [7:0] MEM [31:0];

  function new(mailbox #(ram_transaction) mbx_dr,mailbox #(ram_transaction) mbx_rs, virtual ram_if.REF_SB vif);
    this.mbx_dr=mbx_dr;
    this.mbx_rs=mbx_rs;
    this.vif=vif;
  endfunction

  task start();
    for(int i=0;i<`no_of_trans;i++)
     begin
      ref_trans=new();
      mbx_dr.get(ref_trans);
      repeat(1) @(vif.ref_cb)
       begin 
        if(ref_trans.write_enb&&!ref_trans.read_Enb)
         MEM[ref_trans.address]=ref_trans.data_in;
        $display("[%0t]REFERENCE MODEL DATA IN MEMORY MEM[ADDRESS]=%d",$time,MEM[ref_trans.address]);
        if(ref_trans.read_enb&&!ref_trans.write)
         ref_trans.data_out=MEM[ref_trans.address];
        $display("[%0t]REFERENCE MODEL DATA OUT FROM MEMORY data_out=%d",$time,ref_trans.data_out);
       end
      mbx_rs.put(ref_trans);
     end 
  endtask
endclass
 

