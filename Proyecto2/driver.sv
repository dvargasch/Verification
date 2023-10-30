`include "interface.sv"
`include "clases.sv"
`include "fifo_in.sv"

class Driver #(parameter drvrs = 16, parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40, parameter fifo_depth = 4);
  logic [3:0] num_driver;
  int hold;
  
  fifo_dr #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz), .fifo_depth(fifo_depth)) fifo_in_d;
  agent_driver_mbx #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) agent_driver_mbx_d;
  agent_driver #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) agent_driver_d;
  
  
  
   /////////Mailbox////////////
  
  drv_chckr_mbx drv_chckr_mbx;
  
  
  
  ///////////Transaccion////////////////
  
  drv_chckr transaccion;
  
  
  
 
  function new(int ID);
    this.num_driver = ID; 
    this.fifo_in_d = new(num_driver);
    this.agent_driver_mbx_d = new();
    this.agent_driver_d = new();
    $display ("Driver [%g] ha inicializado en %g", num_driver, $time);
  endfunction
  
  
          // Declaración de una función que toma dos entradas y devuelve una salida
  function logic [3:0] Destino(input logic [3:0] fila, input logic [3:0] columna);
    logic [3:0] destino;
      // Realiza alguna operación basada en las entradas
           case({fila,columna})
              8'b0000_0001: destino = 4'b0000;  // 0
              8'b0000_0010: destino = 4'b0001;  // 1
              8'b0000_0011: destino = 4'b0010;  // 2
              8'b0000_0100: destino = 4'b0011;  // 3
              8'b0001_0000: destino = 4'b0100;  // 4
              8'b0010_0000: destino = 4'b0101;  // 5
              8'b0011_0000: destino = 4'b0110;  // 6
              8'b0100_0000: destino = 4'b0111;  // 7
              8'b0101_0001: destino = 4'b1000;  // 8
              8'b0101_0010: destino = 4'b1001;  // 9
              8'b0101_0011: destino = 4'b1010;  // 10
              8'b0101_0100: destino = 4'b1011;  // 11
              8'b0001_0101: destino = 4'b1100;  // 12
              8'b0010_0101: destino = 4'b1101;  // 13
              8'b0011_0101: destino = 4'b1110;  // 14
              8'b0100_0101: destino = 4'b1111;  // 15       
            default: destino = 4'b1111; // Cuando selector2:selector1 no coincide con ninguno de los casos            
          endcase
      return destino;
    endfunction
  
  virtual task run();
    fork
      fifo_in_d.interfaz();
    join_none
    
    forever begin
      this.agent_driver_mbx_d.get(agent_driver_d);                                          
      $display("Driver [%g] ha recibido una transaccion en %g",this.num_driver, $time);
      $display("Driver [%g] ha enviado el dato %b",this.num_driver,this.agent_driver_d.dato);
      $display("Destino con external ID [%d] [%d] = [%g] ",this.agent_driver_d.fila_,this.agent_driver_d.columna_,this.Destino(this.agent_driver_d.fila_,this.agent_driver_d.columna_));
      $display("Tiempo de retardo = [%g] ",this.agent_driver_d.retardo);
      $display("Modo = [%d] \n ",this.agent_driver_d.mode);
      
    //////////////////////////////////////////////////////////////  
      
              this.transaccion=new();
              this.transaccion.num_driver= this.num_driver;
              this.transaccion=new();
              this.transaccion.num_driver= this.num_driver;
              this.transaccion.dato= this.agent_driver_d.dato;
              this.transaccion.c_fila= this.agent_driver_d.fila_;
              this.transaccion.c_columna =this.agent_driver_d.columna_;
      this.transaccion.Destino =this.Destino(this.agent_driver_d.fila_,this.agent_driver_d.columna_);
              //this.transaccion.tiempo= $time;
              this.transaccion.modo= this.agent_driver_d.mode;
     
      
              drv_chckr_mbx.put(transaccion);
    ///////////////////////////////////////////////////////////////////////
      
      
      hold=0;
      while(hold< agent_driver_d.retardo)begin
        @(posedge fifo_in_d.interf.clk);
        hold=hold+1;
      end
      
      while(this.fifo_in_d.fifo_emul.size >= fifo_depth) #5;
     
      
 this.fifo_in_d.Fin_push({this.agent_driver_d.Next_jump,this.agent_driver_d.fila_,this.agent_driver_d.columna_,this.agent_driver_d.mode,this.num_driver,Destino(this.agent_driver_d.fila_,this.agent_driver_d.columna_),this.agent_driver_d.dato});   
      
      
      
      
      
      
    end
  endtask
endclass


