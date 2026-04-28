module mainfsm(
  input  logic       clk,
  input  logic       reset,
  input  logic [6:0] op,
  output logic       irwrite,
  output logic [1:0] alusrca, alusrcb,
  output logic [1:0] aluop,
  output logic [1:0] resultsrc,
  output logic       adrsrc,
  output logic       pcupdate, branch,
  output logic       regwrite, memwrite
);

  typedef enum logic [3:0] {
    FETCH    = 4'd0,
    DECODE   = 4'd1,
    MEMADR   = 4'd2,
    MEMREAD  = 4'd3,
    MEMWB    = 4'd4,
    MEMWRITE = 4'd5,
    EXECUTER = 4'd6,
    ALUWB    = 4'd7,
    EXECUTEI = 4'd8,
    JAL      = 4'd9,
    BEQ      = 4'd10
  } statetype;

  statetype state, nextstate;

  // State Register
  always_ff @(posedge clk or posedge reset) begin
    if (reset) state <= FETCH;
    else       state <= nextstate;
  end

  // Next State Logic
  always_comb begin
    case (state)
      FETCH:    nextstate = DECODE;
      DECODE:   case(op)
                  7'b0000011: nextstate = MEMADR;   // lw
                  7'b0100011: nextstate = MEMADR;   // sw
                  7'b0110011: nextstate = EXECUTER; // R-type
                  7'b0010011: nextstate = EXECUTEI; // I-type ALU
                  7'b1101111: nextstate = JAL;      // jal
                  7'b1100011: nextstate = BEQ;      // beq
                  default:    nextstate = FETCH;    
                endcase
      MEMADR:   case(op)
                  7'b0000011: nextstate = MEMREAD;  // lw
                  7'b0100011: nextstate = MEMWRITE; // sw
                  default:    nextstate = FETCH;
                endcase
      MEMREAD:  nextstate = MEMWB;
      MEMWB:    nextstate = FETCH;
      MEMWRITE: nextstate = FETCH;
      EXECUTER: nextstate = ALUWB;
      EXECUTEI: nextstate = ALUWB;
      ALUWB:    nextstate = FETCH;
      JAL:      nextstate = ALUWB;
      BEQ:      nextstate = FETCH;
      default:  nextstate = FETCH;
    endcase
  end

  // Output Logic
  always_comb begin
    // Default deterministic values
    adrsrc    = 1'b0;
    irwrite   = 1'b0;
    alusrca   = 2'b00;
    alusrcb   = 2'b00;
    aluop     = 2'b00;
    resultsrc = 2'b00;
    pcupdate  = 1'b0;
    branch    = 1'b0;
    regwrite  = 1'b0;
    memwrite  = 1'b0;

    case (state)
      FETCH: begin
        adrsrc    = 1'b0;
        irwrite   = 1'b1;
        alusrca   = 2'b00;
        alusrcb   = 2'b10;
        aluop     = 2'b00;
        resultsrc = 2'b10;
        pcupdate  = 1'b1;
      end
      DECODE: begin
        alusrca   = 2'b01;
        alusrcb   = 2'b01;
        aluop     = 2'b00;
      end
      MEMADR: begin
        alusrca   = 2'b10;
        alusrcb   = 2'b01;
        aluop     = 2'b00;
      end
      MEMREAD: begin
        resultsrc = 2'b00;
        adrsrc    = 1'b1;
      end
      MEMWB: begin
        resultsrc = 2'b01;
        regwrite  = 1'b1;
      end
      MEMWRITE: begin
        resultsrc = 2'b00;
        adrsrc    = 1'b1;
        memwrite  = 1'b1;
      end
      EXECUTER: begin
        alusrca   = 2'b10;
        alusrcb   = 2'b00;
        aluop     = 2'b10;
      end
      EXECUTEI: begin
        alusrca   = 2'b10;
        alusrcb   = 2'b01;
        aluop     = 2'b10;
      end
      ALUWB: begin
        resultsrc = 2'b00;
        regwrite  = 1'b1;
      end
      JAL: begin
        alusrca   = 2'b01;
        alusrcb   = 2'b10;
        aluop     = 2'b00;
        resultsrc = 2'b00;
        pcupdate  = 1'b1;
      end
      BEQ: begin
        alusrca   = 2'b10;
        alusrcb   = 2'b00;
        aluop     = 2'b01;
        resultsrc = 2'b00;
        branch    = 1'b1;
      end
    endcase
  end
endmodule