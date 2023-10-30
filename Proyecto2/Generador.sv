class Generador #(parameter drvrs = 4, parameter pckg_sz = 16);
  test_generador_mbx test_generador_mbx_g;//mailbox que conecta el test y el generador
  generador_agente_mb generador_agente_mb_g;//mailbox que conecta el generador y el agente
  test_generador test_generador_g;//transacciones entre el test y el generador
  generador_agente generador_agente_g;//transacciones entre el agente y el generador
  rand_parameter pkt;
  
  function new();//constructor
    this.generador_agente_g = new();
    this.test_generador_g = new();
    this.pkt = new();
  endfunction 
  
  task run ();
    forever begin
      pkt.size_cant_transac.constraint_mode(1);
      pkt.randomize();
      test_generador_mbx_g.get(test_generador_g); 
      $display("\n\nGenerador ha recibido la transaccion del TEST en [%g] \n",$time);    
         
      case (this.test_generador_g.tipo_prueba)
        mode_1:begin//configuracion para la prueba en modo 1
        this.generador_agente_g.cant_transac= 4;  
        this.generador_agente_g.tipo_dato = aleat;
        this.generador_agente_g.tipo_envio = fila_modo_1;
        this.generador_agente_g.source_random = 0;
        this.generador_agente_g.source_ = 1;
        this.generador_agente_g.destiny_random = 1;
        this.generador_agente_g.row_ = 0;
        this.generador_agente_g.column_ = 1;
        this.generador_agente_g.random_mode = 0;
        this.generador_agente_g.modo_cf = 1;
        generador_agente_mb_g.put(generador_agente_g);
      end

      mode_0:begin//configuracion para la prueba en modo 0
        this.generador_agente_g.cant_transac= 4; 
        this.generador_agente_g.tipo_dato = aleat;
        this.generador_agente_g.tipo_envio = columna_modo_0;
        this.generador_agente_g.source_random = 1;
        this.generador_agente_g.source_= 1;
        this.generador_agente_g.destiny_random = 1;
        this.generador_agente_g.row_ = 0;
        this.generador_agente_g.column_ = 1;
        this.generador_agente_g.random_mode = 0;
        this.generador_agente_g.modo_cf = 0;
        generador_agente_mb_g.put(generador_agente_g);
      end
      
      uno_a_todos:begin//configuracion para que vaya de una fuente a todos los dispositivos
        this.generador_agente_g.cant_transac = 4;
        this.generador_agente_g.tipo_dato = aleat;
        this.generador_agente_g.tipo_envio = STATIC;
        this.generador_agente_g.source_random = 0;
        this.generador_agente_g.source_ = 1;
        this.generador_agente_g.destiny_random = 1;
        this.generador_agente_g.row_ = 0;
        this.generador_agente_g.column_ = 1;
        generador_agente_mb_g.put(generador_agente_g);
      end
      
       todos_a_uno:begin//configuracion para que vaya de todas las fuentes a un detsino
        this.generador_agente_g.cant_transac = 4;
        this.generador_agente_g.tipo_dato = aleat;
        this.generador_agente_g.tipo_envio = Normal;
        this.generador_agente_g.source_random  = 1;
        this.generador_agente_g.source_ = 1;
        this.generador_agente_g.destiny_random = 0;
        this.generador_agente_g.row_ = 0;
        this.generador_agente_g.column_ = 1;
        generador_agente_mb_g.put(generador_agente_g);
      end

      retardo_aleat:begin//retardo aleatorio
        this.generador_agente_g.cant_transac= 4;
        this.generador_agente_g.tipo_dato = aleat;
        this.generador_agente_g.tipo_envio = retardo_aleatorio;
        this.generador_agente_g.source_random  = 1;
        this.generador_agente_g.source_ = 1;
        this.generador_agente_g.destiny_random = 1;
        this.generador_agente_g.row_ = 0;
        this.generador_agente_g.column_ = 1;
        this.generador_agente_g.random_mode = 0;
        this.generador_agente_g.modo_cf = 0;
        generador_agente_mb_g.put(generador_agente_g);
      end
        
        uno_a_todos_modo0:begin//retardo aleatorio y modo 0
          $display("\n Cantidad de transacciones = [%g]", pkt.cant_transac_aleat);
        this.generador_agente_g.cant_transac= pkt.cant_transac_aleat;
        this.generador_agente_g.tipo_dato = aleat;
        this.generador_agente_g.tipo_envio = retardo_aleatorio_0;
        this.generador_agente_g.source_random = 0;
        this.generador_agente_g.source_ = 1;
        this.generador_agente_g.destiny_random = 1;
        this.generador_agente_g.row_ = 0;
        this.generador_agente_g.column_ = 1;
        this.generador_agente_g.modo_cf = 0;
        generador_agente_mb_g.put(generador_agente_g);
      end
        
        uno_a_todos_modo1:begin //retardo aleatorio y modo 1
       //   $display("\n Cantidad de transacciones = [%g]", pkt.cant_transac_aleat);
      // this.generador_agente_g.cant_transac= pkt.cant_transac_aleat;
        this.generador_agente_g.cant_transac= 4;
        this.generador_agente_g.tipo_dato = aleat;
        this.generador_agente_g.tipo_envio = retardo_aleatorio_1;
        this.generador_agente_g.source_random = 0;
        this.generador_agente_g.source_ = 1;
        this.generador_agente_g.destiny_random = 1;
        this.generador_agente_g.row_ = 0;
        this.generador_agente_g.column_ = 1;
        this.generador_agente_g.modo_cf = 1;
        generador_agente_mb_g.put(generador_agente_g);
      end

      default: begin
        this.generador_agente_g.cant_transac = 30;
        generador_agente_mb_g.put(generador_agente_g);
      end 
      
	endcase
end
    
  endtask
  
endclass