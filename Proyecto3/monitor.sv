//Proyecto 3 - Verificacion Funcional de Circuitos Integrados /////////
//Profesor: Ronny Garcia Ramirez                              /////////
//Estudiantes: Rachell Morales - Daniela Vargas               /////////
///////////////////////////////////////////////////////////////////////
class monitor extends uvm_monitor;
  
  import uvm_pkg::*;
  
  `uvm_component_utils(monitor);// Macro que proporciona funciones y métodos necesarios para el funcionamiento de UVM.
  
  uvm_analysis_port #(mon_score) conec_mon; // Declaración de un puerto de análisis para transacciones de monitor.
  
  mon_score obj; // Declaración de una instancia de la clase 'mon_score'.
  
  
  int pkg_sz=40; // Tamaño paquete
  int num; // Declaración de una variable que define el número de monitor
  int count = 0; //para contador 
  int numero;
  bit modo; // Declaración de una variable que define si es fila o columna
  int dato; // Declaración de una variable que define almacena el dato extraído de la interfaz virtual. 
  
  virtual router_if v_if;
  
  
  //constructor para el monitor
  function new (string name, uvm_component parent);
    super.new(name,parent);
    conec_mon=new("conec_mon",this);// Creación de un puerto de análisis para el monitor.
  endfunction
  
  
  //fase de construccion
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual router_if)::get(this,"","v_if",v_if))begin
      `uvm_error("","uvm_config_db::get failed monitor")//si el get da negativo, o no se logra traer tira el mensaje 
    end
    
  endfunction
  
  task run_phase(uvm_phase phase);
    v_if.pop[num]=0;
    
    phase.raise_objection(this);//esto para ejecutar
    begin 
    
    forever begin
      @(posedge v_if.clk);
   //   @(posedge v_if.clk);
      if (v_if.pndng[num]==1) begin
      
        numero = v_if.data_out[num][31:0];
        modo=v_if.data_out[num][pkg_sz-17];
        dato=v_if.data_out[num][17:0];
        obj = mon_score::type_id::create("mon_score");// se crea el objeto en el monitor
        obj.pkg=numero;
        obj.num_mon=num;// guarda datos en la transacción obj
        obj.tiempo=$time;
        obj.modo=modo;
        obj.dato=dato;
        obj.target_r = v_if.data_out[num][31:28];
        obj.target_c = v_if.data_out[num][27:24];
        
        obj.source_r = v_if.data_out[num][22:19];
        obj.source_c = v_if.data_out[num][18:15];
        conec_mon.write(obj);// Se escribe el objeto en el puerto de análisis del monitor.
        v_if.pop[num]=1;
        
        @(posedge v_if.clk);
        @(posedge v_if.clk);
        v_if.pop[num]=0;
        end
      else v_if.pop[num]=0;
      if (count > 30000) begin
        break;
      end
      count++;
    end
    end
    
    phase.drop_objection(this);// para terminar
    
  endtask
    
endclass: monitor
