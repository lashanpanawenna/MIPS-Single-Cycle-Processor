module forward_1(DATA1,DATA2,fOut);

    input [7:0] DATA1,DATA2;
    output reg [7:0] fOut;

    always @(DATA1,DATA2) begin
        #2 fOut = DATA2;
    end
endmodule