module or_1(DATA1,DATA2,orOut);

    input [7:0] DATA1,DATA2;
    output reg [7:0] orOut;

    always @(DATA1,DATA2) begin
        #1 orOut = DATA1 | DATA2;
    end
endmodule