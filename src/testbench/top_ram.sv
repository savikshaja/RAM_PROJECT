`include "ram.sv"
`include "ram_if.sv"
`include "ram_pkg.sv"
module top( );
    import ram_pkg ::*; 
    bit clk;
    bit reset;
  initial
    begin
     forever #10 clk=~clk;
    end
  initial
    begin
	reset=1;
      @(posedge clk);
      reset=0;
      repeat(3)@(posedge clk);
      reset=1;
    end
    ram_if intrf(clk,reset);
    RAM DUV(.data_in(intrf.data_in),
            .write_enb(intrf.write_enb),
            .read_enb(intrf.read_enb),
            .data_out(intrf.data_out),
            .address(intrf.address),
            .clk(clk),
            .reset(reset)
           );
    test_regression tb_regression= new(intrf.DRV,intrf.MON,intrf.REF_SB); 
  initial
   begin
   tb_regression.run();
    $finish();
   end
endmodule



