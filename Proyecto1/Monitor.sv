// Definición de la clase `fifo_monitor`
class fifo_monitor #(parameter bits = 1, parameter terminales=5, parameter ancho_pal = 32);
  bit pop;
  bit push;
  bit pndng;
  bit [ancho_pal-1:0] D_pop;
  bit [ancho_pal-1:0] queue [$];
  int iterador;
  virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) vif;
  
  // Constructor de la clase
  
  function new(int identify);
    this.pop = 0;
    this.push = 0;
    this.pndng = 0;
    this.D_pop = 0;
    this.queue = {};
    this.iterador = identify;
  endfunction 
  
   //Actualizacion del pending que sale de una FIFO hacia el Bus de datos
  
  task pending_update();
    forever begin
      @(negedge vif.clk);
      vif.pndng[0][iterador] = pndng; 
      pop = vif.pop[0][iterador];
    end
  endtask
  
  // Visto desde la FIFO: actualiza el valor de salida de la fifo (o sea el valor de entrada del bus) y el valor de pending
  
  task Dout_uptate();  
    forever begin
      @(posedge vif.clk);
      vif.D_pop[0][iterador] = queue[0]; // Indica que el dato de entrada al bus de datos va a estar almacenado en la posicion 
      if(pop ==1) begin
        queue.pop_front(); //Eliminando el primer elemento de la fifo.
      end 
      if (queue.size ==0)begin //Se revisa si el tamaño de la queue (fifo) es 0 implica que no hay dato pendiente que enviar al bus de datos
        pndng = 0;
      end
    end
  endtask
  
  // Método para actualizar el dato de entrada
  
  function void Din_update(bit [ancho_pal-1:0] dato); 
    queue.push_back(dato);    //Ingresa el dato en la fifo.
    pndng = 1;
  endfunction
endclass
 

///////////////////////////////////////////


// Definición de la clase `mntr_chckr`

class mntr_chckr #(parameter ancho_pal=32);
  reg [7:0] id;
  int dato;
  int tiempo;

  
  function new ();
  endfunction;
endclass


// Definición de la clase `monitor`

class monitor #(parameter ancho_pal = 32,parameter bits=1, parameter terminales = 5);
  
  //Transacción
	fifo_monitor #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) ff;
	virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) 	vif;
  
  	mntr_chckr #(.ancho_pal(ancho_pal)) transaccion;
  
  // Mailbox
  mntr_chckr_mbx #(.ancho_pal(ancho_pal)) cm_mntr_chckr_mbx;
  
 int ident;    
  
   // Constructor de la clase
  
  function new(int id);
    this.ident = id;
    this.ff = new(id);
  endfunction

   // Tarea principal del monitor
  
  task run();
    $display("[%g] Monitor # [%g] Inicia", $time, ident); // Imprime un mensaje indicando el inicio del monitor y la marca de tiempo actual

    forever begin  // Bucle infinito
      this.transaccion = new ();  // Crear una nueva instancia de la transacción

      fork // Fork para paralelizar dos tareas
        @(posedge ff.vif.clk) // Esperar al flanco de subida del reloj
        ff.pushf(); 
        ff.update(); 
      // Actualizar la FIFO (pop y actualizar Dout)
      join_none
 
      @(posedge ff.vif.clk);
      if (ff.pndng == 1) begin // Verificar si hay una transacción pendiente en la FIFO
         // Establecer el tiempo y la identificación de la transacción
        this.transaccion.tiempo = $time;
        this.transaccion.id = ident;
        @(posedge ff.vif.clk);
        this.transaccion.dato = ff.D_pop;  // Establecer el tiempo y la identificación de la transacción
        this.mntr_chckr_mbx.put(this.transaccion);  // Colocar la transacción en el mailbox
        transaccion_in.print("Monitor: Transaccion recibida");
      end
  
      @(posedge ff.vif.clk);
    end
  endtask

endclass















