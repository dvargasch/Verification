//`include "Clases.sv"

class scoreboard #( parameter pckg_sz = 40);
  
  // Instancias de las mailboxes
  mntr_score_mbx mntr_score_mbx;
  
  //ag_chckr_mbx #(.ancho_pal(ancho_pal)) ag_chckr_mbx;
 
  // Instancias de las transacciones
  mntr_score  mntr_score_transaccion;
  
  //ag_chckr	 ag_chckr_transaccion;
  
  
// Arreglos dinámicos para transacciones recibidas y entregadas
  
  mntr_score #(.pckg_sz (pckg_sz )) recibida [$];
 
  //ag_score	#(.pckg_sz (pckg_sz )) entregada[$];

  
  // Constructor de la clase
  
 virtual interfaz  v_if;// poner parametros
 int id_;
  
  function new();
    this.recibida= {};
    //this.entregada= {};
    this.mntr_score_mbx=new();
    //this.ag_score_mbx=new();
    
  endfunction 
  
// Tarea para el scoreboard del monitor
  
  task run(); 
    forever begin
      this.mntr_score_mbx.get(this.mntr_score_transaccion); // trae el la información del monitor al scoreboard
      this.recibida.push_back(this.mntr_score_transaccion); // Agarra esa información  y la almacena en la cola
      
      $display(" Se recibió el dato %b  con id %g con un tiempo de envío de 	[%g]",this.mntr_score_transaccion.dato,this.mntr_score_transaccion.id,this.mntr_score_transaccion.tiempo);
    end 
  endtask
  
  // Tarea para el scoreboard del agente 

/*task run(); 
    forever begin
      this.ag_chckr_mbx.get(this.ag_chckr_transaccion); // trae el la información del minitor al scoreboard
      this.entregada.push_back(this.ag_chckr_transaccion); // Agarra esa información  y la almacena en la cola
      
      $display(" Se recibió el dato %b  con id %b con un tiempo de envío de [%g]",this.ag_chckr_transaccion.dato,this.ag_chckr_transaccion.id, this.ag_chckr_transaccion.tiempo);
    end 
  endtask
  
  */
endclass
  
