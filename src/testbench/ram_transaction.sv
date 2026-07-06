class ram_transaction;
  rand bit [7:0] data_in;
  rand bit write_enb,read_enb;
  rand bit [4:0] address;
       bit [7:0]data_out;
constraint wr_rd_constraint {{write_enb,read_enb} inside {[0:3]};}
//constraint wr_not_equal_rd  {{write_enb,read_enb}!=2'b11;}

 virtual function ram_transaction copy();
  copy = new();
  copy.data_in=this.data_in;
  copy.write_enb=this.write_enb;
  copy.read_enb=this.read_enb;
  copy.address=this.address;
  return copy;
  endfunction
endclass 

class ram_transaction1 extends ram_transaction;
 constraint wr_rd_constraint {{write_enb,read_enb}==2'b01;}
 virtual function ram_transaction copy();
  ram_transaction1 copy1;
  copy1=new();
  copy1.data_in=this.data_in;
  copy1.write_enb=this.write_enb;
  copy1.read_enb=this.read_enb;
  copy1.address=this.address;
  return copy1;
  endfunction
endclass

class ram_transaction2 extends ram_transaction;
 constraint wr_rd_constraint {{write_enb,read_enb}==2'b10;}
 virtual function ram_transaction copy();
  ram_transaction2 copy2;
  copy2=new();
  copy2.data_in=this.data_in;
  copy2.write_enb=this.write_enb;
  copy2.read_enb=this.read_enb;
  copy2.address=this.address;
  return copy2;
  endfunction
endclass

class ram_transaction3 extends ram_transaction;
 constraint wr_not_equal_rd {{write_enb,read_enb}==2'b11;}
 constraint wr_rd_constraint {{write_enb,read_enb}==2'b11;}
 virtual function ram_transaction copy();
  ram_transaction3 copy3;
  copy3 = new();
  copy3.data_in=this.data_in;
  copy3.write_enb=this.write_enb;
  copy3.read_enb=this.read_enb;
  copy3.address=this.address;
  return copy3;
  endfunction
endclass

class ram_transaction4 extends ram_transaction;
 constraint wr_rd_constraint {{write_enb,read_enb}==2'b00;}
 virtual function ram_transaction copy();
  ram_transaction4 copy4;
  copy4=new();
  copy4.data_in=this.data_in;
  copy4.write_enb=this.write_enb;
  copy4.read_enb=this.read_enb;
  copy4.address=this.address;
  return copy4;
  endfunction
endclass




