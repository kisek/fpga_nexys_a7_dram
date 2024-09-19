/** main.v for Nexys A7 (xc7a100tcsg324-1)              ArchLab, Institute of Science Tokyo **/
/** DDR2 SDRAM: MT47H64M16HR-25E (128MB) of Nexys A7                                        **/
/*********************************************************************************************/
`default_nettype none

`define DDR2_DQ__WIDTH  16
`define DDR2_DQS_WIDTH  2
`define DDR2_ADR_WIDTH  13
`define DDR2_BA__WIDTH  3
`define DDR2_DM__WIDTH  2
`define APP_ADDR_WIDTH  27
`define APP_CMD__WIDTH  3
`define APP_DATA_WIDTH  128
`define APP_MASK_WIDTH  16
`define CMD_READ        3'b001
`define CMD_WRITE       3'b000
         
module m_main (
    input  wire w_clk,                              // 100MHz clock signal
    output wire [3:0] w_led,                        // LED
    inout  wire [`DDR2_DQ__WIDTH-1 : 0]  ddr2_dq,
    inout  wire [`DDR2_DQS_WIDTH-1 : 0]  ddr2_dqs_n,
    inout  wire [`DDR2_DQS_WIDTH-1 : 0]  ddr2_dqs_p,
    output wire [`DDR2_ADR_WIDTH-1 : 0]  ddr2_addr,
    output wire [`DDR2_BA__WIDTH-1 : 0]  ddr2_ba,
    output wire                          ddr2_ras_n,
    output wire                          ddr2_cas_n,
    output wire                          ddr2_we_n,
    output wire [0:0]                    ddr2_ck_p,
    output wire [0:0]                    ddr2_ck_n,
    output wire [0:0]                    ddr2_cke,
    output wire [0:0]                    ddr2_cs_n,
    output wire [`DDR2_DM__WIDTH-1 : 0]  ddr2_dm,
    output wire [0:0]                    ddr2_odt
);
     
    wire                         sys_clk;     // system clock (200MHz),
    wire                         sys_rst = 0; // reset (active-high)
    clk_wiz_0 m0 (sys_clk, w_clk);
        
    reg  [`APP_ADDR_WIDTH-1 : 0] r_app_addr = 0;
    reg  [`APP_CMD__WIDTH-1 : 0] r_app_cmd  = 0;
    reg                          r_app_en = 0;  
    reg                          r_app_wdf_wren = 0;
    reg  [`APP_DATA_WIDTH-1 : 0] r_app_wdf_data = {32'h1, 32'h1, 32'h1, 32'h1};
    reg  [`APP_MASK_WIDTH-1 : 0] r_app_wdf_mask = 0;
    
    wire [`APP_DATA_WIDTH-1 : 0] app_rd_data;
    wire                         app_rd_data_valid;
    wire                         app_rdy;
    wire                         app_wdf_rdy;

    wire                         w_ui_clk; // 333.33MHz / 4 = 83.33MHz
    wire                         init_calib_complete;

    reg [3:0] r_state = 0;
    reg [31:0] r_sum = 0;
    always @(posedge w_ui_clk) if (init_calib_complete) begin
       if (r_state==0 && app_rdy && app_wdf_rdy) begin  ///// WRITE_1
           r_app_en       <= 1;
           r_app_wdf_wren <= 1;         
           r_app_cmd      <= `CMD_WRITE;
           r_state        <= 1;
       end
       else if (r_state==1) begin ///// WRITE_2
           if (app_rdy && app_wdf_rdy && r_app_en) begin
               r_app_en <= 0; 
               r_app_wdf_wren <= 0; 
           end
           if (r_app_en==0 && r_app_wdf_wren==0) begin
               r_app_addr <= r_app_addr + 8;
               r_state <= (r_app_addr[26:3]==24'hffffff) ? 2 : 0;
           end
       end
       else if (r_state==2) begin ///// INIT_FOR_READ
           r_app_addr <= 0;
           r_state    <= 3;
       end
       else if (r_state==3 && app_rdy) begin ///// READ_1
           r_app_en       <= 1;
           r_app_wdf_wren <= 0;
           r_app_cmd      <= `CMD_READ;
           r_state        <= 4;
       end
       else if (r_state==4) begin  ///// READ_2
           if (app_rdy && r_app_en) r_app_en <= 0;
           if (app_rd_data_valid) begin
               r_app_addr <= r_app_addr + 8;
               r_sum <= r_sum + app_rd_data[31:0];
               r_state <= (r_app_addr[26:3]==24'hffffff) ? 5 : 3;
           end
       end
    end
    assign w_led = {init_calib_complete, r_state[2:0]};
        
    vio_0 vio0 (w_ui_clk, r_app_addr, r_sum);
    
    mig_7series_0 mig (
       .ddr2_addr           (ddr2_addr),
       .ddr2_ba             (ddr2_ba),
       .ddr2_cas_n          (ddr2_cas_n),
       .ddr2_ck_n           (ddr2_ck_n),
       .ddr2_ck_p           (ddr2_ck_p),
       .ddr2_cke            (ddr2_cke),
       .ddr2_ras_n          (ddr2_ras_n),
       .ddr2_we_n           (ddr2_we_n),
       .ddr2_dq             (ddr2_dq),
       .ddr2_dqs_n          (ddr2_dqs_n),
       .ddr2_dqs_p          (ddr2_dqs_p),
       .ddr2_cs_n           (ddr2_cs_n),
       .ddr2_dm             (ddr2_dm),
       .ddr2_odt            (ddr2_odt),
       .app_addr            (r_app_addr),
       .app_cmd             (r_app_cmd),
       .app_en              (r_app_en),
       .app_wdf_data        (r_app_wdf_data),
       .app_wdf_end         (r_app_wdf_wren),
       .app_wdf_wren        (r_app_wdf_wren), 
       .app_wdf_mask        (r_app_wdf_mask),
       .app_rd_data         (app_rd_data),
       .app_rd_data_valid   (app_rd_data_valid),    
       .app_rd_data_end     (),
       .app_rdy             (app_rdy),
       .app_wdf_rdy         (app_wdf_rdy),
       .app_sr_req          (1'b0),
       .app_ref_req         (1'b0),
       .app_zq_req          (1'b0),
       .app_sr_active       (),
       .app_ref_ack         (),
       .app_zq_ack          (),
       .ui_clk              (w_ui_clk),
       .ui_clk_sync_rst     (),
       .init_calib_complete (init_calib_complete),      
       .device_temp_i       (),
       .sys_clk_i           (sys_clk), // 200MHz clock signal
       .sys_rst             (sys_rst));
endmodule
