module top_module (
    input clk,
    input areset,  // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

  reg [2:0] state, next_state;
  parameter LEFT = 3'b000, RIGHT = 3'b001, FALL_L = 3'b010, FALL_R = 3'b011, DIG_L = 3'b100, DIG_R = 3'b101, DEAD = 3'b110;
  logic   alive;
  integer count;

  always @(*) begin
    case (state)
      LEFT: begin
        if (ground == 0) next_state = FALL_L;
        else if (dig) next_state = DIG_L;
        else if (bump_left) next_state = RIGHT;
        else next_state = LEFT;
      end
      RIGHT: begin
        if (ground == 0) next_state = FALL_R;
        else if (dig) next_state = DIG_R;
        else if (bump_right) next_state = LEFT;
        else next_state = RIGHT;
      end
      FALL_L: begin
        if (ground == 1) begin
          if (count >= 20) next_state = DEAD;
          else next_state = LEFT;
        end else next_state = FALL_L;
      end
      FALL_R: begin
        if (ground == 1) begin
          if (count >= 20) next_state = DEAD;
          else next_state = RIGHT;
        end else next_state = FALL_R;
      end
      DIG_L: begin
        if (ground == 0) next_state = FALL_L;
        else next_state = DIG_L;
      end
      DIG_R: begin
        if (ground == 0) next_state = FALL_R;
        else next_state = DIG_R;
      end
      DEAD: next_state = DEAD;
      default: begin
        next_state = LEFT;
      end
    endcase
  end

  always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= LEFT;
    else state <= next_state;
  end

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      count <= 0;
    end else if (aaah) begin
      count <= count + 1;
    end else count <= 0;

  end

  assign aaah = (state == FALL_L) || (state == FALL_R);
  assign digging = (state == DIG_L) || (state == DIG_R);
  assign walk_left = (state == LEFT);
  assign walk_right = (state == RIGHT);

endmodule


