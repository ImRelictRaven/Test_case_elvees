task automatic test_all_ops_3_5();
  int mode;
  int sel;
  int cin;

  logic [15:0] A_log = 16'h0003;
  logic [15:0] B_log = 16'h0005;

  alu_intf.a = A_log;
  alu_intf.b = B_log;

  $display("\n=== TEST ALL OPS (A_log=%h, B_log=%h) ===", A_log, B_log);

  for (mode = 0; mode <= 1; mode++) begin
    for (cin = 0; cin <= 1; cin++) begin
      for (sel = 0; sel < 16; sel++) begin
        alu_intf.mode = mode[0];
        alu_intf.sel  = sel[3:0];
        alu_intf.Cin  = cin[0];

        $display("[%0t] mode=%0d sel=%0h Cin=%0b -> result=%h",
                 $time, mode[0], sel[3:0], cin[0], alu_intf.result);
      end
    end
  end
endtask



