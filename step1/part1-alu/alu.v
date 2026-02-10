`include "add.v"
`include"forward.v"
`include "and.v"
`include "or.v"


module alu(DATA1,DATA2,SELECT,RESULT);

    input [7:0] DATA1,DATA2;
    input [2:0] SELECT;
    output reg [7:0] RESULT;

    wire [7:0] fOut,addOut,andOut,orOut;

    and_1 and_1(DATA1,DATA2,andOut);
    forward_1 forward_1(DATA1,DATA2,fOut);
    add_1 add_1(DATA1,DATA2,addOut);
    or_1 or_1(DATA1,DATA2,orOut);

    always @(SELECT,fOut,addOut,andOut,orOut)
    begin
        case(SELECT)

        3'b000  :RESULT=fOut;
        3'b001  :RESULT=addOut;
        3'b010  :RESULT=andOut;
        3'b011  :RESULT=orOut;

        endcase

    end
endmodule