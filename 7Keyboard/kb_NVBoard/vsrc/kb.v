module kb(clk,
          rst,
          ps2_clk,
          ps2_data,
          scan_out_h,
          scan_out_l,
          count_out_h,
          count_out_l,
          ascii_out_l,
          ascii_out_h);
  input clk,rst,ps2_clk,ps2_data;
  output reg [7:0] scan_out_h,
                   scan_out_l,
                   count_out_h,
                   count_out_l,
                   ascii_out_l,
                   ascii_out_h;
  reg [7:0] scan_code,count,ascii;
  reg en;

  lut my_lut(scan_code,ascii);
  ps2_keyboard my_keyboard(clk,~rst,ps2_clk,ps2_data,scan_code,en,count);
  bcd7seg my_bcd7seg_scan_l(en,scan_code[3:0],scan_out_l);
  bcd7seg my_bcd7seg_scan_h(en,scan_code[7:4],scan_out_h);
  bcd7seg my_bcd7seg_ascii_l(en,ascii[3:0],ascii_out_l);
  bcd7seg my_bcd7seg_ascii_h(en,ascii[7:4],ascii_out_h);
  bcd7seg my_bcd7seg_count_l(1,count[3:0],count_out_l);
  bcd7seg my_bcd7seg_count_h(1,count[7:4],count_out_h);


  initial count = 0;
endmodule
