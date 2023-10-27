//`include "Clases.sv"

class scoreboard #( parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40);
  
  ///////////////Mailboxes////////////////////
  
  mntr_score_mbx mntr_score_mbx;
  
  drv_chckr_mbx  drv_chckr_mbx;
 
 
  // Instancias de las transacciones
  mntr_score  mntr_score_transaccion;
  
  drv_chckr	 drv_chckr_transaccion_;
  
  
// Arreglos dinámicos para transacciones recibidas y entregadas
  
  mntr_score #(.pckg_sz (pckg_sz ),.ROWS(ROWS),.COLUMS(COLUMS)) recibida [$]; 
  
  mntr_score #(.pckg_sz (pckg_sz ),.ROWS(ROWS),.COLUMS(COLUMS)) arr_rec [int]; 
 
  drv_chckr	#(.pckg_sz (pckg_sz ),.ROWS(ROWS),.COLUMS(COLUMS)) entregada[$];
  //drv_chckr	#(.pckg_sz (pckg_sz ),.ROWS(ROWS),.COLUMS(COLUMS)) arr_ent [int];
  
  function new();
    this.recibida= {};
    this.entregada= {};
  endfunction 
  
// Tarea para el scoreboard del monitor
  
  task run_rec(); 
    forever begin
      this.mntr_score_mbx.get(this.mntr_score_transaccion); // trae el la información del monitor al scoreboard
      this.recibida.push_back(this.mntr_score_transaccion); // Agarra esa información  y la almacena en la cola
      
      arr_rec [this.mntr_score_transaccion.dato]=this.mntr_score_transaccion;
      
      $display(" Se recibió del monitor el dato %b  con id %g con un tiempo de envío de 	[%g] y con modo[%g]",this.mntr_score_transaccion.dato,this.mntr_score_transaccion.id,this.mntr_score_transaccion.tiempo, this.mntr_score_transaccion.modo);
    end 
  endtask
  
  task display_run ();
    foreach (arr_rec[i]) begin
      $display("ARREGLO pos [%b] con modo [%b]", i, arr_rec[i].modo);
    end
      
  endtask
  
  // Tarea para el scoreboard del agente 

task run_ent(); 
    forever begin
      this.drv_chckr_mbx.get(this.drv_chckr_transaccion_); // trae el la información del driver al scoreboard
      this.entregada.push_back(this.drv_chckr_transaccion_); // Agarra esa información  y la almacena en la cola
      
      $display(" Se recibió del driver el dato %b  con id %b con un tiempo de envío de [%g]",this.drv_chckr_transaccion_.dato,this.drv_chckr_transaccion_.id, this.drv_chckr_transaccion_.tiempo, this.drv_chckr_transaccion_.modo);
    end 
  endtask
  
  
endclass
