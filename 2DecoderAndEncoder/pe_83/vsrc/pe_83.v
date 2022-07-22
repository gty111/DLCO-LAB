module pe_83(x,en,y,f,h,g);
  input [7:0] x;
  input en;
  output reg [2:0] y;
  output reg f;
  output reg [6:0] h;
  output g;
  
  assign g=1'b0;
  
  always @(x or en) begin
    if (en==0) begin
      /* verilator lint_off CASEX */
      casex (x)
          8'b0xxx_xxxx : y = 3'b000;
          8'b10xx_xxxx : y = 3'b001;
          8'b110x_xxxx : y = 3'b010;
          8'b1110_xxxx : y = 3'b011;
          8'b1111_0xxx : y = 3'b100;
          8'b1111_10xx : y = 3'b101;
          8'b1111_110x : y = 3'b110;
          8'b1111_1110 : y = 3'b111;
          8'b1111_1111 : y = 3'b111;
      endcase
      /* verilator lint_on CASEX */
      if (x==8'b0000_0000) 
        f = 0;
      else
        f = 1;
    end
    else begin 
      y=3'b111;
      f=1;
    end
    
  end

bcd7seg seg0(y,h);

endmodule



