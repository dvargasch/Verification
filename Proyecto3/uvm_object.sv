
class mon_score extends uvm_object;
  
  import uvm_pkg::*;
  
  int pkg;
  int num_mon;
  int tiempo;
  int modo;
  int dato;
  int path [5][5];
  int target_r;
  int target_c;
  int source_r;
  int source_c;
  
  `uvm_object_utils_begin(mon_score)
  	`uvm_field_int(pkg,UVM_DEFAULT)
  	`uvm_field_int(num_mon,UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new(string name= "mon_score");
    super.new(name);
  endfunction
  

endclass