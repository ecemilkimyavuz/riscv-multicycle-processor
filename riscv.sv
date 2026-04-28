module riscv(
  input  logic        clk, reset,
  input  logic [31:0] ReadData,
  output logic        MemWrite,
  output logic [31:0] Adr, WriteData
);

  // Internal signals between Controller and Datapath
  logic        Zero, PCWrite, AdrSrc, IRWrite, RegWrite;
  logic [1:0]  ResultSrc, ALUSrcA, ALUSrcB, ImmSrc;
  logic [2:0]  ALUControl;
  logic [6:0]  op;
  logic [2:0]  funct3;
  logic        funct7b5;

  // 1. Controller (from Lab 2)
  controller c(
    .clk(clk), .reset(reset),
    .op(op), .funct3(funct3), .funct7b5(funct7b5), .zero(Zero),
    .immsrc(ImmSrc),
    .alusrca(ALUSrcA), .alusrcb(ALUSrcB),
    .resultsrc(ResultSrc), .adrsrc(AdrSrc),
    .alucontrol(ALUControl),
    .irwrite(IRWrite), .pcwrite(PCWrite),
    .regwrite(RegWrite), .memwrite(MemWrite)
  );

  // 2. Datapath
  datapath dp(
    .clk(clk), .reset(reset),
    .PCWrite(PCWrite), .AdrSrc(AdrSrc), .IRWrite(IRWrite),
    .ResultSrc(ResultSrc), .ALUControl(ALUControl),
    .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ImmSrc(ImmSrc),
    .RegWrite(RegWrite), .Zero(Zero),
    .op(op), .funct3(funct3), .funct7b5(funct7b5),
    .Adr(Adr), .WriteData(WriteData), .ReadData(ReadData)
  );

endmodule