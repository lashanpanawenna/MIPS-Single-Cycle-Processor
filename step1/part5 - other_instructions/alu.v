
module alu(DATA1,DATA2,SELECT,RESULT,ZERO,R,RS);

    input [7:0] DATA1,DATA2;
    input [2:0] SELECT;
    input [1:0] RS;
    input R;//wire for selecting left/right shift
    output reg [7:0] RESULT;
    output reg ZERO;

    wire [7:0] fOut,addOut,andOut,orOut,PRODUCT,SHIFT_OUT;

    and_1 and_1(DATA1,DATA2,andOut);
    forward_1 forward_1(DATA1,DATA2,fOut);
    add_1 add_1(DATA1,DATA2,addOut);
    or_1 or_1(DATA1,DATA2,orOut);
    mul multiplier_8x8(DATA1,DATA2,PRODUCT);
    Shifter alu_shift(DATA1,DATA2,R,SHIFT_OUT,RS);

    always @(SELECT,fOut,addOut,andOut,orOut,PRODUCT,SHIFT_OUT)
    begin
        case(SELECT)

        3'b000  :RESULT=fOut;
        3'b001  :RESULT=addOut;
        3'b010  :RESULT=andOut;
        3'b011  :RESULT=orOut;
        3'b100  :RESULT=PRODUCT;
        3'b101  :RESULT=SHIFT_OUT;
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

module mul(DATA1, DATA2, PRODUCT);

    input [7:0] DATA1, DATA2;
    output [7:0] PRODUCT;

    wire [6:0] Cout [6:0];
    wire [5:0] Sout [5:0];
    wire [7:0] temp;


    //first output bit
    assign temp[0] = DATA1[0] & DATA2[0];

    //Level 1 -> second output bit
    halfadder HA1_1(DATA1[1] & DATA2[0],DATA1[0] & DATA2[1],temp[1],Cout[0][0]);
    fulladder FA1_1(DATA1[2] & DATA2[0],DATA1[1] & DATA2[1],Cout[0][0],Sout[0][0],Cout[0][1]);
    fulladder FA2_1(DATA1[3] & DATA2[0],DATA1[2] & DATA2[1],Cout[0][1],Sout[0][1],Cout[0][2]);
    fulladder FA3_1(DATA1[4] & DATA2[0],DATA1[3] & DATA2[1],Cout[0][2],Sout[0][2],Cout[0][3]);
    fulladder FA4_1(DATA1[5] & DATA2[0],DATA1[4] & DATA2[1],Cout[0][3],Sout[0][3],Cout[0][4]);
    fulladder FA5_1(DATA1[6] & DATA2[0],DATA1[5] & DATA2[1],Cout[0][4],Sout[0][4],Cout[0][5]);
    fulladder FA6_1(DATA1[7] & DATA2[0],DATA1[6] & DATA2[1],Cout[0][5],Sout[0][5],Cout[0][6]);

    //Level 2 -> third output bit
    halfadder HA1_2(DATA1[0] & DATA2[2],Sout[0][0],temp[2],Cout[1][0]);
    fulladder FA1_2(DATA1[1] & DATA2[2],Sout[0][1],Cout[1][0],Sout[1][0],Cout[1][1]);
    fulladder FA2_2(DATA1[2] & DATA2[2],Sout[0][2],Cout[1][1],Sout[1][1],Cout[1][2]);
    fulladder FA3_2(DATA1[3] & DATA2[2],Sout[0][3],Cout[1][2],Sout[1][2],Cout[1][3]);
    fulladder FA4_2(DATA1[4] & DATA2[2],Sout[0][4],Cout[1][3],Sout[1][3],Cout[1][4]);
    fulladder FA5_2(DATA1[5] & DATA2[2],Sout[0][5],Cout[1][4],Sout[1][4],Cout[1][5]);

    //Level 3 -> fourth output bit
    halfadder HA1_3(DATA1[0] & DATA2[3],Sout[1][0],temp[3],Cout[2][0]);
    fulladder FA1_3(DATA1[1] & DATA2[3],Sout[1][1],Cout[2][0],Sout[2][0],Cout[2][1]);
    fulladder FA2_3(DATA1[2] & DATA2[3],Sout[1][2],Cout[2][1],Sout[2][1],Cout[2][2]);
    fulladder FA3_3(DATA1[3] & DATA2[3],Sout[1][3],Cout[2][2],Sout[2][2],Cout[2][3]);
    fulladder FA4_3(DATA1[4] & DATA2[3],Sout[1][4],Cout[2][3],Sout[2][3],Cout[2][4]);

    //Level 4 -> fifth output bit
    halfadder HA1_4(DATA1[0] & DATA2[4],Sout[2][0],temp[4],Cout[3][0]);
    fulladder FA1_4(DATA1[1] & DATA2[4],Sout[2][1],Cout[3][0],Sout[3][0],Cout[3][1]);
    fulladder FA2_4(DATA1[2] & DATA2[4],Sout[2][2],Cout[3][1],Sout[3][1],Cout[3][2]);
    fulladder FA3_4(DATA1[3] & DATA2[4],Sout[2][3],Cout[3][2],Sout[3][2],Cout[3][3]);

    //Level 5 -> sixth output bit
    halfadder HA1_5(DATA1[0] & DATA2[5],Sout[3][0],temp[5],Cout[4][0]);
    fulladder FA1_5(DATA1[1] & DATA2[5],Sout[3][1],Cout[4][0],Sout[4][0],Cout[4][1]);
    fulladder FA2_5(DATA1[2] & DATA2[5],Sout[3][2],Cout[4][1],Sout[4][1],Cout[4][2]);

    //Level 6 -> seventh output bit
    halfadder HA1_6(DATA1[0] & DATA2[6],Sout[4][0],temp[6],Cout[5][0]);
    fulladder FA1_6(DATA1[1] & DATA2[6],Sout[4][1],Cout[5][0],Sout[5][0],Cout[5][1]);

    //Level 7 -> eigth output bit
    halfadder HA1_7(DATA1[0] & DATA2[7],Sout[5][0],temp[7],Cout[6][0]);

    //3 time unit delays since it has a consiberable number of gates
    assign #3 PRODUCT = temp;


