// Declaración de una clase llamada "monitor" con parámetros
class monitor #(
  parameter drvrs = 4,
  parameter ROWS = 4,
  parameter COLUMNS = 4,
  parameter pckg_sz = 40,
  parameter fifo_depth = 4
);

  // Declaración de una interfaz virtual 
  virtual interfaz #(
    .ROWS(ROWS),
    .COLUMNS(COLUMNS),
    .pckg_sz(pckg_sz),
    .fifo_depth(fifo_depth)
  ) vif_m;

  
  int id;

  /////////////// mailbox ///////////////////////
  mntr_score_mbx mntr_score_mbx; // el segundo es el que está adentro del monitor

  // Instancia de la clase "
  mntr_score transaccion;

  // Constructor
  function new(int id);
    this.id = id;
    $display("Monitor [%g] ha inicializado en [%g]", id, $time);
  endfunction

  task run(); 
    this.vif_m.pop[this.id] = 0; 
    forever begin
      // Espera al flanco de subida del reloj.
      @(posedge this.vif_m.clk);

      // Comprueba si hay datos pendientes en la interfaz.
      if (this.vif_m.pndng[this.id] == 1) begin 
        this.vif_m.pop[this.id] = 1; 
        // Crea una nueva transacción y llena sus campos.
         this.transaccion = new();
        this.transaccion.d= this.vif_m.data_out[this.id];
        this.transaccion.dato = this.vif_m.data_out[this.id][14:0];
        this.transaccion.id = this.id;
        this.transaccion.tiempo = $time;
        this.transaccion.modo = this.vif_m.data_out[this.id][pckg_sz-17];
        
        // Muestra información sobre la transacción recibida.
        $display("[%g] El monitor [%g] recibe el dato [%b] ", $time, this.id, this.vif_m.data_out[id]);
        
        // Coloca la transacción en la mailbox 
        mntr_score_mbx.put(transaccion);
        
                     //asercion
        assert(this.vif_m.pop[this.id])begin
        end
        else begin
          $warning("EL MONITOR NO ESTA CAPTURANDO DATOS");
        end
        
        
        
        // Espera al siguiente flanco de subida del reloj.
        @(posedge this.vif_m.clk);
        this.vif_m.pop[this.id] = 0; 
      end
      else begin 
        // Si no hay datos pendientes, establece "pop" en 0.
        this.vif_m.pop[this.id] = 0;
      end
    end
  endtask 
  //task check_monitors_with_data();
    //    if (this.monitor_con_datos == 0) begin
      //      $warning("Aserción: Ningún monitor ha recibido datos en el tiempo %t", $time);
        //end
   // else begin
     // $display("Almenos un monitor recibio datos");
    //end
    //endtask
  
endclass
