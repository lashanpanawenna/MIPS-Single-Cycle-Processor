// including the alu and reg file
`include "alu.v"
`include "regfile.v"

module cpu(PC, INSTRUCTION, CLK, RESET);

//declaring inputs and outputs
input [31:0] INSTRUCTION;
input CLK,RESET;
output reg [31:0] PC;

//required registers and wires

reg [31:0] PC_reg;
reg [7:0] OPCODE,IMMEDIATE,ALUIN2;
wire [7:0] REGOUT1,REGOUT2,ALURESULT;
reg [2:0] READREG1,READREG2,WRITEREG,ALUOP;
reg WRITEENABLE;

//declaring the ALU and the REGISTER_FILE
reg_file REGITSERS(ALURESULT,REGOUT1,REGOUT2,WRITEREG,READREG1,READREG2,WRITEENABLE,CLK,RESET);
alu ALU(REGOUT1,ALUIN2,ALUOP,ALURESULT);

//updating the program counter if reset=0
always @(posedge CLK)
begin
    #1 PC = PC_reg;
end

//resetting the program counter if reset = 1
always @(posedge CLK)
begin
    if (RESET == 1'b1)
    begin
        #1
        PC = 0;
        PC_reg = 0;
    end
end

//updating the PC_reg
always @(PC)
begin
    #1 PC_reg = PC_reg + 4;
end

always @(INSTRUCTION)
begin
    #1
    // decoding the instruction
OPCODE[7:0] = INSTRUCTION[31:24];
IMMEDIATE[7:0] = INSTRUCTION[7:0];
READREG1[2:0] = INSTRUCTION[10:8];
READREG2[2:0] = INSTRUCTION[2:0];
WRITEREG[2:0] = INSTRUCTION[18:16];


//Load instruction
if (OPCODE == 8'b00000000)
begin
    ALUOP = 3'b000;
    ALUIN2 = IMMEDIATE;
    WRITEENABLE = 1'b1;

end
//move instruction

if (OPCODE == 8'b00000001)
begin
    ALUOP = 3'b000;
    ALUIN2 = REGOUT2;
    WRITEENABLE = 1'b1;

end

//add instruction
if (OPCODE == 8'b00000010)
begin
    ALUOP = 3'b001;
    WRITEENABLE = 1'b1;
    ALUIN2 = REGOUT2;

end

//sub instruction
if (OPCODE == 8'b00000011)
begin
    ALUOP = 3'b001;
    WRITEENABLE = 1'b1;
    ALUIN2 = -REGOUT2;
end

//and instruction
if (OPCODE == 8'b00000100)
begin
    ALUOP = 3'b010;
    WRITEENABLE = 1'b1;
    ALUIN2 = REGOUT2;
end

//or instruction
if (OPCODE == 8'b00000100)
begin
    ALUOP = 3'b011;
    WRITEENABLE = 1'b1;
    ALUIN2 = REGOUT2;
end

end
endmodule
