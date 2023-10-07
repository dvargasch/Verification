////////////////////////////////////////////////////
////////////////////////////////////////////////////
//////////Transacciones posibles en el bus//////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////

typedef enum {cant_transac, cant_disp, rst_test, alea_ret, transac_error, aleat_brdst, alt_transac, simul_transac, random_rst} instruct; 

class trans #(parameter ancho_pal = 32, parameter terminales=5);
  rand bit [ancho_pal-13:0] informacion; //20 bits de informacion
  rand int retardo; // tiempo de retardo en ciclos de reloj que se debe esperar antes de ejecutar la transacción
  rand bit[ancho_pal-1:0] dato; // este es el dato de la transacción
  int tiempo; //Representa el tiempo  de la simulación de envio 
  instruct tipo; // lectura, escritura, broadcast, reset
  int max_retardo;//retardo maximo
  bit [3:0] Term_out;//terminal de salida
  bit [7:0] Term_in;//terminal de entrada

 
  //constraint
  constraint const_retardo {retardo <= max_retardo; retardo>0;}
  constraint const_Rx {Term_in < terminales; Term_in >= 0; Term_in != Term_out;}
  constraint const_Tx {Term_out < terminales; Term_out >= 0;}
  
  //constructor
  function new(bit [ancho_pal-19:0] info=0, int ret =0,bit[ancho_pal-1:0] dto=0,int tmp = 0, instruct tpo = cant_transac, int mx_rtrd = 20, tx = 0, rx = 0);
    this.retardo = ret;
    this.dato = dto;
    this.tiempo = tmp;
    this.tipo = tpo;
    this.max_retardo = mx_rtrd;
    this.Term_out = tx;
    this.Term_in = rx;
    this.informacion = info;
  endfunction
    
  
  //funcion para mostrar los datos
  function void print(string tag = "");
    $display("[%g] %s Tiempo de envio=%g Tipo=%s Retardo=%g Transmisor=0x%h dato=0x%h Receptor=0x%h",
             $time,
             tag,
             tiempo,
             this.tipo,
             this.retardo,
             this.Term_out,
             this.dato,
             this.Term_in);
  endfunction

endclass

//conexion con el bus -DUT-
interface interfaz #(parameter bits = 1,parameter terminales = 4, parameter ancho_pal = 16, parameter broadcast = {8{1'b1}})//parametros
  
 (
  input bit clk
);
  logic rst;
  logic pndng[bits-1:0][terminales-1:0];
  logic push[bits-1:0][terminales-1:0];
  logic pop[bits-1:0][terminales-1:0];
  logic [ancho_pal-1:0] D_pop[bits-1:0][terminales-1:0];
  logic [ancho_pal-1:0] D_push[bits-1:0][terminales-1:0];
endinterface

class t_monitor #(parameter ancho_pal=32);
  bit [ancho_pal-1:0] dato;//dato recibido
  int tiempo;//tiempo para enviar
  int ter_in;//terminal que recibe
  int ter_out;//terminal que envia
  
  //contructor
  function new(bit [ancho_pal-1:0] dat=0, int tmp=0, int term_in=0, int term_out);
    this.dato=dt;
    this.tiempo=tmp;
    this.ter_in=term_in;
    this.ter_out=term_out;
  endfunction
  
  //imprimir parametros
  function void print (string tag="");
    $display("[%g] %s Dato=%h Tiempo=%g Terminal que recibe=%g Terminal que envia=%g", 
      		$time,
		tag, 
		this.dato, 
		this.tiempo, 
		this.ter_in);
	endfunction
endclass

//mailboxes de tipo definido intruct para comunicar las interfaces 

//typedef mailbox #(mntr_chckr) mntr_chckr_mbx;//mailbox de monitor a cheker
//typedef mailbox #(ag_chckr) ag_chckr_mbx;// mailbox de agente a checker
//typedef mailbox #(instruct) comando_instrucciones_mbx;
//typedef mailbox #(mntr_chckr #(.pckg_sz(pckg_sz))) cmd_mntr_chckr_mbx;


//Interface entre driver/monitor y DUT
//interface interfaz #(parameter ancho_pal=32, parameter bits=1, parameter n_term=5)(input bit clk);
//  logic rst[n_term];
//  logic pndng[bits-1:0][n_term-1:0];
 // logic pop[bits-1:0][n_term-1:0];
 // logic push[bits-1:0][n_term-1:0];
//  logic [width-1:0] D_push[bits-1:0][n_term-1:0];
//  logic [width-1:0] D_pop[bits-1:0][n_term-1:0];



