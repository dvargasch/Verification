class checker_scoreboard;
  
  //Mailbox
  mntr_chckr_mbx #(.ancho_pal(ancho_pal)) mntr_chckr_mbx;
  
  //Transacción
  mntr_chckr #(.ancho_pal(ancho_pal)) transaccion;
  mntr_chckr instruccion [$];// esta es la estructura dinámica que maneja el scoreboard
  
 
  
  function new();
    this.instruccion= {};
  endfunction 
  
  task run();
    forever begin
      
    this.mntr_chckr_mbx.get(this.transaccion);
      this.instruccion.push_back(this.transaccion);
      
      $display(" Se recibió el dato %b  con id %b con un tiempo de envío de [%g]",this.transaccion.dato,this.transaccion.id, this.transaccion.tiempo);
    end 
  endtask
  
  
  
endclass
