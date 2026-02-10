
module alu(DATA1,DATA2,SELECT,RESULT,ZERO);

    input [7:0] DATA1,DATA2;
    input [2:0] SELECT;
    output reg [7:0] RESULT;
    output reg ZERO;

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

    always @(addOut)begin
        if (addOut == 0)ZERO = 1;
        if (addOut != 0)ZERO = 0;
    end
endmodule

module add_1(DATA1,DATA2,addOut);

    input [7:0] DATA1,DATA2;
    output reg [7:0] addOut;

    always @(DATA1,DATA2) begin
        #2 addOut = DATA1 + DATA2;
    end
endmodule

module and_1(DATA1,DATA2,andOut);

    input [7:0] DATA1,DATA2;
    output reg [7:0] andOut;

    always @(DATA1,DATA2) begin
        #1 andOut = DATA1 & DATA2;
    end
endmodule

module or_1(DATA1,DATA2,orOut);

    input [7:0] DATA1,DATA2;
    output reg [7:0] orOut;

    always @(DATA1,DATA2) begin
        #1 orOut = DATA1 | DATA2;
    end
endmodule

module forward_1(DATA1,DATA2,fOut);

    input [7:0] DATA1,DATA2;
    output reg [7:0] fOut;

    always @(DATA1,DATA2) begin
        #1 fOut = DATA2;
    end
endmodule

module beq(DATA1,DATA2,ZERO);

    input [7:0] DATA1,DATA2;
    output reg ZERO;

    always @(DATA1,DATA2)begin
        if (DATA1 == DATA2);ZERO = 1'b1;
        if (DATA1 != DATA2);ZERO = 1'b0;
    end
endmodule