endmodule

module halfadder(
    input a,
    input b,
    output sum,
    output cOut
);

    assign sum = a ^ b;
    assign cOut = a & b;

endmodule


module fulladder(
    input a,
    input b,
    input cIn,
    output sum,
    output cOut
);

    assign sum = a ^ b ^ cIn;
    assign cOut = (a & b) | (b & cIn) | (a & cIn);

endmodule

module mux_2bit(IN0,IN1,SWITCH,OUT);

    input IN0,IN1;
    input SWITCH;
    output reg OUT;

    always @(SWITCH,IN0,IN1)begin
    if (SWITCH == 0)OUT =IN0;
    if (SWITCH == 1)OUT =IN1;
    end

endmodule

module mux_layer(IN_0,IN_1,SWITCH,OUT);

    input [7:0] IN_0,IN_1;
    input SWITCH;
    output [7:0] OUT;

    mux_2bit mux0(IN_0[0],IN_1[0],SWITCH,OUT[0]);
    mux_2bit mux1(IN_0[1],IN_1[1],SWITCH,OUT[1]);
    mux_2bit mux2(IN_0[2],IN_1[2],SWITCH,OUT[2]);
    mux_2bit mux3(IN_0[3],IN_1[3],SWITCH,OUT[3]);
    mux_2bit mux4(IN_0[4],IN_1[4],SWITCH,OUT[4]);
    mux_2bit mux5(IN_0[5],IN_1[5],SWITCH,OUT[5]);
    mux_2bit mux6(IN_0[6],IN_1[6],SWITCH,OUT[6]);
    mux_2bit mux7(IN_0[7],IN_1[7],SWITCH,OUT[7]);
    
endmodule

module mux_8(IN0,IN1,SWITCH,OUT);

    input [7:0] IN0,IN1;
    input SWITCH;
    output reg [7:0] OUT;

    always @(SWITCH,IN0,IN1)begin
    if (SWITCH == 0)OUT =IN0;
    if (SWITCH == 1)OUT =IN1;
    end

endmodule

