//Proyecto 3 - Verificacion Funcional de Circuitos Integrados /////////
//Profesor: Ronny Garcia Ramirez                              /////////
//Estudiantes: Rachell Morales - Daniela Vargas               /////////
///////////////////////////////////////////////////////////////////////

`include "Router_library.sv"
`include "router_if.svh"
`include "if.svh"

//package test;
import uvm_pkg::*;
`include "Sequence.sv"
`include "driver.svh"
`include "monitor.sv"
`include "scoreboard.sv"

///////////clase agente////////////

class agente extends uvm_agent; // Definición de la clase agente que hereda de uvm_agent
  
  `uvm_component_utils(agente) // Macro que proporciona funciones y utilidades básicas necesarias para un componente UVM
  
  driver driver_ag;// Creación de la instacia driver_ag de clase driver.
  monitor monitor_ag;// Creación de la instacia monitor_ag de clase monitor.
  
  uvm_sequencer#(transaction) sequencer; // Declaración de un objeto de tipo uvm_sequencer parametrizado con el tipo transaction llamado sequencer
  

  function new(string name, uvm_component parent); // constructor
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase); // Fase de construcción: se crean instancias de los componentes driver, monitor y sequencer
    driver_ag=driver ::type_id::create("driver",this);
    monitor_ag=monitor ::type_id::create("monitor",this);
    sequencer = uvm_sequencer#(transaction)::type_id::create("sequencer", this);
  endfunction
  
  function void connect_phase(uvm_phase phase); // Fase de conexión: se establece la conexión entre el puerto seq_item_port del driver y la exportación seq_item_export del sequencer
      driver_ag.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
  
  
endclass

//clase ambiente

class ambiente extends uvm_env;
  
  `uvm_component_utils(ambiente); // Macro que proporciona funciones y métodos necesarios para el funcionamiento de UVM.

  
  agente agente_env[15:0];// Declaración de un array de 16 instancias de la clase 'agente'.
  
  scoreboard scoreboard_env; // Creación de la instacia scoreboard_env de clase scoreboard.
  
  
  ////// Declaración de un puertos de análisis para transacciones de monitor y driver/////////
  
  uvm_analysis_port #(mon_score) cone_score; 
  uvm_analysis_port #(drv_score) cone_score2;
  
  //////Macro que declara la  implementación de puertos de análisis para transacciones de driver y monitor //////
  
  `uvm_analysis_imp_decl(pkt_drv)
  `uvm_analysis_imp_decl(pkt_mon)
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);//construir bloques
    for (int i=0; i<16 ; i++ ) begin
      automatic int a=i;
      agente_env[a] = agente::type_id::create($sformatf("agente%0d",a),this);  // Creación de 16 instancias de la clase 'agente'.
    end
    
    scoreboard_env = scoreboard::type_id::create("scoreboard",this);
    cone_score = new("ap", null);// Creación de un puerto de análisis para la conexion del monitor al scoreboard
    cone_score.connect(scoreboard_env.conec);
    cone_score.resolve_bindings();
    
    cone_score2 = new("at", null);// Creación de un puerto de análisis para la conexion del driver al scoreboard
    cone_score2.connect(scoreboard_env.conec2);
    cone_score2.resolve_bindings();
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);//conexión de puertos
    super.connect_phase(phase);
     for (int i=0; i<16 ; i++ ) begin
      automatic int a=i;
       agente_env[a].monitor_ag.conec_mon.connect(scoreboard_env.conec);// Conexión de los puertos de análisis del monitor al scoreboard.
       agente_env[a].driver_ag.conec_drv.connect(scoreboard_env.conec2); // Conexión de los puertos de análisis del driver al scoreboard.
       
       agente_env[a].driver_ag.num=a;// para que cada driver sepa que numero es
       agente_env[a].monitor_ag.num=a;// para que cada monitor sepa que numero es
     end
    
    
  endfunction
  
endclass


class test extends uvm_test;
  `uvm_component_utils(test)
  
  ambiente ambiente_tst;
  my_sequence	my_sequence_tst;
  my_sequence2	my_sequence2_tst;
  my_sequence3  my_sequence3_tst;
  my_sequence4  my_sequence4_tst;
  my_sequence5  my_sequence5_tst;
  my_sequence6  my_sequence6_tst;
  
  virtual router_if v_if;
  
  function new(string name = "test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    ambiente_tst = ambiente::type_id::create("ambiente",this);
    super.build_phase(phase);
  
          uvm_config_db#(virtual router_if)::set(this,"amb_inst.agent.*","router_if",v_if);
        //Genera la secuencia 
        my_sequence_tst = my_sequence::type_id::create("seq");
     my_sequence2_tst = my_sequence2::type_id::create("seq");
     my_sequence3_tst = my_sequence3::type_id::create("seq");
         my_sequence4_tst = my_sequence4::type_id::create("seq");
        my_sequence5_tst = my_sequence5::type_id::create("seq");
       my_sequence6_tst = my_sequence6::type_id::create("seq");
        
    endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    set_global_timeout(1ms/1ps);
    my_sequence2_tst.randomize() with {trans_num inside{[20:30]};};;
    my_sequence_tst.randomize() with {trans_num inside{[20:30]};};;
    my_sequence3_tst.randomize() with {trans_num inside{[20:30]};};;
    my_sequence4_tst.randomize() with {trans_num inside{[20:30]};};;
    my_sequence5_tst.randomize() with {trans_num inside{[20:30]};};;
    my_sequence6_tst.randomize() with {trans_num inside{[20:30]};};;
    
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
     `uvm_info("MY_INFO", "PRUEBA CON TRANSACCIONES EN MODO 1", UVM_LOW);
      
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
      `uvm_info("MY_INFO", "PRUEBA CON TRANSACCIONES EN MODO 0", UVM_LOW);
      
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
    `uvm_info("MY_INFO", "PRUEBA DE TRANSACCIONES CON RETARDO ALEATORIO", UVM_LOW);

      
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
     `uvm_info("MY_INFO", "PRUEBA QUE ENVÍA TRANSACCIONES DE UNA FUENTE A TODOS LOS DESTINOS", UVM_LOW);

      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;
   
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
      `uvm_info("MY_INFO", "PRUEBA QUE REALIZA TRANSACCIONES DE TODAS LAS FUENTES A UN MISMO DESTINO", UVM_LOW);

      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;
        a = $urandom_range (0, 15);
      my_sequence5_tst.start(ambiente_tst.agente_env[a].sequencer);
      end
        phase.drop_objection(this);
    endtask
endclass


class test_variabilidad extends test;
  `uvm_component_utils(test_variabilidad); // Register at the factory
  function new(string name = "test_variabilidad", uvm_component parent=null); // Builder
        super.new(name,parent);
   endfunction
  

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      my_sequence6_tst.randomize() with {trans_num inside{[20:30]};};
    endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
     `uvm_info("MY_INFO", "PRUEBA DE VARIABILIDAD MAXIMA", UVM_LOW);

      
      for (int i=0; i<15; i++)begin
      	automatic  int a=i;
        a = $urandom_range (0, 15);
      my_sequence6_tst.start(ambiente_tst.agente_env[a].sequencer);
      end
        phase.drop_objection(this);
    endtask
endclass

