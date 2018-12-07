`timescale 1ns / 1ps

module tb_axi_fifo;
reg clk ;
reg rst ;
reg read=0;
reg write=0;

reg wr_data=0;


reg [7:0] s_axi_awid ;
reg [31:0] s_axi_awaddr ;
reg [7:0] s_axi_awlen ;
reg [2:0] s_axi_awsize ;
reg [1:0] s_axi_awburst ;
reg [3:0] s_axi_awcache ;
reg s_axi_awvalid ;
reg [31:0] s_axi_wdata ;
reg [3:0] s_axi_wstrb ;
reg s_axi_wlast ;
reg s_axi_wuser ;
reg s_axi_wvalid ;
reg s_axi_bready ;
reg [7:0] s_axi_arid ;
reg [31:0] s_axi_araddr ;
reg [7:0] s_axi_arlen ;
reg [2:0] s_axi_arsize ;
reg [1:0] s_axi_arburst ;
reg [3:0] s_axi_arcache ;
reg s_axi_arvalid ;
reg s_axi_rready ;
reg m_axi_awready ;
reg m_axi_wready ;
reg [7:0] m_axi_bid ;
reg [1:0] m_axi_bresp ;
reg m_axi_bvalid ;
reg m_axi_arready ;
reg [7:0] m_axi_rid ;
reg [31:0] m_axi_rdata ;
reg [1:0] m_axi_rresp ;
reg m_axi_rlast ;
reg m_axi_rvalid ;

// Outputs
wire s_axi_awready;
wire s_axi_wready;
wire [7:0] s_axi_bid;
wire [1:0] s_axi_bresp;
wire s_axi_bvalid;
wire s_axi_arready;
wire [7:0] s_axi_rid;
wire [31:0] s_axi_rdata;
wire [1:0] s_axi_rresp;
wire s_axi_rlast;
wire s_axi_rvalid;
wire [7:0] m_axi_awid;
wire [31:0] m_axi_awaddr;
wire [7:0] m_axi_awlen;
wire [2:0] m_axi_awsize;
wire [1:0] m_axi_awburst;
wire [3:0] m_axi_awcache;
wire m_axi_awvalid;
wire [31:0] m_axi_wdata;
wire [3:0] m_axi_wstrb;
wire m_axi_wlast;
wire m_axi_wvalid;
wire m_axi_bready;
wire [7:0] m_axi_arid;
wire [31:0] m_axi_araddr;
wire [7:0] m_axi_arlen;
wire [2:0] m_axi_arsize;
wire [1:0] m_axi_arburst;
wire [3:0] m_axi_arcache;
wire m_axi_arvalid;
wire m_axi_rready;

axi_fifo UUT (
    .clk(clk),
    .rst(rst),
    .s_axi_awid(s_axi_awid),
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
    .m_axi_bready(m_axi_bready),
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

  
initial
begin
clk=1'b1;
forever #50 clk=~clk;
end

initial
begin
   rst=1'b1;
   s_axi_wdata =32'h0000;
   #100;
   m_axi_rdata =32'h0000;
   write=1'b1;
   read=1'b1;
   #100;

   rst=1'b0;
   s_axi_wdata =32'h0001;
   #100;
   m_axi_rdata =32'h0001;
 write=1'b1;
   read=1'b1;
   #100;

   rst=1'b0;
   s_axi_wdata =32'h0010;
   #100;
   m_axi_rdata =32'h0010;
write=1'b1;
   read=1'b1;
   #100;

   rst=1'b0;
   s_axi_wdata =32'h0011;
   #100;
    m_axi_rdata =32'h0011;
  write=1'b1;
   read=1'b1;
   #100;

   rst=1'b0;
   s_axi_wdata =32'h0100;
   #100;
   m_axi_rdata =32'h0100;
   write=1'b1;
   read=1'b1;
   #100;

   rst=1'b0;
   s_axi_wdata =32'h0101;
   #100;
   m_axi_rdata =32'h0101;

   write=1'b1;
   read=1'b1;
   #100;

      rst=1'b0;
   s_axi_wdata =32'h0110;
   #100;
   m_axi_rdata =32'h0110;
 write=1'b1;
   read=1'b1;
   #100;

      rst=1'b0;
   s_axi_wdata =32'h0111;
   #100;

   m_axi_rdata =32'h0111;
   write=1'b1;
   read=1'b1;
   #100;


   s_axi_wdata =32'h1000;
   #100;


   s_axi_wdata =32'h1001;
   #100;


   s_axi_wdata =32'h1010;
   #100;


   s_axi_wdata =32'h1011;
   #100;

   s_axi_wdata =32'h1100;
   #100;

   s_axi_wdata =32'h1101;
   #100;

   s_axi_wdata =32'h1110;
   #100;

   s_axi_wdata =32'h1111;
   #100;

   read=1'b1;
   write=1'b0;
   #1600;
   
   rst=1'b1;
   s_axi_wdata =32'h0101;
   write=1'b1;
   read=1'b0;
   #100;

   rst=1'b0;
   s_axi_wdata =32'b0101;
   #100;
   m_axi_rdata =32'b0101;
  
   write=1'b1;
   read=1'b1;
   #100;

   rst=1'b0;
   s_axi_wdata =32'h0110;
   write=1'b0;
   read=1'b1;
   #400;

   
$stop;
end

endmodule