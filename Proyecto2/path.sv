//en este codigo se establecen las rutas que toman los datos
 class path #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40, parameter fifo_depth = 4);
   
  	detector_checker_mb detector_checker_mb;
   path_checker #(.pckg_sz(pckg_sz)) path_checker;


   virtual interfaz #(.ROWS(ROWS), .COLUMS(COLUMS), .pckg_sz(pckg_sz),.fifo_depth(fifo_depth)) interf;
      
	task run();
		fork	        
            begin
              //columna 1, fila 1, internal interface ID 0
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(1,1,testbench.DUT._rw_[1]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                 //columna 1, fila 1, internal interface ID 1
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(1,1,testbench.DUT._rw_[1]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                     //columna 1, fila 1, internal interface ID 2
                    @(posedge testbench.DUT._rw_[1]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(1,1,testbench.DUT._rw_[1]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                     //columna 1, fila 1, internal interface ID 3
                    @(posedge testbench.DUT._rw_[1]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(1,1,testbench.DUT._rw_[1]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(1,2,testbench.DUT._rw_[1]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(1,2,testbench.DUT._rw_[1]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(1,2,testbench.DUT._rw_[1]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(1,2,testbench.DUT._rw_[1]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(1,3,testbench.DUT._rw_[1]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(1,3,testbench.DUT._rw_[1]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(1,3,testbench.DUT._rw_[1]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(1,3,testbench.DUT._rw_[1]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(1,4,testbench.DUT._rw_[1]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(1,4,testbench.DUT._rw_[1]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(1,4,testbench.DUT._rw_[1]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[1]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(1,4,testbench.DUT._rw_[1]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(2,1,testbench.DUT._rw_[2]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(2,1,testbench.DUT._rw_[2]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(2,1,testbench.DUT._rw_[2]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(2,1,testbench.DUT._rw_[2]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(2,2,testbench.DUT._rw_[2]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(2,2,testbench.DUT._rw_[2]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(2,2,testbench.DUT._rw_[2]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(2,2,testbench.DUT._rw_[2]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(2,3,testbench.DUT._rw_[2]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(2,3,testbench.DUT._rw_[2]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(2,3,testbench.DUT._rw_[2]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(2,3,testbench.DUT._rw_[2]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(2,4,testbench.DUT._rw_[2]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(2,4,testbench.DUT._rw_[2]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(2,4,testbench.DUT._rw_[2]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[2]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(2,4,testbench.DUT._rw_[2]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(3,1,testbench.DUT._rw_[3]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(3,1,testbench.DUT._rw_[3]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(3,1,testbench.DUT._rw_[3]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(3,1,testbench.DUT._rw_[3]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(3,2,testbench.DUT._rw_[3]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(3,2,testbench.DUT._rw_[3]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(3,2,testbench.DUT._rw_[3]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(3,2,testbench.DUT._rw_[3]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(3,3,testbench.DUT._rw_[3]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(3,3,testbench.DUT._rw_[3]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(3,3,testbench.DUT._rw_[3]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(3,3,testbench.DUT._rw_[3]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(3,4,testbench.DUT._rw_[3]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(3,4,testbench.DUT._rw_[3]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(3,4,testbench.DUT._rw_[3]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[3]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(3,4,testbench.DUT._rw_[3]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(4,1,testbench.DUT._rw_[4]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop);
                   path_checker=new(4,1,testbench.DUT._rw_[4]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(4,1,testbench.DUT._rw_[4]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(4,1,testbench.DUT._rw_[4]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(4,2,testbench.DUT._rw_[4]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(4,2,testbench.DUT._rw_[4]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(4,2,testbench.DUT._rw_[4]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(4,2,testbench.DUT._rw_[4]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(4,3,testbench.DUT._rw_[4]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(4,3,testbench.DUT._rw_[4]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(4,3,testbench.DUT._rw_[4]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(4,3,testbench.DUT._rw_[4]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop);
                    path_checker=new(4,4,testbench.DUT._rw_[4]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop);
                    path_checker=new(4,4,testbench.DUT._rw_[4]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
              
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop);
                    path_checker=new(4,4,testbench.DUT._rw_[4]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
            begin
                forever begin
                    @(posedge testbench.DUT._rw_[4]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop);
                    path_checker=new(4,4,testbench.DUT._rw_[4]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out);
                    detector_checker_mb.put(path_checker);
                    
                end
            end
          
		join_none
	endtask


endclass