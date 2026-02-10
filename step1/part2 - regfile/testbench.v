/*********************************/
/* CO224 - Computer Architecture */
/* Lab 05 - Part 1				 */
/* Testbench					 */
/* Group - 26					 */
/*********************************/
`include "regfile.v"

module testbench;

	//Input ports for register file
	reg [7:0] WRITEDATA;
	reg [2:0] READREG1, READREG2, WRITEREG;
	reg WRITEENABLE, CLK, RESET;
	
	//Outputs from register file
	wire [7:0] REGOUT1, REGOUT2;
	
	//Instantiating the register file within the testbench module
	reg_file my_reg(WRITEDATA, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
	
	
	//Initial block to initialize control signals
	initial
	begin
		CLK = 0;
		RESET = 0;
		WRITEENABLE = 1;
	end
	
	
	//Performing a set of operations on the register file
	initial
	begin
		WRITEREG = 0;		//Writing value 5 to REG0
		WRITEDATA = 5;
		
		READREG1 = 0;		//Reading from REG0
		READREG2 = 3;		//Reading from REG3
		
		#5
		
		WRITEREG = 3;		//Writing value 15 to REG3
		WRITEDATA = 15;
		
		#2
		
		WRITEENABLE = 0;	//Making WRITEENABLE control signal LOW
		
		#3
		
		WRITEREG = 4;		//Writing 27 to REG4 (Does not get written since WRITEENABLE is LOW)
		WRITEDATA = 27;
		
		#5
		
		READREG1 = 4;		//Reading from REG4
		
		#5
		
		READREG1 = 3;		//Reading from REG3
		READREG2 = 0;		//Reading from REG0
		
		#5
		
		RESET = 1;			//Setting RESET signal to HIGH
	end
	
	
	//Always block to maintain clock pulse
	always #2 CLK = !CLK;		//Inverts value of CLK every 2 time units


	//Handling wavedata dumpfile and monitor outputs
	initial
	begin
		$dumpfile("wavedata.vcd");
		$dumpvars(0, my_reg);
		$monitor("TIME = %g OUT1 = %d OUT2 = %d", $time, REGOUT1, REGOUT2);
		#50 $finish;
	end

endmodule