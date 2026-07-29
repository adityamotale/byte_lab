TARGET = counter

all:
	iverilog -g2012 -o $(TARGET) counter.v tb_counter.v
	vvp $(TARGET)

wave:
	gtkwave counter.vcd

clean:
	rm -f $(TARGET) *.vcd
