
module sr(clk,out1,out2);
  input reg clk;
  output reg [7:0] out1,out2;
  reg [7:0] gen;
  reg t;
  
  initial gen = 8'b00000001;

  always @(posedge clk) begin
    t = gen[0]^gen[2]^gen[3]^gen[4];
    gen = {t,gen[7:1]};
  end
  
  bcd7seg seg0(gen[3:0],out1);
  bcd7seg seg1(gen[7:4],out2);

endmodule