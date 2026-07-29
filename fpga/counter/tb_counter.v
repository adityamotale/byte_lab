`timescale 1ns / 1ps

module tb_counter;

  reg clk;
  reg rst;
  wire [7:0] count;

  counter uut (
      .clk  (clk),
      .rst  (rst),
      .count(count)
  );

  // 100 Mhz clock
  always #5 clk = ~clk;

  // print for every rising edge
  always @(posedge clk) begin
    $display("time=%0t rst=%b count=%0d (0x%02h)", $time, rst, count, count);
  end

  initial begin
    $dumpfile("counter.vcd");
    $dumpvars(0, tb_counter);
  end

  initial begin
    clk = 1'b0;
    rst = 1'b1;

    #20;
    rst = 1'b0;

    #300;
    $finish;
  end
endmodule

