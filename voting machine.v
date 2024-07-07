// Code your design here
timescale 1ns/1ps
module buttoncontrol(
  intput clock , input reset  ,
  input button , output reg valid_vote);
  reg [30:0] counter ; 
  always@(posedge clock)
    begin
      if(reset)
        counter<=0;
      else
        begin
          if(button & counter<11)
            counter<=counter+1;
          else if(!button)
            counter<=0;
        end
    end
  always@(posedge clock)
    begin
      if(reset)
        valid_vote<=1'b0;
      else
        begin
          if(counter==10)
            valid_vote<=1'b1;
          else
            valid_vote<=1'b0;
        end
    end
endmodule
module votelogger(
  input clock , input reset , 
  input mode , input cand1_vote_valid
  input cand2_vote_valid , input cand3_vote_valid
  , input cand4_vote_valid,
  output reg[7:0] cand1_vote_record,
  output reg[7:0] cand2_vote_record,
  output reg[7:0] cand3_vote_record,
  output reg[7:0] cand4_vote_record,);
  always(@posedge clock)
    begin
      if(reset)
        begin
          cand1_vote_record<=0;
           cand2_vote_record<=0;
           cand3_vote_record<=0;
           cand4_vote_record<=0;
        end
      else
        begin
          if(cand1_vote_valid & mode==0)
            cand1_vote_record<=cand1_vote_record+1;
          else if(cand2_vote_valid & mode==0)
            cand2_vote_record<=cand2_vote_record+1;
          else if(cand3_vote_valid & mode==0)
            cand3_vote_record<=cand3_vote_record+1;
          else if(cand4_vote_valid & mode==0)
            cand4_vote_record<=cand4_valid_record+1;
        end
    end
endmodule
module mode(
  input clock , 
  input reset , 
  input mode , 
  input valid_vote,
  input [7:0] cand1_vote,
  input [7:0] cand2_vote,
  input [7:0] cand3_vote,
  input [7:0] cand4_vote,
  input cand1_button,
  input cand2_button,
  input cand3_button,
  input cand4_button,
  output reg [7:0] leds);
  reg[30:0] counter ; 
  always@(posedge clock)
    begin
      if(reset)
        counter<=0;
      else if(valid_vote)
        counter<=counter+1;
      else if(counter!=0 &counter<10)
        counter<=counter+1;
      else
        counter<=0;
    end
  always(@posedge clock)
    begin
      if(reset)
        leds<=0;
      else
        begin
          if(mode==0 &counter>0)
            leds<=8'hFF;
          else if(mode==0)
            leds<=8'h00;
          else if(mode==1)
            begin
              if(cand1_button)
                leds<=cand1_vote;
              else if(cand2_button)
                leds<=cand2_vote;
              else if(cand3_button)
                leds<=cnad3_vote;
              else if(cand4_button)
                leds<=cand4_vote;
            end
        end
    end
endmodule
module voting(
  input clock , input reset,
  input mode , input button1 , 
  input button2 , 
  input button3 , 
  input button4 , 
  output [7:0] leds );
  wire valid_vote1;
   wire valid_vote2;
   wire valid_vote3;
   wire valid_vote4;
  wire [7:0] vote1;
  wire [7:0] vote2;
  wire [7:0] vote3;
  wire [7:0] vote4;
  wire valid ; 
  assign valid = valid_vote1|valid_vote2|valid_vote3|valid_vote4;
  button control bc1(
    .clock(clock),
    .reset(reset),
    .button(button1),
    .valid_vote(valid_vote_1)
  );
    button control bc2(
    .clock(clock),
    .reset(reset),
      .button(button2),
      .valid_vote(valid_vote_2)
  );
    button control bc3(
    .clock(clock),
    .reset(reset),
      .button(button3),
      .valid_vote(valid_vote_3)
  );
    button control bc4(
    .clock(clock),
    .reset(reset),
      .button(button4),
      .valid_vote(valid_vote_4)
  );
         
  votelogger vl(
    .clock(clock),
    .reset(reset),
    .mode(mode),
    .cand1_vote_valid(valid_vote1),
    .cand2_vote_valid(valid_vote2),
    .cand3_vote_valid(valid_vote3),
    .cand4_vote_valid(valid_vote4),
    .cand1_vote_record(vote1),
    .cand2_vote_record(vote2),
    .cand3_vote_record(vote3),
    .cand4_vote_record(vote4));
  mode mc(
    .clock(clock),
    .reset(reset),
    .mode(mode),
    .valid_vote(valid),
    .cand1_vote(vote1),
    .cand2_vote(vote2),
    .cand3_vote(vote3),
    .cand4_vote(vote4),
    .cand1_button(valid_vote1),
    .cand2_button(valid_vote2),
    .cand3_button(valid_vote3),
    .cand4_button(valid_vote4),
    .leds(leds));
endmodule