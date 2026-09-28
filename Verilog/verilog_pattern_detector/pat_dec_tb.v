module tb;
  reg clk, in, rstn;
  wire out;
  integer l_dly;
  
  always #10 clk = ~clk;
  
  det_110101 u0 ( .clk(clk), .rstn(rstn), .in(in), .out(out) );
  
  initial begin
  	clk <= 0;
    rstn <= 0;
    in <= 0;
    
    repeat (5) @ (posedge clk);
    rstn <= 1;

    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    
    #100 $finish;
  end
  
  always @ (posedge clk) begin
    $strobe("T=%0t in=%0b out=%0b", $time, in, out);
  end
  
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
  end
  
endmodule