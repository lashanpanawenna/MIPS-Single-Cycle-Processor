module add_1(DATA1,DATA2,addOut);

    input [7:0] DATA1,DATA2;
    output reg [7:0] addOut;

    always @(DATA1,DATA2) begin
        #2 addOut = DATA1 + DATA2;
    end
endmodule