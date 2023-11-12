class driver extends uvm_driver #(transaction);
  
  `uvm_component_utils(driver)
  
  virtual router_if v_if; //interfaz virtual
  
  int num;
//  int count = 0;
  
  //constructor para el driver
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //fase de construccion 
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual router_if)::get(this, "", "v_if", v_if)) begin
      `uvm_error("","uvm_config_db::get failed")
    end
  endfunction
  
  //fase de ejecucion
  task run_phase(uvm_phase phase);
    v_if.reset = 1;
    
    
    @(posedge v_if.clk);
    #1;
    v_if.reset = 0;
    
  //phase.raise_objection(this);  
    
 forever begin   
    
   seq_item_port.get_next_item(req);

 
    @(posedge v_if.clk);
    v_if.data_out_i_in[num] = 0;
    v_if.pndng_i_in[num] = 0;
    @(posedge v_if.clk);
    @(posedge v_if.clk);
   v_if.data_out_i_in[num] = {req.jump,req.fila_,req.columna_, req.mode, req.payload};
    v_if.pndng_i_in[num] = 1;
    @(posedge v_if.clk);
   wait (v_if.popin[num]);
//  v_if.pndng_i_in[num] = 0;
  // wait (v_if.pndng_i_in[num] == 0);
   
   
   
   
   $display("%0d driver %0d mensaje", num , {req.jump,req.fila_,req.columna_, req.mode, req.payload} );
   
   //if (count > 300)   phase.drop_objection(this);
   //count ++;   
   seq_item_port.item_done();
   

   
 end
    //imprime mensaje de advertencia
    `uvm_warning("Se hizo el reinicio en driver!",get_type_name())
  
  endtask
  
  
endclass: driver