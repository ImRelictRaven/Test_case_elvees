// тест для логической операции XOR

task automatic test_xor_basic(output bit success);

  int          i;
  int unsigned num_tests;
  logic [15:0] expected;
  logic [15:0] A_log;
  logic [15:0] B_log;
  logic [15:0] logic_result;

  success   = 1'b1;
  num_tests = 10;   // количество случайных проверок XOR

  $display("[%0t] [test_xor_basic] Start, random XOR tests = %0d", $time, num_tests);


  alu_intf.mode = 1'b1;
  alu_intf.sel  = 4'b0110;
  alu_intf.Cin  = 1'b0;

  for (i = 0; i < num_tests; i++) begin
    A_log = $urandom()[15:0];
    B_log = $urandom()[15:0];

    expected = A_log ^ B_log;

    alu_intf.a = A_log;
    alu_intf.b = B_log;

    #10;
    logic_result = alu_intf.result;

    if (logic_result !== expected) begin
      $display(
        "[%0t] [test_xor_basic] XOR FAILED: A_log=%h B_log=%h result=%h expected=%h",
        $time, A_log, B_log, logic_result, expected
      );
      success = 1'b0;
    end
    else begin
      $display(
        "[%0t] [test_xor_basic] XOR OK: A_log=%h B_log=%h result=%h",
        $time, A_log, B_log, logic_result
      );
    end
  end

  if (success)
    $display("[%0t] [test_xor_basic] ALL RANDOM XOR TESTS PASSED", $time);
  else
    $display("[%0t] [test_xor_basic] SOME RANDOM XOR TESTS FAILED", $time);

endtask


