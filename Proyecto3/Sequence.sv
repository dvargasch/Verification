class mapeo;
  int fila;
  int column;
endclass

class transaction  #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz =40, parameter fifo_depth = 4) extends uvm_sequence_item;
  
  `uvm_object_utils(transaction)
  parameter pck_sz = 40;
  bit [pck_sz-1:pck_sz-8]jump = 0;
  rand bit [pck_sz-9:pck_sz-12]fila_;
  rand bit [pck_sz-13:pck_sz-16]columna_;
  rand bit mode;
  bit [pck_sz-18:pck_sz-21] source_r;
  bit [pck_sz-22:pck_sz-25] source_c;
  rand bit [pck_sz-26:0] payload;
  rand int source_;
  int destiny;
  rand int retardo;
  int retardo_max = 50;
  int path [5][5];
  int source_aux;
  int destino_aux;
  
  
  ///////////////////////
   constraint modo_1 {mode == 1;};
  constraint modo_0 {mode == 0;};
  
  constraint valid_source {source_ >= 0; source_ < 2*ROWS+2*COLUMS;}; 
  //constraint itself {fila_ != pos_driver[source_].row; columna_ != pos_driver[source_].column;};
  constraint valid_address {fila_ <= ROWS+1; fila_ >= 0; columna_ <= COLUMS+1; columna_ >= 0;};
  constraint restricolumna_ {
    if(fila_ == 0 | fila_ == ROWS+1) 
      columna_ <= COLUMS & columna_ > 0;
  };
  constraint restrifila_ {
    if(columna_ == 0 | columna_ == COLUMS+1) 
      fila_ <= ROWS & fila_ > 0;
  };
  constraint direccion_valida_drvs {
    if(fila_ != 0 & fila_ != ROWS+1)
      columna_ == 0 | columna_ == COLUMS+1;
  };
  //Datos
 // constraint variabilidad_dato {payload > 0;};// Variabilidad maxima
    //Retardo
  constraint retardo_aleat{retardo<=retardo_max;retardo>0;};
  constraint retardo_0{retardo == 0;};
  
  constraint static_source {source_ == source_aux;};
  
  constraint static_destiny {fila_ == 0 ; columna_ == 3;};
  
//  constraint invalid_address {fila_ == 3 ; columna_ == 3;};
  
  constraint variabilidad_dato {payload inside {{(pckg_sz-25){2'b10}},{(pckg_sz-25){2'b01}},{(pckg_sz-25){1'b1}},{(pckg_sz-25){1'b0}}};};// Variabilidad maxima
  
  function new (string name = "");
    super.new(name);
  endfunction
  
endclass: transaction


class my_sequence extends uvm_sequence #(transaction);
  
  `uvm_object_utils(my_sequence)
  
  function new (string name = "my_sequence");
    super.new(name);
  endfunction
  
  parameter int ROWS = 4;
  parameter int COLUMS = 4;
  parameter int pckg_sz = 40; 
  
  rand int trans_num;
  mapeo pos_driver [16];
  
  constraint trans_limit {soft trans_num inside {[50:100]};}

  
  task body;
     repeat(1) begin
      req = transaction::type_id::create("req");
      start_item(req);
        req.valid_source.constraint_mode(1);
        req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(1);
       req.static_destiny.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       req.retardo_0.constraint_mode(1);
       req.variabilidad_dato.constraint_mode(0);
       req.retardo_aleat.constraint_mode(0);
       
           if (!req.randomize()) begin
        `uvm_error("MY_SEQUENCE", "Randomize failed.");
     end
      
        finish_item(req);
    end
  endtask: body
  endclass




class my_sequence2 extends uvm_sequence #(transaction);
  
  `uvm_object_utils(my_sequence2)
  
  function new (string name = "my_sequence2");
    super.new(name);
  endfunction
  
  parameter int ROWS = 4;
  parameter int COLUMS = 4;
  parameter int pckg_sz = 40; 
  
  rand int trans_num;
  mapeo pos_driver [16];
  
  constraint trans_limit {soft trans_num inside {[50:60]};}
 
  
  task body;
     repeat(1) begin
      req = transaction::type_id::create("req");
      start_item(req);
        req.valid_source.constraint_mode(1);
        req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(0);
       req.static_destiny.constraint_mode(0);
       req.modo_1.constraint_mode(1);      
       req.retardo_0.constraint_mode(1);
       req.retardo_aleat.constraint_mode(0);
       req.variabilidad_dato.constraint_mode(0);
     if (!req.randomize()) begin
        `uvm_error("MY_SEQUENCE", "Randomize failed.");
     end
      

       // req.retardo_0.constraint_mode(1);
       // req.retardo_aleat.constraint_mode(0);
        finish_item(req);
    end
  endtask: body
  endclass

class my_sequence3 extends uvm_sequence #(transaction);
  
  `uvm_object_utils(my_sequence3)
  
  function new (string name = "my_sequence3");
    super.new(name);
  endfunction
  
  parameter int ROWS = 4;
  parameter int COLUMS = 4;
  parameter int pckg_sz = 40; 
  
  rand int trans_num;
  mapeo pos_driver [16];
  
  constraint trans_limit {soft trans_num inside {[50:60]};}
 
  
  task body;
     repeat(1) begin
      req = transaction::type_id::create("req");
      start_item(req);
       req.valid_source.constraint_mode(1);
       req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       req.retardo_0.constraint_mode(0);
       req.retardo_aleat.constraint_mode(1);
       req.static_destiny.constraint_mode(0);
       req.variabilidad_dato.constraint_mode(0);
       req.randomize();
        finish_item(req);
    end
  endtask: body
  endclass


