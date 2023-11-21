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
  
 /*task run_phase (uvm_phase phase);
    
    phase.raise_objection(this);
    begin
      my_sequence trans;
      trans = my_sequence::type_id::create("trans");
      
      //my_sequence trans1;
      //trans1 = my_sequence::type_id::create("trans1);
      repeat(1) begin
       trans.start(sequencer);
       //trans1.start(sequencer);
        
      end
    end
    //  begin
  //    my_sequence2 trans2;
      //  trans2 = my_sequence2::type_id::create("trans2");
      
      //my_sequence trans1;
      //trans1 = my_sequence::type_id::create("trans1);
     // repeat(1) begin
       //trans2.start(sequencer);
       //trans1.start(sequencer);
        
      //end
 

   // end
    phase.drop_objection(this);
    
  endtask
 */
  
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
  my_sequence	my_sequence_tst;//para modo 0
  my_sequence2	my_sequence2_tst;//para modo 1
  my_sequence3  my_sequence3_tst;//para retardo aleatorio
  my_sequence4  my_sequence4_tst;//para prueba de todos a uno
  my_sequence5  my_sequence5_tst;//para prueba de uno a todos
  my_sequence6  my_sequence6_tst;//para variabilidad maxima
  
  virtual router_if v_if;
  
  function new(string name = "test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    ambiente_tst = ambiente::type_id::create("ambiente",this);
    super.build_phase(phase);//n
  
    //Verifica si se conecto correctamente al interface
    //if(!uvm_config_db#(virtual router_if)::get(this,"","router_if",v_if))
           // `uvm_fatal("Test","Could not get vif")
          uvm_config_db#(virtual router_if)::set(this,"amb_inst.agent.*","router_if",v_if);
        //Genera la secuencia 
        my_sequence_tst = my_sequence::type_id::create("seq");
     my_sequence2_tst = my_sequence2::type_id::create("seq");
     my_sequence3_tst = my_sequence3::type_id::create("seq");
         my_sequence4_tst = my_sequence4::type_id::create("seq");
        my_sequence5_tst = my_sequence5::type_id::create("seq");
       my_sequence6_tst = my_sequence6::type_id::create("seq");
        //seq.randomize() with {trans_num inside{[30:40]};};
    endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10;
    `uvm_warning("", "Inicio del Test!")
    
    for (int i=0; i<15; i++)begin
      automatic  int a=i;
      my_sequence2_tst.start(ambiente_tst.agente_env[a].sequencer);
      my_sequence_tst.start(ambiente_tst.agente_env[a].sequencer);
      my_sequence3_tst.start(ambiente_tst.agente_env[a].sequencer);
      my_sequence4_tst.start(ambiente_tst.agente_env[a].sequencer);
      my_sequence5_tst.start(ambiente_tst.agente_env[a].sequencer);
         my_sequence6_tst.start(ambiente_tst.agente_env[a].sequencer);
    end
    phase.drop_objection(this);
  endtask
endclass
 

class test_M1 extends test;
  `uvm_component_utils(test_M1); // Register at the factory
  function new(string name = "test_M1", uvm_component parent=null); // Builder
        super.new(name,parent);
   endfunction
  

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      my_sequence2_tst.randomize() with {trans_num inside{[20:30]};};
    endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_warning("","SE ESTA CORRIENDO LA PRUEBA EN LA QUE SE REALIZAN TRANSACCIONES CON MODO 1");
      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;   
        a = $urandom_range (0, 15);        
        my_sequence2_tst.start(ambiente_tst.agente_env[a].sequencer);
      end
      
     
        phase.drop_objection(this);
    endtask
endclass


class test_M0 extends test;
  `uvm_component_utils(test_M0); // Register at the factory
  function new(string name = "test_M0", uvm_component parent=null); // Builder
        super.new(name,parent);
   endfunction
  

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      my_sequence_tst.randomize() with {trans_num inside{[20:30]};};
    endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_warning("","SE ESTA CORRIENDO LA PRUEBA EN LA QUE SE REALIZAN TRANSACCIONES CON MODO 0");
      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;
        a = $urandom_range (0, 15); 
      my_sequence_tst.start(ambiente_tst.agente_env[a].sequencer);
      end
        phase.drop_objection(this);
    endtask
endclass

class test_retardo extends test;
  `uvm_component_utils(test_retardo); // Register at the factory
  function new(string name = "test_retardo", uvm_component parent=null); // Builder
        super.new(name,parent);
   endfunction
  

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      my_sequence3_tst.randomize() with {trans_num inside{[20:30]};};
    endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_warning("","SE ESTA CORRIENDO LA PRUEBA EN LA QUE SE REALIZAN TRANSACCIONES CON RETARDO ALEATORIO");
      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;
            a = $urandom_range (0, 15); 
      my_sequence3_tst.start(ambiente_tst.agente_env[a].sequencer);
      end
        phase.drop_objection(this);
    endtask
endclass


class test_uno_a_todos extends test;
  `uvm_component_utils(test_uno_a_todos); // Register at the factory
  function new(string name = "test_uno_a_todos", uvm_component parent=null); // Builder
        super.new(name,parent);
   endfunction
  

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      my_sequence4_tst.randomize() with {trans_num inside{[20:30]};};
    endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_warning("","SE ESTA CORRIENDO LA PRUEBA EN LA QUE SE REALIZAN TRANSACCIONES QUE SALEN DE UNA MISMA FUENTE");
      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;
   //        a = $urandom_range (0); 
               a = 0; 
      my_sequence4_tst.start(ambiente_tst.agente_env[a].sequencer);
      end
        phase.drop_objection(this);
    endtask
endclass

class test_todos_a_uno extends test;
  `uvm_component_utils(test_todos_a_uno); // Register at the factory
  function new(string name = "test_todos_a_uno", uvm_component parent=null); // Builder
        super.new(name,parent);
   endfunction
  

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      my_sequence5_tst.randomize() with {trans_num inside{[20:30]};};
    endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_warning("","SE ESTA CORRIENDO LA PRUEBA EN LA QUE SE REALIZAN TRANSACCIONES HACIA EL MISMO DESTINO");
      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;
        a = $urandom_range (0, 15);
      my_sequence5_tst.start(ambiente_tst.agente_env[a].sequencer);
      end
        phase.drop_objection(this);
    endtask
endclass


class test_max_variacion extends test;
  `uvm_component_utils(test_max_variacion); // Register at the factory
  function new(string name = "test_max_variacion", uvm_component parent=null); // Builder
        super.new(name,parent);
   endfunction
  

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      my_sequence6_tst.randomize() with {trans_num inside{[20:30]};};
    endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_warning("","SE ESTA CORRIENDO LA PRUEBA EN LA QUE SE REALIZAN TRANSACCIONES CON MAXIMA VARIABILIDAD");
      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;
        a = $urandom_range (0, 15);
      my_sequence6_tst.start(ambiente_tst.agente_env[a].sequencer);
      end
        phase.drop_objection(this);
    endtask
endclass

endpackage