class monitor #(parameter drvrs = 4, parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40, parameter fifo_depth = 4);
  
  
  virtual interfaz #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz), .fifo_depth(fifo_depth)) vif_m;
  bit [pckg_sz-1:0] almacena[$]; 
    int id;
  
  ////////////Mailbox/////////////////
    
  mntr_score_mbx mntr_score_mbx; // el segundo es el que está adentro del monitor
  
  mntr_score transaccion;
  

  function new(int id);
        this.almacena = {}; 
        this.id = id;
    $display("[%g] Funcionando Monitor [%g]", $time, id);
    endfunction

    task run(); 
      this.vif_m.pop[this.id] = 0; 
        forever begin
            @(posedge this.vif_m.clk);
            if (this.vif_m.pndng[this.id] == 1) begin 
              this.vif_m.pop[this.id] = 1; 
              this.transaccion=new();
              this.transaccion.dato= this.vif_m.data_out[this.id];
              this.transaccion.id= this.id;
              this.transaccion.tiempo= $time;
              this.transaccion.modo= this.vif_m.data_out[this.id][pckg_sz-17];
              //this.almacena.push_back(this.vif_m.data_out[this.id]); 
              $display("[%g] El monitor %d tiene el dato %b", $time, this.id, this.vif_m.data_out[id]);
              
                //foreach (almacena[i]) begin
            
                  mntr_score_mbx.put(transaccion);
   		      
                //end
            
              
                @(posedge this.vif_m.clk);
                    this.vif_m.pop[this.id] = 0; 
                end
          
            else begin 
              this.vif_m.pop[this.id] = 0;
            end
        end
    endtask 
endclass

