`timescale 1ns/10ps
`default_nettype none
`include "Monitor.sv"
//`include "Clases.sv"
`include "Router_library.sv"
`include "interfaz.sv"

module Testmonitor;
  
  //Parametros
  parameter ancho_pal_tb =40; // todos los parametros definidos aquí
  reg clk_tb=0;
  
  parameter pckg_sz = 40;
  parameter fifo_size = 4;
  parameter broadcast = {pckg_sz-18{1'b1}};
  parameter id_column = 0;
  parameter id_row = 0;
  parameter COLUMS = 4;
  parameter ROWS = 4;
  parameter Drivers = COLUMS*2+ROWS*2;
  
  interfaz #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_size)) v_if (.clk(clk_tb));
  
  

  mesh_gnrtr #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_size),.bdcst(broadcast)) DUT (
  .clk(clk_tb),
  .reset(v_if.reset),
  .pndng(v_if.pndng),
  .data_out(v_if.data_out),
  .popin(v_if.popin),
  .pop(v_if.pop),
  .data_out_i_in(v_if.data_out_i_in),
  .pndng_i_in(v_if.pndng_i_in)
  );
  
  initial begin
  $dumpfile("test.vcd");
  $dumpvars(0,Testmonitor);
end
  
  
  //Mailbox
  //typedef mailbox #(mntr_score) mntr_score_mbx;
  mntr_score_mbx mntr_score_mbx =new();// siempre inicializar
  
  //Instanciar modulos
  monitor #(.ancho_pal(ancho_pal_tb)) monitor_tb[ROWS*2+COLUMS*2];//Así se parametriza

  
	initial begin
		forever begin
  		 #1 clk_tb = ~clk_tb; 
		end
	end
  
  initial begin
    
    v_if.reset=1;
    
    #150
    
     v_if.reset=0;
    
    for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
     
      
      monitor_tb[i]=new(i);
      monitor_tb[i].v_if = v_if;
      monitor_tb[i].mntr_score_mbx = mntr_score_mbx;
      
    end
    
    for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
     
      fork
        
        automatic int Q=i;
      
        monitor_tb[Q].run(); 
        
      join_none;
      
    end
    
    #100;
    
    for (int i = 0; i<ROWS*2+COLUMS*2; i++ ) begin
    v_if.pndng_i_in[i] = 0;
    v_if.data_out_i_in[i]=0;
  end
  for (int i = 0; i<2; i++ ) begin
    v_if.data_out_i_in[i] =40'b0000000000000011000000000000000000000011;
    v_if.pndng_i_in[i]=1;
  end
    #10;
    
    for (int i = 0; i<2; i++ ) begin
  
      v_if.pndng_i_in[i]=0;
  end
    
    #100;
  	$finish;
    
  end
  
  
  
endmodule
