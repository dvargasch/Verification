class fifoIn #(parameter dvcs = 4, parameter pack_size = 20, parameter f_size = 4, parameter rows = 4, parameter columns = 4); //parametros
  int numFf;
  bit [pack_size-1:0] dQueue[$];//cola para emular la fifo
  virtual interfaz #(.columns(columns), .pack_size(pack_size), .rows(rows), .f_size(f_size)) routerInter;
  
  function new (int numFf);//constructor
    this.numFf = numFf;
    dQueue = {};//hace que la cola este vacia
  endfunction
  
  function push (bit [pack_size-1:0]data); //con esta funcion se agregan datos a la cola
    this.dQueue.push_back(data);//agrega el dato a la cola
    this.routerInter.data_out_i_in[this.numFf] = dQueue[0];// Transmite el primer dato a la interfaz routerInter
    this.routerInter.pndng_i_in[this.numFf] = 1; // Indica que hay datos pendientes en la interfaz routerInter
    endfunction
    
    task signalIF(); // gestionar las senales de la interfaz
      this.routerInter.pndng_i_in[this.numFf] = 0;// Restablece la señal de datos pendientes
      forever begin 
        if(this.dQueue.size==0) begin
          this.routerInter.pndng_i_in[this.numFf] = 0; // No hay datos pendientes
          this.routerInter.data_out_i_in[this.numFf] = 0; // No hay datos para transmitir
        end
        else begin
          this.routerInter.pndng_i_in[this.numFf] = 1;// Indica que hay datos pendientes
          this.routerInter.data_out_i_in[this.numFf] = dQueue[0];// Transmite el primer dato de la cola
        end
        
        @(posedge this.routerInter.popin[this.numFf]);//espera una señal positiva de reloj 
        if(this.dQueue.size>0) this.dQueue.delete(0); // Elimina el primer dato de la cola si hay datos
		end
	endtask
endclass