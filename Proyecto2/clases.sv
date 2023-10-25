class Mapeo_colum_fila;
  int colum;
  int fila;
endclass

class trans_agent_driver #(parameter drvrs = 16, parameter rows = 4, parameter columns = 4, parameter pckg_sz = 40); //Transacciones del agente al driver
  rand bit [pckg_sz-18:0] dato;
  randc bit [3:0] c_fila;
  randc bit [3:0] c_columna;
  rand bit modo;
  rand int fuente;
  bit [7:0] Next_jump;
  int tiempo;
  int variabilidad;
  int fuente_aux;
  Mapeo_colum_fila pos_driver[drvrs];
  
  //Fuente
  constraint Existe_fuente {fuente >= 0; fuente < drvrs;}; 
  //constraint send_self {c_fila != pos_driver[fuente].fila; c_columna != pos_driver[fuente].colum}
  //Dirección
  constraint Existe_direccion {c_fila <= rows+1; c_fila >= 0; c_columna <= columns+1; c_columna >= 0;};
  constraint restric_columna {
    if(c_fila == 0 | c_fila == rows+1) 
      c_columna <= columns & c_columna > 0;
  };
  constraint restric_fila {
    if(c_columna == 0 | c_columna == columns+1) 
      c_fila <= rows & c_fila > 0;
  };
  constraint direccion_valida_drvs {
    if(c_fila != 0 & c_fila != rows+1)
      c_columna == 0 | c_columna == columns+1;
  };
  //Datos
  constraint variabilidad_dato {dato inside {{(pckg_sz-17){1'b1}},{(pckg_sz-17){1'b0}}};};// Variabilidad maxima
  
  function new ();
  variabilidad = pckg_sz - 18;
  endfunction
endclass

class trans_gen_agent; //Transacción del generador al agente
  int cant_transac;
  int data_modo;        
  int tipo_dato; // Aleatorio o con variabilidad
  int tipo_envio; // A quien envia y como
  bit [3:0] fila;
  bit [3:0] columna;
  int fuente_aleat;
  int fuente;
  int retardo;
endclass


class trans_test_gen;
    int tipo_prueba; // Variable que indica el tipo de prueba que va ejecutarse
  endclass 

class mntr_score #( parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40);
  
  bit [pckg_sz-1:0] dato;
  bit modo;
  int id;
  int tiempo;
  
endclass

///////////////////
////Mailboxes//////
///////////////////

typedef mailbox #(trans_agent_driver) agent_driver_mb; // Mailbox Agente - Driver
typedef mailbox #(trans_gen_agent) gen_agent_mb; // Mailbox Generador - Agente
typedef mailbox #(trans_test_gen) test_generador_mbx;

typedef mailbox #(mntr_score) mntr_score_mbx;//monitor

typedef enum {Variab, aleat} _nemo_ag_dato;
typedef enum {Normal, Direccion_invalida, Fuente_invalida, send_self} _nemo_ag_modo;
typedef enum {mode_1, mode_0, todos_a_uno, retardo_aleat, fifo_depth_aleat} _nemo_gen_modo;
