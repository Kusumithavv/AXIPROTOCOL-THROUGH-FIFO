//DATA_WIDTH = 32, ADDR_WIDTH = 32,STRB_WIDTH = (DATA_WIDTH/8), //ID_WIDTH = 8,AWUSER_ENABLE =0,AWUSER_WIDTH = 1,WUSER_ENABLE = 0,
//WUSER_WIDTH =1,BUSER_ENABLE =0,BUSER_WIDTH =1,ARUSER_ENABLE = 0, //ARUSER_WIDTH=1,RUSER_ENABLE=0,RUSER_WIDTH=1,WRITE_FIFO_DEPTH=32, //READ_FIFO_DEPTH = 32,WRITE_FIFO_DELAY = 0,READ_FIFO_DELAY = 0

`timescale 1ns / 1ps

module axi_fifo(input  clk,
                input   rst,

    			input   [7:0] s_axi_awid,    //write addr channel
    input   [31:0] s_axi_awaddr,
    input   [7:0]  s_axi_awlen,
    input   [2:0]  s_axi_awsize,
    input   [1:0]  s_axi_awburst,
    input   [3:0]  s_axi_awcache,
    input   s_axi_awvalid,
    output  s_axi_awready,

    input   [31:0]    s_axi_wdata,           //write data signals
    input   [3:0]    s_axi_wstrb,
    input   s_axi_wlast,
    input   s_axi_wvalid,
    output  s_axi_wready,

    output  [7:0] s_axi_bid,              //write response signals
    output  [1:0] s_axi_bresp,
    output  s_axi_bvalid,
    input   s_axi_bready,

    input   [7:0]      s_axi_arid,         //read address signals
    input   [31:0]    s_axi_araddr,
    input   [7:0] s_axi_arlen,
    input   [2:0] s_axi_arsize,
    input   [1:0] s_axi_arburst,
    input   [3:0] s_axi_arcache,
    input   s_axi_arvalid,
    output  s_axi_arready,

    output  [7:0]      s_axi_rid,           //read data signals
    output  [31:0]    s_axi_rdata,
    output  [1:0]               s_axi_rresp,
    output  s_axi_rlast,
    output  s_axi_rvalid,
    input   s_axi_rready,

//master interface

    output  [7:0]      m_axi_awid,    //write addr channel
    output  [31:0]    m_axi_awaddr,
    output  [7:0]  m_axi_awlen,
    output  [2:0]  m_axi_awsize,
    output  [1:0]  m_axi_awburst,
    output  [3:0]  m_axi_awcache,
    output  m_axi_awvalid,
    input   m_axi_awready,
    
    output  [31:0] m_axi_wdata,        //write data
    output  [3:0]  m_axi_wstrb,
    output  m_axi_wlast,
    output  m_axi_wvalid,
    input   m_axi_wready,
    
    input   [7:0] m_axi_bid,              //write response
    input   [1:0] m_axi_bresp,
    input   m_axi_bvalid,
    output  m_axi_bready,
    
    output  [7:0] m_axi_arid,              //read address channel
    output  [31:0] m_axi_araddr,
    output  [7:0]  m_axi_arlen,
    output  [2:0]  m_axi_arsize,
    output  [1:0]  m_axi_arburst,
    output  [3:0]  m_axi_arcache,
    output  m_axi_arvalid,
    input   m_axi_arready,

    input   [7:0]      m_axi_rid,            //read data signals
    input   [31:0]    m_axi_rdata,
    input   [1:0]               m_axi_rresp,
    input    m_axi_rlast,
    input   m_axi_rvalid,
    output   m_axi_rready
);

/*
axi_fifo_wr axi_fifo_wr_inst (
    .clk(clk),
    .rst(rst),
    .s_axi_awid(s_axi_awid),           //AXI slave interface
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awcache(s_axi_awcache),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bid(s_axi_bid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),

                                       // AXI master interface
    .m_axi_awid(m_axi_awid),
    .m_axi_awaddr(m_axi_awaddr),
    .m_axi_awlen(m_axi_awlen),
    .m_axi_awsize(m_axi_awsize),
    .m_axi_awburst(m_axi_awburst),
    .m_axi_awcache(m_axi_awcache),
    .m_axi_awvalid(m_axi_awvalid),
    .m_axi_awready(m_axi_awready),
    .m_axi_wdata(m_axi_wdata),
    .m_axi_wstrb(m_axi_wstrb),
    .m_axi_wlast(m_axi_wlast),
    .m_axi_wvalid(m_axi_wvalid),
    .m_axi_wready(m_axi_wready),
    .m_axi_bid(m_axi_bid),
    .m_axi_bresp(m_axi_bresp),
    .m_axi_bvalid(m_axi_bvalid),
    .m_axi_bready(m_axi_bready)
);

*/

axi_fifo_rd axi_fifo_rd_inst (
    .clk(clk),
    .rst(rst),

    
     //AXI slave interface
     
    .s_axi_arid(s_axi_arid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arcache(s_axi_arcache),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rid(s_axi_rid),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rlast(s_axi_rlast),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),

     // AXI master interface
     
    .m_axi_arid(m_axi_arid),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
    .m_axi_arcache(m_axi_arcache),
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid),
    .m_axi_rdata(m_axi_rdata),
    .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast),
    .m_axi_rvalid(m_axi_rvalid),
    .m_axi_rready(m_axi_rready)
);

memory u1 (.m_axi_awaddr(m_axi_awaddr),.m_axi_araddr(m_axi_araddr),.s_axi_wdata(s_axi_wdata),.m_axi_wdata(m_axi_wdata),.write(write),.read(read),.clk(clk));

endmodule