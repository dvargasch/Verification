///////////////////////////////////////////////////////////////////////////////////////////////
//////AGENTE-GENERADOR: Encargado de generar las transacciones necesarias para las pruebas//////
///////////////////////////////////////////////////////////////////////////////////////////////

class agente #(parameter bits=1,  parameter terminales=4, parameter ancho_pal = 32);
  
  ///////////Mailbox//////////////
  
  // Mailbox que conecta al agente y al driver
  agente_driver_mailbox ag_dr_mx[terminales];
  
  // Mailbox que conecta al agente y al test
  // test_agente_mailbox te_ag_mx;
  
  // Genera los diferentes tipos de test que van a realizarse
  test_agent tipo;
  
  // Mailbox que conecta al agente y con checker/scoreboard
  ag_chckr_mbx #(.ancho_pal(ancho_pal)) ag_chckr_mbx;
  
  ///////Clases///////////
  
  // Clase de transacción para manejar las transacciones
  transaccion #(.ancho_pal(ancho_pal), .terminales(terminales)) transacciones;
  
 
  ag_chckr #(.ancho_pal(ancho_pal)) ag_chckr_transaccion; // Llamado a la clase del agente
  

  int num_transacciones_ag;  // Número de transacciones
  int retardo_max_ag; // Tiempo de retardo máximo
  int retardo_ag;  // Tiempo de retardo
  bit [3:0] Ter_out_ag;// Terminal que envía
  bit [7:0] Ter_in_ag;  // Terminal que recibe
  bit [terminales-13:0] info_ag;  // Bits restantes para la información
  
  // Constructor para inicializar algunas de las variables de la clase
  function new;
    num_transacciones_ag = 2;
    retardo_max_ag = 10;
  endfunction
  
  // Tarea para iniciar el agente
  task inicia();
    $display("El agente inicializó en: %g", $time);
    forever begin
      #1
      // Verificar si hay instrucciones en la cola
      if (tam.num() > 0); begin
        $display("El agente # %g recibe una instrucción", );
        
        // Obtener la instrucción de la cola
        tam.get(tipo);
        
        // Seleccionar la acción según el tipo de instrucción
        case (tipo)
          random_trans: begin 
            // Generar transacciones aleatorias y ponerlas en la Mailbox del driver
            for (int i = 0; i < num_trans_agent; i++) begin
              transacciones = new();
              transacciones.max_retardo = max_retardo_ag;
              transacciones.tipo = tipo;
              transacciones.randomize();
              transacciones.dato = {transacciones.Rx, transacciones.Tx, transacciones.informacion}; 
              transacciones.print("Agente: Transacción:");
              ag_dr_mx[transacciones.Tx].try_put(transacciones);
            end
          end
          
          broadcast: begin // broadcast
            // Enviar a todas las terminales
            for (int i = 0; i < num_transacciones_ag; i++) begin
              transacciones = new();
              transacciones.max_retardo_ag = max_retardo_ag;
              transacciones.tipo = tipo;
              transacciones.randomize();
              transacciones.Rx = {8{1'b1}};
              transacciones.dato = {transacciones.Rx, transacciones.Tx, transacciones.informacion}; 
              transacciones.print("Agente: Transacción:");
              adm[transacciones.Tx].try_put(transacciones);
              transacciones.Rx = 0;
              transacciones.print("Agente: Transacción:");
              adm[transacciones.Tx].try_put(transacciones);
            end
          end              
          
          trans_especifica: begin  // Esta instrucción genera una transacción específica
            transaccion = new;
            transaccion.tipo = tipo;
            transaccion.retardo = retardo_ag;
            transaccion.Tx = Ter_in_ag;
            transaccion.Rx = Ter_out_ag;
            transaccion.print("Agente: Transacción creada");
            ag_dr_mx[transaccion.Tx].try_put(transaccion);
          end
          
          trans_retar_min: begin // Transacciones con retardo mínimo
            for (int i = 0; i < drvrs; i++) begin
              transacciones = new;
              transacciones.max_retardo = max_retardo_ag;
              transacciones.tipo = tipo;
              transacciones.randomize();
              transacciones.retardo = 1;
              transaccion.dato = {transacciones.Rx, transacciones.Tx, transacciones.informacion};
              transacciones.print("Agente: Transacción:");
              adm[transacciones.Rx].try_put(transacciones);
            end
          end       
  
          trans_todos: begin // Cada terminal envía a todas
            for (int j = 0; j < drvrs; j++) begin
              for (int i = 0; i < drvrs; i++) begin 
                transacciones = new;
                transacciones.max_retardo = max_retardo_ag;
                transacciones.tipo = tipo;
                transacciones.randomize();
                transacciones.Rx = i;
                transaccion.Tx = j;
                transacciones.dato = {transacciones.Rx, transaccion.Tx, transaccion.informacion};
                
                // Evitar enviar a sí misma la terminal
                if (j != i) begin
                  transaccion.print("Agente: Transacción:");
                  agnt_drv_mbx[transaccion.term_envio].try_put(transaccion);
                end
              end
            end
          end           
        endcase
      end
    end
  endtask
endclass