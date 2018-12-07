`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:37:46 12/06/2018 
// Design Name: 
// Module Name:    amba__write_channel 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module amba__write_channel(input clk,reset,
									input [5:0] m2i_AWID,    // ID of the slave to wchich data has to be written 
									input [32:0] m2i_AWADDR,// Starting Address of the periphera whose ID is transferred
									input [3:0] m2i_AWLEN,   // Maximum 8 burst at a time
									input [3:0] m2i_AWSIZE,  // Maximum size of each burst is 1 Byte 			
									input [1:0] m2i_AWBURST, // Defines the next write address calculation
									input m2i_AWVALID,			// Master sends this signal if the the address being sent is valid.
									input [3:0] m2i_WID,     // Maximum 8 words(Bursts) transferred in one transaction
									input [7:0] m2i_WDATA,   // Maximum size of data
									input m2i_WSTRB,			// Becomes 1 and the becomes 0 sfter each burst transfer
									input m2i_WLAST,			//gets active when the last byte of a burst get transfered
									input m2i_WVALID,			// Becomes 1 when the master sends valid data
									input m2i_BREADY,        // Master can accept a write response
									output reg i2m_WREADY,
									output reg i2m_BID,
									output reg i2m_BVALID,
									output reg i2m_BRESP
									);


		reg [5:0] m2i_AWID_reg;    
		reg [3:0] m2i_AWLEN_reg;
		reg [32:0] m2i_AWADDR_reg;   
		reg [3:0] m2i_AWSIZE_reg;   			
		reg [1:0] m2i_AWBURST_reg; 
		reg m2i_AWVALID_reg;			
		reg [3:0] m2i_WID_reg;     
		reg [7:0] m2i_WDATA_reg;   
		reg m2i_WSTRB_reg;			
		reg m2i_WVALID_reg;			
		reg m2i_BREADY_reg;
		reg [7:0] data_reg [0:7];   // Memory element to store all the incoming data
		reg [7:0] count=0;
		reg FLAG=0;
		
always @ (posedge clk)
begin	
	if(reset)
		begin
			m2i_AWID_reg=0;    
			m2i_AWLEN_reg=0;
			m2i_AWADDR_reg=0;   
			m2i_AWSIZE_reg=0;   			
			m2i_AWBURST_reg=0; 
			m2i_AWVALID_reg=0;			
			m2i_WID_reg=0;     
			m2i_WDATA_reg=0;   
			m2i_WSTRB_reg=0;					
			m2i_WVALID_reg=0;			
			m2i_BREADY_reg=0;
			i2m_WREADY=0;
			//count=0;
		end
	else	
		begin
			m2i_AWID_reg=m2i_AWID;     
			m2i_AWADDR_reg=m2i_AWADDR;
			m2i_AWLEN_reg=m2i_AWLEN;   
			m2i_AWSIZE_reg=m2i_AWSIZE;   			
			m2i_AWBURST_reg=m2i_AWBURST; 
			m2i_AWVALID_reg=m2i_AWVALID;			
			m2i_WID_reg=m2i_WID;     
			m2i_WDATA_reg=m2i_WDATA;   
			m2i_WSTRB_reg=m2i_WSTRB;					
			m2i_WVALID_reg=m2i_WVALID;			
			m2i_BREADY_reg=m2i_BREADY;
			count=0;
			i2m_WREADY=1;//interface write-ready
			//FLAG=1 when wlast pulse is sent
		end
end

always @ (posedge i2m_WREADY)
	begin
		if(m2i_AWVALID && m2i_WVALID  )
			begin
				data_reg[count]= m2i_WDATA;
			end
	end

always @(negedge m2i_WSTRB)
	begin
		
		if(m2i_AWVALID && m2i_WVALID && i2m_WREADY==1 )
			begin
				count=count+1;
				data_reg[count]= m2i_WDATA;
				
			end
	end
	
always @(posedge m2i_WLAST)
	begin
			FLAG=1;	
	end
	
always @(posedge clk )
begin			
		if(m2i_BREADY==1)	
			begin
				i2m_BID=m2i_WID_reg;
				i2m_BVALID=1;
				if(FLAG==1)
					i2m_BRESP=1;
			end
end


endmodule
