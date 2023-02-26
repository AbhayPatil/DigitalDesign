// This design 'may' not be synthesizable as there appears to be
// a feedback in combinational logic during function and task calls.
//
// This design is certainly not synthesizable as it contains an
// initial block.

module task_and_function ();

  logic [3:0] num;

  // Task
  // 1. Did not compile without explicit input/output
  // declaration in iverilog.
  task IncT;
    output [3:0] inc;
    input [3:0] num;
    #2;
    inc = num+1;
  endtask

  // Function
  function logic[3:0] IncF (logic [3:0] num);
    IncF = num+1;
  endfunction

  initial begin
    num = 4'd0;
    repeat(16) begin
      $display("Num %d\n", num);
      
      // Call function
      // num = IncF(num);

      // Call a task
      IncT(num, num);
    end
  end

endmodule
