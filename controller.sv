module controller(
  input  logic       clk,
  input  logic       reset,
  input  logic [6:0] op,
  input  logic [2:0] funct3,
  input  logic       funct7b5,
  input  logic       zero,
  output logic [1:0] immsrc,
  output logic [1:0] alusrca, alusrcb,
  output logic [1:0] resultsrc,
  output logic       adrsrc,
  output logic [2:0] alucontrol,
  output logic       irwrite, pcwrite,
  output logic       regwrite, memwrite
);

  // Internal signals connecting the sub-modules
  logic [1:0] aluop;
  logic       branch;
  logic       pcupdate;

  // 1. Main FSM Instantiation
  mainfsm fsm (
    .clk(clk), .reset(reset), .op(op),
    .irwrite(irwrite), .alusrca(alusrca), .alusrcb(alusrcb),
    .aluop(aluop), .resultsrc(resultsrc), .adrsrc(adrsrc),
    .pcupdate(pcupdate), .branch(branch),
    .regwrite(regwrite), .memwrite(memwrite)
  );

  // 2. ALU Decoder Instantiation
  aludec ad (
    .opb5(op[5]), .funct3(funct3), .funct7b5(funct7b5),
    .ALUOp(aluop), .ALUControl(alucontrol)
  );

  // 3. Instruction Decoder Instantiation
  instrdec id (
    .op(op), .ImmSrc(immsrc)
  );

  // PCWrite Logic (AND & OR gates at the top of Figure 1)
  assign pcwrite = (branch & zero) | pcupdate;

endmodule