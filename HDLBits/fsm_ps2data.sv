module top_module (
    input clk,
    input [7:0] in,
    input reset,  // Synchronous reset
    output [23:0] out_bytes,
    output done
);  //

  // FSM from fsm_ps2

  parameter START = 2'd0;
  parameter B1 = 2'd1;
  parameter B2 = 2'd2;
  parameter B3 = 2'd3;

  logic [1:0] s, ns;
  logic in3;

  assign in3 = in[3];

  // State transition logic (combinational)
  always @(*) begin
    case (s)
      START: begin
        ns = in3 ? B1 : START;
      end
      B1: begin
        ns = B2;
      end
      B2: begin
        ns = B3;
      end
      B3: begin
        ns = in3 ? B1 : START;
      end
    endcase
  end

  // State flip-flops (sequential)
  always_ff @(posedge clk) begin
    if (reset) s <= START;
    else s <= ns;
  end

  // Output logic
  assign done = s == B3;

  // New: Datapath to store incoming bytes.
  always_ff @(posedge clk) begin
    if (reset) out_bytes <= 24'd0;
    else if (s == START || s == B3) out_bytes <= {in, 16'd0};
    else if (s == B1) out_bytes[15:8] <= in;
    else if (s == B2) out_bytes[7:0] <= in;
  end

endmodule





