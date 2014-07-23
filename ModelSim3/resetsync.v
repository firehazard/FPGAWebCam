 module resetsync(clk, r1, r2);
  input clk, r1;
  output r2;
  reg r2r, prer2;
  
  always @(posedge clk, posedge r1)
  begin
    if (r1 === 1'b1) 
    begin
      prer2 <= 1'b1;
      r2r     <= 1'b1;
    end
    else
    begin
      prer2 <= 1'b0;
      r2r     <= prer2;
    end
  end
  
  assign r2 = r2r;
  
  endmodule