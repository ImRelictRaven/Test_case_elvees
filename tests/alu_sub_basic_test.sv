// тест для операции SUBTRACT (a-b)

task automatic test_sub_basic(output bit success);

  int          i;
  int unsigned num_tests;
  logic [15:0] expected;
  logic [15:0] A_log;
  logic [15:0] B_log;
  logic [15:0] logic_result;

  success   = 1'b1;
  num_tests = 10;   // количество случайных проверок SUB

  $display("[%0t] [test_sub_basic] Start, random SUB tests = %0d", $time, num_tests);

  alu_intf.mode = 1'b0;        // арифметический режим
  alu_intf.sel  = 4'b0110;     // SUBTRACT
  alu_intf.Cin  = 1'b1;        // "нет входного переноса" 

  for (i = 0; i < num_tests; i++) begin
    // берём случайные 16 младших бит из $urandom(), чтобы избежать предупреждений по ширине
    A_log = $urandom()[15:0];
    B_log = $urandom()[15:0];

    expected = A_log - B_log - 1;

    alu_intf.a = A_log;
    alu_intf.b = B_log;

    #10;
    logic_result = alu_intf.result;

    if (logic_result !== expected) begin
      $display(
        "[%0t] [test_sub_basic] SUB FAILED: A_log=%h B_log=%h Cin=%b logic_result=%h expected=%h",
        $time, A_log, B_log, alu_intf.Cin, logic_result, expected
      );
      success = 1'b0;
    end
    else begin
      $display(
        "[%0t] [test_sub_basic] SUB OK: A_log=%h B_log=%h Cin=%b result=%h",
        $time, A_log, B_log, alu_intf.Cin, logic_result
      );
    end
  end

  if (success)
    $display("[%0t] [test_sub_basic] ALL RANDOM SUB TESTS PASSED", $time);
  else
    $display("[%0t] [test_sub_basic] SOME RANDOM SUB TESTS FAILED", $time);

endtask



