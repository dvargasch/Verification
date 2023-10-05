`timescale 1ns/10ps
`default_nettype none
`include "interfaz.sv"
`include "agente.sv"
`include "Monitor.sv"
`include "driver.sv"
`include "library.sv"


module bus_tb;  
  //Definiendo parametros que recibe el testbench
  
  parameter bits = 1;
  parameter terminales = 5;
  parameter ancho_pal = 16;
  parameter broadcast = {8{1'b1}};
  
  
  // Definiendo entradas del testbench
  reg clk_tb;
  reg reset_tb;
  reg pndng_tb [bits-1:0][terminales-1:0];
  reg [ancho_pal-1:0] D_pop_tb [bits-1:0][terminales-1:0] ;
  
  // Definiendo salidas del testbench
  
  reg push_tb [bits-1:0][terminales-1:0];
  reg pop_tb [bits-1:0][terminales-1:0];
  reg [ancho_pal-1:0] D_push_tb [bits-1:0][terminales-1:0];
  
  // Data push y Data pop para el bus
  
  reg [ancho_pal-1:0] Data_pop_tb [bits-1:0][terminales-1:0];
  
  
  
  //Hay que conectar la interfaz virtual al testbench y luego la interfaz virtual al
  // DUT, la interfaz sirve como "traductor" entre wl hardware y software
  
  
  interfaz  #(.bits(bits), .terminales(terminales), .ancho_pal(ancho_pal), .broadcast(broadcast)) bus_if_inst (.clk(clk_tb)); 
                                                                                               //.rst(reset_tb), .pndng(pndng_tb), .push(push_tb), .pop(pop_tb), .D_pop(D_pop_tb), .D_push(D_push_tb));
  
  
 //Conectando la interfaz y el DUT
  bs_gnrtr_n_rbtr #(.bits(bits), .drvrs(terminales), .pckg_sz(ancho_pal), .broadcast(broadcast)) Top_bus_inst (.clk(bus_if_inst.clk), .reset(bus_if_inst.rst), .pndng(bus_if_inst.pndng), .push(bus_if_inst.push), .pop(bus_if_inst.pop), .D_pop(bus_if_inst.D_pop), .D_push(bus_if_inst.D_push));
  
  
  
///////////////////Driver///////////////////////////////

//Instanciando clases del Driver
  
  
  driver #(.bits(bits), .terminales(terminales), .ancho_pal(ancho_pal)) fifo_driver_inst;
  
  driver_hijo #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) driver_hijo_inst;
  
  driver_padre #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) driver_padre_inst;

initial begin
  $dumpfile("Intf.vcd");
  $dumpvars(0,bus_tb);
  $dumpvars(0);
end  
  
initial begin
forever begin
   #1 clk_tb = ~clk_tb; 
end
end
  
initial begin
  clk_tb =1;
  reset_tb=1;
  #2
  reset_tb =0;
  driver_padre_inst = new();
  for (int i=0; i<terminales; i++)begin
    automatic int j = i;
    driver_padre_inst.driver_h[j].fifo_d.vif = bus_if_inst;
  end
  
  #10;
  driver_padre_inst.inicia();
  #100;
  
$finish;
  
end
  
//////////////////////Monitor//////////////////////
  
//Mailbox
//mntr_chckr_mbx comando_mntr_chckr_mbx= new ();
  mntr_chckr_mbx  #(.ancho_pal(ancho_pal)) comando_mntr_chckr_mbx = new ();
  
  
  
  //Instanciando clases del Monitor
 
  fifo_monitor #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) ff_tb;
   
  monitor #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) mon;
  
      
	initial begin
      mon= new ();
      ff_tb= new ();
    
 ff_tb.mntr_chckr_mbx = cm_mntr_chckr_mbx;
 mon.mntr_chckr_mbx = cm_mntr_chckr_mbx;
    end
  
  /////////////////Agente/////////////////////
  
  mntr_chckr_mbx #(.ancho_pal(ancho_pal)) mntr_chckr_mbx = new ();
  
  //Instanciando clases del Agente
  
      agente #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) agente;
      
  initial begin
      agente= new ();
    
 agente.ag_chckr_mbx  = ag_chckr_mbx ;
    end
  
 
endmodule
