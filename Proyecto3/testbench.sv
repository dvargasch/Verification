`include "uvm_macros.svh"
`include "pckg_test.svh"

module tb_top;
  import uvm_pkg::*;
  import test::*;
  
  bit clk_tb;
  always #5 clk_tb <= ~clk_tb;
 
  router_if dut_if(clk_tb);
  dut_wrapper dut_wr (._if (dut_if));
  
  initial begin
    uvm_config_db#(virtual router_if)::set(null, "*","v_if", dut_if);
   // run_test("test");
    run_test("test_M1");
   // run_test("test_M0");   
   // run_test("test_retardo");
   // run_test("test_todos_a_uno");
   // run_test("test_uno_a_todos");
   // run_test("test_variabilidad");
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb_top);
  end
  
endmodule