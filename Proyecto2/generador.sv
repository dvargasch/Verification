class Generador #(parameter drvrs = 4, parameter pckg_sz = 16);
 
  test_generador_mbx test_gen_mb_g;
  gen_agent_mb gen_agent_mb_g;

  trans_test_gen trans_test_gen_g;
  trans_gen_agent trans_gen_agent_g;

  function new();
    this.trans_gen_agent_g = new();
    this.trans_test_gen_g = new();
    
  endfunction 

  task run ();
    forever begin
    test_gen_mb_g.get(trans_test_gen_g);
	$display("GENERADOR: Transaccion recivida de TEST recibida en %d",$time);    
    case (this.trans_test_gen_g.tipo_prueba)
      mode_1:begin
        this.trans_gen_agent_g.cant_transac= 30;  
        this.trans_gen_agent_g.tipo_dato = aleat;
        this.trans_gen_agent_g.tipo_envio = Normal;
        this.trans_gen_agent_g.fuente_aleat = 1; 
        this.trans_gen_agent_g.fuente = 1;
        gen_agent_mb_g.put(trans_gen_agent_g);  
      end

   
      
	endcase
end
    
    
    
  endtask
  
endclass
