`timescale 1ns / 1ps

module tb_counter;

  reg clk;
  reg rst;
  reg [7:0] count;

  counter uut (
      .clk  (clk),
      .rst  (rst),
      .count(count)
  );

  // 100 Mhz clock
  always #5 clk = ~clk;

  initial begin
    $dumpfile("counter.vcd");
    $dumpvars(0, tb_counter);
  end

  initial begin
    clk = 8'd0;
    rst = 8'd1;

    #20;
    rst = 8'd0;

    #300;
    $finish;
  end
endmodule

