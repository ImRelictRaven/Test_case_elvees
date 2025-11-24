 // тест для операции ADD

task automatic test_add_basic(output bit success);

  int          i;
  int unsigned num_tests;
  logic [15:0] expected;
  logic [15:0] A_log;
  logic [15:0] B_log;
  logic [15:0] logic_result;

  success   = 1'b1;
  num_tests = 10;   // количество случайных проверок ADD

  $display("[%0t] [test_add_basic] Start, random ADD tests = %0d", $time, num_tests);

  // фиксируем режим ADD один раз
  alu_intf.mode = 1'b0;        // арифметический режим
  alu_intf.sel  = 4'b1001;     // ADD
  alu_intf.Cin  = 1'b1;        // нет входного переноса

  for (i = 0; i < num_tests; i++) begin

    // берём случайные 16 младших бит из $urandom(), чтобы избежать предупреждений по ширине
    A_log = $urandom()[15:0];
    B_log = $urandom()[15:0];

    expected = A_log + B_log;

    alu_intf.a = A_log;
    alu_intf.b = B_log;

    #10;
    logic_result = alu_intf.result;
    //вместо assert стоит if чтобы тест не падал
    if (logic_result !== expected) begin
      $display(
        "[%0t] [test_add_basic] ADD FAILED: A_log=%h B_log=%h Cin=%b logic_result=%h expected=%h",
        $time, A_log, B_log, alu_intf.Cin, logic_result, expected
      );
      success = 1'b0;
    end
    else begin
      $display(
        "[%0t] [test_add_basic] ADD OK: A_log=%h B_log=%h Cin=%b result=%h",
        $time, A_log, B_log, alu_intf.Cin, logic_result
      );
    end
  end

  if (success)
    $display("[%0t] [test_add_basic] ALL RANDOM ADD TESTS PASSED", $time);
  else
    $display("[%0t] [test_add_basic] SOME RANDOM ADD TESTS FAILED", $time);

endtask



