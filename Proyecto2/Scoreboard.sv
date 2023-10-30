//`include "Clases.sv"

class scoreboard #( parameter drvrs = 16, parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40);
  
  ///////////////Mailboxes////////////////////
  
  mntr_score_mbx mntr_score_mbx;
  
  drv_chckr_mbx  drv_chckr_mbx;
 
 
  // Instancias de las transacciones
  mntr_score   mntr_score_transaccion;
  
  drv_chckr	 drv_chckr_transaccion_;
  
  
// Arreglos dinámicos para transacciones recibidas y entregadas
  
  //mntr_score #(.drvrs(drvrs),.pckg_sz (pckg_sz ),.ROWS(ROWS),.COLUMS(COLUMS)) recibida [$]; 
  
  mntr_score #(.drvrs(drvrs),.pckg_sz (pckg_sz ),.ROWS(ROWS),.COLUMS(COLUMS)) arr_rec [int]; 
 
  //drv_chckr	#(.drvrs(drvrs),.pckg_sz (pckg_sz ),.ROWS(ROWS),.COLUMS(COLUMS)) entregada[$];
  
  drv_chckr	#(.drvrs(drvrs),.pckg_sz (pckg_sz ),.ROWS(ROWS),.COLUMS(COLUMS)) arr_ent [int];
  
  
  int cont;
  int cont1;
  int cont2;
  
  
  function new();
    //this.recibida= {};
    //this.entregada= {};
  endfunction 
  
// Tarea para el scoreboard del monitor
  
  task run_rec(); 
    forever begin
      this.mntr_score_mbx.get(this.mntr_score_transaccion); // trae el la información del monitor al scoreboard
     // this.recibida.push_back(this.mntr_score_transaccion); // Agarra esa información  y la almacena en la cola
      
      cont=cont+1;
      
      arr_rec [this.mntr_score_transaccion.dato[pckg_sz-9:0]]=this.mntr_score_transaccion;
      
      $display(" Ya se pasó la información del Monitor al Checker/Scoreboard ");
      
     // $display(" Se recibió del monitor [%g] el dato [%b] con un tiempo de envío de [%g] y con modo[%g]",this.mntr_score_transaccion.id, this.mntr_score_transaccion.dato,this.mntr_score_transaccion.tiempo, this.mntr_score_transaccion.modo);
    end 
  endtask
  
 
  
  task mntr_score_run ();
    foreach (arr_rec[i]) begin
      $display("Se recibió del monitor [%g] el dato [%0b] con un tiempo de envío de [%g] y con modo[%g]",arr_rec[i].id,i,arr_rec[i].tiempo , arr_rec[i].modo);
    end
    $display("El monitor tiene [%g] transacciones",cont);
  endtask
  
  // Tarea para el scoreboard del agente 

task run_ent(); 
    forever begin
      this.drv_chckr_mbx.get(this.drv_chckr_transaccion_); // trae el la información del driver al scoreboard
      //this.entregada.push_back(this.drv_chckr_transaccion_); // Agarra esa información  y la almacena en la cola
      cont1=cont1+1;
      
      arr_ent [this.drv_chckr_transaccion_.dato[pckg_sz-9:0]]=this.drv_chckr_transaccion_;
      
      $display(" Ya se pasó la información del Driver al Checker/Scoreboard ");
      
      
      //$display(" Se recibió del driver [%g] el dato [%0b] con destino al [%g] con un modo de [%b]",this.drv_chckr_transaccion_.num_driver,this.drv_chckr_transaccion_.dato,this.drv_chckr_transaccion_.Destino, this.drv_chckr_transaccion_.modo);
    end 
  endtask
  
  task drv_chckr_run ();
        foreach (arr_ent[k]) begin
      $display("Se recibió del driver [%g] el dato [%0b] con destino al [%g] con un modo de [%b]",arr_ent[k].num_driver, k,arr_ent[k].Destino , arr_ent[k].modo);
        end
    $display("El driver tiene [%g] transacciones",cont1);
      endtask
  
  task eliminar();
    
    foreach (arr_rec[i]) begin
     	arr_ent.delete(i);
      end;
    
    foreach (arr_ent[i]) begin
      cont2=cont2+1;
      $display("Este dato se perdió en el camino [%b]",i);
      end;
    $display("[%g] transacciones",cont2);
  endtask
  
  
endclass
