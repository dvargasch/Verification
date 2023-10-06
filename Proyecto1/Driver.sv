`include "fifoDriver.sv"

class driver #(parameter ancho_pal = 32, parameter bits=1, parameter terminales=5);
  fifo_entrada #(.ancho_pal(ancho_pal), .terminales(terminales)) fifo_d;
  virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) vif_hijo;
  //agent_driver_mailbox  adm; // Se define el manejador adm que apunta al objeto agent_driver_mailbox 
  //driver_checker_mailbox dcm; // Manejador que apunta al driver_checker_mailbox
  int HOLD;
  int iterador;

  function new (int identify);
    this.iterador = identify;
    this.fifo_d = new(identify);
    this.fifo_d.vif = vif_hijo;
    
  endfunction 
  
  task inicia();
    $display ("Driver # [%g] se inicializa en tiempo [%g]",iterador,$time);
    fork
      fifo_d.pop_();
      fifo_d.Dout_uptate();
    join_none
    
    
    @(posedge fifo_d.vif.clk);
    fifo_d.vif.rst=1;
    @(posedge fifo_d.vif.clk);
    forever begin 
      trans_bus #(.ancho_pal(ancho_pal), .terminales(terminales)) transacciones;
      fifo_d.vif.rst=0;
      fifo_d.vif.D_push[0][iterador] =0;
      fifo_d.vif.pndng [0][iterador] =1;
      
      $display("Driver # [%g] esperando transaccion [%g]",iterador,$time);
      HOLD = 0;
      transacciones = new();
      @(posedge fifo_d.vif.clk);
      //adm.get(transacciones); //Conecta mailbox al handler que apunta al bus de transacciones
      $display("Driver # [%g] recibe transaccion en tiempo [%g]",iterador,$time);
      while(HOLD<transacciones.retardo) begin
        @(posedge fifo_d.vif.clk);
        HOLD=HOLD +1;
      end
      
      if(transacciones.Tx ==iterador)begin
        transacciones.tiempo = $time;
        @(posedge fifo_d.vif.clk);
        fifo_d.push_(transacciones.dato);//Ingresa el dato dado por la variable DATO en el Trans_bus y lo agrega a la variable de Din_update de la clase fifo_d
        $display("Driver[%g]: transaccion completada en tiempo [%g]",iterador,$time);
        //dcm.put(transacciones); //Envia la transaccion al checker desde el bus de transacciones
      end
    end
  endtask
endclass


class driver_padre #(parameter ancho_pal =32, parameter bits=1, parameter terminales =5);
  driver_hijo #(.ancho_pal(ancho_pal), .terminales(terminales)) driver_h [terminales]; 
  virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) vif_padre;
  // handler que apunta a la clase driver_hijo
  function new();
    for(int i=0; i< terminales; i++)begin
      driver_h[i]=new(i);
      driver_h[i].vif_hijo= vif_padre;// Genera varias instancias de la clase driver_hijo
    end
  endfunction
  
  task inicia();
    for (int i=0; i< terminales; i++)begin
      fork
        automatic int j=i;
        begin
          driver_h[j].inicia(); // Hace un for para que los procesos hijos se ejecuten de forma simultánea.
        end
      join_none
    end	
  endtask
	
endclass