class my_sequence4 extends uvm_sequence #(transaction);
  
  `uvm_object_utils(my_sequence4)
  
  function new (string name = "my_sequence4");
    super.new(name);
  endfunction
  
  parameter int ROWS = 4;
  parameter int COLUMS = 4;
  parameter int pckg_sz = 40; 
  
  rand int trans_num;
  mapeo pos_driver [16];
  
  constraint trans_limit {soft trans_num inside {[50:60]};}
 
  
  task body;
     repeat(1) begin
      req = transaction::type_id::create("req");
      start_item(req);
       req.valid_source.constraint_mode(1);
       req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       req.retardo_0.constraint_mode(1);
       req.retardo_aleat.constraint_mode(0);
       req.static_source.constraint_mode(1);
   //    req.valid_source.constraint_mode(1);
       req.static_destiny.constraint_mode(0);
       req.valid_address.constraint_mode(1);
       req.variabilidad_dato.constraint_mode(0);
       
       
req.randomize();
        finish_item(req);
     end
  endtask: body
  endclass

class my_sequence5 extends uvm_sequence #(transaction);
  
  `uvm_object_utils(my_sequence5)
  
  function new (string name = "my_sequence5");
    super.new(name);
  endfunction
  
  parameter int ROWS = 4;
  parameter int COLUMS = 4;
  parameter int pckg_sz = 40; 
  
  rand int trans_num;
  mapeo pos_driver [16];
  
  constraint trans_limit {soft trans_num inside {[50:60]};}
 
  
  task body;
     repeat(1) begin
      req = transaction::type_id::create("req");
      start_item(req);
       req.valid_source.constraint_mode(1);
       req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       req.retardo_0.constraint_mode(1);
       req.retardo_aleat.constraint_mode(0);
       req.static_destiny.constraint_mode(1);
       req.variabilidad_dato.constraint_mode(0);
       req.randomize();
        finish_item(req);
    end
  endtask: body
  endclass

class my_sequence6 extends uvm_sequence #(transaction);
  
  `uvm_object_utils(my_sequence6)
  
  function new (string name = "my_sequence6");
    super.new(name);
  endfunction
  
  parameter int ROWS = 4;
  parameter int COLUMS = 4;
  parameter int pckg_sz = 40; 
  
  rand int trans_num;
  mapeo pos_driver [16];
  
  constraint trans_limit {soft trans_num inside {[50:60]};}
 
  
  task body;
     repeat(1) begin
      req = transaction::type_id::create("req");
      start_item(req);
       req.valid_source.constraint_mode(1);
       req.valid_address.constraint_mode(1);
       req.modo_0.constraint_mode(0);
       req.modo_1.constraint_mode(0);      
       req.retardo_0.constraint_mode(0);
       req.retardo_aleat.constraint_mode(1);
       req.static_destiny.constraint_mode(0);
       req.variabilidad_dato.constraint_mode(1);
       req.randomize();
       finish_item(req);
    end
  endtask: body
  endclass

