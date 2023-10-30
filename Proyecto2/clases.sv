class mapeo;
  int row;
  int column;
endclass

class agent_driver #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40); //Transacciones del agente al driver
  rand bit [pckg_sz-26:0] dato;
  randc bit [3:0] fila_;
  randc bit [3:0] columna_;
  rand bit mode;
  bit modo_selec;
  rand int source_;
  bit [3:0] destino;
  bit [7:0] Next_jump;
  int tiempo;
  int variabilidad;
  rand int retardo;
  int retardo_max;
  int source_aux;
  mapeo pos_driver[16];
  
  constraint modo_1 {mode == 1;};//modo 1
  constraint modo_0 {mode == 0;};//modo 0
  
  constraint valid_source {source_ >= 0; source_ < 2*ROWS+2*COLUMS;}; //fuente valida
  constraint itself {fila_ != pos_driver[source_].row; columna_ != pos_driver[source_].column;};//enviarse a el mismo
  constraint valid_address {fila_ <= ROWS+1; fila_ >= 0; columna_ <= COLUMS+1; columna_ >= 0;};//direccion valida
  constraint restricolumna_ { 
    if(fila_ == 0 | fila_ == ROWS+1) 
      columna_ <= COLUMS & columna_ > 0;
  };
  constraint restrifila_ {
    if(columna_ == 0 | columna_ == COLUMS+1) 
      fila_ <= ROWS & fila_ > 0;
  };
  constraint direccion_valida_drvs {
    if(fila_ != 0 & fila_ != ROWS+1)
      columna_ == 0 | columna_ == COLUMS+1;
  };
  constraint variabilidad_dato {dato inside {{(pckg_sz-17){1'b1}},{(pckg_sz-17){1'b0}}};};//dato aleatorio
  constraint static_source {source_ == source_aux;};//que no cambie la fuente
  constraint delay_random{retardo<=retardo_max;retardo>0;};//retardo aleatorio
  constraint min_delay{retardo == 0;};//retardo minimo
  
  function new (bit [pckg_sz-26:0] dat = 0, bit [3:0] fil = 0, bit [3:0] col = 0, bit mod = 0, int fnt = 0, bit [3:0] dst = 0, bit [7:0] nxt = 0, int tmp = 0, int rtd = 0, int rtd_max = 100, int fnt_aux = 0 );
        this.variabilidad = pckg_sz - 26;
   		this.dato = dat;
		this.fila_ = fil;
		this.columna_ = col;
		this.mode = mod;
		this.source_ = fnt;
		this.destino = dst;
		this.Next_jump = nxt;
		this.tiempo = tmp;
    	this.retardo = rtd;
    	this.retardo_max = rtd_max;
    	this.source_aux = fnt_aux;
  endfunction
endclass

class generador_agente; //Transacción del generador al agente
  int cant_transac;
  int data_modo;        
  int tipo_dato;
  int tipo_envio; 
  bit [3:0] row_;
  bit [3:0] column_;
  int destiny_random;//destino random
  int source_random;//fuente random
  int source_;
  int retardo;
  int random_mode;//modo random
  int modo_cf;//modo
endclass
  
  
class test_generador;//transacciones entre el test y el geenrador
  int tipo_prueba; // tipo de prueba que va ejecutarse
  int fuente;
  int prueba;
endclass 

class mntr_score #( parameter drvrs = 16, parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40);//transacciones entre el sc y el monitor
  
  bit [pckg_sz-1:0] dato;
  bit modo;
  int id;
  int tiempo;
  
endclass

class drv_chckr #( parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40);//transacciones entre el driver y el checker
  
  bit [pckg_sz-1:0] dato;
  bit modo;
  int id;
  int tiempo;
  logic [3:0] num_driver;
  bit [3:0] c_fila;
  bit [3:0] c_columna;
  logic [3:0] Destino;
  
endclass

class trans_checker_sb;
  int prueba;
  int drivers;
  int pckg_sz;
  int fifo_size;
endclass


class path_checker #(parameter pckg_sz=40);//transacciones del path
  int row_path;
  int column_path;
  bit [pckg_sz-1:0] data_out;
  int tiempo;
  
  
  function new(int row_path, int column_path, [pckg_sz-1:0] data_out);
    this.row_path = row_path;
    this.column_path = column_path;
    this.data_out = data_out;
    this.tiempo = $time;
  endfunction
endclass 

class rand_parameter;
  randc int pckg_sz_rand;
  rand int fifo_depth;
  rand int cant_transac_aleat;
  
  //constrains
  constraint size_pckg {pckg_sz_rand >= 25; pckg_sz_rand <= 50;}; 
  constraint size_fifo {fifo_depth >= 4; fifo_depth <= 25;}; 
  constraint size_cant_transac {cant_transac_aleat >= 1; cant_transac_aleat <= 10;}; 
endclass


//Mailboxes

typedef mailbox #(agent_driver) agent_driver_mbx; // Mailbox Agente - Driver
typedef mailbox #(generador_agente) generador_agente_mb; // Mailbox Generador - Agente
typedef mailbox #(test_generador) test_generador_mbx; //Mailbox Test - Generador
typedef mailbox #(trans_checker_sb) test_checker_sb_mb; //Mailbox test - Checker
typedef mailbox #(path_checker) detector_checker_mb; // Dectector - Checker 
typedef mailbox #(mntr_score) mntr_score_mbx;//monitor
typedef mailbox #(drv_chckr) drv_chckr_mbx;//driver


typedef enum {mode_1, mode_0, uno_a_todos, todos_a_uno, retardo_aleat, uno_a_todos_modo0, uno_a_todos_modo1,Variab, aleat, Normal, fila_modo_1, columna_modo_0, STATIC, retardo_aleatorio ,invalid_address, retardo_aleatorio_0, retardo_aleatorio_1, invalid_source, it_self} _nemonicos;