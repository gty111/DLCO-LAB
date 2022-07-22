module alu(x,y,s,z,f1,f2,f3);
  input [3:0] x,y;
  input [2:0] s;
  output reg [3:0] z;
  output reg f1,f2,f3;
  reg [3:0] t;
  /* verilator lint_off LATCH */
  always @(x or y or s) begin
    f1 = 1'b0;
    f2 = 1'b0;
    f3 = 1'b0;
    case (s)
        3'b000 : begin 
          {f3,z} = x + y;
          f1 = ~(|z);
          f2 = (x[3]==y[3])&&(z[3]!=x[3]);
        end
        3'b001 : begin 
          t = ~y;
          {f3,z} = x + t + 4'b0001;
          f1 = ~(|z);
          f2 = (x[3]==t[3])&&(z[3]!=x[3]);
        end
        3'b010 : begin z=~x; end
        3'b011 : begin z=x&y; end
        3'b100 : begin z=x|y; end
        3'b101 : begin z=x^y; end
        3'b110 : begin 
          t = ~y;
          z = x + t + 4'b0001;
          f2 = (x[3]==t[3])&&(z[3]!=x[3]);
          if (f2) begin
            if(x[3]==0)
              z = 4'b0000;
            else
              z = 4'b0001;
          end
          else begin
            if(z[3]==0)
              z = 4'b0000;
            else
              z = 4'b0001;
          end
          f2 = 0;
        end
        3'b111 : begin 
          if(x==y)
            z = 4'b0001;
          else 
            z = 4'b0000;
        end
    endcase        
  end
endmodule
