/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * cpu_testbench
    * Version 1.0
*/

`include "pc.v"

module Testbench;
    reg CLK, RESET;
    wire [31:0] PC;
    reg [31:0] INSTRUCTION;

    cpu mycpu(PC, INSTRUCTION, CLK, RESET);

    always @ (PC)
    begin
        # 2 // Latency for instruction register
        // Manually written opcodes
        case (PC)
            32'b0000_0000_0000_0000_0000_0000_0000_0000: INSTRUCTION = 32'b00000000_00000100_00000000_00000101; // loadi 4 0x05 //0
            
            32'b0000_0000_0000_0000_0000_0000_0000_0100: INSTRUCTION = 32'b00000000_00000010_00000000_00000011; // loadi 2 0x13 //4

            32'b0000_0000_0000_0000_0000_0000_0000_1000: INSTRUCTION = 32'b00000110_00000001_00000010_00000010; // j 0x01 //8

            32'b0000_0000_0000_0000_0000_0000_0000_1100: INSTRUCTION = 32'b00000001_00000000_00000000_00000100; // mov 0 4 //12
            
            32'b0000_0000_0000_0000_0000_0000_0001_0000: INSTRUCTION = 32'b00000000_00000001_00000000_00000001; // loadi 1 0x01 //16

            32'b0000_0000_0000_0000_0000_0000_0001_0100: INSTRUCTION = 32'b00001111_00000001_00000100_00000010; // bne 0x1 2 4 //20

            32'b0000_0000_0000_0000_0000_0000_0001_1000: INSTRUCTION = 32'b00000010_00000010_00000010_00000001; // add 2 2 1 //24

            32'b0000_0000_0000_0000_0000_0000_0001_1100: INSTRUCTION = 32'b00000010_00000110_00000100_00000010; // add 6 4 2 //28

            32'b0000_0000_0000_0000_0000_0000_0010_0000: INSTRUCTION = 32'b00001000_00000110_00000100_00000010; // mult 6 4 2 //32

            32'b0000_0000_0000_0000_0000_0000_0010_0100: INSTRUCTION = 32'b00001001_00000000_00000100_00000010; // sll 0 4 0x2 //36

            32'b0000_0000_0000_0000_0000_0000_0010_1000: INSTRUCTION = 32'b00001010_00000001_00000000_00000001; // srl 1 0 0x1 //40

            32'b0000_0000_0000_0000_0000_0000_0010_1100: INSTRUCTION = 32'b00010001_00000011_00000010_00000001; // srl 1 0 0x1 //44

        endcase
    end

    initial begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata1.vcd");
		$dumpvars(0, mycpu);
        
        RESET = 1'b0;
        CLK = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1;
        #6
        RESET = 0;
        // finish simulation after some time
        #100
        $finish;
    end
        
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
    
endmodule