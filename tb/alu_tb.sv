`timescale 1ns/1ps

module alu_tb;

  // интерфейс для связи testbench <-> DUT
  alu_if alu_intf();

  // экземпляр DUT (16-разрядное АЛУ)
  alu16 dut (
    .a      (alu_intf.a),
    .b      (alu_intf.b),
    .Cin    (alu_intf.Cin),
    .mode   (alu_intf.mode),
    .sel    (alu_intf.sel),
    .result (alu_intf.result),
    .Cout   (alu_intf.Cout),
    .nBo    (alu_intf.nBo),
    .nGo    (alu_intf.nGo)
  );

  // тесты
  `include "../tests/alu_add_basic_test.sv"
  `include "../tests/alu_sub_basic_test.sv"
  `include "../tests/alu_all_ops_3_5_test.sv"

  // счётчики для статистики тестов
  int unsigned passed_tests;
  int unsigned failed_tests;

  // главный управляющий блок testbench
  initial begin

    initialize_test();

    run_tests();

    report_results();

    $finish;
  end

  task automatic initialize_test();
    alu_intf.a    = '0;
    alu_intf.b    = '0;
    alu_intf.Cin  = 1'b1;
    alu_intf.mode = 1'b0;
    alu_intf.sel  = 4'b0000;

    passed_tests = 0;
    failed_tests = 0;

    $display("[%0t] Testbench initialization done", $time);
  endtask

  task automatic run_tests();
    bit success;

    $display("[%0t] Starting run_tests()", $time);

    // 1) Обзорный тест по всем инструкциям для A_log=3, B_log=5
    test_all_ops_3_5();

    // 2) ADD (сложение)
    test_add_basic(success);
    if (success) passed_tests++; else failed_tests++;

    // 3) SUBTRACT (вычитание)
    test_sub_basic(success);
    if (success) passed_tests++; else failed_tests++;
  endtask

  task automatic report_results();
    $display("\n=== TEST SUMMARY ===");
    $display("  Passed tests : %0d", passed_tests);
    $display("  Failed tests : %0d", failed_tests);
  endtask

endmodule


