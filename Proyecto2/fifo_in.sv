class fifo_dr #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40, parameter fifo_depth = 4);

  //paramteros
  bit [pckg_sz-1:0] fifo_emul[$]; 
  int id_fifo;
  
  virtual interfaz #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_depth)) interf;//interfaz

  function new (int id); //numero de fifo
    fifo_emul = {}; //queue vacia 
		this.id_fifo = id; 
	endfunction

  function Fin_push(bit [pckg_sz-1:0] dato); // emula el push de una fifo
			this.fifo_emul.push_back(dato);
			this.interf.data_out_i_in[this.id_fifo] = fifo_emul[0];
			this.interf.pndng_i_in[this.id_fifo] = 1;
	endfunction

  task interfaz();//se encarga de decir que sucede si hay datos pendientes o si no
      	this.interf.pndng_i_in[this.id_fifo] = 0;
		forever begin
			if(this.fifo_emul.size==0) begin 
				this.interf.pndng_i_in[this.id_fifo] = 0;
				this.interf.data_out_i_in[this.id_fifo] = 0;
			end
			else begin
				this.interf.pndng_i_in[this.id_fifo] = 1;
				this.interf.data_out_i_in[this.id_fifo] = fifo_emul[0];
			end
          	@(posedge this.interf.popin[this.id_fifo]);
          if(this.fifo_emul.size>0) this.fifo_emul.delete(0);
          
          
          //asercion
 assert(this.interf.popin[this.id_fifo])begin
            $display("CAPTURA DATO");
          end
          else begin
            $warning("WARNING-----------NO CAPTURA DATO");
          end
        end
    endtask
endclass