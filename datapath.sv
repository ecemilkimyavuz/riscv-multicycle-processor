module datapath(
  input  logic        clk, reset,
  input  logic        PCWrite, AdrSrc, IRWrite,
  input  logic [1:0]  ResultSrc,
  input  logic [2:0]  ALUControl,
  input  logic [1:0]  ALUSrcA, ALUSrcB,
  input  logic [1:0]  ImmSrc,
  input  logic        RegWrite,
  output logic        Zero,
  output logic [6:0]  op,
  output logic [2:0]  funct3,
  output logic        funct7b5,
  output logic [31:0] Adr, WriteData,
  input  logic [31:0] ReadData
);

  logic [31:0] PC, Instr, Data;
  logic [31:0] OldPC, A, B;
  logic [31:0] SrcA, SrcB, ALUResult, ALUOut, Result;
  logic [31:0] ImmExt;
  logic [31:0] RD1, RD2;

  // --- Signals to Controller ---
  assign op       = Instr[6:0];
  assign funct3   = Instr[14:12];
  assign funct7b5 = Instr[30];

  // --- Write Data to Memory ---
  assign WriteData = B;

  // --- 1. PC and Address Logic ---
  flopenr #(32) pcreg   (clk, reset, PCWrite, Result, PC);
  mux2    #(32) adrmux  (PC, Result, AdrSrc, Adr);

  // --- 2. Storing Data from Memory ---
  flopenr #(32) ir      (clk, reset, IRWrite, ReadData, Instr);
  flopenr #(32) oldpcreg(clk, reset, IRWrite, PC, OldPC);
  flopr   #(32) datareg (clk, reset, ReadData, Data);

  // --- 3. Register File (Read/Write) ---
  RegFile rf(clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, RD1, RD2);
  flopr   #(32) areg    (clk, reset, RD1, A);
  flopr   #(32) breg    (clk, reset, RD2, B);

  // --- 4. Immediate Extension ---
  Extend ext(Instr[31:7], ImmSrc, ImmExt);

  // --- 5. ALU Input Muxes ---
  // ALUSrcA (00: PC, 01: OldPC, 10: A)
  mux3 #(32) srcamux(PC, OldPC, A, ALUSrcA, SrcA);
  // ALUSrcB (00: B, 01: ImmExt, 10: 4)
  mux3 #(32) srcbmux(B, ImmExt, 32'd4, ALUSrcB, SrcB);

  // --- 6. ALU and Output ---
  alu alu_unit(SrcA, SrcB, ALUControl, ALUResult, Zero);
  flopr #(32) aluoutreg(clk, reset, ALUResult, ALUOut);

  // --- 7. Result Mux (Feedback and PCNext) ---
  // ResultSrc (00: ALUOut, 01: Data, 10: ALUResult)
  mux3 #(32) resmux(ALUOut, Data, ALUResult, ResultSrc, Result);

endmodule