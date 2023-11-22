`include "uvm_object.sv"

class driver extends uvm_driver #(transaction);
  
  `uvm_component_utils(driver)
  
  uvm_analysis_port #(drv_score) conec_drv;
  
  drv_score obj;
  
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
    conec_drv=new("conec_drv",this);
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
   if((req.fila_ == Row[num]) & (req.columna_ == column[num])) begin
     req.fila_ = column[num];
     req.columna_ = Row[num];
     v_if.data_out_i_in[num] = {req.jump,req.fila_,req.columna_, req.mode,req.source_r,req.source_c ,req.payload};
   end
    v_if.pndng_i_in[num] = 1;
    @(posedge v_if.clk);
   wait (v_if.popin[num]);
  v_if.pndng_i_in[num] = 0;
  v_if.data_out_i_in[num] = 0;
  // wait (v_if.pndng_i_in[num] == 0);
   
   
   
   $display(" %0d driver %b mensaje R[%0d] C[%0d] itself %2d con un retardo de [%0d]", num , {req.jump,req.fila_,req.columna_, req.mode,req.source_r,req.source_c ,req.payload},req.fila_,req.columna_, numero[num], req.retardo);
   
   /////////////////////////////////////////////
   
   
   obj = drv_score::type_id::create("drv_score");// se crea el objeto en el monitor
        obj.pkg={req.jump,req.fila_,req.columna_, req.mode,req.source_r,req.source_c ,req.payload};
        obj.tiempo=$time;
        obj.modo=req.mode;
        obj.dato=req.payload;
        obj.target_r = req.fila_;
        obj.target_c = req.columna_;
        
        obj.source_r = req.source_r;
        obj.source_c = req.source_c;
   		obj.num_drv = num;
        conec_drv.write(obj);
   
   
   
   ///////////////////////////////////////////
   
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
