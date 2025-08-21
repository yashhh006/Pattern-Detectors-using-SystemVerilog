module tb#(parameter pattern=5'b10110, num_bits=5);
  reg rstn,clk,data;
  reg valid;
  wire detect;
  
  dyn_patt uut(.*);
  
  string testcase2;
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    rstn=0;
    valid=0;
    #6
    rstn=1;
    valid=1;
  end
  
  task random();
    begin
      repeat(300)begin
        @(posedge clk);
        data=$random;
      end
    end
  endtask
  
  task fixed();
    begin
      #5
      @(posedge clk); data=1;
      @(posedge clk); data=0;
      @(posedge clk); data=1;
      @(posedge clk); data=1;
      @(posedge clk); data=0;
    
      @(posedge clk); data=1;
      @(posedge clk); data=1;
      @(posedge clk); data=0;
      
      @(posedge clk); data=1;
      @(posedge clk); data=1;
      @(posedge clk); data=0;
      @(posedge clk); data=1;
    end
  endtask
  
  initial begin
    if($value$plusargs("testcase2=%s",testcase2))begin
      case(testcase2)
        "random": random();
        "fixed":fixed();
        default:random();
      endcase
    end
    else begin
      $display("No Arguement Passsed TB >> Random");
      random();
    end
       end
  
  initial begin
    #2000
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0, tb);
  end
endmodule
