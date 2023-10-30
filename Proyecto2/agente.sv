class agente #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40, parameter fifo_depth = 4, parameter drvrs = 16);
  
  
  agent_driver #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) trans_agent_driver_a;//transacciones entre el agente y el driver
  generador_agente generador_agente_a;//transacciones entre el generador y el agente
  generador_agente_mb generador_agente_mb_a;//mailbox que conecta el agente con el generador
  agent_driver_mbx #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) agent_driver_mbx_a [drvrs];//mailbox que conecta el agente con el generador

  int transac_cant;//cantidad de transaccion

  mapeo mapeo_a[drvrs];//mapeo de los 16 dispositivos
  
  function new();
    this.trans_agent_driver_a = new();
    this.generador_agente_a = new();
    
    for(int i = 0; i < drvrs; i++) begin
      automatic int k = i;	
      this.agent_driver_mbx_a[k] = new();
    end
    
    for(int i = 0; i < drvrs; i++) begin
      automatic int k = i;	
      mapeo_a[k] = new();
    end
    
    for (int i = 0; i<COLUMS;i++)begin 
      mapeo_a[i].row = 0;              
      mapeo_a[i].column = i+1; 
    end 
    
    for (int i = 0; i<ROWS;i++)begin 
      mapeo_a[i+COLUMS].column = 0; 
      mapeo_a[i+COLUMS].row = i+1; 
    end 
    
    for (int i = 0; i<COLUMS;i++)begin 
      mapeo_a[i+ROWS*2].row = ROWS+1; 
      mapeo_a[i+ROWS*2].column = i+1; 
    end
    
    for (int i = 0; i<ROWS;i++)begin 
      mapeo_a[i+COLUMS*3].column = COLUMS+1; 
      mapeo_a[i+COLUMS*3].row = i+1; 
    end         
    
    $display("\n \n///////////////////DISTRIBUCION DE LOS DISPOSITIVOS///////////////////\n \n");
    foreach (mapeo_a[i]) begin
      $display("Device [%g] fila = %0d columna =%0d",i,mapeo_a[i].row,mapeo_a[i].column);
    end
    
    $display("\n \nINICIALIZACION DEL AGENTE............\n \n ");
  endfunction
  
  task run();
    forever begin
      this.generador_agente_mb_a.get(this.generador_agente_a);
      this.transac_cant = this.generador_agente_a.cant_transac;
      
      for (int i = 0; i < this.transac_cant; i++) begin
        this.trans_agent_driver_a = new();
        this.trans_agent_driver_a.pos_driver = this.mapeo_a;
        
        case (this.generador_agente_a.tipo_dato)
          Variab:begin
            trans_agent_driver_a.variabilidad_dato.constraint_mode(1);
          end
          
          aleat:begin
            trans_agent_driver_a.variabilidad_dato.constraint_mode(0);
          end
          
          default: begin
            trans_agent_driver_a.variabilidad_dato.constraint_mode(0);
          end
        endcase
        
        case (this.generador_agente_a.tipo_envio)
          Normal:begin
            trans_agent_driver_a.modo_0.constraint_mode(0); //para que no tenga un modo definido
            trans_agent_driver_a.modo_1.constraint_mode(0); //para que no tenga un modo definido
            trans_agent_driver_a.static_source.constraint_mode(0);//para que cambie la fuente
            trans_agent_driver_a.delay_random.constraint_mode(0);//para que no se aleatorice
            trans_agent_driver_a.itself.constraint_mode(1); //para que no se mande a si mismo
            trans_agent_driver_a.min_delay.constraint_mode(1);//para que el retardo
            trans_agent_driver_a.valid_source.constraint_mode(1); //la fuente debe existir
            trans_agent_driver_a.valid_address.constraint_mode(1);//direccion valida
          end
                    
          fila_modo_1:begin
            trans_agent_driver_a.modo_0.constraint_mode(0); //para que no empiece en columnas
            trans_agent_driver_a.static_source.constraint_mode(0);//para que cambie la fuente
            trans_agent_driver_a.delay_random.constraint_mode(0);//para que no se aleatorice
            trans_agent_driver_a.itself.constraint_mode(1); //para que no se mande a si mismo
            trans_agent_driver_a.min_delay.constraint_mode(1);//para que el retardo
            trans_agent_driver_a.valid_source.constraint_mode(1); //la fuente debe existir
            trans_agent_driver_a.valid_address.constraint_mode(1);//direccion valida
            trans_agent_driver_a.modo_1.constraint_mode(1); //para que empiece en filas

          end
          
          columna_modo_0:begin
            trans_agent_driver_a.modo_1.constraint_mode(0); //para que empiece en columnas
            trans_agent_driver_a.static_source.constraint_mode(0);//para que cambie la fuente
            trans_agent_driver_a.delay_random.constraint_mode(0);//para que no se aleatorice
            trans_agent_driver_a.itself.constraint_mode(1); //para que no se mande a si mismo
            trans_agent_driver_a.min_delay.constraint_mode(1);//para que el retardo
            trans_agent_driver_a.valid_source.constraint_mode(1); //la fuente debe existir
            trans_agent_driver_a.valid_address.constraint_mode(1);//direccion valida
            trans_agent_driver_a.modo_0.constraint_mode(1); //para que no empiece en filas
          end
          
          STATIC:begin
            trans_agent_driver_a.modo_0.constraint_mode(0); //para que no tenga un modo definido
            trans_agent_driver_a.modo_1.constraint_mode(0); //para que no tenga un modo definido
			trans_agent_driver_a.delay_random.constraint_mode(0);//para que no se aleatorice
            trans_agent_driver_a.itself.constraint_mode(1); //para que no se mande a si mismo
            trans_agent_driver_a.min_delay.constraint_mode(1);//para que el retardo
            trans_agent_driver_a.valid_source.constraint_mode(1); //la fuente debe existir
            trans_agent_driver_a.valid_address.constraint_mode(1);//direccion valida
            trans_agent_driver_a.static_source.constraint_mode(1);//para que no cambie la fuente
          end
          
          retardo_aleatorio:begin
            trans_agent_driver_a.modo_0.constraint_mode(0); //para que no tenga un modo definido
            trans_agent_driver_a.modo_1.constraint_mode(0); //para que no tenga un modo definido
            trans_agent_driver_a.itself.constraint_mode(0); //para que no se mande a si mismo
            trans_agent_driver_a.min_delay.constraint_mode(0);//para que el retardo
            trans_agent_driver_a.delay_random.constraint_mode(1);//para que no se aleatorice
            trans_agent_driver_a.valid_source.constraint_mode(1); //la fuente debe existir
            trans_agent_driver_a.valid_address.constraint_mode(1);//direccion valida
            trans_agent_driver_a.static_source.constraint_mode(1);//para que no cambie la fuente
          end
          
          
            retardo_aleatorio_0:begin
            trans_agent_driver_a.modo_0.constraint_mode(1); //para que no tenga un modo definido
            trans_agent_driver_a.modo_1.constraint_mode(0); //para que no tenga un modo definido
            trans_agent_driver_a.itself.constraint_mode(0); //para que no se mande a si mismo
            trans_agent_driver_a.min_delay.constraint_mode(0);//para que el retardo
            trans_agent_driver_a.delay_random.constraint_mode(1);//para que no se aleatorice
            trans_agent_driver_a.valid_source.constraint_mode(1); //la fuente debe existir
            trans_agent_driver_a.valid_address.constraint_mode(1);//direccion valida
            trans_agent_driver_a.static_source.constraint_mode(1);//para que no cambie la fuente
          end
          
            retardo_aleatorio_1:begin
              trans_agent_driver_a.modo_0.constraint_mode(0); //para que no tenga un modo definido
              trans_agent_driver_a.modo_1.constraint_mode(1); //para que no tenga un modo definido
            trans_agent_driver_a.itself.constraint_mode(0); //para que no se mande a si mismo
            trans_agent_driver_a.min_delay.constraint_mode(0);//para que el retardo
            trans_agent_driver_a.delay_random.constraint_mode(1);//para que no se aleatorice
            trans_agent_driver_a.valid_source.constraint_mode(1); //la fuente debe existir
            trans_agent_driver_a.valid_address.constraint_mode(1);//direccion valida
            trans_agent_driver_a.static_source.constraint_mode(1);//para que no cambie la fuente
          end
          
          invalid_address:begin
            trans_agent_driver_a.valid_source.constraint_mode(1);//existe la fuente
            trans_agent_driver_a.valid_address.constraint_mode(0);//no existe la direccion
          end
          
          invalid_address:begin
            trans_agent_driver_a.valid_source.constraint_mode(0);//no existe la fuente
            trans_agent_driver_a.valid_address.constraint_mode(1);// existe la direccion
          end
          
          it_self: begin
            trans_agent_driver_a.valid_source.constraint_mode(1);// existe la fuente
            trans_agent_driver_a.valid_address.constraint_mode(1);// existe la direccion
          end
        endcase
        
        if(this.generador_agente_a.random_mode == 0) trans_agent_driver_a.mode = generador_agente_a.modo_cf;
        this.trans_agent_driver_a.randomize(); 
        if(this.generador_agente_a.source_random==0) trans_agent_driver_a.source_aux = generador_agente_a.source_;
        if(this.generador_agente_a.destiny_random==0) begin
          trans_agent_driver_a.fila_ = generador_agente_a.row_;
          trans_agent_driver_a.columna_ = generador_agente_a.column_;
        end
        this.trans_agent_driver_a.tiempo = $time;
        this.agent_driver_mbx_a[this.trans_agent_driver_a.source_].put(this.trans_agent_driver_a);
        #1;
      end
    end
  endtask
endclass