
`include "Clases.sv"

/*

  logic pndng[ROWS*2+COLUMS*2];
  logic [pckg_sz-1:0] data_out[ROWS2+COLUMS2];
  logic popin[ROWS2+COLUMS2];
  logic pop[ROWS2+COLUMS2];
  logic [pckg_sz-1:0]data_out_i_in[ROWS2+COLUMS2];
  logic pndng_i_in[ROWS2+COLUMS2];
  logic reset;
  
  */

class monitor #(parameter ancho_pal=32);//poner parametros
  
  //mailbok
  mntr_score_mbx mntr_score_mbx; // el segundo es el que está adentro del monitor
  
  //trasn
  mntr_score transaccion;
  
  
 virtual interfaz  v_if;// poner parametros
 int id_; 
  
  function new (int id);
    this.id_ = id;
    $display("Monitor %g",id);
    
  endfunction
  
  
  
  task run();
    
    $display("Funcionando %g",this.id_);
    
    this.v_if.pop[this.id_] = 0;//Cuidadoooooooooooooooooooooooooooo
    
    forever begin
      
      @(posedge this.v_if.clk); //Luego pasarlo a la v.interfaz
      if (this.v_if.pndng[this.id_]==1) begin
        transaccion=new();
        transaccion.dato=this.v_if.data_out[this.id_]; 
        mntr_score_mbx.put(transaccion);
        $display("Se recibe este dato: %b", this.v_if.data_out[this.id_]);
      
      end
    end
    
  endtask
  
endclass
  
  
