//Proyecto 3 - Verificacion Funcional de Circuitos Integrados /////////
//Profesor: Ronny Garcia Ramirez                              /////////
//Estudiantes: Rachell Morales - Daniela Vargas               /////////
///////////////////////////////////////////////////////////////////////

`uvm_analysis_imp_decl(_drv) // Declaración de puertos de análisis para el driver 
`uvm_analysis_imp_decl(_mon) // Declaración de puertos de análisis para el monitor
`include "path.sv" // Inclusión de un archivo path.sv
class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard) // Macro para la implementación de componentes UVM
  
  int c = 1; // Variable de conteo
  int overflow [5][5]; // Matriz para controlar overflow
  int time_prom;
 
  // Puertos de análisis para el driver y el monitor
  uvm_analysis_imp_drv #(drv_score, scoreboard) conec2;
  uvm_analysis_imp_mon #(mon_score, scoreboard) conec;
  
   // Arreglos de score para almacenar información del monitor y el driver
  mon_score score_arr[int]; //Arreglo que se instancia por enteros
  drv_score score_arr2[int];
  
  
    // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    conec = new("conec", this);
    conec2 =new ("conec2",this);
  endfunction
  
  // Tarea de ejecución
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork      
      `path // Ejecución de tareas definidas en el archivo path.sv
    join_none
    phase.drop_objection(this);
  endtask
  
  // Función para la fase de verificación
  function void check_phase(uvm_phase phase);
    
    // Verificación de posibles overflows
    for (int i = 0; i <=5 ; i++)begin
        for (int j = 0; j <= 5; j++) begin
          if(overflow[i][j] >=5) begin
            `uvm_info("REPORT",$sformatf("Posible overflow en la terminal [%0d][%0d]",i,j),UVM_LOW)
          end
            //$display("Posible Overflow en la terminal [%0d][%0d], cantidad de datos [%0d]",i,j,overflow[i][j]);
        end
      end
    
    // Verificación de datos no recibidos por el destino
    foreach(score_arr2[m])begin
      for (int i = 1; i <=5 ; i++)begin
        for (int j = 1; j <= 5; j++) begin
          if(score_arr2[m].path[i][j] == 1) begin
            $display("El dato [%b] no pasó por [%0d][%0d]",m,i,j);
            $display("Source: [%0d][%0d] Target: [%0d][%0d]",score_arr2[m].source_r,score_arr2[m].source_c,score_arr2[m].target_r,score_arr2[m].target_c);
          end
        end
      end
    end
    
    
    // Imprime estadísticas
    `uvm_info("REPORT",$sformatf("Cantidad de Transacciones Enviadas %0.2f",score_arr2.size()),UVM_LOW)
    `uvm_info("REPORT",$sformatf("Cantidad de Transacciones Recibidas %0.2f",score_arr.size()),UVM_LOW)
    
    foreach(score_arr[i])begin
      time_prom = (score_arr[i].tiempo - score_arr2[i].tiempo)+time_prom;
    end
    `uvm_info("REPORT",$sformatf("Retardo Promedio %0.2f",time_prom/score_arr.size()),UVM_LOW)
    foreach(score_arr[i])begin
      score_arr2.delete(i);
    end
    `uvm_info("REPORT",$sformatf("Cantidad de Transacciones Perdidas %0.2f",score_arr2.size()),UVM_LOW)
    
  endfunction 
 
  // Función para escribir datos del monitor en el scoreboard
  virtual function void write_mon(input mon_score pkt);
    
     score_arr[pkt.pkg] = pkt;
    listo=0;

    c++;
      
  endfunction:write_mon
  
  // Función para escribir datos del driver en el scoreboard
  virtual function void write_drv(input drv_score pkt);
    
     score_arr2[pkt.pkg] = pkt;
    
    // Llamada a la función golden_reference para verificar la ruta del paquete
    golden_reference(pkt.pkg,score_arr2[pkt.pkg].modo,score_arr2[pkt.pkg].target_r,score_arr2[pkt.pkg].target_c,score_arr2[pkt.pkg].source_r,score_arr2[pkt.pkg].source_c);
    listo=0;
  
    c++;
  endfunction:write_drv
  
  
 int r; // Variable para la fila de origen
  int c; // Variable para la columna de origen
  int rr; // Variable temporal para la fila durante el procesamiento
  int cc; // Variable temporal para la columna durante el procesamiento
  int listo = 0; // Variable que indica si se ha completado el procesamiento
 
  
  // Definición de la tarea golden_reference
  task golden_reference(int dato,int modo, int target_r,int target_c,int source_r, int source_c );
    
    //Inicialización
      r = source_r;
      c = source_c;
    
    // Ajuste de la fila y columna de origen para evitar desbordamientos
      if(r == 0) r = 1;
      if(c == 0) c = 1;
      if(r == 5) r = 4;
      if(c == 5) c = 4;
    
    // Utilización de una estructura case para manejar diferentes modos
      case(modo)
        0:begin
          if(((source_r <=target_r)&(listo !=1))) begin
            if((source_c <= target_c)&(listo !=1))begin
               // Proceso ascendente hacia la derecha
              rr = r;
              cc = c;
              while((cc< target_c)&(cc<4))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                cc++;
               end
              while((rr<= target_r)&(rr<4))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                rr++;
              end
          	end
          	else begin
              rr = r;
              cc = c;
              while((cc > target_c)&(cc>=2))begin
                score_arr2[dato].path[rr][cc] = 1; // Marca la ruta en la matriz de path del objeto score_arr2
                overflow[rr][cc] =overflow[rr][cc] + 1; // Incrementa el contador de overflow para esa posición
                listo = 1; // Marca que el procesamiento ha sido completado
                cc--;
               end
              while(rr<= target_r)begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                rr++;// Incrementa la fila temporal para avanzar en la matriz
              end
            end
          end
          if(((source_r >= target_r)&(listo !=1))) begin
            if((source_c <= target_c)&(listo !=1))begin
              rr = r;
              cc = c;
              while((cc< target_c)&(cc<=3))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                cc++;// Incrementa la columna temporal para avanzar en la matriz
              end
              while((rr>= target_r)&(rr>=2))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                rr--;
               end
          	end
          	else begin
              rr = r;
              cc = c;
              while((cc > target_c)&(cc>1))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                cc--;// Decrementa la columna temporal para retroceder en la matriz
               end
              while((rr >= target_r)&(rr>=1))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                rr--;
              end
            end
          end
        end
        1:begin
          if(((source_r <=target_r)&(listo !=1))) begin
            if((source_c <= target_c)&(listo !=1))begin
              rr = r;
              cc = c;
              while((rr< target_r)&(rr<=3))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                rr++;
              end
              while((cc<= target_c)&(cc<=4))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                cc++;
               end
          	end
          	else begin
              rr = r;
              cc = c;
              
              while((rr< target_r)&(rr<=3))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                rr++;
               end
              while(cc >= target_c)begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                cc--;
              end
            end
          end
          
          if(((source_r >= target_r)&(listo !=1))) begin
            if((source_c <= target_c)&(listo !=1))begin
              rr = r;
              cc = c;
              while((rr> target_r)&(rr>=2))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                rr--; // Decrementa la fila temporal para retroceder en la matriz
               end
              while((cc<= target_c)&(cc<=4))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                cc++;
              end
          	end
          	else begin
              rr = r;
              cc = c;
              while((rr > target_r)&(rr>1))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                rr--;
               end
              while((cc >= target_c)&(cc>=1))begin
                score_arr2[dato].path[rr][cc] = 1;
                overflow[rr][cc] =overflow[rr][cc] + 1;
                listo = 1;
                cc--;
              end
            end
          end
        end
      endcase
     
      
    
endtask
  
  
  
endclass: scoreboard
