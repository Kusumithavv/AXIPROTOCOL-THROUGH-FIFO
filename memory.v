module memory(s_axi_wdata,m_axi_wdata,write,read,clk,m_axi_awaddr,m_axi_araddr);

   parameter data_width    = 32;
   parameter address_width = 32;
   parameter ram_depth     = 16;

   
   input     [data_width-1:0]     s_axi_wdata;
   output     [data_width-1:0]    m_axi_wdata;
   input     [address_width-1:0]   m_axi_awaddr;
   input     [address_width-1:0]   m_axi_araddr;
   input                           write,clk,read;

   
   reg [address_width-1:0]     memory[0:ram_depth-1];
   reg [data_width-1:0]        data_2_out;
   wire [data_width-1:0]  s_axi_wdata;
   

   always @(posedge clk)
     begin
    if (write)
      memory[m_axi_awaddr]=s_axi_wdata;
     end

   always @(posedge clk)
     begin
    if (read)
      data_2_out=memory[m_axi_araddr];
     end

   assign m_axi_wdata =(read)?data_2_out:32'b0;

endmodule