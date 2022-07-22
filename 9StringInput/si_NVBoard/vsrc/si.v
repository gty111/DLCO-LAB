module si(
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    output VGA_CLK,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_BLANK_N,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B
    );
    reg [23:0] vga_mem [524287:0]; // 显存
    reg [23:0] ascii_graph [32767:0]; //ascii转点阵图
    reg [23:0] cursor_dis; // 光标的点阵图
    reg [7:0] scan_code,ascii; // 键盘扫描码和按键的ascii码
    reg [18:0] count,count_last,bias; // 光标位置或按键计数 上一次的按键计数 偏移量(用于滚动页面)
    reg f_null,shift; // 判断是否为空白字符 判断是否按下shift
    initial begin
        $readmemh("resource/str.hex", ascii_graph);
        count_last = 0;
        count = 0;
        count_cursor = 0;
        cursor_dis = 0;
        shift = 0;
        bias = 0;
    end
    
    assign VGA_CLK = clk;

    wire [9:0] h_addr;
    wire [9:0] v_addr;
    wire [23:0] vga_data;

    vga_ctrl my_vga_ctrl(
    .pclk(clk),
    .reset(rst),
    .vga_data(vga_data),
    .h_addr(h_addr),
    .v_addr(v_addr),
    .hsync(VGA_HSYNC),
    .vsync(VGA_VSYNC),
    .valid(VGA_BLANK_N),
    .vga_r(VGA_R),
    .vga_g(VGA_G),
    .vga_b(VGA_B)
    );

    ps2_keyboard my_ps2_keyboard(
    .clk(clk),
    .resetn(~rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .scan_code(scan_code),
    .count_num(count),
    .shift(shift)
    );

    lut my_lut(
    .clk(clk),
    .shift(shift),
    .scan_code(scan_code),
    .ascii(ascii)
    );
    
    integer i,j,row_b,col_b,c,idx,count_cursor,last_cursor;

    always @(posedge clk)begin
        if(count != count_last)begin // 检测到按键
            c[18:0] = count;
            case(scan_code)
            8'h5A : begin // 换行
                count = count - 1; // 抵消掉由于本身按键造成的count+1
                c = c - 1;
                if(count % 80 == 0) begin
                    count = count + 80;
                    c = c + 80;
                end
                else begin 
                    c = (c / 80 + 1) * 80;   
                    count = c[18:0];
                end
                if(count>=2400+bias/16*80)begin //向下滚动页面
                    for(i=0;i<16;i++)begin // 清空第一行
                        for(j=0;j<640;j++)begin
                            /* verilator lint_off WIDTH */
                            vga_mem[480*j+i+bias] = 24'h0;
                            /* verilator lint_on WIDTH */
                        end
                    end
                    bias += 16;
                end
            end
            8'h66 : begin //退格
                count = count - 1;
                c = c - 1;
                if(c[18:0] != bias)begin
                    row_b = (c-1) / 80 * 16;
                    col_b = (c-1) % 80 * 8;
                    for(j=col_b;j<col_b+8;j++)begin
                        for(i=row_b;i<row_b+16;i++)begin
                        vga_mem[480*j+i] = 24'h0;
                        end
                    end
                    c = c - 1;
                    count = count - 1;
                    if((c+1)%80==0)begin //保证光标停留在非空白符后面
                        f_null = 0;
                        while(!f_null)begin
                            row_b = (c-1) / 80 * 16;
                            col_b = (c-1) % 80 * 8;
                            for(j=col_b;j<col_b+8;j++)begin
                                for(i=row_b;i<row_b+16;i++)begin
                                    f_null = f_null | (|vga_mem[480*j+i]);
                                end
                            end
                            if(!f_null)begin
                                c = c - 1;
                                count = count - 1;
                            end
                        end
                    end
                end
            end
            8'h75 : begin //向上移动光标
                count = count - 1;
                if(count /80 > bias/16) count = count - 80;
            end
            8'h72 : begin //向下移动光标
                count = count - 1;
                if(count + 80 < 2400 + bias/16*80)
                    count = count + 80;
            end
            8'h6B : begin //向左移动光标
                count = count - 1;
                if(count > bias/16*80)
                    count = count - 1;
            end
            8'h74 : begin //向右移动光标
                count = count - 1;
                if(count + 1 < 2400 + bias/16*80)
                    count = count + 1;
            end
            default : begin //打印字符
                if(ascii==8'hFF)begin //屏蔽其他按键
                    count = count - 1;
                end
                else begin
                    idx = ascii * 128;
                    row_b = (c-1) / 80 * 16;
                    col_b = (c-1) % 80 * 8;
                    for(j=col_b;j<col_b+8;j++)begin
                        for(i=row_b;i<row_b+16;i++)begin
                        vga_mem[480*j+i] = ascii_graph[idx];
                        idx++;
                        end
                    end
                end
            end
            endcase
            count_last = count ;
        end
        // 闪烁光标
        count_cursor = count_cursor + 1;
        if(count_cursor>500000)begin 
            //删除上一次的光标
            row_b = last_cursor / 80 * 16 + 15;
            col_b = last_cursor % 80 * 8;
            for(j=col_b;j<col_b+8;j++)begin
                vga_mem[480*j+row_b] = 24'h0;
            end

            count_cursor = 0;
            c[18:0] = count; 
            row_b = c / 80 * 16 + 15;
            col_b = c % 80 * 8;
            for(j=col_b;j<col_b+8;j++)begin
                vga_mem[480*j+row_b] = cursor_dis;
            end
            cursor_dis = ~cursor_dis;
            last_cursor = c;
        end
    end 
    
    /* verilator lint_off WIDTH */
    assign vga_data = vga_mem[h_addr*480+v_addr[8:0]+bias];
    /* verilator lint_on WIDTH */
endmodule