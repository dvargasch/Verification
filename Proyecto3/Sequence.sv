//Proyecto 3 - Verificacion Funcional de Circuitos Integrados /////////
//Profesor: Ronny Garcia Ramirez                              /////////
//Estudiantes: Rachell Morales - Daniela Vargas               /////////
///////////////////////////////////////////////////////////////////////


// Definición de la clase "transaction" que extiende "uvm_sequence_item"

class transaction  #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz =40, parameter fifo_depth = 4) extends uvm_sequence_item;
  
  `uvm_object_utils(transaction)// macro de UVM que proporciona utilidades básicas para un objeto UVM
  
  //variables utilizadas en los constraints
  
  parameter pck_sz = 40;//paquete completo
  bit [pck_sz-1:pck_sz-8]jump = 0;// 8 bits que pertenencen al next jump
  rand bit [pck_sz-9:pck_sz-12]fila_;//numero de la fila del dispositivo al que se envia
  rand bit [pck_sz-13:pck_sz-16]columna_;//numero de la columna del dispositivo al que se envia
  rand bit mode;//para activar o desactivar los constraints
  bit [pck_sz-18:pck_sz-21] source_r;
  bit [pck_sz-22:pck_sz-25] source_c;
  rand bit [pck_sz-26:0] payload;//corresponde al dato (payload)
  rand int source_;
  int destiny;
  rand int retardo;//se utiliza para el constraint de retardo aleatorio
  int retardo_max = 50;//se utiliza para limitar en el constraint de retardo aleatorio
  int path [5][5];
  int source_aux;
  int destino_aux;
  
  
  constraint modo_1 {mode == 1;};//para activar los constraint
  constraint modo_0 {mode == 0;};//para desactivar los constraint
  
  constraint valid_source {source_ >= 0; source_ < 16;}; //para que la fuente este dentro del rango
  constraint valid_address {fila_ <= ROWS+1; fila_ >= 0; columna_ <= COLUMS+1; columna_ >= 0;};//para una dirección válida dentro de rangos de fila y columna especificados
  
  //limita el rango de columna cuando la fila está en el límite
  constraint restricolumna_ {
    if(fila_ == 0 | fila_ == ROWS+1) 
      columna_ <= COLUMS & columna_ > 0;
  };
  
  //limita el rango de fila cuando la columna está en el límite
  constraint restrifila_ {
    if(columna_ == 0 | columna_ == COLUMS+1) 
      fila_ <= ROWS & fila_ > 0;
  };
  
  //garantiza una dirección válida para ciertas filas
  constraint direccion_valida_drvs {
    if(fila_ != 0 & fila_ != ROWS+1)
      columna_ == 0 | columna_ == COLUMS+1;
  };
  
  constraint retardo_aleat{retardo<=retardo_max;retardo>0;};//permite aleatorizar el retardo en un rango
  constraint retardo_0{retardo == 0;};//permite el retardo minimo
  constraint static_source {source_ == source_aux;};//permite que la fuente sea estatica
  constraint static_destiny {fila_ == 0 ; columna_ == 3;};//permite que el destino sea estatica
  constraint variabilidad_dato {payload inside {{(pckg_sz-25){2'b10}},{(pckg_sz-25){2'b01}},{(pckg_sz-25){1'b1}},{(pckg_sz-25){1'b0}}};};// Variabilidad maxima
  
  //constructor
  function new (string name = "");
    super.new(name);
  endfunction
  
endclass: transaction



// Definición de la clase "my_sequence" que extiende "uvm_sequence"
class my_sequence extends uvm_sequence #(transaction);//esta clase es utilizada para la prueba que realiza transacciones en modo 0
  
  `uvm_object_utils(my_sequence)//macro de UVM que proporciona utilidades básicas para un objeto UVM
  
  //constructor
  function new (string name = "my_sequence");
    super.new(name);
  endfunction
  
  rand int trans_num;//para randomizar el numero de transacciones
  
  constraint trans_limit {soft trans_num inside {[50:100]};}//para limitar el numero de transacciones
  
  task body;//se activan y desactivan los constraints segun lo que se requiera
    `uvm_info("PRUEBA MODO 0", $sformatf("Comenzando en el tiempo %0t", $realtime), UVM_LOW);//indica en cual prueba se utiliza esta frecuencia
    repeat(trans_num) begin
      req = transaction::type_id::create("req"); //crea una nueva instancia del objeto transaction
      start_item(req);//inicia la ejecución de una transacción
      req.valid_source.constraint_mode(1);//fuente valida activada
      req.valid_address.constraint_mode(1);//direccion valida activada
      req.modo_0.constraint_mode(1);//modo 0 activado
      req.static_destiny.constraint_mode(0);//fuente estatica desactivada
      req.modo_1.constraint_mode(0);//modo 1 desactivado      
      req.retardo_0.constraint_mode(1);//retardo minimo activado
      req.variabilidad_dato.constraint_mode(0);//variabilidad desactivada
      req.retardo_aleat.constraint_mode(0);//aleatorizacion de retardo desactivado
      
      
      // aleatoriza los campos de la transacción req de acuerdo con las restricciones y modos de aleatorización definidos en las constraint
      if (!req.randomize()) begin
        `uvm_error("MY_SEQUENCE", "Randomize failed.");//si la aleatorizacion falla envia un mensaje de error
     end
      
      finish_item(req);
    end
  endtask: body
