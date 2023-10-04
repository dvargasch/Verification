//Emulada
class fifo_monitor #(parameter pckg_sz = 32,parameter bits=1, parameter terminales = 5);
    bit pop;
    bit push;
    bit pndng;
    bit [pckg_sz-1:0] d_in;
    bit [pckg_sz-1:0] d_out;
    bit [pckg_sz-1:0] fifo_queue[$]; 
    int ident;

virtual interfaz #(.pckg_sz(pckg_sz), .bits(bits), .terminales(terminales)) vif;

function new(int id);
	this.pop=0;
	this.push=0;
	this.pndng=0;
	this.d_in=0;
    this.d_out=0;
	this.fifo_queue= {};
    this.ident=id;
endfunction

//////////////////////////////////////////


task pen_update(); //Actualizacion del pending que sale de una FIFO hacia el Bus de datos
    forever begin
      @(negedge vif.clk);
      vif.pndng[0][ident] = pndng; 
      pop = vif.pop[0][ident];
    end
  endtask

  task Dout_uptate(); // Visto desde la FIFO: actualiza el valor de salida de la fifo (o sea el valor de entrada del bus) y el valor de pending 
    forever begin
      @(posedge vif.clk);
      vif.d_out[0][ident] = fifo_queue[0]; // Indica que el dato de entrada al bus de datos va a estar almacenado en la posicion 
      if(pop ==1) begin
        fifo_queue.pop_front(); //Eliminando el primer elemento de la fifo.
      end 
      if (fifo_queue.size ==0)begin //Se revisa si el tamaño de la queue (fifo) es 0 implica que no hay dato pendiente que enviar al bus de datos
        pndng = 0;
      end
    end
  endtask


  function void Din_update(bit [pckg_sz-1:0] dato); 
    fifo_queue.push_back(dato);    //Ingresa el dato en la fifo.
    pndng = 1;
  endfunction
endclass 

///////////////////////////////////////////

class monitor #(parameter ancho_pal = 32,parameter bits=1, parameter terminales = 7)
  
  fifo_monitor #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) ff;
  trans_monitor #(.ancho_pal(ancho_pal)) transaccion_in, transaccion_out;
  MNTR_CHCKR_mxb comando_MNTR_CHCKR_mxb;
  
  int ident;
  
  function new(int id);
    this.ident = id;
    this.ff = new(id);
  endfunction

  task run();
    $display("[%g] Monitor # [%g] Inicia", $time, ident);

    forever begin
     transaccion_in = new;

      fork
        @(posedge ff.vif.clk) // Esperar al flanco de subida del reloj
        ff.pushf();
     	ff.update();
      join_none
 
      @(posedge ff.vif.clk);
      if (ff.pndng == 1) begin
        transaccion_in.tiempo = $time;
        transaccion_in.ter_in = ident;
        @(posedge ff.vif.clk);
        transaccion_in.dato = ff.d_in;
        MNTR_CHCKR_mxb.put(transaccion_in);
        transaccion_in.print("Monitor: Transaccion recibida");
      end
  
      @(posedge ff.vif.clk);// Monitorear datos que salen
      transaccion_out = new;
  
      @(posedge ff.vif.clk);
      if (ff.pndng == 1) begin
        ff.popf();
        transaccion_out.tiempo = $time;
        transaccion_out.ter_out = ident;
        @(posedge fifo.vif.clk);
        transaccion_out.dato = ff.d_out;
        MNTR_CHCKR_mxb.put(transaccion_out);
        transaccion_out.print("Monitor: Transaccion enviada");
      end
      @(posedge ff.vif.clk);
    end
  endtask

endclass
