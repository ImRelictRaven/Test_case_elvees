# Тестовое задание на позицию junior инженера-верификатора UVM/SystemVerilog

## Цель задания
Оценить базовые навыки кандидата в создании тестового окружения на SystemVerilog, написании тестов, анализе результатов и работе с системой контроля версий Git.

## Описание тестируемого дизайна (DUT)
В качестве объекта верификации используется упрощенная версия 16-разрядного процессора, а именно его блок арифметико-логического устройства (АЛУ). Дизайн был разработан в рамках учебного курса "Цифровая схемотехника и архитектура компьютера" для проведения учебного процесса в НИУ ВШЭ МИЭМ.

В тестируемом дизайне (DUT) исключены следующие компоненты из оригинального дизайна:
- регистровый файл;
- регистр статуса с флагами;
- блок переходов;
- подсистема DSP;
  - Матричный умножитель;
  - Модуль восстанавливающего деления;
  - Комбинационный умножитель;
  - Расчет обратного корня;

## Состав дизайна

__Модуль верхнего уровня:__ [16-разрядное АЛУ](./top_alu_16.v): Каскадируется из четырех 4-разрядных АЛУ
- __4-разрядное АЛУ:__ [74181](./74181.v) (арифметико-логическое устройство)
- __Модуль ускоренного переноса (CLA):__ [74182](./74182_CLA.v) (Carry Look-Ahead Unit)

## Иерархия:

```
alu16  
 ├── 74181 (экземпляры 0..3)  
 └── 74182    
```

## Задание

### 1. Разработка тестового окружения
- Создать интерфейс (interface) для подключения тестового окружения к DUT
- Реализовать модуль тестового окружения (testbench) на SystemVerilog для модуля __alu_16__
- Организовать проверку результатов с помощью assert-проверок и сравнения с ожидаемыми значениями (опционально)
- Реализовать сбор и вывод статистики по результатам тестирования

### 2. Написание тестов
- Разработать набор directed-тестов для проверки базового функционала:
  - 3-4 арифметические операции (например: ADD, SUB, INC)
  - 2-3 логические операции (например: AND, OR, XOR)
  - Проверка работы с переносами
- Для экономии времени __допускается реализовать поддержку только 50% инструкций АЛУ__ из арифметического и логического набора
- Каждый тест должен содержать понятные проверки и сообщения об ошибках

### 3. Анализ и отчетность
- В случае обнаружения несоответствия поведения дизайна, составить краткий отчет об ошибке
- Отчет должен содержать:
  - Краткое описание проблемы
  - Условия воспроизведения
  - Ожидаемое и фактическое поведение

## Требования к результату

1. __Исходный код:__ Весь код должен быть предоставлен в виде ссылки на __Git-репозиторий__

2. __Состав репозитория:__
   - __README.md__ с описанием:
     - Как запускать симуляцию
     - Список реализованных тестов
     - Краткое описание архитектуры тестового окружения
   - __Makefile__ или скрипты для запуска симуляции
   - __.gitignore__ - для исключения временных файлов симуляции

3. __Структура проекта:__ Логичное разделение на директории (например: `rtl/`, `tb/`, `tests/`, `scripts/`)

4. __История коммитов:__ История Git должна отражать поэтапный процесс разработки. Пример:

```
feat: add basic testbench structure
feat: implement ALU driver and monitor
test: add ADD operation tests
test: add logical operations tests
feat: add result checking with assertions
docs: update README with run instructions
```

## Критерии оценивания

| Критерий | Вес | Описание |
|----------|-----|-----------|
| __Работа с Git и организация кода__ | 20% | Логичная структура проекта, история коммитов, наличие README |
| __Архитектура тестового окружения__ | 40% | Корректная организация testbench, модульность, чистота кода |
| __Качество тестов__ | 30% | Полнота покрытия базового функционала, понятность проверок |
| __Анализ результатов__ | 10% | Качество отчетов об ошибках и выводов по тестированию |

## Рекомендуемая структура testbench

```sv
  // ALU Interface definition
  interface alu_if (input logic clk);
    logic        reset;
    logic [15:0] operand_a;
    logic [15:0] operand_b; 
    logic [3:0]  opcode;
    logic [15:0] result;
    logic        carry_in;
    logic        carry_out;

  // Modport for DUT (inputs are driven by testbench)
  modport dut_mp (
    ...
  );

  // Modport for testbench (inputs are received from DUT)  
  modport tb_mp (
    ...
  );
  ```

  ```sv
  // Main testbench module
  module alu_tb;
  logic clk;

  // Interface instantiation
  alu_if alu_intf(clk);

  // DUT instantiation using interface
  alu16 dut (
  .clk(clk),
  .reset(alu_intf.reset),
  .operand_a(alu_intf.operand_a),
  .operand_b(alu_intf.operand_b),
  .opcode(alu_intf.opcode),
  .carry_in(alu_intf.carry_in),
  .result(alu_intf.result),
  .carry_out(alu_intf.carry_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test controller
  initial begin
    initialize_test();
    run_tests();
    report_results();
    $finish;
  end

  // Helper tasks
  task initialize_test();
    alu_intf.reset <= 1;
    alu_intf.operand_a <= 0;
    alu_intf.operand_b <= 0;
    alu_intf.opcode <= 0;
    alu_intf.carry_in <= 0;
    #20 alu_intf.reset <= 0;
    $display("Test initialization completed");
  endtask

  task run_tests();
    test_add_operation();
    ...
    test_and_operation();
    ...
  endtask

  // Individual test tasks
    task test_add_operation();
    $display("Testing ADD operation...");
    alu_intf.opcode <= 4'b0000; // ADD
    alu_intf.operand_a <= 16'h0005;
    alu_intf.operand_b <= 16'h0003;
    alu_intf.carry_in <= 0;
    
    ...
    end
  endtask

  task test_and_operation();
    $display("Testing AND operation...");
    alu_intf.opcode <= 4'b0101; // AND
    alu_intf.operand_a <= 16'h00FF;
    alu_intf.operand_b <= 16'h0F0F;
    ...
  endtask


  // Results reporting
  task report_results();
    $display("\n=== TEST SUMMARY ===");
    $display("All basic operations tested");
    $display("Testbench completed successfully");
  endtask

  // Additional monitoring
  always @(posedge clk) begin
  if (!alu_intf.reset) begin
    // Monitor can be extended here
    $display("Cycle: opcode=%h, a=%h, b=%h, result=%h, carry_out=%b",
              alu_intf.opcode, alu_intf.operand_a, 
              alu_intf.operand_b, alu_intf.result, alu_intf.carry_out);
  end
  end
  endmodule

```

## Бонусные задания (опционально):

- Добавьте случайную генерацию тестовых данных для нескольких операций
- Реализуйте простую систему отчетности с подсчетом пройденных/непройденных тестов
- Используйте SystemVerilog coverpoints для сбора базовой статистики покрытия
- Добавьте тесты для проверки граничных случаев (corner cases) / с использованием случайных данных
- Добавьте отдельный монитор (monitor module), использующий monitor_mp modport
- Реализуйте простой драйвер (driver module) для генерации транзакций
- Добавьте coverpoints в interface для сбора базовой статистики покрытия

## Стратегия оценивания:
- Умение создать работоспособное тестовое окружение
- Понимание основ верификации цифровых схем
- Качество и читаемость кода
- Организацию работы с системой контроля версий
- Способность к самостоятельному решению задач