
/*`timescale 1ns/100ps
/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description	:

This file presents a skeleton implementation of the cache controller using a Finite State Machine model. Note that this code is not complete.
*/

/*module dcache (clock,read,write,busywait,cpu_address,reset,cpu_writeData,cpu_readData,
mem_address,mem_busywait,mem_read,mem_write,
mem_readData,mem_writeData);
    
    input clock,reset;
    input [7:0] cpu_address , cpu_writeData ;
    input write,read ;
    output reg [7:0] cpu_readData ;
    output reg busywait;
    input [31:0] mem_readData;
    input mem_busywait;
    output reg [31:0] mem_writeData ;
    output reg [5:0] mem_address ;
    output reg  mem_read,mem_write;

    //Cache memory array
    reg [31:0] cache_mem [7:0];
    reg [2:0] tag_array [7:0];
    reg valid_array [7:0];
    reg dirty_array [7:0];

    // wires and regs for cache functioning
    wire [2:0] tag,index,cache_tag;
    wire [1:0] offset;
    reg taghit,writehit;
    reg hit;

    // decoding the cpu address
    assign offset = cpu_address[1:0];
    assign index = cpu_address[4:2];
    assign tag = cpu_address[7:5];

    // retrieving the info from the cache
    assign #1 cache_tag = tag_array[index];
    assign #1 dirty = dirty_array[index];
    
    // setting the busywait as soon as read or write is gven to cache.
    always @(read,write) begin
        if (read || write)busywait=1;
    end

    // making busywait in respond to memory busywait
    always @(mem_busywait)begin
        if (mem_busywait == 1)busywait=1;
    end

    // tag comparision
    always @(index,tag,cache_tag,valid_array[index])begin
        #0.9
        if (tag == cache_tag)begin
            taghit = 1;
        end
        else begin
            taghit = 0;
        end
        hit = taghit & valid_array[index];
    end

    // reading data from the cache => parallel to tag comparision
    always @(*)begin
        #1
        case (offset)
            0: cpu_readData = cache_mem[index][7:0] ;
            1: cpu_readData = cache_mem[index][15:8] ;
            2: cpu_readData = cache_mem[index][23:16] ;
            3: cpu_readData = cache_mem[index][31:24] ;
        endcase
    end

    

    // control signals to make busywait,taghit => 0 in next cycle
    // and determine whether it was a write hit
    always @(posedge clock) begin
        if(hit || writehit) begin
            busywait = 0;
        end
    end
    always @(writehit) begin
        if (writehit) begin
            busywait = 0;
        end
    end

    always @(*) begin
        #1
        if(hit) begin
            if(read && (!write)) begin
                taghit = 0 ;
            end
            else if (write && (!read)) begin
                writehit = 1;
            end
        end
    end

    initial
    begin
        
        $dumpfile("cpu_wavedata.vcd");
        for (integer i=0;i<8;i++)
            $dumpvars(1,cache_mem[i]);
    end

// writing to the cache in the next cycle if it was a write hit
always @(posedge clock) begin
    if(writehit==1) begin
        #1
            case (offset)
                0: cache_mem[index][7:0] = cpu_writeData;
                1: cache_mem[index][15:8] = cpu_writeData;
                2: cache_mem[index][23:16] = cpu_writeData;
                3: cache_mem[index][31:24] = cpu_writeData;
            endcase
        dirty_array[index] = 1;
        valid_array[index] = 1;
        writehit = 0;
    end
    end

    /* Cache Controller FSM Start */

   /* parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((read || write) && !dirty && !hit)
                    next_state = MEM_READ;
                else if ((read || write) && dirty && !hit)
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            MEM_READ:
                if (!mem_busywait)
                    next_state = IDLE;
                else
                    next_state = MEM_READ;
            MEM_WRITE:
                if (!mem_busywait)
                    next_state = MEM_READ;
                else
                    next_state = MEM_WRITE;
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;
                mem_writeData = 8'dx;
            end

            MEM_READ:
            begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {tag, index};
                mem_writeData = 32'dx;
                busywait = 1;
                #1 if (!mem_busywait)begin
                    cache_mem[index] = mem_readData;
                    valid_array[index] = 1;
                    tag_array[index] = tag;
                end
            end
            
            MEM_WRITE:
            begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {cache_tag, index};
                mem_writeData = cache_mem[index];
                busywait = 1;
                if (!mem_busywait)begin
                    dirty_array[index] = 0;
                end
            end
        endcase
    end

    // sequential logic for state transitioning
    integer i;
    always @(posedge clock, reset)
    begin
        if(reset) begin
            state = IDLE;
            for(i = 0 ; i<7 ;i = i+1) begin
                dirty_array[i] = 0 ;
                valid_array[i] = 0 ;
            end
        end
        else
            state = next_state;
    end
    /* Cache Controller FSM End */

/*endmodule