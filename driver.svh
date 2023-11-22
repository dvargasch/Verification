class driver extends uvm_driver #(transaction);
  
  `uvm_component_utils(driver)
  transaction transaccion_tst = new;
  virtual router_if v_if; //interfaz virtual
  int hold;
  
  int num;
  int numero[16] = '{01,02,03,04,10,20,30,40,51,52,53,54,15,25,35,45};
  int Row[16] = '{0,0,0,0,1,2,3,4,5,5,5,5,1,2,3,4};
  int column[16] = '{1,2,3,4,0,0,0,0,1,2,3,4,5,5,5,5};
  int path [5][5];
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
    
    v_if.data_out_i_in[num] = 0;
    v_if.pndng_i_in[num] = 0;
    
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
   req.source_r = Row[num];
   req.source_c = column[num];
   v_if.data_out_i_in[num] = {req.jump,req.fila_,req.columna_, req.mode,req.source_r,req.source_c ,req.payload};
    v_if.pndng_i_in[num] = 1;
    @(posedge v_if.clk);
   wait (v_if.popin[num]);
  v_if.pndng_i_in[num] = 0;
  v_if.data_out_i_in[num] = 0;
  // wait (v_if.pndng_i_in[num] == 0);
   
   
   `uvm_info("MY_DRIVER_INFO", $sformatf("Driver [%0d] que se encuentra en %2d envia el dato %h hacia el dispositivo ubicado en R[%0d] C[%0d] con un retardo de [%0d] \n ", num ,  numero[num], {req.jump, req.fila_, req.columna_, req.mode, req.source_r, req.source_c, req.payload}, req.fila_, req.columna_, req.retardo), UVM_LOW);
   
   
   
   
   
  // `uvm_info("DRIVER", $sformatf("El driver #[%0d] envía desde la fuente [%0d][%0d] el mensaje: %0h hacia el destino [%0d][%0d] en modo [%d], con un valor de retardo [%0d]", id_driver, f_fila, f_columna, vif.data_out_i_in[id_driver][pckg_sz-26:0], s_item.d_fila, s_item.d_columna, s_item.modo, s_item.retardo), UVM_LOW);

   
 //  $display(" %0d driver %b mensaje R[%0d] C[%0d] itself %2d con un retardo de [%0d]", num , {req.jump,req.fila_,req.columna_, req.mode,req.source_r,req.source_c ,req.payload},req.fila_,req.columna_, numero[num], req.retardo);
   
   //golden_reference(req.mode,req.fila_,req.columna_);
   
   
   //if (count > 300)   phase.drop_objection(this);
   //count ++;   
   
   hold = 0;
   while(hold<transaccion_tst.retardo) begin
     @(posedge v_if.clk);
     hold = hold + 1;
   end
   
   
   seq_item_port.item_done();
   

   
 end
    //imprime mensaje de advertencia
    `uvm_warning("Se hizo el reinicio en driver!",get_type_name())
  
  endtask
  
    
  
 
  
  
endclass: driver