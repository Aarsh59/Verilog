module single_port_ram(
  input[7:0] data , 
  input [5:0] address ,
  input we , 
  input clk , 
  output [7:0] out
);
  reg[7:0] ram[63:0] ; 
  reg[5:0] addr_reg ; 
  always@(posedge clk)
    begin
      if(we)
        ram[address]=data;
      else
        addr_reg<=address;
    end
  assign q = ram[addr_reg];
endmodule
module dual_port_ram(
  input[7:0] dataa ,
  input[7:0] datab , 
  input[5:0] addr_a,
  input[5:0] addr_b,
  input wea , 
  input web , 
  input clk , 
  output reg[7:0] qa , 
  output reg[7:0] qb ,
  
  
);
  reg[7:0] ram[63:0];
  always@(posedge clk)
    begin
      if(wea)
        ram[addr_a]=dataa;
      else
        qa<=ram[addr_a];
    end
  always@(posedge clk)
    begin
      if(web)
        ram[addr_b]=datab;
      else
        qb<=ram[addr_b];
    end
endmodule
module rom (
  input clk , 
  input en, 
  input[3:0] addr , 
  output [3:0] data 
  
  
  
  
);
  reg[3:0] mem[15:0] ; 
  always@(posedge clk)
    begin
      if(en)
        data<=mem[addr];
      else
        data<=4'bxxxx;
    end
  initial 
    begin
      
      mem[0]=4'b0010;
      mem[1]=4'b0010;
      mem[2]=4'b1110;
      mem[3]=4'b0010;
      mem[4]=4'b0100;
      mem[5]=4'b1010;
      mem[6]=4'b1100;
      mem[7]=4'b0000;
      mem[8]=4'b1010;
      mem[9]=4'b0010;
      mem[10]=4'b1110;
      mem[11]=4'b0010;
      mem[12]=4'b0100;
      mem[13]=4'b1010;
      mem[14]=4'b1100;
      mem[15]=4'b0000;
    end
endmodule
        