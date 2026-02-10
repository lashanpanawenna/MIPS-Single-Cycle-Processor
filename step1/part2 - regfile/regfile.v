module reg_file(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS, WRITE, CLK, RESET);

    input [7:0] IN;
    input [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS;
    input WRITE,CLK,RESET;
    output reg [7:0] OUT1,OUT2;

    reg [7:0] registers [7:0];

    always @(OUT1ADDRESS,OUT2ADDRESS) begin

        #2 OUT1 = registers[OUT1ADDRESS];
        #2 OUT2 = registers[OUT2ADDRESS];
    end

    integer i;

    always @(posedge CLK) begin
        
        if (RESET == 1'b1)
        begin
            #1 for (i = 0; i < 8; i = i +1)
            begin
                registers[i] = 8'b00000000;
            end
        end

        if (WRITE == 1'b1)
        begin

            #1 registers[INADDRESS] = IN;
        end

    end

endmodule