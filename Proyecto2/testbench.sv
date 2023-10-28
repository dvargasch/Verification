`timescale 1ns/1ps
`include "Router_library.sv"
`include "Driver.sv"
`include "monitor.sv"
`include "agente.sv"
`include "Generador.sv"
`include "scoreboard.sv"
`include "ambiente.sv"
`include "test.sv"

module testbench();
  
  initial begin
    rand_parameter pkt = new();
    pkt.size_pckg.constraint_mode(1); 
    pkt.randomize();
  end
  
  reg clk_tb;
  parameter devices_tb = 16; //cantidad de dispositivos
  parameter rows_tb = 4; //cantidad de filas
  parameter columns_tb = 4; //cantidad de columnas
  parameter pckg_sz_tb = 40; //ancho de la palabra
  parameter fifo_depth_tb = 4; //profundidad de la fifo
  
  
  //instancias
  test_generador_mbx test_generador_mbx_tb =new();//mailbox entre el test y el generador
  path_checker #(.pckg_sz(pckg_sz_tb)) path_checker_tb;//mailbox entre el checker y el path 
  interfaz #(.ROWS(rows_tb), .COLUMS(columns_tb ),.pckg_sz(pckg_sz_tb),.fifo_depth(fifo_depth_tb)) interf (.clk(clk_tb));
  ambiente  #(.ROWS(rows_tb), .COLUMS(columns_tb ), .pckg_sz(pckg_sz_tb), .fifo_depth(fifo_depth_tb), .drvrs(devices_tb)) ambiente_tb;
  test #(.ROWS(rows_tb), .COLUMS(columns_tb ), .pckg_sz(pckg_sz_tb), .fifo_depth(fifo_depth_tb), .drvrs(devices_tb)) test_tb;
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,testbench);
  end
  
  //instancia para la conexion con el DUT
  mesh_gnrtr #(.ROWS(rows_tb), .COLUMS(columns_tb ), .pckg_sz(pckg_sz_tb),.fifo_depth(fifo_depth_tb)) DUT (.clk(clk_tb),.reset(interf.reset),.pndng(interf.pndng),.data_out(interf.data_out),.popin(interf.popin),.pop(interf.pop),.data_out_i_in(interf.data_out_i_in),.pndng_i_in(interf.pndng_i_in));
  
  initial begin
    forever begin
      #5
      clk_tb = ~clk_tb;
    end
  end
  
  initial begin
    clk_tb = 0;
    interf.reset = 1;
    
    #50
    interf.reset = 0;
  end
  
  initial begin 
    test_tb = new(); //constructor test
    test_tb.test_generador_mbx_t = test_generador_mbx_tb;
    ambiente_tb = new();//constructor ambiente
    ambiente_tb.display();
    ambiente_tb.generador_amb.test_generador_mbx_g = test_generador_mbx_tb;
    ambiente_tb.debug_signal_detector_amb.interf = interf;
    
    for (int i = 0; i < devices_tb; i++ ) begin //para que se ejecute para cada dispositivo
      automatic int k = i;
      ambiente_tb.driver_amb[k].fifo_in_d.interf = interf;
      ambiente_tb.monitor_amb[k].vif_m = interf;
    end
    
    fork //para que se ejecuten en paralelo
      test_tb.run();
      ambiente_tb.run();
    join_none
  end
  
  initial begin
    forever begin
      ambiente_tb.detector_checker_mb_amb.get(path_checker_tb);
      $display("\n Por el router con internal ID [%0d] [%0d] pasa la transacción [%b]",path_checker_tb.row_path,path_checker_tb.column_path,path_checker_tb.data_out);
  		end
  	end
  
  initial begin
    #50000;
     ambiente_tb.t_run();
    $finish;
  end
endmodule