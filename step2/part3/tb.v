// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor

`include "cpu.v"

`timescale 1ns/100ps
module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC,MEM_WRITE_DATA,MEM_READ_DATA;
    wire [31:0] INSTRUCTION;
    wire WRITE,READ,BUSYWAITI,BUSYWAITD,MEM_BUSYWAIT,MEM_READ,MEM_WRITE,INSTRUCTION_MEMORY_READ,INSTRUCTION_MEM_BUSYWAIT,BUSYWAIT;
    wire [7:0] ADDRESS,WRITEDATA,ALURESULT,READDATA;
    wire [5:0]MEM_ADDRESS;
    wire [127:0] MEM_INSTRUCTION;
    wire [5:0] INSTRUCTION_MEM_ADDRESS;


    //cpu module instantiation
    cpu mycpu(PC,INSTRUCTION,CLK,RESET,BUSYWAITI,BUSYWAITD,WRITE,READ,ADDRESS,WRITEDATA,READDATA);

    //data cache module instantiation
    //CACHE mycache(CLK,RESET,READ,WRITE,ADDRESS,WRITEDATA,READDATA,BUSYWAIT,MEM_READ,MEM_WRITE,MEM_ADDRESS,MEM_WRITE_DATA,MEM_READ_DATA,MEM_BUSYWAIT);

    //cache2
    dcache mycache2(CLK,READ,WRITE,BUSYWAITD,ADDRESS,RESET,WRITEDATA,READDATA,MEM_ADDRESS,MEM_BUSYWAIT,MEM_READ,MEM_WRITE,MEM_READ_DATA,MEM_WRITE_DATA);

    //data memory module instantiation
    data_memory mymemory(CLK,RESET,MEM_READ,MEM_WRITE,MEM_ADDRESS,MEM_WRITE_DATA,MEM_READ_DATA,MEM_BUSYWAIT);
    
    //instruction cache
    instruction_cache my_instructions_cache(PC[9:0],BUSYWAITI,INSTRUCTION,CLK,RESET,INSTRUCTION_MEMORY_READ,MEM_INSTRUCTION,INSTRUCTION_MEM_ADDRESS,INSTRUCTION_MEM_BUSYWAIT,BUSYWAITD);
    
    //instruction memory
    instruction_memory my_instruction_memory(CLK,INSTRUCTION_MEMORY_READ,INSTRUCTION_MEM_ADDRESS,MEM_INSTRUCTION,INSTRUCTION_MEM_BUSYWAIT);
    /* 
    -----
     CPU
    -----
    */
    
    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave 
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b0;

        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
		RESET = 1'b1;
		#5
		RESET = 1'b0;
        
        // finish simulation after some time
        #4000
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule