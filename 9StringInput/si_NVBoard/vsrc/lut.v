module lut(clk,shift,scan_code,ascii);
  input clk;
  input [7:0] scan_code;
  input reg shift;
  output reg [7:0] ascii;

  always @(posedge clk) begin
      case (scan_code)
      8'h16 : begin 
        if(shift==0)
          ascii = 8'h31 ; //1
        else 
          ascii = 8'h21; // !
      end
      8'h1E : begin 
        if(shift==0)
          ascii = 8'h32 ; //2
        else 
          ascii = 8'h40; // @
      end
      8'h26 : begin 
        if(shift==0)
          ascii = 8'h33 ; //3
        else 
          ascii = 8'h23; // #
      end
      8'h25 : begin 
        if(shift==0)
          ascii = 8'h34 ; //4
        else 
          ascii = 8'h24; // $
      end
      8'h2E : begin 
        if(shift==0)
          ascii = 8'h35 ; //5
        else 
          ascii = 8'h25; // %
      end
      8'h36 : begin 
        if(shift==0)
          ascii = 8'h36 ; //6
        else 
          ascii = 8'h5E; // ^
      end
      8'h3D : begin
        if(shift==0)
          ascii = 8'h37 ; //7
        else 
          ascii = 8'h26; // &
      end
      8'h3E : begin 
        if(shift==0)
          ascii = 8'h38 ; //8
        else 
          ascii = 8'h2A; // *
      end
      8'h46 : begin 
        if(shift==0)
          ascii = 8'h39 ; //9
        else 
          ascii = 8'h28; // (
      end
      8'h45 : begin
        if(shift==0)
          ascii = 8'h30 ; //0
        else 
          ascii = 8'h29; // )
      end
      8'h15 : ascii = 8'h71 ; //q
      8'h1D : ascii = 8'h77 ; //w
      8'h24 : ascii = 8'h65 ; //e
      8'h2D : ascii = 8'h72 ; //r
      8'h2C : ascii = 8'h74 ; //t
      8'h35 : ascii = 8'h79 ; //y
      8'h3C : ascii = 8'h75 ; //u
      8'h43 : ascii = 8'h69 ; //i
      8'h44 : ascii = 8'h6F ; //o
      8'h4D : ascii = 8'h70 ; //p
      8'h1C : ascii = 8'h61 ; //a
      8'h1B : ascii = 8'h73 ; //s
      8'h23 : ascii = 8'h64 ; //d
      8'h2B : ascii = 8'h66 ; //f
      8'h34 : ascii = 8'h67 ; //g
      8'h33 : ascii = 8'h68 ; //h
      8'h3B : ascii = 8'h6A ; //j
      8'h42 : ascii = 8'h6B ; //k
      8'h4B : ascii = 8'h6C ; //l
      8'h1A : ascii = 8'h7A ; //z
      8'h22 : ascii = 8'h78 ; //x
      8'h21 : ascii = 8'h63 ; //c
      8'h2A : ascii = 8'h76 ; //v
      8'h32 : ascii = 8'h62 ; //b
      8'h31 : ascii = 8'h6E ; //n
      8'h3A : ascii = 8'h6D ; //m
      8'h29 : ascii = 8'h20 ; //space
      8'h4E : begin 
        if(shift==0)
          ascii = 8'h2D ; // -
        else 
          ascii = 8'h5F; // _
      end 
      8'h55 : begin
        if(shift==0)
          ascii = 8'h3D ; // =
        else 
          ascii = 8'h2B; // +
      end
      8'h54 : begin
        if(shift==0)
          ascii = 8'h5B ; // [
        else 
          ascii = 8'h7B; // {
      end
      8'h5B : begin
        if(shift==0)
          ascii = 8'h5D ; // ]
        else 
          ascii = 8'h7D; // }
      end
      8'h5D : begin
        if(shift==0)
          ascii = 8'h5C ; // \
        else 
          ascii = 8'h7C; // |
      end
      8'h4C : begin
        if(shift==0)
          ascii = 8'h3B ; // ;
        else 
          ascii = 8'h3A; // :
      end
      8'h52 : begin 
        if(shift==0)
          ascii = 8'h27 ; // '
        else 
          ascii = 8'h22; // "
      end
      8'h41 : begin 
        if(shift==0)
          ascii = 8'h2C ; // ,
        else 
          ascii = 8'h3C; // <
      end
      8'h49 : begin 
        if(shift==0)
          ascii = 8'h2E ; // .
        else 
          ascii = 8'h3E; // >
      end 
      8'h4A : begin
        if(shift==0)
          ascii = 8'h2F ; // /
        else 
          ascii = 8'h3F; // ?
      end
      8'h0E : begin
        if(shift==0)
          ascii = 8'h60 ; // `
        else 
          ascii = 8'h7E; // ~
      end
      default : ascii = 8'hFF;
      endcase 
      if (ascii>=8'h61 && ascii <=8'h7A && shift)
        ascii = ascii - 8'h20; // 转换为大写
  end
endmodule