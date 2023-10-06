/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////Esta clase corresponde al driver////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

`include "fifoDriver.sv"//libreria con fifo

class driver#(parameter ancho_pal = 32, parameter terminales=4);//parametros
  fifo_entrada #(.ancho_pal(ancho_pal), .terminales(terminales)) fifo_in;//instancia
  virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) vif_d;//interfaz virtual
  
  //agent_driver_mailbox  agent_driver_mailbox_; // Manejador que apunta al agent_driver_mailbox 
  //driver_checker_mailbox driver_checker_mailbox_; // Manejador que apunta al driver_checker_mailbox
  
  int hold;//variable que controla el tiempo de espera
  int identificador;//identificador del driver
  
  //constructor
  function new (int identify);
    this.identificador = identify; // Asigna el identificador
    this.fifo_in = new(identify);// Inicializa la instancia de la FIFO
    this.fifo_in.vif = vif_d;//asigna la interfaz virtual vif_d a la fifo
  endfunction 
  
  task inicia();
    $display ("Driver numero [%g] se inicializa en el tiempo [%g]",identificador,$time);
    
    //ejecuta tareas en paralelo
    fork
      fifo_in.pop_();//realiza el pop
      fifo_in.Dout_uptate();//actualiza el valor de salida
    join_none
    
    @(posedge fifo_in.vif.clk);
    fifo_in.vif.rst=1;//se resetea la fifo simulada cuando se detecta el flanco positivo
    @(posedge fifo_in.vif.clk);
    
    forever begin 
      trans #(.ancho_pal(ancho_pal), .terminales(terminales)) transacciones;
      fifo_in.vif.rst=0;//señal de reinicio
      fifo_in.vif.D_push[0][identificador] =0;//se desactiva el push
      fifo_in.vif.pndng [0][identificador] =1;//transacciones pendientes
      
      $display("Driver numero [%g] espera transaccion en el tiempo [%g]",identificador,$time);
      
      hold = 0;
      transacciones = new();
      
      @(posedge fifo_in.vif.clk);
      $display("Driver numero [%g] ha recibido la transaccion en el tiempo [%g]",identificador,$time);
      
      for (int i;hold<transacciones.retardo; i++) begin // este for hace que se espere segun el retardo
        @(posedge fifo_in.vif.clk);
        hold = hold +1;
      end
      
      if(transacciones.Term_out == identificador)begin
        transacciones.tiempo = $time;
        
        @(posedge fifo_in.vif.clk);
        fifo_in.push_(transacciones.dato);//ingresa el dato en la fifo
        $display("Driver numero [%g] ha completado su transaccion en el tiempo [%g]",identificador,$time);
      end
    end
  endtask
endclass

class driver_ #(parameter ancho_pal = 32, parameter terminales = 4);
  driver #(.ancho_pal(ancho_pal), .terminales(terminales)) driver_m [terminales]; 
  virtual interfaz #(.ancho_pal(ancho_pal), .terminales(terminales)) vif_dr;

  function new();
    for(int i=0; i< terminales; i++)begin
      driver_m[i]=new(i);//crea instancias
      driver_m[i].vif_d= vif_dr;// Genera varias instancias y asigna la interfaz 
    end
  endfunction
  
  task inicia();//simulacion de los controladores 
    for (int i=0; i< terminales; i++)begin
      fork
        automatic int j=i;
        begin
          driver_m[j].inicia(); // Hace un for para que los procesos hijos se ejecuten de forma simultánea.
        end
      join_none
    end	
  endtask
	
endclass
