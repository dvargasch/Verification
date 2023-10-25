`timescale 1ns/10ps
`include "Router_library.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agente.sv"
`include "generador.sv"
`include "scoreboard.sv"
`include "ambiente.sv"
`include "test.sv"


module testbench();
  parameter devices_tb = 16; //cantidad de dispositivos
  parameter rows_tb = 4; //cantidad de filas
  parameter columns_tb = 4; //cantidad de columnas
  parameter pckg_sz_tb = 40; //ancho de la palabra
  parameter fifo_depth_tb = 4; //profundidad de la fifo
  
  reg clk_tb; //parametro para reloj
  
  mntr_score_mbx mntr_score_mbx =new();// siempre inicializar
  test_generador_mbx test_generador_mbx_tb =new();//mailbox entre el test y el generador
  
  ambiente  #(.rows(rows_tb), .columns(columns_tb), .pckg_sz(pckg_sz_tb), .f_depth(fifo_depth_tb), .drvrs(devices_tb)) ambiente_tb;//instancia del ambiente
  test #(.rows(rows_tb), .columns(columns_tb), .pckg_sz(pckg_sz_tb), .f_depth(fifo_depth_tb), .drvrs(devices_tb)) test_tb;//instancia del test
  interfaz #(.rows(rows_tb), .columns(columns_tb),.pckg_sz(pckg_sz_tb),.f_depth(fifo_depth_tb)) interfaz_tb (.clk(clk_tb));//instancia de la interfaz
  
  // conexion con el DUT
  mesh_gnrtr #(.ROWS(rows_tb), .COLUMS(columns_tb), .pckg_sz(pckg_sz_tb),.fifo_depth(fifo_depth_tb)) DUT (
    .clk(clk_tb),
    .reset(interfaz_tb.reset),
    .pndng(interfaz_tb.pndng),
    .data_out(interfaz_tb.data_out),
    .popin(interfaz_tb.popin),
    .pop(interfaz_tb.pop),
    .data_out_i_in(interfaz_tb.data_out_i_in),
    .pndng_i_in(interfaz_tb.pndng_i_in));
  
  //clock
  initial begin
    forever begin
      #5
      clk_tb = ~clk_tb;
    end
  end
  
  initial begin
    clk_tb = 0;
    interfaz_tb.reset = 1;    
    #50
    interfaz_tb.reset = 0;
  end
  
  initial begin 
    test_tb = new();
    ambiente_tb = new();
    ambiente_tb.display();
    
    test_tb.test_gen_mb_t = test_generador_mbx_tb;
    ambiente_tb.generador_amb.test_gen_mb_g = test_generador_mbx_tb;
    
    
    fork//inicializar test y ambiente
      test_tb.run();
      ambiente_tb.run();
    join_none 
    
    // Conexión de los controladores al DUT y la interfaz
    for (int i = 0; i < devices_tb; i++ ) begin
      automatic int k = i;
      ambiente_tb.driver_amb[k].fifo_dr_d.interfaz_f = interfaz_tb;
      ambiente_tb.monitor_amb[k].vif_m = interfaz_tb;
      
    end
  end
  
  initial begin
    $dumpfile("prueba.vcd");
    $dumpvars(0,testbench);
  end
  
  initial begin
    #50000;
    ambiente_tb.t_run();
    $finish;
  end
endmodule
