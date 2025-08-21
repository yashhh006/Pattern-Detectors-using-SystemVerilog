module dyn_patt #(parameter pattern=5'b10110, num_bits=5)(
  input rstn,clk,data,
  input reg valid,
  output reg detect);
  
  reg [4:0] temp;
  reg [2:0]count;
  string testcase;
  
  
  always@(posedge clk)begin
    if(!rstn)begin
      temp=0;
      detect=0;
      count=0;
    end
    else begin
      if(valid==1)begin
        temp={temp[num_bits-2:0],data};
        count=count+1;
        detect=0;
        if(count==num_bits)begin
          if(temp==pattern)begin
            detect=1;
            if($value$plusargs("testcase=%s",testcase))begin
              case(testcase)
                "nonoverlap":count=0;
                "overlap":count=count-1;
                default:count=0;
              endcase
            end
            else begin
              $display("No Arguement Passsed Design >> Non-Overlap");
              count=0;
            end
          end
          else begin
            detect=0;
            count=count-1; 
          end
        end
      end
    end
  end
endmodule
