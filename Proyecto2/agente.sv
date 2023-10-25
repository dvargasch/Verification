class Agente #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40, parameter fifo_depth = 4 , parameter drvrs = 16);
  agent_driver_mb #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) agent_driver_mb_a [drvrs];
    gen_agent_mb gen_agent_mb_a;

  trans_agent_driver #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) trans_agent_driver_a;
    trans_gen_agent trans_gen_agent_a;

    int num_transac;
    int retardo;
    int fuente;

    Mapeo_colum_fila pos_driver_a[drvrs];

    function new();
        this.trans_agent_driver_a = new();

        for(int i = 0; i < drvrs; i++) begin
            automatic int k = i;	
            this.agent_driver_mb_a[k] = new();
        end

        for(int i = 0; i < drvrs; i++) begin
            automatic int k = i;	
            pos_driver_a[k] = new();
        end

        for (int i = 0; i<COLUMS;i++)begin 
            pos_driver_a[i].fila = 0;              
            pos_driver_a[i].colum = i+1; 
        end 
        for (int i = 0; i<ROWS;i++)begin 
            pos_driver_a[i+COLUMS].colum = 0; 
            pos_driver_a[i+COLUMS].fila = i+1; 
        end 
        for (int i = 0; i<COLUMS;i++)begin 
            pos_driver_a[i+ROWS*2].fila = ROWS+1; 
            pos_driver_a[i+ROWS*2].colum = i+1; 
        end
        for (int i = 0; i<ROWS;i++)begin 
            pos_driver_a[i+COLUMS*3].colum = COLUMS+1; 
            pos_driver_a[i+COLUMS*3].fila = i+1; 
        end         

        foreach (pos_driver_a[i]) begin
          $display("Dispositivo %d FILA=%0d COLUMNA=%0d",i,pos_driver_a[i].fila,pos_driver_a[i].colum);
        end

        $display("Agente inicializado");
    endfunction

    task run();
        forever begin
            this.gen_agent_mb_a.get(this.trans_gen_agent_a); // captura la transacción del generador
          	$display("Agente captura instruccion del generador");
            this.num_transac = this.trans_gen_agent_a.cant_transac;

            //Variabilidad de datos
            for (int i = 0; i < this.num_transac; i++) begin
                this.trans_agent_driver_a = new();

                case (this.trans_gen_agent_a.tipo_dato)
                    Variab:begin
                        trans_agent_driver_a.variabilidad_dato.constraint_mode(1);
                      $display("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                    end

                    aleat:begin
                        trans_agent_driver_a.variabilidad_dato.constraint_mode(0);
                    end

                    default: begin
                        trans_agent_driver_a.variabilidad_dato.constraint_mode(0);
                    end
                endcase


                this.trans_agent_driver_a.randomize(); 


                this.trans_agent_driver_a.tiempo = $time;
                this.agent_driver_mb_a[this.trans_agent_driver_a.fuente].put(this.trans_agent_driver_a);
                #1;

            end

        end
        
    endtask

endclass

