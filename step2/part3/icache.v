`timescale 1ns/100ps

module instruction_cache(
    ADDRESS,BUSYWAIT,INSTRUCTION,CLOCK,RESET, // in and out => CPU
    READ,MEM_INSTRUCTION,MEM_ADDRESS,MEM_BUSYWAIT,BUSYWAITD // in and out => instruction cache
);
    // inputs and outputs from the cache => cpu
    input CLOCK,RESET;
    input [9:0] ADDRESS;
    output reg [31:0] INSTRUCTION;
    output reg BUSYWAIT;

    // inputs and outputs from the cache => i_memory
    input [127:0] MEM_INSTRUCTION;
    input MEM_BUSYWAIT,BUSYWAITD;
    output reg READ;
    output reg [5:0] MEM_ADDRESS;

    // cache memory
    reg [127:0] cache_mem [7:0];
    reg [1:0] tag_array [7:0];
    reg valid_array [7:0];

    //wires and regs for the cache
    wire [1:0] offset;
    wire [2:0] index,tag,cache_tag;
    wire [127:0] instruction_block;
    wire valid;
    reg [31:0] temp_instruction;


    wire tag_match;
    reg read_hit;
    reg [2:0] cache_tag_reg;

    // decoding of the address
    assign offset = ADDRESS[3:2];
    assign index = ADDRESS[6:4];
    assign tag = ADDRESS[9:7];

    // assigning instruction to wire
    assign #1 instruction_block = cache_mem[index];
    assign #1 cache_tag = tag_array[index];
    assign #1 valid = valid_array[index];

    // performing tag comparision
    assign #0.9 tag_match = (tag == cache_tag)? 1:0;

    always @(tag_match,valid)begin
        read_hit = tag_match & valid;
    end

    always @ (ADDRESS)	BUSYWAIT = 1'b1;

    // assigning the instruction parallel to the tag comparision
    always @ (*)
	begin
		case (offset)
			2'b00:	temp_instruction = #1 instruction_block[31:0];
			2'b01:	temp_instruction = #1 instruction_block[63:32];
			2'b10:	temp_instruction = #1 instruction_block[95:64];
			2'b11:	temp_instruction = #1 instruction_block[127:96];
		endcase
	end

    always @(temp_instruction)begin
        INSTRUCTION = (read_hit)? temp_instruction:32'bx;
    end

    always @ (CLOCK) if (read_hit) BUSYWAIT = 1'b0;
    
    //always @ (posedge CLOCK) if (state == 3'b000) read_hit = 0;

    initial
    begin
        
        $dumpfile("cpu_wavedata.vcd");
        for (integer i=0;i<8;i++)
            $dumpvars(1,cache_mem[i]);
    end



    ////////////////////////////////
    /* Cache Controller FSM Start */ //=> same fsm as used in the data cache edited here
    ////////////////////////////////

    parameter IDLE = 3'b000, MEM_READ = 3'b001;
    reg [2:0] state, next_state;
	
	// combinational next state logic
    always @(*)
    begin
        if (BUSYWAITD == 0)begin
        case (state)
            IDLE:
                if (read_hit)
                    next_state = IDLE;
                else
                    next_state = MEM_READ;
            MEM_READ:
                if (MEM_BUSYWAIT)
                    next_state = MEM_READ;
                else
                    next_state = IDLE;
        endcase
        end
    end
	

    // combinational output logic
    always @ (*)
    begin
        case(state)
            IDLE:
            begin
                READ = 0;
                MEM_ADDRESS = 6'dx;
                //BUSYWAIT = 0;
            end
            MEM_READ:
            begin
				BUSYWAIT = 1;
                READ = 1;
                MEM_ADDRESS = ADDRESS[9:4];
                #1
				if(MEM_BUSYWAIT == 0)
				begin
                    //$display("hello");
					READ = 0;
					MEM_ADDRESS = 6'dx;
                    cache_mem[index] = MEM_INSTRUCTION;
                    //$display("%d",MEM_INSTRUCTION);
                    valid_array[index] = 1;
                    tag_array[index] = tag;
                end
            end
        endcase
    end


    // sequential logic for state transitioning
	integer i;
    always @(posedge CLOCK, RESET)
    begin
        if(RESET) begin
            state = IDLE;
            for(i = 0 ; i<8 ;i = i+1) begin
                valid_array[i] = 0;
            end
        end
        else
            state = next_state;
    end


endmodule