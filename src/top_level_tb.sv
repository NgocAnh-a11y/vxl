module top_level_tb();
    logic        clk;
    logic        rst;
    logic [31:0] write_data, da;
    logic        mem_write;

    // Gọi khối top
    top_level dut (
        .clk(clk), .rst(rst),
        .write_data(write_data), .da(da), .mem_write(mem_write)
    );

    // Tạo xung Clock (chu kỳ 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Kịch bản Test
    initial begin
        // Reset hệ thống trong 22ns (hơn 2 chu kỳ clock)
        rst = 1;
        #22; 
        rst = 0; // Thả reset, CPU bắt đầu lấy lệnh tại PC = 0 và chạy

        $display("Bắt đầu mô phỏng CPU ARM Single Cycle...");
        
        // Bạn có thể cho chạy khoảng vài trăm ns rồi dừng
        #500;
        $display("Mô phỏng kết thúc. Hãy mở Waveform để xem tín hiệu.");
		  $stop;
    end

    // Tính năng tự động kiểm tra kết quả (Tùy chọn)
    // Giả sử chương trình Assembly của bạn cuối cùng sẽ ghi giá trị số 7 vào bộ nhớ tại địa chỉ 100
    always @(negedge clk) begin
        if (mem_write) begin
            if (da === 32'd100 && write_data === 32'd7) begin
                $display("Mô phỏng THÀNH CÔNG: Đã ghi giá trị 7 vào địa chỉ 100!");
                $stop;
            end
        end
    end
endmodule
