module det_1011 (
    input clk,
    input rstn,
    input in,
    output out
);

    localparam[2:0] IDLE = 0,
                    S1   = 1,
                    S10  = 2,
                    S101 = 3,
                    S1011= 4;

    reg[2:0] cur_state, next_state;

    //Khối lưu trữ trạng thái
    always @(posedge clk) begin
        if(!rstn) 
            cur_state <= IDLE;
        else
            cur_state <= next_state;
    end

    //Khối tính toán trạng thái tiếp theo
    always @(*) begin
        case(cur_state)
            IDLE : begin
                if(in) next_state = S1;
                else next_state = IDLE;
            end

            S1 : begin
                if(in) next_state = S1;
                else next_state = S10;
            end

            S10 : begin
                if(in) next_state = S101;
                else next_state = IDLE;
            end

            S101 : begin
                if(in) next_state = S1011;
                else next_state = S10;
            end

            S1011 : begin
                if(in) next_state = S1;
                else next_state = S10;
            end

            default : next_state = IDLE;
        endcase
    end

    //Phép tổ hợp cho output (output = 1 khi state = S1011)
    assign out = (cur_state == S1011);

endmodule