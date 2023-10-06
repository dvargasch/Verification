class fifo_monitor #(parameter bits = 1, parameter terminales=5, parameter ancho_pal = 32);
  bit pop;
  bit push;
  bit pndng;
  bit [ancho_pal-1:0] D_pop;
  bit [ancho_pal-1:0] queue [$];
  int iterador;
  virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) vif;
  
  function new(int identify);
    this.pop = 0;
    this.push = 0;
    this.pndng = 0;
    this.D_pop = 0;
    this.queue = {};
    this.iterador = identify;
  endfunction 
  
  task pending_update(); //Actualizacion del pending que sale de una FIFO hacia el Bus de datos
    forever begin
      @(negedge vif.clk);
      vif.pndng[0][iterador] = pndng; 
      pop = vif.pop[0][iterador];
    end
  endtask
  
  task Dout_uptate(); // Visto desde la FIFO: actualiza el valor de salida de la fifo (o sea el valor de entrada del bus) y el valor de pending 
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
  
  
  function void Din_update(bit [ancho_pal-1:0] dato); 
    queue.push_back(dato);    //Ingresa el dato en la fifo.
    pndng = 1;
  endfunction
endclass
 

///////////////////////////////////////////

class mntr_chckr_#(parameter ancho_pal=32);
  reg [7:0] id;
  int dato;
  int tiempo;

  
  function new ();
  endfunction;
endclass

class monitor #(parameter ancho_pal = 32,parameter bits=1, parameter terminales = 5);
  
  //Transacción
	fifo_monitor #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) ff;
	virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) 	vif;
  
  	mntr_chckr #(.ancho_pal(ancho_pal)) transaccion;
  
  // Mailbox
  mntr_chckr_mbx #(.ancho_pal(ancho_pal)) cm_mntr_chckr_mbx;
  
 int ident;    
  
  function new(int id);
    this.ident = id;
    this.ff = new(id);
  endfunction

  task run();
    $display("[%g] Monitor # [%g] Inicia", $time, ident);

    forever begin
     //this.transaccion_in = new ();
       this.transaccion = new ();

      fork
        @(posedge ff.vif.clk) // Esperar al flanco de subida del reloj
        ff.pushf();
     	ff.update();
      join_none
 
      @(posedge ff.vif.clk);
      if (ff.pndng == 1) begin
        this.transaccion.tiempo = $time;
        this.transaccion.id = ident;
        @(posedge ff.vif.clk);
        this.transaccion.dato = ff.D_pop;
        this.mntr_chckr_mbx.put(this.transaccion);
        transaccion_in.print("Monitor: Transaccion recibida");
      end
  
      //@(posedge ff.vif.clk);// Monitorear datos que salen
      //this.transaccion_out = new ();
  
      //@(posedge ff.vif.clk);
      //if (ff.pndng == 1) begin
        //ff.popf();
        //this.transaccion_out.tiempo = $time;
        //this.transaccion_out.id = ident;
        //@(posedge fifo.vif.clk);
        //this.transaccion_out.dato = ff.D_pop;
        //this.mntr_chckr_mbx.put(this.transaccion_out);
        //transaccion_out.print("Monitor: Transaccion enviada");
      //end
      @(posedge ff.vif.clk);
    end
  endtask

endclass















