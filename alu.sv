module alu(
  input  logic [31:0] a, b,
  input  logic [2:0]  alucontrol,
  output logic [31:0] result,
  output logic        zero
);

  logic [31:0] condinvb, sum;

  // alucontrol[2] biti 1 ise (örneğin 110 veya 111), çıkarma işlemi yapılır
  assign condinvb = alucontrol[2] ? ~b : b;
  assign sum = a + condinvb + alucontrol[2];

  always_comb
    case (alucontrol)
      3'b010: result = sum;         // ADD (Toplama) - Artık 010 geldiğinde toplayacak!
      3'b110: result = sum;         // SUB (Çıkarma)
      3'b000: result = a & b;       // AND (Ve)
      3'b001: result = a | b;       // OR (Veya)
      3'b111: result = {31'b0, sum[31]}; // SLT (Küçüktür)
      default: result = 32'bx;
    endcase

  assign zero = (result == 32'b0);

endmodule