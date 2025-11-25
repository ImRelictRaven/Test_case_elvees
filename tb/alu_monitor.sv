`timescale 1ns/1ps

module alu_monitor (alu_if.monitor_mp mon_if);

  logic [15:0] prev_result;
  logic        prev_Cout;

  initial begin
    prev_result = mon_if.result;
    prev_Cout   = mon_if.Cout;
    $display("[%0t] [monitor] стартовал", $time); // Комментарий
  end

  // логируем изменения результата и переноса
  // РЕкомендуется исп-ть always_comb

  always @(mon_if.result or mon_if.Cout or mon_if.a or mon_if.b or mon_if.sel or mon_if.mode) begin
    if (mon_if.result !== prev_result || mon_if.Cout !== prev_Cout) begin
      $display("[%0t] [monitor] mode=%b sel=%h Cin=%b a=%h b=%h -> result=%h Cout=%b",
        $time, mon_if.mode, mon_if.sel, mon_if.Cin, mon_if.a, mon_if.b, mon_if.result, mon_if.Cout);
        // Это комбинационная логика, тут не смысла жестко присваивать
      prev_result <= mon_if.result;
      prev_Cout   <= mon_if.Cout;
    end
  end

endmodule