endclass

// Definición de la clase "my_sequence2" que extiende "uvm_sequence"
class my_sequence2 extends uvm_sequence #(transaction);//esta clase es utilizada para la prueba que realiza transacciones en modo 1
  
  `uvm_object_utils(my_sequence2)//macro de UVM que proporciona utilidades básicas para un objeto UVM
 
 //constructor
  function new (string name = "my_sequence2");
    super.new(name);
  endfunction
  
  rand int trans_num;//para randomizar el numero de transacciones
  constraint trans_limit {soft trans_num inside {[50:60]};}//para limitar el numero de transacciones
 
  task body;//se activan y desactivan los constraints segun lo que se requiera
    `uvm_info("PRUEBA MODO 1", $sformatf("Comenzando la simulación en %0t", $realtime), UVM_LOW);
     repeat(trans_num) begin
      req = transaction::type_id::create("req");
      start_item(req);
      req.valid_source.constraint_mode(1);
      req.valid_address.constraint_mode(1);
      req.modo_0.constraint_mode(0);//en este caso se desactiva el modo 0
      req.static_destiny.constraint_mode(0);
      req.modo_1.constraint_mode(1);//en este caso se activa el modo 1      
      req.retardo_0.constraint_mode(1);
      req.retardo_aleat.constraint_mode(0);
      req.variabilidad_dato.constraint_mode(0);
       
       
     if (!req.randomize()) begin
        `uvm_error("MY_SEQUENCE", "Randomize failed.");
     end
       
       
       finish_item(req);
     end
  endtask: body
endclass

// Definición de la clase "my_sequence3" que extiende "uvm_sequence"
class my_sequence3 extends uvm_sequence #(transaction);//esta clase es utilizada para la prueba que realiza transacciones en tiempo aleatorio
  
  `uvm_object_utils(my_sequence3)//macro de UVM que proporciona utilidades básicas para un objeto UVM
  
  //constructor
  function new (string name = "my_sequence3");
    super.new(name);
  endfunction

  rand int trans_num;//para randomizar el numero de transacciones
  constraint trans_limit {soft trans_num inside {[50:60]};}//para limitar el numero de transacciones
  
  task body;//se activan y desactivan los constraints segun lo que se requiera
     `uvm_info("PRUEBA RETARDO ALEATORIO", $sformatf("Comenzando la simulación en %0t", $realtime), UVM_LOW);
     repeat(trans_num) begin
      req = transaction::type_id::create("req");
      start_item(req);
       req.valid_source.constraint_mode(1);
       req.valid_address.constraint_mode(1);
       
       //se desactivan ambos modos, para que use ambos
       req.modo_0.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       
       req.retardo_0.constraint_mode(0);//se desactiva el retardo minimo
       req.retardo_aleat.constraint_mode(1);//se activa el retardo aleatorio
       req.variabilidad_dato.constraint_mode(0);
       req.static_destiny.constraint_mode(0);
       req.randomize();
      
        finish_item(req);
    end
  endtask: body
  endclass


// Definición de la clase "my_sequence4" que extiende "uvm_sequence"
class my_sequence4 extends uvm_sequence #(transaction);//esta clase es utilizada para la prueba que realiza transacciones de una fuente a todos los destinos
  
  `uvm_object_utils(my_sequence4)//macro de UVM que proporciona utilidades básicas para un objeto UVM
  
  //constructor
  function new (string name = "my_sequence4");
    super.new(name);
  endfunction
  
  rand int trans_num;//para randomizar el numero de transacciones
  constraint trans_limit {soft trans_num inside {[50:60]};}//para limitar el numero de transacciones
 
  task body;//se activan y desactivan los constraints segun lo que se requiera
    `uvm_info("PRUEBA UNO A TODOS", $sformatf("Comenzando la simulación en %0t", $realtime), UVM_LOW);
     repeat(trans_num) begin
      req = transaction::type_id::create("req");
      start_item(req);
       req.valid_source.constraint_mode(1);
       req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       req.retardo_0.constraint_mode(1);
       req.retardo_aleat.constraint_mode(0);
       req.static_source.constraint_mode(1);//activa el constraint para que la fuente sea estatica
       req.static_destiny.constraint_mode(0);
       req.valid_address.constraint_mode(1);
       req.variabilidad_dato.constraint_mode(0);
       
       
       req.randomize();
        finish_item(req);
     end
  endtask: body
endclass

// Definición de la clase "my_sequence5" que extiende "uvm_sequence"
class my_sequence5 extends uvm_sequence #(transaction);//esta clase es utilizada para la prueba que realiza transacciones de varias fuentes a un destino
  
  `uvm_object_utils(my_sequence5)//macro de UVM que proporciona utilidades básicas para un objeto UVM
  
  function new (string name = "my_sequence5");
    super.new(name);
  endfunction
  
  rand int trans_num;//para randomizar el numero de transacciones
  
  constraint trans_limit {soft trans_num inside {[50:60]};}//para limitar el numero de transacciones
 
  task body;////se activan y desactivan los constraints segun lo que se requiera
    `uvm_info("PRUEBA TODOS A UNO", $sformatf("Comenzando la simulación en %0t", $realtime), UVM_LOW);
     repeat(trans_num) begin
      req = transaction::type_id::create("req");
      start_item(req);
       req.valid_source.constraint_mode(1);
       req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       req.retardo_0.constraint_mode(1);
       req.retardo_aleat.constraint_mode(0);
       req.static_destiny.constraint_mode(1);//se activa que el destino sea estatico
       req.variabilidad_dato.constraint_mode(0);
       
       req.randomize();
        finish_item(req);
    end
  endtask: body
endclass


// Definición de la clase "my_sequence5" que extiende "uvm_sequence"
class my_sequence6 extends uvm_sequence #(transaction);//esta clase es utilizada para la prueba de variabilidad maxima y retardo aleatorio
  
  `uvm_object_utils(my_sequence6)//macro de UVM que proporciona utilidades básicas para un objeto UVM
 //Proyecto 3 - Verificacion Funcional de Circuitos Integrados /////////
//Profesor: Ronny Garcia Ramirez                              /////////
//Estudiantes: Rachell Morales - Daniela Vargas               /////////
/////////////////////////////////////////////////////////////////////// 
  function new (string name = "my_sequence6");
    super.new(name);
  endfunction
  
  rand int trans_num;

  constraint trans_limit {soft trans_num inside {[50:60]};}//para limitar el numero de transacciones
 
  task body;
    `uvm_info("PRUEBA VARIABILIDAD MAXIMA", $sformatf("Comenzando la simulación en %0t", $realtime), UVM_LOW);
     repeat(trans_num) begin

      req = transaction::type_id::create("req");
      start_item(req);
       req.valid_source.constraint_mode(1);
       req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       req.retardo_0.constraint_mode(0);
       req.retardo_aleat.constraint_mode(1);//se activa el retardo aleatorio
       req.static_destiny.constraint_mode(0);
       req.variabilidad_dato.constraint_mode(1);//se activa la varialbilidad
       req.randomize();
       
      
       finish_item(req);
    end
  endtask: body
  endclass

