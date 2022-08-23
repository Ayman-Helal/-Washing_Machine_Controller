module wash(  
    input rst_n,
    input clk,
    input [1:0]clk_freq,
    input coin_in,
    input double_wash,
    input timer_pause,
    output reg wash_done);

localparam s0 = 3'b000, 
           s1 = 3'b001,
           s2 = 3'b010,
           s3 = 3'b011,
           s4 = 3'b100;
reg[2:0] current_state, next_state;
reg flag;
reg [31:0] counter1_out, counter2_out;
reg one;
reg two;
reg five;



always @(posedge clk or negedge rst_n)
  begin
   if (!rst_n)
     begin 
       current_state <= s0;
     end
   else 
     begin
      current_state <= next_state;
     end
  end

// counter of state timer 
always @(posedge clk or negedge rst_n) begin
   if (!rst_n)
     begin 
       counter1_out <= 32'b0;
     end 
   else 
     begin
      counter1_out <= counter1_out + 32'b1;
     end 
end


// down counter for pause 
always @(posedge clk or negedge rst_n) begin
   if (!rst_n)
     begin 
       counter2_out <= 32'H11111111;
     end 
    else if (~timer_pause)begin
      counter2_out <= 32'b0; 
    end 
    else if (counter2_out == 32'b1)begin
      counter2_out <= 32'H11111111;
    end 
   else begin
      counter2_out <= counter2_out - 32'b1;
     end 
end




always @(*) begin
  case (clk_freq)
  2'b00:begin
    if (counter1_out == 32'd60000000)begin
      one = 1'b1;
    end 
    else if (counter1_out == 32'd120000000)begin
      two = 1'b1;
    end 
    else if (counter1_out == 32'd300000000)begin
      five  = 1'b1;
    end
    else begin 
      one = 1'b0;
      two = 1'b0;
      five = 1'b0;
    end 
  end

    2'b01:begin
    if (counter1_out == 32'd120000000)begin
      one = 1'b1;
    end 
    else if (counter1_out == 32'd240000000)begin
      two = 1'b1;
    end 
    else if (counter1_out == 32'd600000000)begin
      five  = 1'b1;
    end
    else begin 
      one = 1'b0;
      two = 1'b0;
      five = 1'b0;
    end 
  end

      2'b10:begin
    if (counter1_out == 32'd240000000)begin
      one = 1'b1;
    end 
    else if (counter1_out == 32'd480000000)begin
      two = 1'b1;
    end 
    else if (counter1_out == 32'd1200000000)begin
      five  = 1'b1;
    end
    else begin 
      one = 1'b0;
      two = 1'b0;
      five = 1'b0;
    end 
  end

     2'b11:begin
    if (counter1_out == 32'd480000000)begin
      one = 1'b1;
    end 
    else if (counter1_out == 32'd960000000)begin
      two = 1'b1;
    end 
    else if (counter1_out == 32'd2400000000)begin
      five  = 1'b1;
    end
    else begin 
      one = 1'b0;
      two = 1'b0;
      five = 1'b0;
    end 
  end
  endcase 
  
end

always @(*)
  begin
   wash_done = 1'b1;
   
   case (current_state)
     s0: begin
          wash_done = 1'b1;
          if (coin_in)
             begin
             next_state = s1;
             end
          else
             begin
             next_state = s0;
             end
          end
     s1: begin
         wash_done = 1'b0;
         if (two) begin
         counter1_out = 32'b0;
         next_state = s2;
         end 
         else begin 
          next_state = s1;
         end 
         end
     s2: begin
         wash_done = 1'b0;
         if (five)begin
         counter1_out = 32'b0;
         next_state = s3;
         end 
         else begin 
          next_state = s2;
         end 
         end
     s3: begin
         wash_done = 1'b0;
         if (two)begin
          counter1_out = 32'b0;
         if (double_wash)
            begin
             next_state = s2;
            end
         else
             begin
              next_state = s4;
             end
         end
         else begin 
          next_state = s3;
         end 
     end
     s4: begin
          wash_done = 1'b0;
          if (counter2_out == 32'b0)begin
          if (one) begin
          counter1_out = 32'b0;
          next_state = s0;
          end 
          else begin 
             next_state = s4;
          end 
          end
         end
    default: next_state = s0;
   endcase
  end
endmodule

