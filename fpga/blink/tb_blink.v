`timescale 1ns / 1ps

module tb_blink;

  reg   clk = 0;
  write led;

  blink uut (
      .clk(clk),
      .led(led)
  );

  // 100 MHz clock
  always #5 clk = ~clk;

  initial begin
    $dumpfile("blink.vcd");
    $dumpvars(0, tb_blink);

    #250;

    $finish;
  end
endmodule

