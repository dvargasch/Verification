class agnt_drvr #(parameter pack_size = 20, parameter rows = 2, parameter columns = 2);
  rand bit [pack_size-18:0] data;
  randc bit [3:0] row_num;
  randc bit [3:0] column_num;
  rand bit mode;
  rand int source;
  bit [7:0] Nxt_jump;
  int time_;
  int variability;
  int fix_source;
  
  constraint pos_source_addrs {source >= 0;};  //**Restriccion necesaria
  constraint source_addrs {source < columns*2+rows*2;};  //**Restriccion para asegurar que el paquete se dirige a un driver existente (necesaria)
  //Respecto al ID
  constraint valid_addrs {row_num <= rows+1; row_num >= 0; column_num <= columns+1; column_num >= 0;};       //Restriccion asegura que la direccion pertenece a un driver
  constraint valid_addrs_col {if(row_num == 0 | row_num == rows+1)column_num <= columns & column_num > 0;};
  constraint valid_addrs_row {if(column_num == 0 | column_num == columns+1) row_num <= rows & row_num > 0;};
  constraint valid_addrs_Driver {if(row_num != 0 & row_num != rows+1)column_num == 0 | column_num == columns+1;};
  
   
  function new();
    variability = pack_size - 18;
  endfunction
  
endclass


  //Clases para transacciones
/*
class mntr_score #(parameter ancho_pal=32);
  
  int dato;
  
  function new();
    
  endfunction
  
endclass

*/

//typedef mailbox #(mntr_score) mntr_score_mbx;
typedef mailbox #(agnt_drvr) agnt_drvr_mb ; 
























