class driver #(parameter bits = 1, parameter terminales=5, parameter ancho_pal = 32);
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
  
  task pending_update(); 
    forever begin
      @(negedge vif.clk);
      vif.pndng[0][iterador] = pndng; 
      pop = vif.pop[0][iterador];
    end
  endtask
  
  task Dout_uptate();
    forever begin
      @(posedge vif.clk);
      vif.D_pop[0][iterador] = queue[0]; 
      if(pop ==1) begin
        queue.pop_front();
      end 
      if (queue.size ==0)begin 
        pndng = 0;
      end
    end
  endtask
  
  function void Din_update(bit [ancho_pal-1:0] dato); 
    queue.push_back(dato); 
    pndng = 1;
  endfunction
endclass

class driver_ #(parameter ancho_pal = 32, parameter bits=1, parameter terminales=5);
  driver #(.ancho_pal(ancho_pal), .terminales(terminales)) fifo_d;
  virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) vif_hijo;
  int hold;
  int iterador;

  function new (int identify);
    this.iterador = identify;
    this.fifo_d = new(identify);
    this.fifo_d.vif = vif_hijo;
  endfunction 
  
  task inicia();
    $display ("El Driver # %g se inicializa en %g",iterador,$time);
    fork
      fifo_d.pending_update();
      fifo_d.Dout_uptate();
    join
    
    @(posedge fifo_d.vif.clk);
    fifo_d.vif.rst=1;
    @(posedge fifo_d.vif.clk);
    forever begin 
      transaccion #(.ancho_pal(ancho_pal), .terminales(terminales)) transacciones;
      fifo_d.vif.rst=0;
      fifo_d.vif.D_push[0][iterador] =0;
      fifo_d.vif.pndng [0][iterador] =1;
      
      $display("El Driver # %g espera transaccion en %g",iterador,$time);
      hold = 0;
      transacciones = new();
      @(posedge fifo_d.vif.clk);
      $display("El Driver # %g recibe transaccion en %g",iterador,$time);
      while(hold<transacciones.retardo) begin
        @(posedge fifo_d.vif.clk);
        hold=hold +1;
      end
      
      if(transacciones.Tx ==iterador)begin
        transacciones.tiempo = $time;
        @(posedge fifo_d.vif.clk);
        fifo_d.Din_update(transacciones.dato);
        $display("El Driver  # %g completo su transaccion en %g",iterador,$time);
      end
    end
  endtask
endclass

