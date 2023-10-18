//Clases para transacciones

class mntr_score #(parameter ancho_pal=32);
  
  int dato;
  
  function new();
    
  endfunction
  
endclass

typedef mailbox #(mntr_score) mntr_score_mbx;
