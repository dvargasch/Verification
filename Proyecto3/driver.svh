//Proyecto 3 - Verificacion Funcional de Circuitos Integrados /////////
//Profesor: Ronny Garcia Ramirez                              /////////
//Estudiantes: Rachell Morales - Daniela Vargas               /////////
///////////////////////////////////////////////////////////////////////

`include "uvm_object.sv"

class driver extends uvm_driver #(transaction);
  
  `uvm_component_utils(driver)  // Macro que proporciona funciones y métodos necesarios para el funcionamiento de UVM.
  
  uvm_analysis_port #(drv_score) conec_drv; // Declaración de un puerto de análisis para transacciones de driver.
  
  drv_score obj; // Declaración de una instancia de la clase 'drv_score'.
  
  transaction transaccion_tst = new; // Declaración e inicialización de una transacción de prueba.
  
  
  virtual router_if v_if; // interfaz virtual
  int hold;// Declaración de una variable que se utiliza para simular un retraso antes de continuar con la ejecución del resto del código. 
  
  int num; // Declaración de una variable que define el número de driver
  int numero[16] = '{01,02,03,04,10,20,30,40,51,52,53,54,15,25,35,45}; // Inicialización de un array de enteros llamado 'numero'. 
  int Row[16] = '{0,0,0,0,1,2,3,4,5,5,5,5,1,2,3,4}; //Un arreglo con enteros de la posición de la fila para determinar el numero de driver
  int column[16] = '{1,2,3,4,0,0,0,0,1,2,3,4,5,5,5,5}; //Un arreglo con enteros de la posición de la columna para determinar el numero de driver
  int path [5][5];

  
  //constructor para el driver
  function new(string name,uvm_component parent);
    super.new(name,parent);
    conec_drv=new("conec_drv",this);// Creación de un puerto de análisis para el driver.
  endfunction
  
  
  //fase de construccion 
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual router_if)::get(this, "", "v_if", v_if)) begin
      `uvm_error("","uvm_config_db::get failed") // Mensaje de error si la obtención de la interfaz virtual falla.
    end
  endfunction
  
  //fase de ejecucion
  task run_phase(uvm_phase phase);
    
    
    v_if.reset = 1; // Se activa la señal de reset en la interfaz virtual.
    
    v_if.data_out_i_in[num] = 0; // Se establece a 0 la salida de datos en la interfaz virtual.
    v_if.pndng_i_in[num] = 0; // Se establece a 0 la señal de pendiente en la interfaz virtual.
    
    @(posedge v_if.clk);
    #1;
    v_if.reset = 0;// Se desactiva la señal de reset en la interfaz virtual.
    
 forever begin   
    
   seq_item_port.get_next_item(req);// Se obtiene la transacción del secuenciador.
   

 
    @(posedge v_if.clk);
    v_if.data_out_i_in[num] = 0;
    v_if.pndng_i_in[num] = 0;
    @(posedge v_if.clk);
    @(posedge v_if.clk);
   ///se guardan los datos en la transacción req, y se define también la fila y la columna al cual se le van a enviar los datos de la transacción req////
   req.source_r = Row[num];
   req.source_c = column[num];
   v_if.data_out_i_in[num] = {req.jump,req.fila_,req.columna_, req.mode,req.source_r,req.source_c ,req.payload};
   if((req.fila_ == Row[num]) & (req.columna_ == column[num])) begin
     req.fila_ = column[num];
     req.columna_ = Row[num];
     v_if.data_out_i_in[num] = {req.jump,req.fila_,req.columna_, req.mode,req.source_r,req.source_c ,req.payload};
   end
    v_if.pndng_i_in[num] = 1;
    @(posedge v_if.clk);
   wait (v_if.popin[num]);
   @(posedge v_if.clk);
  v_if.pndng_i_in[num] = 0;
  v_if.data_out_i_in[num] = 0;
   
   /////////////////////////////////////////////
   
   ////Se guardan los datos en la transacción obj para poder enviar el paquete por medio del puerto a una function write en el scoreboard//
   
   obj = drv_score::type_id::create("drv_score");// Se crea un objeto de la clase drv_score.
        obj.pkg={req.jump,req.fila_,req.columna_, req.mode,req.source_r,req.source_c ,req.payload};
        obj.tiempo=$time;
        obj.modo=req.mode;
        obj.dato=req.payload;
        obj.target_r = req.fila_;
        obj.target_c = req.columna_;
        
        obj.source_r = req.source_r;
        obj.source_c = req.source_c;
   		obj.num_drv = num;
        conec_drv.write(obj); // Se escribe el objeto en el puerto de análisis del driver.
   
   
   
   ///////////////////////////////////////////   
   /// esperar un cierto tiempo antes de continuar con la siguiente parte del código.
   
   hold = 0;
   while(hold<transaccion_tst.retardo) begin // Inicia un bucle while que se ejecutará mientras el valor de hold sea menor que el retardo especificado por 
     @(posedge v_if.clk);
     hold = hold + 1; // Incrementa el valor de hold en 1. Esto simula el paso de un ciclo de reloj durante la espera.
   end
   
   
   seq_item_port.item_done(); // Se notifica que la transacción ha sido completada.
   
   

   
 end
  
  endtask
  
 
endclass: driver
