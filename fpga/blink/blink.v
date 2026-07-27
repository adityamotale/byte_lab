module blink (
    input  wire clk,
    output reg  led
);

  reg [3:0] counter;

  initial begin
    led = 0;
    counter = 0;
  end

  always @(posedge clk) begin
    if (counter == 9) begin
      counter <= 0;
      led <= ~led;
    end else begin
      counter <= counter + 1;
    end
  end

endmodule
