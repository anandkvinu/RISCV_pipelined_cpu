
module fetch_cycle (clk,rst,PCSrcE,PCTargetE,InstrD,PCD,PCPlus4D);

input clk,rst;
input PCSrcE;
input [31:0] PCTargetE;
output [31:0] InstrD;
output [31:0] PCPlus4D,PCD;

wire [31:0] PC_F,PCF,PCPlus4F;
wire [31:0] InstrF; 
reg [31:0]InstrF_reg;
reg [31:0]PCF_reg,PCPlus4F_reg;
// instatiate mux
 Mux PC_MUX (.a(PCPlus4F),
             .b(PCTargetE),
             .s(PCSrcE),
             .c(PC_F));
// instantiate program counter
PC_Module Program_counter(.clk(clk),
          .rst(rst),
          .PC(PCF),
          .PC_Next(PC_F));

// instantiate instruction memory
Instruction_Memory im(.rst(rst),
                      .A(PCF),
                      .RD(InstrF));
// instantiate PC adder

PC_Adder  PC_adder(.a(PCF),
                   .b(32'h00000004),
                   .c(PCPlus4F));

always @(posedge clk or negedge rst) begin
if(rst == 1'b0)begin
InstrF_reg <= 32'h00000000;
PCF_reg <= 32'h00000000;
PCPlus4F_reg <= 32'h00000000;
end
else begin
InstrF_reg <= InstrF;
PCF_reg <= PC_F;
PCPlus4F_reg <= PCPlus4F;

end
end
// assigning register outputs
    assign InstrD = (rst ==1'b0) ? 32'h00000000 : InstrF_reg;
    assign PCD = (rst ==1'b0) ? 32'h00000000 : PCF_reg;
    assign PCPlus4D = (rst ==1'b0) ? 32'h00000000 : PCPlus4F_reg;
endmodule