`timescale 1ns/10ps
`default_nettype none
`include "Monitor.sv"
`include "driver.sv"
//`include "Clases.sv"
`include "Router_library.sv"
//`include "interfaz.sv"

module Testmonitor;
  
  //Parametros
  reg clk_tb=0;
  reg rst_tb;
  
  parameter pckg_sz_tb  = 21;
  parameter fifo_size_tb = 4;
  parameter broadcast = {pckg_sz_tb-18{1'b1}}; 
  parameter id_column_tb = 0;
  parameter id_row_tb = 0;
  parameter COLUMNS_tb = 4;
  parameter ROWS_tb = 4;
  parameter Drivers_tb = 16;
  
  
  monitor #(.rows(ROWS_tb), .columns(COLUMNS_tb), .fifo_depth(fifo_size_tb),  .pckg_sz(pckg_sz_tb)) monitor_tb [Drivers_tb];//Así se parametriza 
  
  
  
  Driver #(.pack_size(pckg_sz_tb), .rows(ROWS_tb), .columns(COLUMNS_tb), .f_size(fifo_size_tb), .dvcs(Drivers_tb)) driver_tb [Drivers_tb];
  
  agnt_drvr_mb  #(.pack_size (pckg_sz_tb), .rows(ROWS_tb), .columns(COLUMNS_tb), .f_size(fifo_size_tb), .dvcs(Drivers_tb)) agnt_drvr_mb_tb [Drivers_tb];
  
    
  agnt_drvr  #(.pack_size(pckg_sz_tb), .rows(ROWS_tb), .columns(COLUMNS_tb), .f_size(fifo_size_tb), .dvcs(Drivers_tb)) agnt_drvr_tb;
  
  
  interfaz #(.rows(ROWS_tb), .columns(COLUMNS_tb), .pckg_sz(pckg_sz_tb),.fifo_depth(fifo_size_tb)) v_if (.clk(clk_tb));
  

  mesh_gnrtr #(.ROWS(ROWS_tb), .COLUMS(COLUMNS_tb),   .pckg_sz(pckg_sz_tb),.fifo_depth(fifo_size_tb),.bdcst(broadcast)) DUT (
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
  //mntr_score_mbx mntr_score_mbx =new();// siempre inicializar
  
  //Instanciar modulos
  
  

  
	initial begin
		forever begin
  		 #1 clk_tb = ~clk_tb; 
		end
	end
  
  initial begin
    clk_tb = 0;
    v_if.reset = rst_tb;
    rst_tb = 1;
    v_if.reset = rst_tb;
    
   
    #150
    rst_tb = 0;
     v_if.reset=0;
  end
  
  initial begin
    for (int i = 0; i<ROWS_tb*2+COLUMNS_tb*2; i++ ) begin
      automatic int k = i;
      agnt_drvr_mb_tb[k] = new();
    end
    
   #50
    
    for (int i = 0; i<ROWS_tb*2+COLUMNS_tb*2; i++ ) begin
      automatic int k = i;
      driver_tb[k]=new(k);
      monitor_tb[k]=new(k);
      driver_tb[k].agnt_drvr_mb_dr = agnt_drvr_mb_tb[k];
    end
    
    for (int i = 0; i < COLUMNS_tb; i++) begin
      automatic int k = i;
      driver_tb[k] = new(k);
      monitor_tb[k] = new(k);
      driver_tb[k].agnt_drvr_mb_dr = agnt_drvr_mb_tb[k];
    end
    
    for (int i = 0; i < COLUMNS_tb; i++) begin
      driver_tb[i].row = 0;
      driver_tb[i].column = i+1;
    end

    
    for (int i = 0; i<ROWS_tb;i++)begin
      driver_tb[i+COLUMNS_tb].column = 0;
      driver_tb[i+COLUMNS_tb].row = i+1;
		end
    for (int i = 0; i<COLUMNS_tb;i++)begin
      driver_tb[i+ROWS_tb*2].row = ROWS_tb+1;
      driver_tb[i+ROWS_tb*2].column = i+1;
		end
          for (int i = 0; i<ROWS_tb;i++)begin
            driver_tb[i+COLUMNS_tb*3].column = COLUMNS_tb+1;
            driver_tb[i+COLUMNS_tb*3].row = i+1;
		end
		
    for (int i = 0; i<ROWS_tb*2+COLUMNS_tb*2; i++ ) begin
			automatic int k = i;
      $display("Driver [%0d] id_row: %0d id_col: %0d",i,driver_tb[k].row,driver_tb[k].column);
      driver_tb[k].fifoInDr.routerInter = v_if;
      monitor_tb[k].v_if = v_if;
		end
		
    for(int i = 0; i<COLUMNS_tb*2+ROWS_tb*2; i++ ) begin
			fork
			automatic int k = i;
			driver_tb[k].run();
			monitor_tb[k].run();
			join_none
		end
		
		for(int i = 0; i < 16; i++) begin
			automatic int k = i;
			agnt_drvr_tb = new();
			agnt_drvr_tb.randomize();
			agnt_drvr_tb.Nxt_jump = 0;
			//Este if verifica si se va a enviar un paquete a él mismo, invierte la dirección si es necesario
          if(agnt_drvr_tb.row_num == driver_tb[agnt_drvr_tb.source].row  & agnt_drvr_tb.column_num == driver_tb[agnt_drvr_tb.source].column) begin
            agnt_drvr_tb.row_num = driver_tb[agnt_drvr_tb.source].column;
            agnt_drvr_tb.column_num = driver_tb[agnt_drvr_tb.source].row;
			end
          agnt_drvr_mb_tb[agnt_drvr_tb.source].put(agnt_drvr_tb);
			$display("Fuente = %0d coordenada fila = %0d coordenada columna = %0d modo = %b dato = %b", agnt_drvr_tb.source,agnt_drvr_tb.row_num,agnt_drvr_tb.column_num,agnt_drvr_tb.mode,agnt_drvr_tb.data);
			
		end

		end

		initial begin
		#5000;
		$finish;
		end


	
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
      
   //   monitor_tb[i].mntr_score_mbx = mntr_score_mbx;
      
      
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
*/
	endmodule