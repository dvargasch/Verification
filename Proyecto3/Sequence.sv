class transaction  #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz =40, parameter fifo_depth = 4) extends uvm_sequence_item;
  
  `uvm_object_utils(transaction)
  
  bit [7:0]jump = 0;
  rand bit [3:0]fila_;
  rand bit [3:0]columna_;
  rand bit mode;
  rand bit [22:0] payload;
  rand int source_;
  
  ///////////////////////
 //  constraint modo_1 {mode == 1;};
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
  constraint variabilidad_dato {payload > 0;};// Variabilidad maxima
  
  
  
  function new (string name = "");
    super.new(name);
  endfunction
  
endclass: transaction

class my_sequence extends uvm_sequence #(transaction);
  
  `uvm_object_utils(my_sequence)
  
  function new (string name = "");
    super.new(name);
  endfunction
  
  task body;
    repeat(1) begin
      req = transaction::type_id::create("req");
      start_item(req);

      if (!req.randomize()) begin
        `uvm_error("MY_SEQUENCE", "Randomize failed.");
      end


      finish_item(req);
    end
  endtask: body
  
endclass