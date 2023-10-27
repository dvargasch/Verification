`include "interface.sv"
`include "clases.sv"
`include "fifo_dr.sv"

// Driver: fuerza senales al DUT

class Driver #(parameter drvrs = 16, parameter rows = 4, parameter columns = 4, parameter pckg_sz = 40, parameter f_depth = 4);
  int driver_num;
  
  fifo_dr #(.rows(rows), .columns(columns), .pckg_sz(pckg_sz), .f_depth(f_depth)) fifo_dr_d;
  agent_driver_mb #(.rows(rows), .columns(columns), .pckg_sz(pckg_sz)) agent_driver_mb_d;
  trans_agent_driver #(.rows(rows), .columns(columns), .pckg_sz(pckg_sz)) trans_agent_driver_d;
  
  /////////Mailbox////////////
  
  drv_chckr_mbx drv_chckr_mbx;
  
  
  
  ///////////Transaccion////////////////
  
  drv_chckr transaccion;
  
  function new(int dn);// Constructor de la clase Driver
    this.driver_num = dn;
    this.fifo_dr_d = new(driver_num);
    this.agent_driver_mb_d = new();
    this.trans_agent_driver_d = new();
    $display ("Driver [%g] inicializado en %g ", driver_num, $time);
  endfunction
  
  virtual task run();
    fork
      fifo_dr_d.interfaz(); // Iniciar la interfaz de la FIFO
    join_none
    
    forever begin
      this.agent_driver_mb_d.get(trans_agent_driver_d);                                         
      $display("Driver [%g] recibida transaccion en %g ",this.driver_num, $time );
      $display("Driver [%g] envia dato %b a fila [%g] y columna [%g]",this.driver_num,this.trans_agent_driver_d.dato,this.trans_agent_driver_d.c_fila,this.trans_agent_driver_d.c_columna);
      
      
              this.transaccion=new();
              this.transaccion.dato= this.trans_agent_driver_d.dato;
              this.transaccion.c_fila= this.trans_agent_driver_d.c_fila;
              this.transaccion.c_columna =this.trans_agent_driver_d.c_columna;
              //this.transaccion.tiempo= $time;
              this.transaccion.modo= this.trans_agent_driver_d.modo;
      
      
      
      //this.drv_chckr_mbx.put({this.trans_agent_driver_d.Next_jump,this.trans_agent_driver_d.c_fila,this.trans_agent_driver_d.c_columna,this.trans_agent_driver_d.modo,this.trans_agent_driver_d.dato});
      
              drv_chckr_mbx.put(transaccion);
      
      while(this.fifo_dr_d.FIFO_IN.size >= f_depth) #5;
      this.fifo_dr_d.Fin_push({this.trans_agent_driver_d.Next_jump,this.trans_agent_driver_d.c_fila,this.trans_agent_driver_d.c_columna,this.trans_agent_driver_d.modo,this.trans_agent_driver_d.dato});
      
      
    end
  endtask
endclass

