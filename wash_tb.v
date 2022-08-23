`timescale 1ms/1ns
module wash_tb();

// testbench intelnal signals
reg         rst_n_tb;
reg         clk_tb;
reg  [1:0]  clk_freq_tb;
reg         coin_in_tb;
reg         double_wash_tb;
reg         timer_pause_tb;
wire        wash_done_tb;

// testbench parameters 
localparam clk_period = 0.001;

// clock generation 
always # (clk_period /2) clk_tb = ~clk_tb;

// module instatiation
wash wash_tb(
    .rst_n(rst_n_tb),
    .clk(clk_tb),
    .clk_freq(clk_freq_tb),
    .coin_in(coin_in_tb),
    .double_wash(double_wash_tb),
    .timer_pause(timer_pause_tb),
    .wash_done(wash_done_tb)
);

// main intial block
initial 
 begin

     // intialization 
     clk_freq_tb = 2'b00;
     clk_tb = 1'b0;
     rst_n_tb = 1'b1;
     coin_in_tb = 1'b0;
     double_wash_tb = 1'b0; 
     timer_pause_tb = 1'b0;

     // Reset
     #(clk_period * 0.2)
     rst_n_tb = 1'b0;
     #(clk_period * 0.6)
     rst_n_tb = 1'b1;
      
     
     // test case
      
     coin_in_tb = 1'b1;
     $display ("-------------------test case 1--------------------");
     if (wash_done_tb ==  1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");

        
      #(clk_period * 10) 
    $display ("-------------------test case 2--------------------");
     if (wash_done_tb ==  1'b0)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
     
     coin_in_tb = 1'b0;
      
    #(clk_period * 120000000) 
    $display ("-------------------test case 3--------------------");
     if (wash_done_tb ==  1'b0)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
     

     #(clk_period * 300000000) 
    $display ("-------------------test case 4--------------------");
     if (wash_done_tb ==  1'b0)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
    

    #(clk_period * 120000000) 
    $display ("-------------------test case 5--------------------");
     if (wash_done_tb ==  1'b0)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
    

    #(clk_period * 60000000) 
    $display ("-------------------test case 6--------------------");
     if (wash_done_tb ==  1'b1)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failled");
    
     $stop; // $finish;(will close modelsim)


     


     
 end



endmodule 