module reg_file(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS, WRITE, CLK, RESET);

    input [7:0] IN;
    input [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS;
    input WRITE,CLK,RESET;
    output reg [7:0] OUT1,OUT2;

    reg [7:0] registers [7:0];

    always @(OUT1ADDRESS,OUT2ADDRESS) begin

        #2
        OUT1 = registers[OUT1ADDRESS];
        OUT2 = registers[OUT2ADDRESS];
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

    initial
    begin
        #5;
        $display("\n\t\t\t=================================================");
        $display("\t\t\t Cahnge of register content strating from time #5");
        $display("\t\t\t==================================================");
        $display("\t\ttime\treg0\treg1\treg2\treg3\treg4\treg5\treg6\treg7");
        $display("\t\t----------------------------------------------------");
        $monitor($time,"\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d",registers[0],registers[1],registers[2],registers[3],registers[4],registers[5],registers[6],registers[7]);
    end

    initial
    begin
        
        $dumpfile("cpu_wavedata.vcd");
        for (integer i=0;i<8;i++)
            $dumpvars(1,registers[i]);
    end

endmodule