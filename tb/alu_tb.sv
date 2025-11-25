`timescale 1ns/1ps

module alu_tb;

  // интерфейс для связи testbench <-> DUT
  alu_if alu_intf();
  
  // Промежуточные wire для явного прокидывания сигналов
  wire [15:0] dut_a_wire, dut_b_wire, dut_result_wire;
  wire        dut_Cin_wire, dut_mode_wire, dut_Cout_wire, dut_nBo_wire, dut_nGo_wire;
  wire [3:0]  dut_sel_wire;

  // Подключение интерфейса к wire
  // Интерфейс сам по себе можно использовать

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

  // Monitor — пассивно наблюдает изменения на интерфейсе
  alu_monitor monitor_i (.mon_if(alu_intf));

  // тесты
  `include "../tests/alu_add_basic_test.sv"
  `include "../tests/alu_sub_basic_test.sv"
  `include "../tests/alu_shift_basic_test.sv"
  `include "../tests/alu_carry_only_test.sv"
  `include "../tests/alu_nocarry_only_test.sv"
  `include "../tests/alu_and_basic_test.sv"
  `include "../tests/alu_xor_basic_test.sv"
  `include "../tests/alu_or_basic_test.sv"
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
    #1;
    // 1) Обзорный тест по всем инструкциям для A_log=3, B_log=5
    test_all_ops_3_5();

    // 2) ADD (сложение)
    test_add_basic(success);
    if (success) passed_tests++; else failed_tests++;

    // 3) SUBTRACT (вычитание)
    test_sub_basic(success);
    if (success) passed_tests++; else failed_tests++;

    // 4) A PLUS A
    test_shift_basic(success);
    if (success) passed_tests++; else failed_tests++;

    // 5) перенос при сложении (проверяем только Cout)
    test_add_carry_only(success);
    if (success) passed_tests++; else failed_tests++;

    // 6) отсутствие переноса при сложении (проверяем только Cout)
    test_add_nocarry_only(success);
    if (success) passed_tests++; else failed_tests++;

    // 7) логическая операция AND
    test_and_basic(success);
    if (success) passed_tests++; else failed_tests++;

    // 8) логическая операция XOR
    test_xor_basic(success);
    if (success) passed_tests++; else failed_tests++;

    // 9) логическая операция OR
    test_or_basic(success);
    if (success) passed_tests++; else failed_tests++;
  endtask

  task automatic report_results();
    $display("\n=== TEST SUMMARY ===");
    $display("  Passed tests : %0d", passed_tests);
    $display("  Failed tests : %0d", failed_tests);
  endtask

endmodule


