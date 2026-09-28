`timescale 1ns/1ps

module tb;
  // 1. Khai báo tín hiệu kết nối
  reg        clk;
  reg        in;
  reg        rstn;
  wire       out;

  // Biến phục vụ stimulus
  reg [1:0]  l_dly;
  reg        tb_in;
  integer    loop = 20; // Tăng số lần lặp ngẫu nhiên để test bao phủ
  integer    i;         // Khai báo biến đếm chuẩn Verilog

  // 2. Tạo xung nhịp 50MHz (Chu kỳ T = 20ns)
  initial clk = 0;      // Khởi tạo mức 0 tuyệt đối tại t=0
  always #10 clk = ~clk;

  // 3. Kết nối DUT (Device Under Test)
  det_1011 u0 (
    .clk  (clk),
    .rstn (rstn),
    .in   (in),
    .out  (out)
  );

  // 4. Khối điều khiển kích thích (Stimulus Process)
  initial begin
    // Cấu hình xuất file sóng xem trên GTKWave
    $dumpfile("seq_det_output.vcd");
    $dumpvars(0, tb);   // Dump toàn bộ tín hiệu từ module đỉnh tb trở xuống

    // Khởi tạo các tín hiệu đầu vào ban đầu
    rstn = 0;
    in   = 0;

    // Giữ reset tích cực mức thấp trong 5 chu kỳ xung nhịp
    repeat (5) @(posedge clk);
    rstn <= 1;          // Nhả reset

    // ----------------------------------------------------
    // Kịch bản 1: Directed Pattern (Kịch bản định hướng sẵn)
    // Mục tiêu kiểm tra chuỗi: 1-0-1-1 rồi lặp lại 1-0-1-1
    // ----------------------------------------------------
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1; // Khớp chuỗi lần 1 -> out bật lên 1
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1; // Khớp chuỗi lần 2 -> out bật lên 1

    // ----------------------------------------------------
    // Kịch bản 2: Random Stimulus (Kích thích ngẫu nhiên)
    // ----------------------------------------------------
    for (i = 0; i < loop; i = i + 1) begin
      l_dly = $random;
      repeat (l_dly) @(posedge clk);
      tb_in = $random;
      in <= tb_in;
    end

    // Đợi thêm một khoảng thời gian để quan sát hết chu kỳ cuối
    #100;
    $display(">> Hoan thanh mo phong kiem tra FSM 1011 <<");
    $finish;
  end

  // 5. In log tự động ra Terminal để kiểm tra nhanh kết quả
  always @(posedge clk) begin
    if (out) begin
      $display("[THOI GIAN %0t ns] DETECTED: Phat hien chuoi 1011 hop le!", $time);
    end
  end

endmodule