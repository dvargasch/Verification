class ag_chckr #(parameter ancho_pal = 16); 
  bit [ancho_pal-9:0] dato ;
  bit [7:0] id ;
  int tiempo;

    // Constructor de la clase
  
  function new(bit [ancho_pal-1:0] , [7:0] direccion, tiempo, source);
    this.dato = info;
    this.id = direccion;
    this.tiempo = tiempo;
  endfunction
  
  // Función para mostrar información
  
  function display();
    $display("El dato: %b se envió, en el tiempo %g", this.dato, this.tiempo);
  endfunction 
  
endclass

class checker_sb #(parameter bits = 1, parameter terminales=5, parameter ancho_pal = 32);
  
  // Instancias de las mailboxes
  mntr_chckr_mbx #(.ancho_pal(ancho_pal)) mntr_chckr_mbx;
  
  ag_chckr_mbx #(.ancho_pal(ancho_pal)) ag_chckr_mbx;
  
  
 // Instancias de las transacciones
  mntr_chckr #(.ancho_pal(ancho_pal)) mntr_chckr_transaccion;
  
  ag_chckr	#(.ancho_pal(ancho_pal)) ag_chckr_transaccion;
  
// Arreglos dinámicos para transacciones recibidas y entregadas
  
  mntr_chckr #(.ancho_pal(ancho_pal)) recibida [$];
 
  ag_chckr	#(.ancho_pal(ancho_pal)) entregada[$];

  
  // Constructor de la clase
  
  function new();
    this.recibida= {};
    this.entregada= {};
    this.mntr_chckr_mbx=new();
    this.ag_chckr_mbx=new();
    
  endfunction 
  
// Tarea para el scoreboard del monitor
  
  task run(); 
    forever begin
      this.mntr_chckr_mbx.get(this.mntr_chckr_transaccion); // trae el la información del minitor al scoreboard
      this.recibida.push_back(this.mntr_chckr_transaccion); // Agarra esa información  y la almacena en la cola
      
      $display(" Se recibió el dato %b  con id %b con un tiempo de envío de 	[%g]",this.mntr_chckr_transaccion.dato,this.mntr_chckr_transaccion.id,this.mntr_chckr_transaccion.tiempo);
    end 
  endtask
  
  // Tarea para el scoreboard del agente 

task run(); 
    forever begin
      this.ag_chckr_mbx.get(this.ag_chckr_transaccion); // trae el la información del minitor al scoreboard
      this.entregada.push_back(this.ag_chckr_transaccion); // Agarra esa información  y la almacena en la cola
      
      $display(" Se recibió el dato %b  con id %b con un tiempo de envío de [%g]",this.ag_chckr_transaccion.dato,this.ag_chckr_transaccion.id, this.ag_chckr_transaccion.tiempo);
    end 
  endtask
  
  
endclass
