module dyn_patt #(parameter pattern=5'b10110, num_bits=5)(
  input rstn,clk,data,
  input reg valid,
  output reg [num_bits:0]state,
  output reg detect);
  
  reg [num_bits-1:0]temp;
  reg [2:0]count;
  string testcase;
  
  reg [4:0]s_rstn=5'b00001;
  reg [4:0]s_1   =5'b00010;
  reg [4:0]s_10  =5'b00100;
  reg [4:0]s_101 =5'b01000;
  reg [4:0]s_1011=5'b10000;
  
  reg [num_bits:0]next_state;
  
  always@(posedge clk)begin
    if(!rstn)begin
      state=s_rstn;
      temp=0;
      detect=0;
      count=0;
      next_state=s_rstn;
    end
    else begin
      if(valid==1)begin
        temp={temp[num_bits-2:0],data};
        $display("At %0t temp=%b",$time,temp);
        count=count+1;
        $display("count=%0d",count);
          case(state)
            s_rstn:begin
              if(temp[0]==pattern[4])begin
                next_state=s_1;
                detect=0;
              end
              else begin
                next_state=s_rstn;
                detect=0;
                count=count-1;
              end
            end
            
            s_1:begin
              if(temp[1:0]==pattern[4:3])begin
                next_state=s_10;
                detect=0;
              end
              else if(temp[0]==pattern[4])begin
                next_state=s_1;
                detect=0;
                count=count-1;
              end
              else begin
                next_state=s_rstn;
                detect=0;
                count=count-2;
              end
            end
            
            s_10:begin
              if(temp[2:0]==pattern[4:2])begin
                next_state=s_101;
                detect=0;
              end
              else if(temp[1:0]==pattern[4:3])begin
                next_state=s_10;
                detect=0;
                count=count-1;
              end
              else if(temp[0]==pattern[4])begin
                next_state=s_1;
                detect=0;
                count=count-2;
              end
              else begin
                next_state=s_rstn;
                detect=0;
                count=count-3;
              end
            end
            
            s_101:begin
              if(temp[3:0]==pattern[4:1])begin
                next_state=s_1011;
                detect=0;
              end
              else if(temp[2:0]==pattern[4:2])begin
                next_state=s_101;
                detect=0;
                count=count-1;
              end
              else if(temp[1:0]==pattern[4:3])begin
                next_state=s_10;
                detect=0;
                count=count-2;
              end
              else if(temp[0]==pattern[4])begin
                next_state=s_1;
                detect=0;
                count=count-3;
              end
              else begin
                next_state=s_rstn;
                detect=0;
                count=count-4;
              end
            end
            
            s_1011:begin
              if($value$plusargs("testcase=%s",testcase))begin
                case(testcase)
                  "nonoverlap":begin
                    if(count==num_bits)begin
                      if(temp[4:0]==pattern[4:0])begin
                        next_state=s_rstn;
                        detect=1;
                        count=0;
                      end
                      else begin
                        if(temp[3:0]==pattern[4:1])begin
                          next_state=s_1011;
                          detect=0;
                          count=count-1;
                        end
                        else if(temp[2:0]==pattern[4:2])begin
                          next_state=s_101;
                          detect=0;
                          count=count-2;
                        end
                        else if(temp[1:0]==pattern[4:3])begin
                          next_state=s_10;
                          detect=0;
                          count=count-3;
                        end
                        else if(temp[0]==pattern[4])begin
                          next_state=s_1;
                          detect=0;
                          count=count-4;
                        end
                        else begin
                          next_state=s_rstn;
                          detect=0;
                          count=0;
                        end
                      end
                    end
                  end
                  "overlap":begin
                    if(count==num_bits)begin
                      if(temp[4:0]==pattern[4:0])begin
                        detect=1;
                        if(temp[3:0]==pattern[4:1])begin
                          next_state=s_1011;
                          count=count-1;
                        end
                        else if(temp[2:0]==pattern[4:2])begin
                          next_state=s_101;
                          count=count-2;
                        end
                        else if(temp[1:0]==pattern[4:3])begin
                          next_state=s_10;
                          count=count-3;
                        end
                        else if(temp[0]==pattern[4])begin
                          next_state=s_1;
                          count=count-4;
                        end
                        else begin
                          next_state=s_rstn;
                          count=0;
                        end
                      end
                    end
                    else if(temp[4:0]!=pattern[4:0]) begin
                        if(temp[3:0]==pattern[4:1])begin
                          next_state=s_1011;
                          detect=0;
                          count=count-1;
                        end
                        else if(temp[2:0]==pattern[4:2])begin
                          next_state=s_101;
                          detect=0;
                          count=count-2;
                        end
                        else if(temp[1:0]==pattern[4:3])begin
                          next_state=s_10;
                          detect=0;
                          count=count-3;
                        end
                        else if(temp[0]==pattern[4])begin
                          next_state=s_1;
                          detect=0;
                          count=count-4;
                        end
                        else begin
                          next_state=s_rstn;
                          detect=0;
                          count=0;
                        end
                      end
                  end
                endcase
              end
            end
          endcase
      end
    end
  end
  
  always@(next_state)
    state=next_state;
  
endmodule
