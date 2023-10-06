`timescale 1ns/10ps
`default_nettype none
`include "interface.sv"
`include "driver.sv"
`include "Library.sv"

module bus_tb;  
  //Definiendo parametros que recibe el testbench
  
  parameter bits = 1;
  parameter terminales = 4;
  parameter ancho_pal = 32;
  parameter broadcast = {8{1'b1}};
  
  
  // Definiendo entradas del testbench
  reg clk_tb;
  reg reset_tb;
  reg pndng_tb [terminales-1:0];
  reg [ancho_pal-1:0] D_pop_tb [terminales-1:0] ;
  
  // Definiendo salidas del testbench
  
  reg push_tb [bits-1:0][terminales-1:0];
  reg pop_tb [bits-1:0][terminales-1:0];
  reg [ancho_pal-1:0] D_push_tb [terminales-1:0];
  
  // Data push y Data pop para el bus
  
  reg [ancho_pal-1:0] Data_pop_tb [terminales-1:0];
  
  
  
  //Hay que conectar la interfaz virtual al testbench y luego la interfaz virtual al
  // DUT, la interfaz sirve como "traductor" entre wl hardware y software
  
  
  interfaz  #(.terminales(terminales), .ancho_pal(ancho_pal), .broadcast(broadcast)) bus_if_inst (.clk(clk_tb)); 
                                                                                               //.rst(reset_tb), .pndng(pndng_tb), .push(push_tb), .pop(pop_tb), .D_pop(D_pop_tb), .D_push(D_push_tb));
  
  
 //Conectando la interfaz y el DUT
  bs_gnrtr_n_rbtr #( .drvrs(terminales), .pckg_sz(ancho_pal), .broadcast(broadcast)) Top_bus_inst (.clk(bus_if_inst.clk), .reset(bus_if_inst.rst), .pndng(bus_if_inst.pndng), .push(bus_if_inst.push), .pop(bus_if_inst.pop), .D_pop(bus_if_inst.D_pop), .D_push(bus_if_inst.D_push));
  
  //Instanciando clases del Driver
  
  
  fifo_entrada #(.terminales(terminales), .ancho_pal(ancho_pal)) fifo_driver_inst;
  
  driver #(.ancho_pal(ancho_pal), .terminales(terminales)) driver_hijo_inst;
  
  driver_padre #(.ancho_pal(ancho_pal), .terminales(terminales)) driver_padre_inst;

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
    driver_padre_inst.driver_h[j].fifo_in.vif = bus_if_inst;
  end
  
  #10;
  driver_padre_inst.inicia();
  #100;
  
$finish;
  
end
  
endmodule
