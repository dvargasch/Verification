class scoreboard #(parameter drvrs = 16, parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40);

  // Declaración de las "Mailboxes" 
  mntr_score_mbx mntr_score_mbx;
  drv_chckr_mbx drv_chckr_mbx;

  // Instancias de las transacciones 
  mntr_score mntr_score_transaccion;
  drv_chckr drv_chckr_transaccion_;

  // Declaración de arreglos dinámicos para transacciones recibidas y entregadas.
  mntr_score #(.drvrs(drvrs), .pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) arr_rec [int];
  drv_chckr #(.drvrs(drvrs), .pckg_sz(pckg_sz), .ROWS(ROWS), .COLUMS(COLUMS)) arr_ent [int];

  // Declaración de variables enteras cont, cont1, y cont2.
  int cont;
  int cont1;
  int cont2;

  // Constructor de la clase "scoreboard".
  function new();
  endfunction

  // Tarea para el scoreboard del monitor.
  task run_rec();
    forever begin
      this.mntr_score_mbx.get(this.mntr_score_transaccion);
      // Contador para la transaccion
      cont = cont + 1;

      // Almacena la información del monitor en el arreglo "arr_rec".
      arr_rec[this.mntr_score_transaccion.dato[pckg_sz-18:0]] = this.mntr_score_transaccion;

      
      $display("Ya se pasó la información del Monitor al Checker/Scoreboard");
    end
  endtask

  // Tarea para mostrar las transacciones del monitor.
  task mntr_score_run();
    foreach (arr_rec[i]) begin
      // Muestra información de las transacciones recibidas.
      $display("Se recibió del monitor [%g] el dato [%0b] con un tiempo de envío de [%g] y con modo[%g]",
               arr_rec[i].id, i, arr_rec[i].tiempo, arr_rec[i].modo);
    end
    // Muestra el número total de transacciones del monitor.
    $display("El monitor tiene [%g] transacciones", cont);
  endtask

  // Tarea para el scoreboard del driver.
  task run_ent();
    forever begin
      this.drv_chckr_mbx.get(this.drv_chckr_transaccion_);
      
      cont1 = cont1 + 1;

      // Almacena la información del driver en el arreglo
      arr_ent[this.drv_chckr_transaccion_.dato[pckg_sz-18:0]] = this.drv_chckr_transaccion_;

      $display("Ya se pasó la información del Driver al Checker/Scoreboard");
    end
  endtask

  // Tarea para mostrar las transacciones del driver.
  task drv_chckr_run();
    foreach (arr_ent[k]) begin
      // Muestra información de las transacciones entregadas.
      $display("Se recibió del driver [%g] el dato [%0b] con destino al [%g] con un modo de [%b]",
               arr_ent[k].num_driver, k, arr_ent[k].Destino, arr_ent[k].modo);
    end
    // Muestra el número total de transacciones del driver.
    $display("El driver tiene [%g] transacciones", cont1);
  endtask

  // Tarea para eliminar datos y mostrar los datos perdidos.
  task eliminar();
    foreach (arr_rec[i]) begin
      // Elimina elementos del arreglo "arr_ent".
      arr_ent.delete(i);
    end;
    foreach (arr_ent[i]) begin
      
      cont2 = cont2 + 1;
      $display("Este dato se perdió en el camino [%b]", i);
    end;
    // Muestra el número total de datos perdidos.
    $display("[%g] transacciones", cont2);
  endtask

endclass
