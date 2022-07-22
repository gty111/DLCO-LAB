module ps2_keyboard(clk,resetn,ps2_clk,ps2_data,scan_code,en,count_num);
    input clk,resetn,ps2_clk,ps2_data;
    output reg [7:0] scan_code,count_num;
    output reg en;

    reg [7:0] last_scan_code;
    reg [9:0] buffer;        // ps2_data bits
    reg [3:0] count;  // count ps2_data bits
    reg [2:0] ps2_clk_sync;

    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
        if (resetn == 0) begin // reset
            count <= 0;
        end
        else begin
            if (sampling) begin
              if (count == 4'd10) begin
                if ((buffer[0] == 0) &&  // start bit
                    (ps2_data)       &&  // stop bit
                    (^buffer[9:1])) begin      // odd  parity
                    $display("recieve %x", buffer[8:1]);
                    if(last_scan_code!=8'b11110000 && buffer[8:1]!=8'b11110000) begin
                      if(scan_code != buffer[8:1])
                        count_num <= count_num + 1;
                      scan_code <= buffer[8:1];
                      en <= 1;
                    end
                    else begin
                      scan_code <= 8'b00000000;
                      en <= 0;
                    end
                    last_scan_code <= buffer[8:1];
                end
                count <= 0;     // for next
              end else begin
                buffer[count] <= ps2_data;  // store ps2_data
                count <= count + 3'b1;
              end
            end
        end
    end

endmodule