module and_1(DATA1,DATA2,andOut);

    input [7:0] DATA1,DATA2;
    output reg [7:0] andOut;

    always @(DATA1,DATA2) begin
        #1 andOut = DATA1 & DATA2;
    end
endmodule