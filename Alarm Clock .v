module Alarm(
  input reset , 
  input clock ,
  input[1:0] H_in1,
  input [3:0] H_in0,
  input [3:0] M_in1,
  input [3:0] M_in0,
  input load_time,
  input load_alarm,
  input stop_al,
  input Al_on,
  output reg Alarm,
  output [1:0] H_out1,
  output [3:0] H_out0,
  output [3:0] M_out1,
  output [3:0] M_out0,
  output [3:0] S_out1,
  output [3:0] S_out0,
);
  
  reg clk_1s ; 
  reg[3:0] tmp_1s ;
  reg[5:0] tmp_hour , tmp_min , tmp_sec ; 
  reg[1:0] c_hour1,a_hour1 ; 
  reg[3:0] c_hour0 , a_hour0;
  reg[3:0] c_min1 , a_min1 ; 
  reg[3:0] c_min0, a_min0 ; 
  reg[3:0] c_sec1 , a_sec1;
  reg[3:0] c_sec0 , a_sec0 ;
  function [3:0] mod_10
    input[5:0] number ;
    begin
      mod_10 = (number>=50?:5:(number>=40?4:(number>=30?3:(number>=20?2:(number>=10?1:0)))));
    end
  endfunction
  always@(posedge clock or posedge reset)
    begin
      if(reset)
        begin
          a_hour1<=2'b00;
          a_hour0<=4'b0000;
          a_min1<=4'b0000;
          a_min0<=4'b0000;
          a_sec0<=4'b0000;
          a_sec1<=4'b0000;
          tmp_hour = 10*H_in1+H_in0;
          tmp_min= 10*M_in1+M_in0;
          tmp_sec<=0;
        end
      else
        begin
          if(load_alarm)
            begin
              a_hour1<=H_in1;
              a_hour0<=H_in0;
              a_min1<=M_in1;
              a_min0<=M_in0;
              a_sec1<=4'b0000; 
              a_sec0<=4'b0000;
            end
          if(load_time)
            begin
               tmp_hour = 10*H_in1+H_in0;
               tmp_min= 10*M_in1+M_in0;
               tmp_sec<=0;
            end
          else
            begin
              tmp_sec<=tmp_sec+1;
              if(tmp_sec>=59)begin
                tmp_min<=tmp_min+1;
                tmp_sec<=0;
              
                if(tmp_min>=59)begin
                  tmp_hour<=tmp_hour+1;
                  tmp_min<=0;
                  if(tmp_hour>=24)begin
                    tmp_hour<=0;
                  end
                end
              end
            end
        end
    end
  always@(posedge clock or posedge reset)
    begin
      if(reset)
        begin
          tmp_1s<=0;
          clk_1s<=0;
        end
      else
        begin
          tmp_1s<=tmp_1s+1;
          if(tmp_1s<=5)
            clk_1s<=0;
          else if(tmp_1s>=10)begin
            clk_1s<=1;H
            tmp_1s<=1;
          end
          else
            clk_1s<=1;
        end
    end
  always@(*)
    begin
      if(tmp_hour>=20)
        begin
          c_hour1=2;
        end
      else
        begin
          if(tmp_hour>=10)
            begin
              c_hour1=1;
            end
          else
            c_hour1=0;
        end
      c_hour0 = tmp_hour-10*(c_hour1);
      c_min1 = mod_10(tmp_min);
      c_min0 = tmp_min-10*(c_min1);
      c_sec1 = mod_10(tmp_sec);
      c_sec0 = tmp_sec-10*(c_sec1);
       assign H_out1 = c_hour1 ;
  assign H_out0 = c_hour0 ;
  assign M_out1 = c_min1 ;
  assign M_out0 = c_min0 ;
  assign S_out1 = c_sec1 ;
  assign S_out0 = c_sec0 ;
    end
 
  
  always@(posedge clk_1s or posedge reset)
    begin
      if(reset)
        Alarm<=0 ; 
      else
        begin
          if({a_hour1,a_hour0,a_min1,a_min0,a_sec1,a_sec0}=={c_hour1,c_hour0,c_min1 , c_min0 , c_sec1,c_sec0})
            begin
              if(Al_on)
                Alarm<=1;
            end
              if(stop_al)
                Alarm<=0;
        end
    end
endmodule
            
    
  
  
    
                
          
              