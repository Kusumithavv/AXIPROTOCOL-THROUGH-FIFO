# AXIPROTOCOL-THROUGH-FIFO
This Project aims to design the working of AMBA Bus Architechture, considering the AXI protocol. 
AXI protocol defined for high-frequency, high-bandwidth systems for data communication.
AXI Protocol has 5 transaction channels:
Write Address Channel(AW), Write Data(W), Write Response(B), Read Address Channel(AR), Read Data(R)
Data transfer from master to slave : Write from master to slave & Read from slave.
# CODES:
axi_fifo.v -top module instantiating read & write instances
axi_fifo_rd.v - module performing read operation from slave by master
axi_fifo_wr.v- module performing write operation to slave from master
memory.v - memory instantiation
tb_axi_fifo.v - testbench 

