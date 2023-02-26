// This code does not clear all tests.
// It needs some work.

module top_module (
    input  clk,
    input  in,
    input  reset,  // Synchronous reset
    output done
);

  integer counter;

  parameter IDLE = 2'd0;
  parameter PARSING = 2'd1;
  parameter CHECKSUM = 2'd2;
  parameter DONE = 2'd3;

  logic [1:0] s, ns;

  always @(*) begin
    case (s)
      IDLE: begin
        ns = ~in ? PARSING : IDLE;
      end

      PARSING: begin
        ns = (counter == 7) ? CHECKSUM : PARSING;
      end

      CHECKSUM: begin
        ns = in ? DONE : IDLE;
      end

      DONE: begin
        ns = (~in) ? PARSING : IDLE;
      end
    endcase
  end

  always @(posedge clk) begin
    s <= reset ? IDLE : ns;
  end

  always @(posedge clk) begin
    counter <= (s == PARSING) ? counter + 1 : 0;
  end

  assign done = (s == DONE);

endmodule

