module top_module (
    input clk,
    input [7:0] in,
    input reset,  // Synchronous reset
    output done
);  //

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

endmodule
