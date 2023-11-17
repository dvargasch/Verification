`include "Router_library.sv"
`include "router_if.svh"
`include "if.svh"

package test;
import uvm_pkg::*;
`include "Sequence.sv"
`include "driver.svh"
`include "monitor.sv"
`include "scoreboard.sv"



//clase agente
class agente extends uvm_agent;
  `uvm_component_utils(agente)
  
  driver driver_ag;
  monitor monitor_ag;
  
  uvm_sequencer#(transaction) sequencer;
  

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    driver_ag=driver ::type_id::create("driver",this);
    monitor_ag=monitor ::type_id::create("monitor",this);
    sequencer = uvm_sequencer#(transaction)::type_id::create("sequencer", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
      driver_ag.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
  
 task run_phase (uvm_phase phase);
    
    phase.raise_objection(this);
    begin
      my_sequence trans;
      trans = my_sequence::type_id::create("trans");
      
      repeat(1) begin
       trans.start(sequencer);
        
      end
 

    end
    phase.drop_objection(this);
    
  endtask
  
endclass

//clase ambiente

class ambiente extends uvm_env;
  
  `uvm_component_utils(ambiente);
  
  agente agente_env[15:0];
  
  scoreboard scoreboard_env;
  
  uvm_analysis_port #(mon_score) cone_score;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);//construir bloques
    for (int i=0; i<16 ; i++ ) begin
      automatic int a=i;
      agente_env[a] = agente::type_id::create($sformatf("agente%0d",a),this);  
    end
    
    scoreboard_env = scoreboard::type_id::create("scoreboard",this);
    cone_score = new("ap", null);// para la conexion del monitor scoreboard
    cone_score.connect(scoreboard_env.conec);
    cone_score.resolve_bindings();
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);//construcción de los puertos de análisis
    super.connect_phase(phase);
     for (int i=0; i<16 ; i++ ) begin
      automatic int a=i;
       agente_env[a].monitor_ag.conec_mon.connect(scoreboard_env.conec);
       agente_env[a].driver_ag.num=a;// para que cada driver sepa que numero es
       agente_env[a].monitor_ag.num=a;// para que cada monitor sepa que numero es
     end
    
    
  endfunction
  
endclass


class test extends uvm_test;
  `uvm_component_utils(test)
  
  ambiente ambiente_tst;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    ambiente_tst = ambiente::type_id::create("ambiente",this);
  endfunction
  
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10;
    `uvm_warning("", "Inicio del Test!")
    phase.drop_objection(this);
  endtask
  
  
endclass


endpackage