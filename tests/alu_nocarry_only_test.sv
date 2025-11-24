// тест для проверки отсутствия переноса (Cout) при сложении

task automatic test_add_nocarry_only(output bit success);

  logic [15:0] A_log;
  logic [15:0] B_log;
  logic [15:0] logic_result;

  success = 1'b1;

  $display("[%0t] [test_add_carry_only] Start", $time);

  A_log = 16'h0001;
  B_log = 16'h0002;

  alu_intf.mode = 1'b0;        // арифметический режим
  alu_intf.sel  = 4'b1001;     // ADD
  alu_intf.Cin  = 1'b1;        // нет входного переноса

  alu_intf.a = A_log;
  alu_intf.b = B_log;

  logic_result = alu_intf.result;

  // для переполнения ожидаем Cout = 1 из-за инверсии
  if (alu_intf.Cout === 1'b1) begin
    $display(
      "[%0t] [test_add_carry_only] CARRY OK: A_log=%h B_log=%h result=%h Cout=%b",
      $time, A_log, B_log, logic_result, alu_intf.Cout
    );
  end
  else begin
    $display(
      "[%0t] [test_add_carry_only] CARRY FAILED: A_log=%h B_log=%h result=%h Cout=%b (expected Cout=0)",
      $time, A_log, B_log, logic_result, alu_intf.Cout
    );
    success = 1'b0;
  end

endtask

