//Proyecto 3 - Verificacion Funcional de Circuitos Integrados /////////
//Profesor: Ronny Garcia Ramirez                              /////////
//Estudiantes: Rachell Morales - Daniela Vargas               /////////
///////////////////////////////////////////////////////////////////////

class mon_score extends uvm_object; // Clase para comunicación entre monitor y el score
  
  import uvm_pkg::*; // Importa el paquete UVM para acceder a sus definiciones
  
  int pkg; // Campo para almacenar datos del paquete
  int num_mon; // Campo para almacenar el número del monitor
  int tiempo; // Campo para almacenar el tiempo
  int modo; // Campo para almacenar el modo
  int dato; // Campo para almacenar el dato
  int path [5][5]; // Matriz para almacenar la ruta
  int target_r; // Campo para almacenar la fila de destino
  int target_c; // Campo para almacenar la columna de destino
  int source_r; // Campo para almacenar la fila de origen
  int source_c; // Campo para almacenar la columna de origen
  
  `uvm_object_utils_begin(mon_score)
  	`uvm_field_int(pkg,UVM_DEFAULT) // Macro para especificar el campo 'pkg' como un campo de objeto UVM
  	`uvm_field_int(num_mon,UVM_DEFAULT) // Macro para especificar el campo 'num_mon' como un campo de objeto UVM
  `uvm_object_utils_end // Macro que finaliza la definición de campos y funciones UVM
  
  function new(string name = "mon_score"); // Constructor de la clase
    super.new(name); // Llama al constructor de la clase base (uvm_object)
  endfunction
endclass


class drv_score extends uvm_object; // Clase para comunicación entre driver y el score
  
  import uvm_pkg::*; // Importa el paquete UVM para acceder a sus definiciones
  
  int pkg; // Campo para almacenar datos del paquete
  int num_drv; // Campo para almacenar el número del driver
  int tiempo; // Campo para almacenar el tiempo
  int modo; // Campo para almacenar el modo
  int dato; // Campo para almacenar el dato
  int path [5][5]; // Matriz para almacenar la ruta
  int target_r; // Campo para almacenar la fila de destino
  int target_c; // Campo para almacenar la columna de destino
  int source_r; // Campo para almacenar la fila de origen
  int source_c; // Campo para almacenar la columna de origen
  
  `uvm_object_utils_begin(drv_score)
  	`uvm_field_int(pkg,UVM_DEFAULT) // Macro para especificar el campo 'pkg' como un campo de objeto UVM
  	`uvm_field_int(modo,UVM_DEFAULT) // Macro para especificar el campo 'modo' como un campo de objeto UVM
  `uvm_object_utils_end // Macro que finaliza la definición de campos y funciones UVM
  
  function new(string name = "drv_score"); // Constructor de la clase
    super.new(name); // Llama al constructor de la clase base (uvm_object)
  endfunction
endclass
