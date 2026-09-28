// Code your testbench here
// or browse Examples
module tb;
	reg sig;                                  // Declare internal TB signal called sig to drive the sig pin of the design
	reg clk;                                  // Declare internal TB signal called clk to drive clock to the design
	
	// Instantiate the design in TB and connect with signals in TB
	pos_edge_det ped0 (  .sig(sig),           
    					 .clk(clk),
 			      		 .pe(pe));

	// Generate a clock of 100MHz
	always #5 clk = ~clk;           
	
	// Drive stimulus to the design
	initial begin
		clk <= 0;
		sig <= 0;
		#15 sig <= 1;
		#20 sig <= 0;
		#15 sig <= 1;
		#10 sig <= 0;
		#20 $finish;
	end	
  
  	initial begin
      	$dumpvars;
      $dumpfile("dump.vcd");
    end
    
endmodule