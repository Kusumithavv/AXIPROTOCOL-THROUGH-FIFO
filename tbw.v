`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:48:42 12/07/2018
// Design Name:   amba__write_channel
// Module Name:   D:/ARM/ARM_PROJECT/AMBA/arm_amba/tbw.v
// Project Name:  arm_amba
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: amba__write_channel
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tbw;

	// Inputs
	reg clk;
	reg reset;
	reg [5:0] m2i_AWID;
	reg [32:0] m2i_AWADDR;
	reg [3:0] m2i_AWLEN;
	reg [3:0] m2i_AWSIZE;
	reg [1:0] m2i_AWBURST;
	reg m2i_AWVALID;
	reg [3:0] m2i_WID;
	reg [7:0] m2i_WDATA;
	reg m2i_WSTRB;
	reg m2i_WLAST;
	reg m2i_WVALID;
	reg m2i_BREADY;

	// Outputs
	wire i2m_WREADY;
	wire i2m_BID;
	wire i2m_BVALID;
	wire i2m_BRESP;

	// Instantiate the Unit Under Test (UUT)
	amba__write_channel uut (
		.clk(clk), 
		.reset(reset), 
		.m2i_AWID(m2i_AWID), 
		.m2i_AWADDR(m2i_AWADDR), 
		.m2i_AWLEN(m2i_AWLEN), 
		.m2i_AWSIZE(m2i_AWSIZE), 
		.m2i_AWBURST(m2i_AWBURST), 
		.m2i_AWVALID(m2i_AWVALID), 
		.m2i_WID(m2i_WID), 
		.m2i_WDATA(m2i_WDATA), 
		.m2i_WSTRB(m2i_WSTRB), 
		.m2i_WLAST(m2i_WLAST), 
		.m2i_WVALID(m2i_WVALID), 
		.m2i_BREADY(m2i_BREADY), 
		.i2m_WREADY(i2m_WREADY), 
		.i2m_BID(i2m_BID), 
		.i2m_BVALID(i2m_BVALID), 
		.i2m_BRESP(i2m_BRESP)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 0;	
		m2i_AWID = 6;
		m2i_AWADDR = 777;
		m2i_AWLEN = 7;
		m2i_AWSIZE = 7;
		m2i_AWBURST = 0;
		m2i_AWVALID = 0;
		m2i_WID = 10;
		m2i_WDATA = 0;
		m2i_WSTRB = 0;
		m2i_WLAST = 1;
		m2i_WVALID = 1;
		
		reset = 1;
		#10 reset = 0;
		m2i_AWVALID = 1;
		
		#2 m2i_WDATA = 10;
		#30 m2i_BREADY = 1;
	end
      
	always 
		begin
		#20 clk=~clk;
		end
	always 
		begin
			#3 m2i_WSTRB=~m2i_WSTRB;
		end
		
	always 
		begin
			#3 m2i_WLAST=~m2i_WLAST;
		end
		
	
		
endmodule

