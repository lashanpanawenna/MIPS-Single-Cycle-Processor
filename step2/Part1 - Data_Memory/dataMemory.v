module Data_Memory(ADDRESS,WRITEDATA,WRITE,READ,READDATA,BUSYWAIT);

    input [7:0] ADDRESS,WRITEDATA;
    input WRITE,READ;
    output reg [7:0] READDATA;
    output reg BUSYWAIT;

    //creating an array to store the memory
    reg [7:0] data_memory [255:0];

    always @(WRITE,READ)begin

        //making the BUSYWAIT => 1 when the memory is in operation
        if (WRITE == 1'b1 || READ == 1'b1)begin
            BUSYWAIT = 1'b1;
        end
    end

    //initiate when inputs to the memory changes
    always @(*) begin


        //READ condition
        if (READ == 1'b1)begin
            #40
            READDATA = data_memory[ADDRESS];
            BUSYWAIT = 1'b0;

        end

        //WRITE condition
        if (WRITE == 1'b1)begin
            #40
            data_memory[ADDRESS] = WRITEDATA;
            BUSYWAIT = 1'b0;
        end
    end

endmodule