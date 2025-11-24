interface alu_if;

  // Входы DUT (то, что подает testbench)
  logic [15:0] a;
  logic [15:0] b;
  logic        Cin;
  logic        mode;
  logic [3:0]  sel;

  // Выходы DUT (то, что наблюдает testbench)
  logic [15:0] result;
  logic        Cout;
  logic        nBo;
  logic        nGo;

  // Modport для подключения DUT:
  // DUT "читает" входы и "пишет" выходы
  modport dut_mp (
    input  a,
    input  b,
    input  Cin,
    input  mode,
    input  sel,
    output result,
    output Cout,
    output nBo,
    output nGo
  );

  // Modport для testbench:
  // testbench управляет входами и наблюдает выходы
  modport tb_mp (
    output a,
    output b,
    output Cin,
    output mode,
    output sel,
    input  result,
    input  Cout,
    input  nBo,
    input  nGo
  );

  // Modport для монитора (пассивное наблюдение всех сигналов)
  modport monitor_mp (
    input a,
    input b,
    input Cin,
    input mode,
    input sel,
    input result,
    input Cout,
    input nBo,
    input nGo
  );

endinterface


