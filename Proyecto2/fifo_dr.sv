class fifo_dr #(parameter rows = 4, parameter columns = 4, parameter pckg_sz = 40, parameter f_depth = 4);

	bit [pckg_sz-1:0] FIFO_IN[$]; 
	int id_fifo;
  virtual interfaz #(.rows(rows), .columns(columns), .pckg_sz(pckg_sz),.f_depth(f_depth)) interfaz_f;

	function new (int ID);
		FIFO_IN = {};
		this.id_fifo = ID; 
	endfunction
	

	function Fin_push(bit [pckg_sz-1:0] dato);
			this.FIFO_IN.push_back(dato);
			this.interfaz_f.data_out_i_in[this.id_fifo] = FIFO_IN[0];
			this.interfaz_f.pndng_i_in[this.id_fifo] = 1;
	endfunction

	task interfaz();
		$display("FIFO #%d: ingresa dato al bus",this.id_fifo);
      	this.interfaz_f.pndng_i_in[this.id_fifo] = 0;
		forever begin
			if(this.FIFO_IN.size==0) begin 
				this.interfaz_f.pndng_i_in[this.id_fifo] = 0;
				this.interfaz_f.data_out_i_in[this.id_fifo] = 0;
			end
			else begin
				this.interfaz_f.pndng_i_in[this.id_fifo] = 1;
				this.interfaz_f.data_out_i_in[this.id_fifo] = FIFO_IN[0];
			end
          	@(posedge this.interfaz_f.popin[this.id_fifo]);
          if(this.FIFO_IN.size>0) this.FIFO_IN.delete(0);
		end
	endtask
endclass
