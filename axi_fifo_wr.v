`timescale 1ns / 1ps

// AXI4 FIFO (write)
 module axi_fifo_wr (
    input                       clk,
    input                       rst,
// AXI slave interface
    input   [7:0]      s_axi_awid,
    input   [31:0]    s_axi_awaddr,
    input   [7:0]               s_axi_awlen,
    input   [2:0]               s_axi_awsize,
    input   [1:0]               s_axi_awburst,
    input   [3:0]               s_axi_awcache,
    input                       s_axi_awvalid,
    output                      s_axi_awready,
    input   [31:0]    s_axi_wdata,
    input   [3:0]    s_axi_wstrb,
    input                       s_axi_wlast,
    input                       s_axi_wvalid,
    output                      s_axi_wready,
    output  [7:0]      s_axi_bid,
    output  [1:0]               s_axi_bresp,
    output                      s_axi_bvalid,
    input                       s_axi_bready,

    // AXI master interface
    output  [7:0]      m_axi_awid,
    output  [31:0]    m_axi_awaddr,
    output  [7:0]               m_axi_awlen,
    output  [2:0]               m_axi_awsize,
    output  [1:0]               m_axi_awburst,
    output  [3:0]               m_axi_awcache,
    output                      m_axi_awvalid,
    input                       m_axi_awready,
    output  [31:0]    m_axi_wdata,
    output  [3:0]    m_axi_wstrb,
    output                      m_axi_wlast,
    output                      m_axi_wvalid,
    input                       m_axi_wready,
    input   [7:0]      m_axi_bid,
    input   [1:0]               m_axi_bresp,
    input                       m_axi_bvalid,
    output                      m_axi_bready
);

parameter FIFO_ADDR_WIDTH = 32;
parameter FIFO_DELAY= 32;

reg [FIFO_ADDR_WIDTH:0] wr_ptr_reg = {FIFO_ADDR_WIDTH+1{1'b0}}, wr_ptr_next;
reg [FIFO_ADDR_WIDTH:0] wr_addr_reg = {FIFO_ADDR_WIDTH+1{1'b0}};
reg [FIFO_ADDR_WIDTH:0] rd_ptr_reg = {FIFO_ADDR_WIDTH+1{1'b0}}, rd_ptr_next;
reg [FIFO_ADDR_WIDTH:0] rd_addr_reg = {FIFO_ADDR_WIDTH+1{1'b0}};

reg [36:0] mem[(2**FIFO_ADDR_WIDTH)-1:0];
reg [36:0] mem_read_data_reg;
reg mem_read_data_valid_reg = 1'b0, mem_read_data_valid_next;

wire [36:0] s_axi_w;

reg [36:0] m_axi_w_reg;
reg m_axi_wvalid_reg = 1'b0, m_axi_wvalid_next;

// full when first MSB different but rest same
wire full = ((wr_ptr_reg[FIFO_ADDR_WIDTH] != rd_ptr_reg[FIFO_ADDR_WIDTH]) &&
             (wr_ptr_reg[FIFO_ADDR_WIDTH-1:0] == rd_ptr_reg[FIFO_ADDR_WIDTH-1:0]));


// empty when pointers match exactly
wire empty = wr_ptr_reg == rd_ptr_reg;

wire hold;

// control signals
reg write;
reg read;
reg out;

assign s_axi_wready = !full && !hold;

generate
    assign s_axi_w[31:0] = s_axi_wdata;
    assign s_axi_w[32 +: 4] = s_axi_wstrb;
endgenerate

generate

if (32) begin
    // store write addr channel value until W channel FIFO is full

    localparam [1:0]
        STATE_IDLE = 2'd0,
        STATE_TRANSFER_IN = 2'd1,
        STATE_TRANSFER_OUT = 2'd2;

    reg [1:0] state_reg = STATE_IDLE, state_next;

    reg hold_reg = 1'b1, hold_next;
    reg [8:0] count_reg = 9'd0, count_next;

    reg [7:0] m_axi_awid_reg = {8{1'b0}};
    reg [7:0] m_axi_awid_next;
    reg [31:0] m_axi_awaddr_reg = {32{1'b0}};
    reg [31:0] m_axi_awaddr_next;
    reg [7:0] m_axi_awlen_reg = 8'd0;
    reg [7:0] m_axi_awlen_next;
    reg [2:0] m_axi_awsize_reg = 3'd0;
    reg [2:0] m_axi_awsize_next;
    reg [1:0] m_axi_awburst_reg = 2'd0;
    reg [1:0] m_axi_awburst_next;
    reg [3:0] m_axi_awcache_reg = 4'd0;
    reg [3:0] m_axi_awcache_next;
    reg m_axi_awvalid_reg = 1'b0;
    reg m_axi_awvalid_next;

    reg s_axi_awready_reg = 1'b0;
    reg s_axi_awready_next;

    assign m_axi_awid = m_axi_awid_reg;
    assign m_axi_awaddr = m_axi_awaddr_reg;
    assign m_axi_awlen = m_axi_awlen_reg;
    assign m_axi_awsize = m_axi_awsize_reg;
    assign m_axi_awburst = m_axi_awburst_reg;
    assign m_axi_awcache = m_axi_awcache_reg;
    assign m_axi_awvalid = m_axi_awvalid_reg;

    assign s_axi_awready = s_axi_awready_reg;

    assign hold = hold_reg;

    always @* begin
        state_next = STATE_IDLE;

        hold_next = hold_reg;
        count_next = count_reg;

        m_axi_awid_next = m_axi_awid_reg;
        m_axi_awaddr_next = m_axi_awaddr_reg;
        m_axi_awlen_next = m_axi_awlen_reg;
        m_axi_awsize_next = m_axi_awsize_reg;
        m_axi_awburst_next = m_axi_awburst_reg;
        m_axi_awcache_next = m_axi_awcache_reg;
        m_axi_awvalid_next = m_axi_awvalid_reg && !m_axi_awready;
        s_axi_awready_next = s_axi_awready_reg;

        case (state_reg)
            STATE_IDLE: begin
                s_axi_awready_next = !m_axi_awvalid;
                hold_next = 1'b1;

                if (s_axi_awready & s_axi_awvalid) begin
                    s_axi_awready_next = 1'b0;

                    m_axi_awid_next = s_axi_awid;
                    m_axi_awaddr_next = s_axi_awaddr;
                    m_axi_awlen_next = s_axi_awlen;
                    m_axi_awsize_next = s_axi_awsize;
                    m_axi_awburst_next = s_axi_awburst;
                    m_axi_awcache_next = s_axi_awcache;

                    hold_next = 1'b0;
                    count_next = 0;
                    state_next = STATE_TRANSFER_IN;
                end else begin
                    state_next = STATE_IDLE;
                end
            end
            STATE_TRANSFER_IN: begin
                s_axi_awready_next = 1'b0;
                hold_next = 1'b0;

                if (s_axi_wready & s_axi_wvalid) begin
                    count_next = count_reg + 1;
                    if (count_next == 2**FIFO_ADDR_WIDTH) begin
                        m_axi_awvalid_next = 1'b1;
                        state_next = STATE_TRANSFER_OUT;
                    end else if (count_reg == m_axi_awlen) begin
                        m_axi_awvalid_next = 1'b1;
                        hold_next = 1'b1;
                        state_next = STATE_IDLE;
                    end else begin
                        state_next = STATE_TRANSFER_IN;
                    end
                end else begin
                    state_next = STATE_TRANSFER_IN;
                end
            end
            STATE_TRANSFER_OUT: begin
                s_axi_awready_next = 1'b0;
                hold_next = 1'b0;

                if (s_axi_wready & s_axi_wvalid) begin
                    count_next = count_reg + 1;
                    if (count_reg == m_axi_awlen) begin
                        hold_next = 1'b1;
                        state_next = STATE_IDLE;
                    end else begin
                        state_next = STATE_TRANSFER_OUT;
                    end
                end else begin
                    state_next = STATE_TRANSFER_OUT;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            state_reg <= STATE_IDLE;
            hold_reg <= 1'b1;
            m_axi_awvalid_reg <= 1'b0;
            s_axi_awready_reg <= 1'b0;
        end else begin
            state_reg <= state_next;
            hold_reg <= hold_next;
            m_axi_awvalid_reg <= m_axi_awvalid_next;
            s_axi_awready_reg <= s_axi_awready_next;
        end

        count_reg <= count_next;

        m_axi_awid_reg <= m_axi_awid_next;
        m_axi_awaddr_reg <= m_axi_awaddr_next;
        m_axi_awlen_reg <= m_axi_awlen_next;
        m_axi_awsize_reg <= m_axi_awsize_next;
        m_axi_awburst_reg <= m_axi_awburst_next;
        m_axi_awcache_reg <= m_axi_awcache_next;
    end
end else begin
    
//passing write addr channel
    assign m_axi_awid = s_axi_awid;
    assign m_axi_awaddr = s_axi_awaddr;
    assign m_axi_awlen = s_axi_awlen;
    assign m_axi_awsize = s_axi_awsize;
    assign m_axi_awburst = s_axi_awburst;
    assign m_axi_awcache = s_axi_awcache;
    assign m_axi_awvalid = s_axi_awvalid;
    assign s_axi_awready = m_axi_awready;

    assign hold = 1'b0;
end

endgenerate

// pass B channel
assign s_axi_bid = m_axi_bid;
assign s_axi_bresp = m_axi_bresp;
assign s_axi_bvalid = m_axi_bvalid;
assign m_axi_bready = s_axi_bready;

assign m_axi_wvalid = m_axi_wvalid_reg;

assign m_axi_wdata = m_axi_w_reg[31:0];
assign m_axi_wstrb = m_axi_w_reg[32+: 4];

// Write logic
always @(*) begin
    write = 1'b0;

    wr_ptr_next = wr_ptr_reg;

    if (s_axi_wvalid) begin
                                // input data valid
        if (!full && !hold) begin
                                  // not full, then write
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
        mem[wr_addr_reg[FIFO_ADDR_WIDTH-1:0]] <= s_axi_w;
    end
end

// Read logic

always @(*) begin
    read = 1'b0;

    rd_ptr_next = rd_ptr_reg;

    mem_read_data_valid_next = mem_read_data_valid_reg;

    if (out || !mem_read_data_valid_reg) begin
        // output data not valid OR currently being transferred
        if (!empty) begin     // not empty, perform read
            read = 1'b1;
            mem_read_data_valid_next = 1'b1;
            rd_ptr_next = rd_ptr_reg + 1;
        end 
		else begin
                                    // empty, invalidate
            mem_read_data_valid_next = 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        rd_ptr_reg <= {FIFO_ADDR_WIDTH+1{1'b0}};
        mem_read_data_valid_reg <= 1'b0;
    end else begin
        rd_ptr_reg <= rd_ptr_next;
        mem_read_data_valid_reg <= mem_read_data_valid_next;
    end

    rd_addr_reg <= rd_ptr_next;

    if (read) begin
        mem_read_data_reg <= mem[rd_addr_reg[FIFO_ADDR_WIDTH-1:0]];
    end
end

// Output register

always @(*) begin
    out = 1'b0;

    m_axi_wvalid_next = m_axi_wvalid_reg;

    if (m_axi_wready || !m_axi_wvalid) begin
        out = 1'b1;
        m_axi_wvalid_next = mem_read_data_valid_reg;
    end
end

always @(posedge clk) begin
    if (rst) begin
        m_axi_wvalid_reg <= 1'b0;
    end else begin
        m_axi_wvalid_reg <= m_axi_wvalid_next;
    end

    if (out) begin
        m_axi_w_reg <= mem_read_data_reg;
    end
end

endmodule