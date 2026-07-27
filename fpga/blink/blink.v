module blink (
    input  wire clk,
    output reg  led = 0
);

  reg [3:0] counter = 0;

  always @(posedge clk) begin
    if (counter == 9) begin
      counter <= 0;
      led <= ~led;
    end else begin
      counter <= counter + 1;
    end
  end

endmodule
