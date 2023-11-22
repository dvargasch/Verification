`uvm_analysis_imp_decl(_drv)
`uvm_analysis_imp_decl(_mon)

class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard)
  
  int c = 1;
  
 // uvm_analysis_imp#(mon_score, scoreboard) conec;
  
  uvm_analysis_imp_drv #(drv_score, scoreboard) conec2;
  uvm_analysis_imp_mon #(mon_score, scoreboard) conec;
  
  mon_score score_arr[int]; //Arreglo que se instancia por enteros
  drv_score score_arr2[int];
  
  
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    conec = new("conec", this);
    conec2 =new ("conec2",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_warning("Se inicializó el scoreboard", get_type_name())
    phase.drop_objection(this);
  endtask
  
  /*function void agregar_elemento(mon_score pkt);
    string clave;
    score_arr[pkt] = c;
  endfunction*/
  
  
  /*function write (string pkt);
   
    $display("[%0d] %s",c,pkt);
    c++;

  endfunction*/
  
  virtual function void write_mon(input mon_score pkt);
    
     score_arr[pkt.pkg] = pkt;
    
    //foreach (score_arr[i]) begin
    $display("Se recibió del monitor [%g] el dato [%b] con un tiempo de envío de [%g] y con modo[%g]",score_arr[pkt.pkg].num_mon, score_arr[pkt.pkg].pkg,score_arr[pkt.pkg].tiempo, score_arr[pkt.pkg].modo);
    //$display ("Source [%0d] [%0d]  Destino [%0d][%0d]",score_arr[pkt.pkg].source_r,score_arr[pkt.pkg].source_c,score_arr[pkt.pkg].target_r,score_arr[pkt.pkg].target_c);
    
    golden_reference(pkt.pkg,score_arr[pkt.pkg].modo,score_arr[pkt.pkg].target_r,score_arr[pkt.pkg].target_c,score_arr[pkt.pkg].source_r,score_arr[pkt.pkg].source_c);
    
    listo=0;
    //end
    c++;
      
  endfunction:write_mon
  
  
  virtual function void write_drv(input drv_score pkt);
    
     score_arr2[pkt.pkg] = pkt;
    
    //foreach (score_arr[i]) begin
    $display("Se recibió del driver [%g] el dato [%b] con un tiempo de envío de [%g] y con modo[%g]",score_arr2[pkt.pkg].num_drv, score_arr2[pkt.pkg].pkg,score_arr2[pkt.pkg].tiempo, score_arr2[pkt.pkg].modo);
    
    listo=0;
    //end
    c++;
      
  endfunction:write_drv
  
  
 int r;
  int c;
  int rr;
  int cc;
  int listo = 0;
 
  task golden_reference(int dato,int modo, int target_r,int target_c,int source_r, int source_c );
      r = source_r;
      c = source_c;
      if(r == 0) r = 1;
      if(c == 0) c = 1;
      if(r == 5) r = 4;
      if(c == 5) c = 4;
      case(modo)
        0:begin
          if(((source_r <=target_r)&(listo !=1))) begin
            if((source_c <= target_c)&(listo !=1))begin
              
              rr = r;
              cc = c;
              while((cc< target_c)&(cc<4))begin
                //$display("Va de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc++;
               end
              while((rr<= target_r)&(rr<4))begin
                //$display("Vainside de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr++;
              end
          	end
          	else begin
              rr = r;
              cc = c;
              while((cc > target_c)&(cc>=2))begin
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc--;
               end
              while(rr<= target_r)begin
               // $display("Valores de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr++;
              end
            end
          end
          if(((source_r >= target_r)&(listo !=1))) begin
            //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",source_r,source_c, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], target_c);
            if((source_c <= target_c)&(listo !=1))begin
              rr = r;
              cc = c;
              while((cc< target_c)&(cc<=3))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc++;
              end
              while((rr>= target_r)&(rr>=2))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr--;
               end
          	end
          	else begin
              //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",source_r,source_c, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], target_c);
              rr = r;
              cc = c;
              //$display("rr[%0d] y cc[%0d]",rr,cc);
              while((cc > target_c)&(cc>1))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc--;
               end
              //$display("REF RR %0d row %0d",rr,target_r;
              while((rr >= target_r)&(rr>=1))begin
                //$display("Valoress de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr--;
              end
            end
          end
        end
        1:begin
         // $display("Valor de R %0d C %0d",r,c);
          if(((source_r <=target_r)&(listo !=1))) begin
            if((source_c <= target_c)&(listo !=1))begin
              //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",source_r,source_c, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], target_c);
              rr = r;
              cc = c;
              while((rr< target_r)&(rr<=3))begin
                //$display("Valores de R- %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr++;
              end
              while((cc<= target_c)&(cc<=4))begin
                //$display("Valores de R- %0d C %0d t%0d",rr,cc,target_c);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc++;
               end
          	end
          	else begin
              rr = r;
              cc = c;
              //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",source_r,source_c, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], target_c);
              while((rr< target_r)&(rr<=3))begin
                //$display("Validación de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr++;
               end
              while(cc > target_c)begin
                //$display("Valores de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc--;
              end
            end
          end
          
          if(((source_r >= target_r)&(listo !=1))) begin
            if((source_c <= target_c)&(listo !=1))begin
              //$display("ORI: [%0d] [%0d] DIR: [%0d] [%0d]",source_r,source_c, drv_sb_transaction.paquete[pckg_sz-9:pckg_sz-12], target_c);
              rr = r;
              cc = c;
              while((rr>= target_r)&(rr>=2))begin
               //$display("Valores de R- %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr--;
               end
              while((cc<= target_c)&(cc<=4))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc++;
              end
          	end
          	else begin
              rr = r;
              cc = c;
             // $display("rr[%0d] y cc[%0d]",rr,cc);
              while((rr > target_r)&(rr>1))begin
               // $display("Valores de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                rr--;
               end
              while((cc >= target_c)&(cc>=1))begin
                //$display("Valores de R %0d C %0d",rr,cc);
                score_arr[dato].path[rr][cc] = 1;
                //drv_sb_transaction.ruta[{rr,cc}]=1;
                listo = 1;
                //drv_sb_transaction.jump =drv_sb_transaction.jump +1;
                cc--;
              end
            end
          end
        end
      endcase
      //sb_chk_mbx.put(drv_sb_transaction);
      
     
   /*   //$display("SE ENVIÓ UN PAQUETE AL CHK ");
   $display("SALIDA [%0d][%0d] DESTINO [%0d][%0d] modo [%0d]",source_r,source_c,target_r,target_c,modo);
    for (int i = 0; i <=5 ; i++)begin
      for (int j = 0; j <= 5; j++) begin
        if(score_arr[dato].path[i][j]==1)$display("ruta [%0d][%0d]",i,j);
      end
    end*/
    
endtask
  
  
  
endclass: scoreboard
