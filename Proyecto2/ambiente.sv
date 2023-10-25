class ambiente  #(parameter rows = 4, parameter columns = 4, parameter pckg_sz = 40, parameter f_depth = 4, parameter drvrs = 16);


    Driver #(.drvrs(drvrs), .ROWS(rows), .COLUMS(columns), .pckg_sz(pckg_sz)) driver_amb [drvrs];
    monitor #(.ROWS(rows), .COLUMS(columns), .pckg_sz(pckg_sz)) monitor_amb [drvrs];
  	Agente #(.ROWS(rows), .COLUMS(columns), .pckg_sz(pckg_sz), .fifo_depth(f_depth), .drvrs(drvrs)) agente_amb;
    Generador #(.drvrs(drvrs), .pckg_sz(pckg_sz)) generador_amb;
  
  scoreboard #(.drvrs(drvrs), .ROWS(rows), .COLUMS(columns), .pckg_sz(pckg_sz)) scoreboard_amb;
  

    agent_driver_mb #(.ROWS(rows), .COLUMS(columns), .pckg_sz(pckg_sz)) agent_driver_mb_amb [drvrs];
    gen_agent_mb gen_agent_mb_amb;
    test_generador_mbx test_gen_mb_amb;
    mntr_score_mbx mntr_score_mbx =new();

    function new();
        for(int i = 0; i < drvrs; i++) begin
            automatic int k = i;
            this.agent_driver_mb_amb[k] = new();
	    end
		this.gen_agent_mb_amb = new();
  		this.test_gen_mb_amb = new ();

		this.agente_amb = new();
		this.agente_amb.gen_agent_mb_a = gen_agent_mb_amb;
		this.generador_amb = new();
		this.generador_amb.gen_agent_mb_g = gen_agent_mb_amb;
		this.generador_amb.test_gen_mb_g = test_gen_mb_amb;
        this.scoreboard_amb= new();
        this.scoreboard_amb.mntr_score_mbx = mntr_score_mbx;

		for (int i = 0; i<drvrs; i++ ) begin
			automatic int k = i;
			this.driver_amb[k] = new(k);
            this.driver_amb[k].agent_driver_mb_d = agent_driver_mb_amb[k];
             this.monitor_amb[k] = new(k);
             this.monitor_amb[k].mntr_score_mbx = mntr_score_mbx;
            this.agente_amb.agent_driver_mb_a[k] = agent_driver_mb_amb[k];
        end

	endfunction

	task run();
		fork
            this.scoreboard_amb.run();
            this.agente_amb.run();
			this.generador_amb.run();
            for(int i = 0; i<drvrs; i++ ) begin
                fork
              		automatic int k = i;
              		this.driver_amb[k].run();
              		this.monitor_amb[k].run();
				join_none
            end
		join
	endtask

	function display();
		$display("Ambiente: Drivers=%d / pckg=%d / fifo=%d",this.drvrs,this.pckg_sz,this.f_depth);
	endfunction

  task t_run();
     
    this.scoreboard_amb.display_run();
    
   endtask
     

endclass
