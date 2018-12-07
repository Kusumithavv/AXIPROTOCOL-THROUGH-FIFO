`timescale 1ns/10ps

module axi_fifo_rd    (input clk,
			  	input rst,
			  	input [7:0] s_axi_arid,
				input [31:0] s_axi_araddr,
				input [7:0] s_axi_arlen,
				input [2:0] s_axi_arsize,
				input [1:0] s_axi_arburst,
				input [3:0] s_axi_arcache,
				input s_axi_arvalid,
				output wire s_axi_arready,
				output wire [7:0] s_axi_rid,
    				output wire [31:0] s_axi_rdata,
    				output wire [1:0] s_axi_rresp,
    				output wire  s_axi_rlast,
    				output wire  s_axi_rvalid,
    				input  wire  s_axi_rready,
	
				//master interface
 				output [7:0] m_axi_arid,
				output [31:0] m_axi_araddr,
				output [7:0] m_axi_arlen,
				output [2:0] m_axi_arsize,
				output [1:0] m_axi_arburst,
				output [3:0] m_axi_arcache,
				output m_axi_arvalid,
				input wire m_axi_arready,
				input wire [7:0] m_axi_rid,
    				input wire [31:0] m_axi_rdata,
    				input wire [1:0] m_axi_rresp,
    				input wire  m_axi_rlast,
    				input wire  m_axi_rvalid,
    				output  wire  m_axi_rready);

parameter FIFO_ADDR_WIDTH = 32;
parameter FIFO_DEPTH=32;

reg [FIFO_ADDR_WIDTH:0] wr_ptr_reg = {FIFO_ADDR_WIDTH+1{1'b0}}; reg wr_ptr_next;
reg [FIFO_ADDR_WIDTH:0] wr_addr_reg = {FIFO_ADDR_WIDTH+1{1'b0}};
reg [FIFO_ADDR_WIDTH:0] rd_ptr_reg = {FIFO_ADDR_WIDTH+1{1'b0}}; reg rd_ptr_next;
reg [FIFO_ADDR_WIDTH:0] rd_addr_reg = {FIFO_ADDR_WIDTH+1{1'b0}};

reg mem_read_data_valid_reg = 1'b0;
reg mem_read_data_valid_next;
reg [31:0] mem[63:0];
reg [31:0] mem_read_data_reg;


wire [43:0] m_axi_read;

reg [31:0] s_axi_read_reg;
reg s_axi_rvalid_reg = 1'b0, s_axi_rvalid_next;

//full condition
wire full= ((wr_ptr_reg[FIFO_ADDR_WIDTH]!= rd_ptr_reg[FIFO_ADDR_WIDTH]) &&
             (wr_ptr_reg[31:0] == rd_ptr_reg[31:0]));

wire empty = wr_ptr_reg[31:0]  == rd_ptr_reg[31:0] ;

reg read;
reg write;
reg out;

generate  //generate valid addr for entire burst

if (32) begin //delay
//store read address channel until enough space to store read data //burst in FIFO 

    parameter COUNT_WIDTH = 9;

    reg [8:0] count_reg = 0;
    reg [8:0] count_next;

    reg [7:0] m_axi_arid_reg = 8'b0 ;
    reg [7:0] m_axi_arid_next;
    reg [31:0] m_axi_araddr_reg = 32'b0;
    reg [31:0] m_axi_araddr_next;
    reg [7:0]  m_axi_arlen_reg = 8'd0;
    reg [7:0]  m_axi_arlen_next;
    reg [2:0] m_axi_arsize_reg = 3'd0;
    reg [2:0] m_axi_arsize_next;
    reg [1:0] m_axi_arburst_reg = 2'd0;
    reg [1:0] m_axi_arburst_next;
    reg [3:0] m_axi_arcache_reg = 4'd0;
    reg [3:0] m_axi_arcache_next;
    reg m_axi_arvalid_reg = 1'b0;
    reg m_axi_arvalid_next;

    reg s_axi_arready_reg = 1'b0;
    reg s_axi_arready_next;

    assign m_axi_arid = m_axi_arid_reg; //reg val assigned to rid
    assign m_axi_araddr = m_axi_araddr_reg;
    assign m_axi_arlen = m_axi_arlen_reg;
    assign m_axi_arsize = m_axi_arsize_reg;
    assign m_axi_arburst = m_axi_arburst_reg;
    assign m_axi_arcache = m_axi_arcache_reg;
    assign m_axi_arvalid = m_axi_arvalid_reg;

    assign s_axi_arready = s_axi_arready_reg;

    always @(*) begin

        count_next = count_reg;

        m_axi_arid_next = m_axi_arid_reg;
        m_axi_araddr_next = m_axi_araddr_reg;
        m_axi_arlen_next = m_axi_arlen_reg;
        m_axi_arsize_next = m_axi_arsize_reg;
        m_axi_arburst_next = m_axi_arburst_reg;
        m_axi_arcache_next = m_axi_arcache_reg;
        m_axi_arvalid_next = m_axi_arvalid_reg && !m_axi_arready;
        s_axi_arready_next = s_axi_arready_reg;


    end

    always @(posedge clk) begin
        if (rst) begin
            m_axi_arvalid_reg <= 1'b0;
            s_axi_arready_reg <= 1'b0;
        end else begin
            m_axi_arvalid_reg <= m_axi_arvalid_next;
            s_axi_arready_reg <= s_axi_arready_next;
        end

        count_reg <= count_next;

        m_axi_arid_reg <= m_axi_arid_next;
        m_axi_araddr_reg <= m_axi_araddr_next;
        m_axi_arlen_reg <= m_axi_arlen_next;
        m_axi_arsize_reg <= m_axi_arsize_next;
        m_axi_arburst_reg <= m_axi_arburst_next;
        m_axi_arcache_reg <= m_axi_arcache_next;
    end
end
 else begin
    // pass read addr channel
    assign m_axi_arid = s_axi_arid;
    assign m_axi_araddr = s_axi_araddr;
    assign m_axi_arlen = s_axi_arlen;
    assign m_axi_arsize = s_axi_arsize;
    assign m_axi_arburst = s_axi_arburst;
    assign m_axi_arcache = s_axi_arcache;
    assign m_axi_arvalid = s_axi_arvalid;
    assign s_axi_arready = m_axi_arready;
end

endgenerate

assign s_axi_rvalid = s_axi_rvalid_reg;
assign s_axi_rdata = s_axi_read_reg[31:0];  //data store



// Write 
always @(*) begin
    write = 1'b0;

    wr_ptr_next = wr_ptr_reg;

    if (m_axi_rvalid) begin       // input data valid
        if (!full) begin
            // not full, perform write
            write = 1'b1;
            wr_ptr_next = wr_ptr_reg + 1;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        wr_ptr_reg <= {FIFO_ADDR_WIDTH+1{1'b0}};
    end else begin
        wr_ptr_reg <= wr_ptr_next;
    end

    wr_addr_reg <= wr_ptr_next;

    if (write) begin
        mem[wr_addr_reg[31:0]] <= m_axi_read;
    end
end

// Read 
always @(*) begin
    read = 1'b0;  //initial

    //rd_ptr_next = rd_ptr_reg;

    mem_read_data_valid_next = mem_read_data_valid_reg;

        if (!empty) begin           // not empty, then read
            read = 1'b1;
            mem_read_data_valid_next = 1'b1;
            rd_ptr_next = rd_ptr_reg + 1;
        end else begin              // empty, invalidate
            mem_read_data_valid_next = 1'b0;
        end
    end

always @(posedge clk) begin
    if (rst) begin
        rd_ptr_reg <= {FIFO_ADDR_WIDTH+1{1'b0}};
        mem_read_data_valid_reg <= 1'b0;
    end else begin
        rd_ptr_reg <= rd_ptr_next;   //next val stored in reg
        mem_read_data_valid_reg <= mem_read_data_valid_next;
    end

    rd_addr_reg <= rd_ptr_next;

    if (read) begin
		mem_read_data_reg <= mem[rd_addr_reg[31:0]];
       end
end


// Output register
always @(*) begin
    out= 1'b0;

    s_axi_rvalid_next = s_axi_rvalid_reg;

    if (s_axi_rready || !s_axi_rvalid) begin
        out= 1'b1;
        s_axi_rvalid_next = mem_read_data_valid_reg;
    end
end

always @(posedge clk) begin
    if (rst) 
        s_axi_rvalid_reg <= 1'b0;
else begin
        s_axi_rvalid_reg <= s_axi_rvalid_next;
    end

    if (out) begin
        s_axi_read_reg <= mem_read_data_reg;
    end
end

endmodule

