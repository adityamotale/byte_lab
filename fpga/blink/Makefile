TARGET = blink

all:
	iverilog -g2012 -o $(TARGET) blink.v tb_blink.v
	vvp $(TARGET)

wave:
	gtkwave blink.vcd

clean:
	rm -f $(TARGET) *.vcd
