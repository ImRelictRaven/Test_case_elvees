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

  // счётчики для будущей статистики тестов
  int unsigned passed_tests;
  int unsigned failed_tests;

  // главный управляющий блок testbench
  initial begin

    initialize_test();

    run_tests();

    report_results();

    $finish;
  end

  // базовая инициализация интерфейса и счётчиков
  task automatic initialize_test();
    // обнуление сигналов интерфейса
    // начальные сообщения в лог
    passed_tests = 0;
    failed_tests = 0;
    $display("[%0t] Testbench initialization done", $time);
  endtask

  // запуск отдельных тестов для операций АЛУ
  task automatic run_tests();
    // здесь позже будут вызываться тесты

    $display("[%0t] run_tests() is not implemented yet", $time);
  endtask

  // итоговый отчёт по результатам тестирования
  task automatic report_results();
    $display("\n=== TEST SUMMARY ===");
    $display("  Passed tests : %0d", passed_tests);
    $display("  Failed tests : %0d", failed_tests);
  endtask

endmodule


