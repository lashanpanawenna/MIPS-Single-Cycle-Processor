// including the alu and reg file
`include "alu.v"
`include "regfile.v"
`include "dataMemory.v"

module cpu(PC, INSTRUCTION, CLK, RESET,BUSYWAIT,WRITE,READ,ALURESULT,REGOUT1,READDATA);

//declaring inputs and outputs
input [31:0] INSTRUCTION;
input [7:0] READDATA;
input CLK,RESET,BUSYWAIT;
output reg [31:0] PC;
output reg WRITE,READ;
output [7:0] ALURESULT,REGOUT1;

//required registers and wires

wire [31:0] PC_reg;
reg [7:0] OPCODE,IMMEDIATE,JIMMEDIATE;
wire [7:0] REGOUT1,REGOUT2,ALURESULT,TWOS_OUT,MUX1_OUT,ALUIN2,READDATA,MEMUXOUT;
reg [2:0] READREG1,READREG2,WRITEREG,ALUOP;
reg MUX1_SWITCH,MUX2_SWITCH,MEMORYCONTROL;
reg WRITEENABLE,JUMP,BRANCH,MUX3_SWITCH,R;
reg [1:0] RS;
wire [31:0] target,ex_JIMMEDIATE,PC_OUT;

//declaring all the modules and connecting the required wires

reg_file REGITSERS(MEMUXOUT,REGOUT1,REGOUT2,WRITEREG,READREG1,READREG2,WRITEENABLE,CLK,RESET);
mux mux2(IMMEDIATE,MUX1_OUT,ALUIN2,MUX2_SWITCH);
alu ALU(REGOUT1,ALUIN2,ALUOP,ALURESULT,ZERO,R,RS);
twos_Comp COMP(REGOUT2,TWOS_OUT);
mux mux1(REGOUT2,TWOS_OUT,MUX1_OUT,MUX1_SWITCH);
SignExtender signextend(JIMMEDIATE,ex_JIMMEDIATE);
Branch_or_Jump_adder add(PC_reg,ex_JIMMEDIATE,target);
flow_Control flow(JUMP,BRANCH,ZERO,OUT,OPCODE);
mux2 mux3(target,PC_reg,PC_OUT,OUT);
PC_adder my_adder(PC,PC_reg);
mux memux(READDATA,ALURESULT,MEMUXOUT,MEMORYCONTROL);

//control instructions for the PC
always @ ( posedge CLK)
	begin
		if (RESET == 1'b1) #1 PC = 0;
		else if (BUSYWAIT == 1'b1);
		else #1 PC = PC_OUT;
	end

always @ (BUSYWAIT)
begin
	if (BUSYWAIT == 1'b0)
	begin
		READ = 0;
		WRITE = 0;
	end
end


always @(INSTRUCTION)
begin
    // decoding the instruction
OPCODE[7:0] = INSTRUCTION[31:24];
IMMEDIATE[7:0] = INSTRUCTION[7:0];
READREG1[2:0] = INSTRUCTION[10:8];
READREG2[2:0] = INSTRUCTION[2:0];
WRITEREG[2:0] = INSTRUCTION[18:16];
JIMMEDIATE[7:0] = INSTRUCTION[23:16];


//Load instruction
if (OPCODE == 8'b00000000)
begin
    #1
    ALUOP = 3'b000;
    WRITEENABLE = 1'b1;
    MUX2_SWITCH = 1'b0;
    MUX1_SWITCH = 1'bX;
    JUMP = 1'b0;
    BRANCH = 1'b0;
    READ = 1'b0;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'b1;
end
//move instruction

if (OPCODE == 8'b00000001)
begin
    #1
    ALUOP = 3'b000;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'b0;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH = 1'b0;
    READ = 1'b0;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'b1;
end

//add instruction
if (OPCODE == 8'b00000010)
begin
    #1
    ALUOP = 3'b001;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'b0;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH = 1'b0;
    READ = 1'b0;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'b1;
end

//sub instruction
if (OPCODE == 8'b00000011)
begin
    #1
    ALUOP = 3'b001;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'b1;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH = 1'b0;
    READ = 1'b0;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'b1;
end

//and instruction
if (OPCODE == 8'b00000100)
begin
    #1
    ALUOP = 3'b010;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'b0;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH = 1'b0;
    READ = 1'b0;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'b1;
end

//or instruction
if (OPCODE == 8'b00000101)
begin
    #1
    ALUOP = 3'b011;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'b0;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH = 1'b0;
    READ = 1'b0;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'b1;
end

//j instruction
if (OPCODE == 8'b00000110)
begin
    #1
    ALUOP = 3'bXXX;
    WRITEENABLE = 1'b0;
    MUX1_SWITCH = 1'bX;
    MUX2_SWITCH = 1'bX;
    JUMP = 1'b1;
    BRANCH = 1'b0;
    READ = 1'b0;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'bX;
end

//Barnch if equal instruction

if (OPCODE == 8'b00000111)
begin
    #1
    ALUOP = 3'b001;
    WRITEENABLE = 1'b0;
    MUX1_SWITCH = 1'b1;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH =1'b1;
    READ = 1'b0;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'bX;
end

//Multiplication instruction
/*
if (OPCODE == 8'b00001000)
begin
    #1
    ALUOP = 3'b100;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'b0;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH =1'b0;
end

//Logical left shift

if (OPCODE == 8'b00001001)
begin
    #1
    ALUOP = 3'b101;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'bX;
    MUX2_SWITCH = 1'b0;
    JUMP = 1'b0;
    BRANCH =1'b0;
    R = 1'b0;
end

//Logical Right shift

if (OPCODE == 8'b00001010)
begin
    #1
    ALUOP = 3'b101;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'bX;
    MUX2_SWITCH = 1'b0;
    JUMP = 1'b0;
    BRANCH =1'b0;
    R = 1'b1;
    RS = 2'b00;
end

//Barnch if not equal instruction

if (OPCODE == 8'b00001111)
begin
    #1
    ALUOP = 3'b001;
    WRITEENABLE = 1'b0;
    MUX1_SWITCH = 1'b1;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH =1'b1;
end

//Arithmatic right shift

if (OPCODE == 8'b00010000)
begin
    #1
    ALUOP = 3'b101;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'bX;
    MUX2_SWITCH = 1'b0;
    JUMP = 1'b0;
    BRANCH =1'b0;
    R = 1'b1;
    RS = 2'b01;
end

//Rotated right shift

if (OPCODE == 8'b00010001)
begin
    #1
    ALUOP = 3'b101;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'bX;
    MUX2_SWITCH = 1'b0;
    JUMP = 1'b0;
    BRANCH =1'b0;
    R = 1'b1;
    RS = 2'b10;
end
*/

// load word direct instruction

if (OPCODE == 8'b00001000)
begin
    #1
    ALUOP = 3'b000;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'b0;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH =1'b0;
    READ = 1'b1;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'b0;
end

// load word immediate instruction

if (OPCODE == 8'b00001001)
begin
    #1
    ALUOP = 3'b000;
    WRITEENABLE = 1'b1;
    MUX1_SWITCH = 1'bX;
    MUX2_SWITCH = 1'b0;
    JUMP = 1'b0;
    BRANCH =1'b0;
    READ = 1'b1;
    WRITE = 1'b0;
    MEMORYCONTROL = 1'b0;
end

// store word direct instruction

if (OPCODE == 8'b00001010)
begin
    #1
    ALUOP = 3'b000;
    WRITEENABLE = 1'b0;
    MUX1_SWITCH = 1'b0;
    MUX2_SWITCH = 1'b1;
    JUMP = 1'b0;
    BRANCH =1'b0;
    READ = 1'b0;
    WRITE = 1'b1;
    MEMORYCONTROL = 1'b0;
end

// store word immediate instruction

if (OPCODE == 8'b00001011)
begin
    #1
    ALUOP = 3'b000;
    WRITEENABLE = 1'b0;
    MUX1_SWITCH = 1'bX;
    MUX2_SWITCH = 1'b0;
    JUMP = 1'b0;
    BRANCH =1'b0;
    READ = 1'b0;
    WRITE = 1'b1;
    MEMORYCONTROL = 1'b0;
end

end
endmodule

module mux(IN1,IN2,OUT,SWITCH);

    input [7:0] IN1,IN2;
    input SWITCH;
    output reg [7:0] OUT;

    always @(SWITCH,IN1,IN2)begin
    if (SWITCH == 0)OUT =IN1;
    if (SWITCH == 1)OUT =IN2;
    end

endmodule

module mux2(IN1,IN2,OUT,SWITCH);

    input [31:0] IN1,IN2;
    input SWITCH;
    output reg [31:0] OUT;

    always @(SWITCH,IN1,IN2)begin
    if (SWITCH == 0)OUT =IN2;
    if (SWITCH == 1)OUT =IN1;
    end

endmodule

module twos_Comp(IN,OUT);

    input [7:0] IN;
    output reg [7:0] OUT;

    always @(IN)begin
    #1
    OUT = -1*IN;
    end

endmodule

module Branch_or_Jump_adder(
    input [31:0] PC_reg,
    input [31:0] ex_JIMMEDIATE,
    output [31:0] target
);

    assign #2 target = PC_reg + (ex_JIMMEDIATE << 2);

endmodule

module SignExtender(
    input [7:0] extend,
    output [31:0] extended
);

    assign extended = {{24{extend[7]}}, extend};

endmodule


module flow_Control(JUMP,BRANCH,ZERO,OUT,OPCODE);

    input [7:0] OPCODE;
    input JUMP,BRANCH,ZERO;
    output reg OUT;

    //wire DECIDE to decide the Branch instruction
    wire DECIDE;

    assign DECIDE = OPCODE[3];

    always @(JUMP,BRANCH,ZERO,DECIDE) begin
    if (JUMP == 1'b1 || (ZERO == 1'b1 && BRANCH == 1'b1 && DECIDE == 1'b0) || (ZERO == 1'b0 && BRANCH == 1'b1 && DECIDE == 1'b1))begin
        OUT = 1'b1;
    end
    else begin
        OUT = 1'b0;
    end
    end

endmodule

module PC_adder(PC,PC_reg);

    input [31:0] PC;
    output reg [31:0] PC_reg;

    always @(PC) begin
        #1 PC_reg = PC + 4;
    end

endmodule

