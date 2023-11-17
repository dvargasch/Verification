class scoreboard extends uvm_scoreboard;
  int c = 1;
  
  uvm_analysis_imp #(mon_score, scoreboard) conec;
  
  //uvm_analysis_imp #(int, scoreboard) conec2;
  
  //int internal_state;
  
  // Arreglo de Hash
  //uvm_tlm_collector #(string, int) score_arr;
  
  //uvm_queue #(int,scoreboard) score_arr[int];
  
  //mon_score score_arr[int];
  
  `uvm_component_utils(scoreboard)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    conec = new("conec", this);
    //conec2 =new ("conec2");
    //score_arr=new("score_arr", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_warning("Se inicializó el scoreboard", get_type_name())
    phase.drop_objection(this);
  endtask
  
  /*function void agregar_elemento(mon_score pkt);
    string clave;
    score_arr[pkt] = c;
  endfunction*/
  
  
  /*function write (string pkt);
   
    $display("[%0d] %s",c,pkt);
    c++;

  endfunction*/
  
  function void write(mon_score pkt);
    
    
    // score_arr[pkt.pkg] = pkt;
    
   // foreach (score_arr[i]) begin
    $display("Se recibió del monitor [%g] el dato [%0b] con un tiempo de envío de [%g] y con modo[%g]",pkt.num_mon, pkt.dato,pkt.tiempo, pkt.modo);
      
   // end
    c++;
  endfunction
  
  
  
endclass: scoreboard
