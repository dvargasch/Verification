class monitor extends uvm_monitor;
  
  `uvm_component_utils(monitor);
  
  uvm_analysis_port #(string) conec_mon;
  
  
  virtual router_if v_if;
  
  function new (string name, uvm_component parent);
    super.new(name,parent);
    conec_mon=new("conec_mon",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual router_if)::get(this,"","v_if",v_if))begin
      `uvm_error("","uvm_config_db::get failed monitor")//si el get da negativo, o no se logra traer tira el mensaje 
    end
  endfunction
  
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);//esto para ejecutar
    
    `uvm_warning("Se inicializó el monitor", get_type_name())
    conec_mon.write("hola");
    
    phase.drop_objection(this);// para terminar
    
  endtask
    
endclass: monitor
