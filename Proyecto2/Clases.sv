//Clases para transacciones

class mntr_score #(parameter pckg_sz=32);
  
  int dato;
  int tiempo;
  int id;
  
  function new();
    
  endfunction
  
endclass

typedef mailbox #(mntr_score) mntr_score_mbx;
