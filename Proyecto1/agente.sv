///////////////////////////////////////////////////////////////////////////////////////////////
//////AGENTE-GENERADOR:Encargado de generar las transacciones necesarias para las pruebas//////
///////////////////////////////////////////////////////////////////////////////////////////////

class agente #(parameter bits=1,  parameter terminales=4, parameter ancho_pal = 32);
  
  ///////////Mailbox//////////////
  
  agente_driver_mailbox ag_dr_mx [terminales];//mailbox que conecta al agente y al driver
 // test_agente_mailbox te_ag_mx //mailbox que conecta al agente y al test
  
  test_agent tipo; // Genera los diferentes tipos de test que van a realizarse
  
  ag_chckr_mbx #(.ancho_pal(ancho_pal)) ag_chckr_mbx;
  
  ///////Clases///////////
  
  transaccion #(.ancho_pal(ancho_pal), .terminales(terminales)) transacciones;
  
  ag_chckr	#(.ancho_pal(ancho_pal)) ag_chckr_transaccion;
  
  int num_transacciones_ag;//numero de transacciones
  int retardo_max_ag;//tiempo de retardo maximo
  int retardo_ag;//tiempo de retardo
  bit [3:0] Ter_out_ag;//terminal que envia
  bit [7:0] Ter_in_ag;//terminal que recibe
  bit [terminales-13:0] info_ag;//bits restantes para la informacion
  
  function new; //para inicializar algunas de las variables de la clase
    num_transacciones = 2;
    retardo_max_ag = 10;
  endfunction
  
  task inicia();
    $display("El agente inicializo en: %g", $time);
    forever begin
      #1
      if (tam.num()>0);begin
        $display("El agente # %g  recibe una instruccion", );
        tam.get(tipo);
        case(tipo)
          random_trans: begin 
            for(int i=0; i<num_trans_agent; i++)begin
              transacciones = new();
              transacciones.max_retardo = max_retardo_ag;
              transacciones.tipo = tipo;
              transacciones.randomize();
              transacciones.dato = {transacciones.Rx, transacciones.Tx,
                                    transacciones.informacion}; 
              transacciones.print("Agente: Transaccion:");
              ag_dr_mx[transacciones.Tx].try_put(transacciones);
            end
          end
          
          broadcast:begin //broadcast
            for(int i=0; i<num_transacciones_ag;i++)begin
              transacciones = new();
              transacciones.max_retardo_ag = max_retardo_ag;
              transacciones.tipo = tipo;
              transacciones.randomize();
              transacciones.Rx = {8{1'b1}};
              transacciones.dato = {transacciones.Rx, transacciones.Tx,
                                    transacciones.informacion}; 
              transacciones.print("Agente: Transaccion:");
              adm[transacciones.Tx].try_put(transacciones);
              transacciones.Rx = 0;
              transacciones.print("Agente: Transacccion:");
              adm[transacciones.Tx].try_put(transacciones);
            end
          end              
          
           trans_especifica: begin  // Esta instrucción genera una transacción específica
            transaccion =new;
            transaccion.tipo = tipo;
            transaccion.retardo = retardo_ag;
            transaccion.Tx=Ter_in_ag;
			transaccion.Rx=Ter_out_ag;
            transaccion.print("Agente: transacción creada");
            ag_dr_mx[transaccion.Tx].try_put(transaccion);
          end
          
          trans_retar_min:begin //Transacciones con retardo minimo
            for(int i=0; i<drvrs; i++)begin
              transacciones = new;
              transacciones.max_retardo=max_retardo_ag;
              transacciones.tipo=tipo;
              transacciones.randomize();
              transacciones.retardo=1;
              transaccion.dato={transacciones.Rx, transacciones.Tx, transacciones.informacion};
              transacciones.print("Agente: transaccion:");
              adm[transacciones.Rx].try_put(transacciones);
            end
          end       
  
           trans_todos:begin //cada terminmal envia a todos
            for(int j=0; j<drvrs;j++)begin // j se mantiene consntate primero e i es variable
              for(int i=0; i<drvrs; i++)begin 
                transacciones = new;
                transacciones.max_retardo= max_retardo_ag;
                transacciones.tipo=tipo;
                transacciones.randomize();
                transacciones.Rx=i;
                transaccion.Tx=j;
                transacciones.dato={transacciones.Rx, transaccion.Tx, transaccion.informacion};
                
                if(j!=i)begin //para que no se envie a si misma la terminal
                  transaccion.print("Agente: transaccion:");
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
