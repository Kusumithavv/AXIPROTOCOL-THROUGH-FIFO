# AMBA -Advanced Microcontroller Bus Architecture
AMBA is an standard onchip Interconnect by ARM.  

<img width="576" alt="amba system" src="https://user-images.githubusercontent.com/38127428/49651245-abb89e00-fa54-11e8-810b-427efa57d197.png">

# PROJECT: Simulation and synthesis of AMBA AXI4 Protocol.
==========================================================
> Design Modules:  
<img width="576" alt="fifo_architecture" src="https://user-images.githubusercontent.com/38127428/49651394-0d790800-fa55-11e8-9ad4-76ed4b8b08c3.png">
-__AXI FIFO (axi_fifo.v)__  
    - This is the Top module instantiating read and write transaction channel from master to the slave.
-__AXI FIFO WRITE (axi_fifo_wr.v)__  
    -Transaction channel initiating write operation from master to the slave.  
       __SIGNAL DESCRIPTIONS:__  
 
       <img width="576" alt="write channel" src="https://user-images.githubusercontent.com/38127428/49651439-30a3b780-fa55-11e8-80a9-708f258f2ef2.png">

             WRITE ADDRESS CHANNEL:_  
                  -AWID (MASTER TO SLAVE)  
                    The identification tag for the write address group of signals.  
                  -AWADDR (MASTER TO SLAVE)  
                    The write address gives the address of the first transfer in a write burst transaction.   
                  -AWLEN (MASTER TO SLAVE)  
                    The burst length gives the exact number of transfers in a burst. This information  
                    determines the number of data transfers associated with the address  
                  -AWSIZE (MASTER TO SLAVE)  
                    Indicates the size of each transfer in the burst.   
                  -AWBURST (MASTER TO SLAVE)  
                     The burst type and the size information, determine how the address for each  
                     transfer within the burst is calculated  
                  -AWVALID (MASTER TO SLAVE)  
                     Indicates that the channel is signaling valid write address and control information.  
                  -AWREADY (SLAVE TO MASTER)  
                     Slave Indicates that the slave is ready to accept an address and associated control signals.  
                       
            WRITE DATA CHANNEL:_
                  -WID (MASTER TO SLAVE)
                      -The ID tag of the write data transfer. 
                  -WDATA (MASTER TO SLAVE)
                       -Write data.
                  -WSTRB (MASTER TO SLAVE)
                      -Indicates that the byte lanes that hold valid data. There is one write strobe bit for each 8
                      bits of the write data bus.
                  -WLAST (MASTER TO SLAVE)
                       -Indicates the last transfer in a write burst. 
                  -WVALID (MASTER TO SLAVE)
                       -This signal indicates that valid write data and strobes are available. 
                  -WREADY (SLAVE TO MASTER)
                       -This signal indicates that the slave can accept the write data
                       
            -WRITE RESPONSE CHANNEL:
                  -BID (SLAVE TO MASTER)
                       -The ID tag of the write response. 
                  -BRESP (SLAVE TO MASTER)
                       -Indicates the status of the write transaction. 
                  -BVALID (SLAVE TO MASTER)
                       -Indicates that the channel is signaling a valid write response. 
                  -BREADY (MASTER TO SLAVE)
                       -Indicates that the master can accept a write response. 
<img width="594" alt="waveform for write channel" src="https://user-images.githubusercontent.com/38127428/49651540-7f515180-fa55-11e8-80fa-cd9801fe6da6.png">
  <img width="640" alt="fifo_data" src="https://user-images.githubusercontent.com/38127428/49651645-c8090a80-fa55-11e8-8b11-d0b2234b92b5.png">
         
__AXI FIFO READ (axi_fifo_rd.v)__ 
<img width="576" alt="read channel" src="https://user-images.githubusercontent.com/38127428/49651488-5466fd80-fa55-11e8-945e-4784a4b27fa5.png">

      -Transaction channel initiating write operation from master to the slave.  
           __SIGNAL DESCRIPTIONS__  
           
             -_READ ADDRESS CHANNEL:_  
                  -ARID (MASTER TO SLAVE)  
                       -The identification tag for the read address group of signals.    
                  -ARADDR (MASTER TO SLAVE)  
                       -The read address gives the address of the first transfer in a read burst transaction.    
                  -ARVALID (MASTER TO SLAVE)  
                       -Indicates that the channel is signaling valid read address and control information.   
                  -ARREADY (SLAVE TO MASTER)  
                       -Indicates that the slave is ready to accept an address and associated control signals.   
                  -ARLEN (MASTER TO SLAVE)  
                       -Indicates the exact number of transfers in a burst.    
                  -ARSIZE (MASTER TO SLAVE)  
                       -Indicates the size of each transfer in the burst.    
                  -ARBURST (MASTER TO SLAVE)  
                       -The burst type and the size information determine how the address for each transfer  
                       within the burst is calculated.     
            -_READ DATA CHANNEL:_  
                  -RID (SLAVE TO MASTER)   
                      -The identification tag for the read data group of signals that are generated by the slave  
                  -RDATA (SLAVE TO MASTER)    
                      -Read data  
                  -RLAST (SLAVE TO MASTER)  
                      -Indicates the last transfer in a read burst.  
                  -RVALID (SLAVE TO MASTER)  
                      -The channel is signaling the required read data.   
                  -RREADY (SLAVE TO MASTER)  
                      -Indicates that the master can accept the read data and response information.   
 <img width="640" alt="read_waveform" src="https://user-images.githubusercontent.com/38127428/49651566-92fcb800-fa55-11e8-920a-b7bddbd60831.png">
 
# TESTBENCH MODULE(tb_axi_fifo.v)  
    -This module creates a DUT of the AXI FIFO design module. The DUT acts as a master for the axi_fifo module.   
      
__SYNTHESIS(CADENCE GENUS)__  
_-TIMING REPORT_  
  
Cost Group   : '400Mhz' (path_group '400Mhz')  
Timing slack :    5279ps  
Start-point  : WRITE/rd_ptr_reg_reg[17]/CK  
End-point    : WRITE/wr_ptr_reg_reg[32]/D  
                  
<img width="639" alt="synthesised_output" src="https://user-images.githubusercontent.com/38127428/49651678-dce59e00-fa55-11e8-83f7-49ba0ca48a61.png">

                  

