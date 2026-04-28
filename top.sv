module top(
  input  logic        clk, reset,
  output logic [31:0] WriteData, DataAdr,
  output logic        MemWrite
);

  logic [31:0] ReadData;

  // Processor and Memory instantiation
  riscv rv32(clk, reset, ReadData, MemWrite, DataAdr, WriteData);
  mem   memory(clk, MemWrite, DataAdr, WriteData, ReadData);

endmodule