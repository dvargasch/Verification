class scoreboard extends uvm_scoreboard;
  int c = 1;
  
  uvm_analysis_imp #(string, scoreboard) conec;
  string internal_state;
  
  `uvm_component_utils(scoreboard)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    conec=new("conec",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    
     phase.raise_objection(this);
    
    `uvm_warning("Se inicializó el scoreboard", get_type_name())
    
     phase.drop_objection(this);
    
  endtask
  
  function write (string pkt);
   
    $display("[%0d] %s",c,pkt);
    c++;

  endfunction
  
  
endclass:scoreboard