module right_left_shifter(IN,S0,S1,S2,R,OUT,RS0,RS1);

    input [7:0] IN;
    input S0,S1,S2,R,RS0,RS1;
    output [7:0] OUT;

    //muxes for selecting the right shift
    mux_3bit mux31(1'b0,IN[7],IN[0],RS0,RS1,R1[7]);

    mux_3bit mux32(1'b0,L1_OUT[7],L1_OUT[1],RS0,RS1,R2[7]);
    mux_3bit mux33(1'b0,L1_OUT[7],L1_OUT[0],RS0,RS1,R2[6]);

    mux_3bit mux34(1'b0,L2_OUT[7],L2_OUT[3],RS0,RS1,R3[7]);
    mux_3bit mux35(1'b0,L2_OUT[7],L2_OUT[2],RS0,RS1,R3[6]);
    mux_3bit mux36(1'b0,L2_OUT[7],L2_OUT[1],RS0,RS1,R3[5]);
    mux_3bit mux37(1'b0,L2_OUT[7],L2_OUT[0],RS0,RS1,R3[4]);

    //intermediate wires between muxes
    wire [7:0] L1_OUT,L1_IN,L2_IN,L2_OUT,L3_IN,L3_OUT;

    //wires to decide the left or right shift muxes
    wire [7:0] L1,R1,L2,R2,L3,R3;

    //setting the wires to required values to right or left shift

    //Layer1 => Left
    assign L1[0] = 1'b0;
    assign L1[1] = IN[0];
    assign L1[2] = IN[1];
    assign L1[3] = IN[2];
    assign L1[4] = IN[3];
    assign L1[5] = IN[4];
    assign L1[6] = IN[5];
    assign L1[7] = IN[6];

    //Layer1 => Right
    assign R1[0] = IN[1];
    assign R1[1] = IN[2];
    assign R1[2] = IN[3];
    assign R1[3] = IN[4];
    assign R1[4] = IN[5];
    assign R1[5] = IN[6];
    assign R1[6] = IN[7];

    //Layer2 => Left
    assign L2[0] = 1'b0;
    assign L2[1] = 1'b0;
    assign L2[2] = L1_OUT[0];
    assign L2[3] = L1_OUT[1];
    assign L2[4] = L1_OUT[2];
    assign L2[5] = L1_OUT[3];
    assign L2[6] = L1_OUT[4];
    assign L2[7] = L1_OUT[5];

    //Layer2 => Right
    assign R2[0] = L1_OUT[2];
    assign R2[1] = L1_OUT[3];
    assign R2[2] = L1_OUT[4];
    assign R2[3] = L1_OUT[5];
    assign R2[4] = L1_OUT[6];
    assign R2[5] = L1_OUT[7];
    
    //Layer3 => Left
    assign L3[0] = 1'b0;
    assign L3[1] = 1'b0;
    assign L3[2] = 1'b0;
    assign L3[3] = 1'b0;
    assign L3[4] = L2_OUT[0];
    assign L3[5] = L2_OUT[1];
    assign L3[6] = L2_OUT[2];
    assign L3[7] = L2_OUT[3];

    //Layer3 => Right
    assign R3[0] = L2_OUT[4];
    assign R3[1] = L2_OUT[5];
    assign R3[2] = L2_OUT[6];
    assign R3[3] = L2_OUT[7];

    //3 mux_2bit layers & 3 muxes are required

    //1st selecter mux_2bit
    mux_8 mux_L1(L1,R1,R,L1_IN);

    //1st mux_2bit layer
    mux_layer layer1(IN,L1_IN,S0,L1_OUT);

    //2nd selecter mux_2bit
    mux_8 mux_L2(L2,R2,R,L2_IN);

    //2nd mux_2bit layer
    mux_layer layer2(L1_OUT,L2_IN,S1,L2_OUT);

    //3rd selecter mux_2bit
    mux_8 mux_L3(L3,R3,R,L3_IN);

    //3rd mux_2bit layer
    mux_layer layer3(L2_OUT,L3_IN,S2,L3_OUT);

    //delay = 3 time units
    assign #3 OUT = L3_OUT;

endmodule

module Shifter(DATA1,DATA2,R,SHIFT_OUT,RS);

    input [7:0] DATA1,DATA2;
    input [1:0] RS;
    input R;
    output [7:0] SHIFT_OUT;

    //required wires for shifter
    wire S0,S1,S2,RS0,RS1;

    assign S0 = DATA2[0];
    assign S1 = DATA2[1];
    assign S2 = DATA2[2];

    assign RS0 = RS[0];
    assign RS1 = RS[1];
    right_left_shifter shifter(DATA1,S0,S1,S2,R,SHIFT_OUT,RS0,RS1);

endmodule

module mux_3bit(IN0,IN1,IN2,R0,R1,OUT);

    input IN0,IN1,IN2,R0,R1;
    output reg OUT;

    always @(IN0,IN1,IN2,R0,R1) begin
    if (R0 == 0 && R1 == 0)OUT=IN0;
    if (R0 == 1 && R1 == 0)OUT=IN1;
    if (R0 == 0 && R1 == 1)OUT=IN2;
    end

endmodule