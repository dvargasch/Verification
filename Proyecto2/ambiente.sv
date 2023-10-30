`include "path.sv"


class ambiente  #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40, parameter fifo_depth = 4, parameter drvrs = ROWS*2 + COLUMS*2);

  //instancias
    Driver #(.drvrs(drvrs), .ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz), .fifo_depth(fifo_depth)) driver_amb [drvrs];
    monitor #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz), .fifo_depth(fifo_depth)) monitor_amb [drvrs];
  	agente #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz), .fifo_depth(fifo_depth), .drvrs(drvrs)) agente_amb;
    Generador #(.drvrs(drvrs), .pckg_sz(pckg_sz)) generador_amb;
  path #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_depth)) path_amb;
  scoreboard #(.drvrs(drvrs),.ROWS(ROWS), .COLUMS(ROWS), .pckg_sz(pckg_sz)) scoreboard_amb;

	//mailbox
  agent_driver_mbx #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz)) agent_driver_mbx_am [drvrs];
    generador_agente_mb generador_agent_mb_amb;
    test_generador_mbx test_generador_mbx_amb;
  	detector_checker_mb detector_checker_mb_amb;
    mntr_score_mbx mntr_score_mbx =new();
    drv_chckr_mbx drv_chckr_mbx=new();
  

    function new();
        //Inicialización de mailbox
        for(int i = 0; i < drvrs; i++) begin
            automatic int k = i;
            this.agent_driver_mbx_am[k] = new();
	    end
		this.generador_agent_mb_amb = new();
  		this.test_generador_mbx_amb = new ();
      	this.detector_checker_mb_amb = new ();

        //Inicialización
		this.agente_amb = new();
		this.agente_amb.generador_agente_mb_a = generador_agent_mb_amb;
		this.generador_amb = new();
		this.generador_amb.generador_agente_mb_g = generador_agent_mb_amb;
		this.generador_amb.test_generador_mbx_g = test_generador_mbx_amb;
      	this.path_amb = new();
      	this.path_amb.detector_checker_mb = detector_checker_mb_amb;
        this.scoreboard_amb= new();
       this.scoreboard_amb.mntr_score_mbx = mntr_score_mbx;
       this.scoreboard_amb.drv_chckr_mbx = drv_chckr_mbx;
      
//para que el monitor y el driver se ejecuten 16 veces
		for (int i = 0; i<drvrs; i++ ) begin
			automatic int k = i;
			this.driver_amb[k] = new(k);
          this.driver_amb[k].agent_driver_mbx_d = agent_driver_mbx_am[k];
          this.driver_amb[k].drv_chckr_mbx = drv_chckr_mbx;
            this.monitor_amb[k] = new(k);
          this.monitor_amb[k].mntr_score_mbx = mntr_score_mbx;
          this.agente_amb.agent_driver_mbx_a[k] = agent_driver_mbx_am[k];
        end

	endfunction

//para que se ejecute en paralelo
	task run();
		fork
          		this.scoreboard_amb.run_rec();
                this.scoreboard_amb.run_ent();
                this.agente_amb.run();
			    this.generador_amb.run();
          	    this.path_amb.run();
           
            for(int i = 0; i<drvrs; i++ ) begin
                fork
              		automatic int k = i;
              		this.driver_amb[k].run();
              		this.monitor_amb[k].run();
                  
				join_none
            end
		join
	endtask
//lo que debe mostrar la terminal
	function display();
      $display("\n \n ______________AMBIENTE____________\n \n");
      $display("Dispositivos = [%g]",this.drvrs);
      $display("Tamano del paquete = [%g]",this.pckg_sz);
      $display("Profundidad de la fifo = [%g]",this.fifo_depth);
	endfunction

 
  task t_run();
     
    this.scoreboard_amb.drv_chckr_run();
    this.scoreboard_amb.mntr_score_run();
    this.scoreboard_amb.eliminar();
    
   endtask


endclass