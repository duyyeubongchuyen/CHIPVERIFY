module pos_edge_det (
    input clk,
    input sig,
    output pe
);

    //Khối lưu trữ giá trị trước đó của sig bằng cách dùng reg và flipflop
    reg sig_dly;
    always @(posedge clk) begin
        sig_dly <= sig;
    end

    //Phép tổng hợp logic cho pe (sig tích cực lên thì pe = 1)
    assign pe = sig & ~sig_dly;

endmodule