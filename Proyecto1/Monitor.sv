class monitor #(parameter ancho_pal = 32,parameter bits=1, parameter terminales = 7)
  
  fifomonitor #(.ancho_pal(ancho_pal), .bits(bits), .terminales(terminales)) ff;
  trans_monitor #(.ancho_pal(ancho_pal)) transaccion_in, transaccion_out;
  comando_MNTR_CHCKR_mxb MNTR_CHCKR_mxb;
  
  int ident;
  
  function new(int id);
    this.ident = id;
    this.ff = new(id);
  endfunction

  task run();
    $display("[%g] Monitor # [%g] Inicia", $time, ident);

    forever begin
     transaccion_in = new;

      fork
        @(posedge ff.vif.clk) // Esperar al flanco de subida del reloj
        ff.pushf();
     	ff.update();
      join_none
 
      @(posedge ff.vif.clk);
      if (fifo.pndng == 1) begin
        transaccion_in.tiempo = $time;
        transaccion_in.ter_in = ident;
        @(posedge ff.vif.clk);
        transaccion_in.dato = ff.d_in;
        MNTR_CHCKR_mxb.put(transaccion_in);
        transaccion_in.print("Monitor: Transaccion recibida");
      end
  
      @(posedge ff.vif.clk);// Monitorear datos que salen
      transaccion_out = new;
  
      @(posedge ff.vif.clk);
      if (ff.pndng == 1) begin
        ff.popf();
        transaccion_out.tiempo = $time;
        transaccion_out.ter_out = ident;
        @(posedge fifo.vif.clk);
        transaccion_out.dato = ff.d_out;
        MNTR_CHCKR_mxb.put(transaccion_out);
        transaccion_out.print("Monitor: Transaccion enviada");
      end
      @(posedge ff.vif.clk);
    end
  endtask

endclass
