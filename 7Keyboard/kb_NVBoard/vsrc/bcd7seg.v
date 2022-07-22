module bcd7seg(en,in,out);
  input [3:0] in;
  input en;
  output reg [7:0] out;
  
  always @(in or en) begin
    if(en) begin 
      case (in)
          4'b0000 : out = 8'b01000000;
          4'b0001 : out = 8'b01111001;
          4'b0010 : out = 8'b00100100;
          4'b0011 : out = 8'b00110000;
          4'b0100 : out = 8'b00011001;
          4'b0101 : out = 8'b00010010;
          4'b0110 : out = 8'b00000010;
          4'b0111 : out = 8'b01111000;
          4'b1000 : out = 8'b00000000;
          4'b1001 : out = 8'b00010000;
          4'b1010 : out = 8'b00001000;
          4'b1011 : out = 8'b00000011;
          4'b1100 : out = 8'b01000110;
          4'b1101 : out = 8'b00100001;
          4'b1110 : out = 8'b00000110;
          4'b1111 : out = 8'b00001110;
      endcase
    end
    else
      out = 8'b11111111;
  end
endmodule
