`include "uvm_object.sv"

class monitor extends uvm_monitor;
  
  import uvm_pkg::*;
  
  `uvm_component_utils(monitor);
  
  uvm_analysis_port #(mon_score) conec_mon;
  
  mon_score obj;
  
  //uvm_analysis_port #(int) conec_mon2;
  
  int pkg_sz=40;
  int num;
  int count = 0;
  int numero;
  bit modo;
  int dato;
  //int numero = [01,02,03,04,10,20,30,40,51,52,53,54,15,25,35,45];
  virtual router_if v_if;
  
  function new (string name, uvm_component parent);
    super.new(name,parent);
    conec_mon=new("conec_mon",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual router_if)::get(this,"","v_if",v_if))begin
      `uvm_error("","uvm_config_db::get failed monitor")//si el get da negativo, o no se logra traer tira el mensaje 
    end
    //obj = mon_score::type_id::create("mon_score");
  endfunction
  
  task run_phase(uvm_phase phase);
    v_if.pop[num]=0;
    
    phase.raise_objection(this);//esto para ejecutar
    begin 
    
 //   `uvm_warning("Se inicializó el monitor", get_type_name())
    forever begin
      @(posedge v_if.clk);
   //   @(posedge v_if.clk);
      if (v_if.pndng[num]==1) begin
       // $sformat(numero,"%b",v_if.data_out[num][31:0]);
        numero = v_if.data_out[num][31:0];
        modo=v_if.data_out[num][pkg_sz-17];
        dato=v_if.data_out[num][17:0];
        obj = mon_score::type_id::create("mon_score");// se crea el objeto en el monitor
        obj.pkg=numero;
        obj.num_mon=num;
        obj.tiempo=$time;
        obj.modo=modo;
        obj.dato=dato;
        obj.target_r = v_if.data_out[num][31:28];
        obj.target_c = v_if.data_out[num][27:24];
        
        obj.source_r = v_if.data_out[num][22:19];
        obj.source_c = v_if.data_out[num][18:15];
        conec_mon.write (obj);
        //conec_mon.agregar_elemento(numero);
        //numero = "";
     //     count = 0;
        
        
        
        `uvm_info("MY_MONITOR_INFO", $sformatf("El monitor [%0d] recibio el dato %b \n",  num , numero), UVM_LOW);
        v_if.pop[num]=1;
        
        @(posedge v_if.clk);
        @(posedge v_if.clk);
        v_if.pop[num]=0;
        end
      else v_if.pop[num]=0;
      if (count > 750) begin
        break;
      end
      count++;
    end
    end
    
    phase.drop_objection(this);// para terminar
    
  endtask
    
endclass: monitor