// тест для операции A PLUS A

task automatic test_shift_basic(output bit success);

  int          i;
  int unsigned num_tests;
  logic [16:0] sum_ext;
  logic [15:0] expected;
  logic        expected_cout;
  logic [15:0] A_log;
  logic [15:0] B_log;
  logic [15:0] logic_result;

  success   = 1'b1;
  num_tests = 10;   // количество случайных проверок 

  $display("[%0t] [test_shift_basic] Start, random SHIFT tests = %0d", $time, num_tests);

  alu_intf.mode = 1'b0;        // арифметический режим
  alu_intf.sel  = 4'b1100;     // A + A 
  alu_intf.Cin  = 1'b1;        // нет входного переноса

  for (i = 0; i < num_tests; i++) begin
    // B для этой операции, неважен
    A_log = $urandom()[15:0];
    B_log = $urandom()[15:0];

    sum_ext       = {1'b0, A_log} + {1'b0, A_log};
    expected      = sum_ext[15:0];
    expected_cout = ~sum_ext[16];

    alu_intf.a = A_log;
    alu_intf.b = B_log;

    logic_result = alu_intf.result;

    if (logic_result !== expected || alu_intf.Cout !== expected_cout) begin
      $display(
        "[%0t] [test_shift_basic] SHIFT FAILED: A_log=%h B_log=%h Cin=%b logic_result=%h expected=%h Cout=%b expected_cout=%b",
        $time, A_log, B_log, alu_intf.Cin,
        logic_result, expected, alu_intf.Cout, expected_cout
      );
      success = 1'b0;
    end
    else begin
      $display(
        "[%0t] [test_shift_basic] SHIFT OK: A_log=%h B_log=%h Cin=%b result=%h",
        $time, A_log, B_log, alu_intf.Cin, logic_result
      );
    end
  end

  if (success)
    $display("[%0t] [test_shift_basic] ALL RANDOM SHIFT TESTS PASSED", $time);
  else
    $display("[%0t] [test_shift_basic] SOME RANDOM SHIFT TESTS FAILED", $time);

endtask



