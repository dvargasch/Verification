class monitor #(parameter rows = 4, parameter columns = 4, parameter fifo_depth = 4, parameter pckg_sz = 21);
  
  virtual interfaz #(.rows(rows), .columns(columns), .fifo_depth(fifo_depth), .pckg_sz(pckg_sz))  v_if;
  int id_mon; 
  bit [pckg_sz-1:0] queue_mon[$];              
                
  function new (int id);
    this.id_mon = id;
    $display("Monitor %g",id);
    
  endfunction
  
  
  
  task run();
    
    $display("Funcionando %g",this.id_mon);
    
    this.v_if.pop[this.id_mon] = 0;//Cuidadoooooooooooooooooooooooooooo
    
    forever begin
      
      @(posedge this.v_if.clk); //Luego pasarlo a la v.interfaz
      if (this.v_if.pndng[this.id_mon]==1) begin
        this.v_if.pop[this.id_mon]=1;
        this.queue_mon.push_back(this.v_if.data_out[this.id_mon]);
        $display("Monitor %d recibe este dato: %b", this.id_mon, this.v_if.data_out[this.id_mon]);   
         @(posedge this.v_if.clk); 
        this.v_if.pop[this.id_mon]=0;
      end
      else begin
        this.v_if.pop[this.id_mon]=0;   
      end
     end
    
  endtask
  
endclass