module mem(
  input  logic        clk, WE,
  input  logic [31:0] A, WD,
  output logic [31:0] RD
);

  logic [31:0] RAM[63:0];

  initial
      $readmemh("C:/Users/HP/Desktop/4thSpring/FPGA/Labs/3/multicycle proccessor/riscvtest.txt", RAM); // File containing the test code

  assign RD = RAM[A[31:2]]; // Word aligned

  always_ff @(posedge clk)
    if (WE) RAM[A[31:2]] <= WD;

endmodule