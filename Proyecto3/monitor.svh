class monitor extends uvm_monitor;
  
  `uvm_component_utils(monitor);
  
  uvm_analysis_port #(string) conec_mon;
  
  int num;
  int count = 0;
  
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
    v_if.pop[num]=0;
    
    phase.raise_objection(this);//esto para ejecutar
    begin 
    
 //   `uvm_warning("Se inicializó el monitor", get_type_name())
    forever begin
      v_if.pop[num]=0;
   //   @(posedge v_if.clk);

      if (v_if.pndng[num]==1) begin
        conec_mon.write ( $sformatf(v_if.data_out[num]));
     //     count = 0;
        
        $display("\n %0d paquete %0d monitor \n", v_if.data_out[num], num);
        v_if.pop[num]=1;
        
        @(posedge v_if.clk);


        
        end
      if (count > 150) begin
        break;
      end
      count++;
   @(posedge v_if.clk);
    end
    end
    
    phase.drop_objection(this);// para terminar
    
  endtask
    
endclass: monitor