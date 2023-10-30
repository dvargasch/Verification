class test #(parameter ROWS = 4, parameter COLUMS = 4, parameter pckg_sz = 40, parameter fifo_depth = 4,parameter drvrs = ROWS*2+2*COLUMS);

  test_generador test_generador_t;//transacciones entre el test y el generador
  test_generador_mbx test_generador_mbx_t;//mailbox que conecta el test con el generador

  function new();//constructor
    this.test_generador_t = new();
  endfunction 

  task run();


    
    // prueba modo en 0, empieza por columnas
    this.test_generador_t = new();
    test_generador_t.tipo_prueba = mode_0;
    test_generador_mbx_t.put(test_generador_t);
    $display("\n\n_________________________________________");
    $display("\n\n  PRUEBA 1: MODO 0",$time);
    $display("\n\n_________________________________________\n\n");
    #1000
    
    // prueba modo en 1, empieza por filas
    this.test_generador_t = new();
    test_generador_t.tipo_prueba = mode_1;
    test_generador_mbx_t.put(test_generador_t);
    $display("\n\n_________________________________________");
    $display("\n\n  PRUEBA 2: MODO 1",$time);
    $display("\n\n_________________________________________\n\n");
    #1000

    //prueba De todas las fuentes a un mismo destino
    this.test_generador_t = new();
    test_generador_t.tipo_prueba = todos_a_uno;
    test_generador_mbx_t.put(test_generador_t);
    $display("\n\n_________________________________________");
    $display("\n \n PRUEBA 3: De todas las fuentes a un mismo destino",$time);
    $display("\n\n_________________________________________\n\n");
        
    #1000
        
    //prueba De la misma fuente a todos los destinos
    this.test_generador_t = new();
    test_generador_t.tipo_prueba = uno_a_todos;
    test_generador_mbx_t.put(test_generador_t);
    $display("\n\n_________________________________________");
    $display("\n\n PRUEBA 4: De la misma fuente a todos los destinos",$time);
    $display("\n\n_________________________________________\n\n");
    
    #1000
    //prueba retardo aleatorio
    this.test_generador_t = new();
    test_generador_t.tipo_prueba = retardo_aleat;
    test_generador_mbx_t.put(test_generador_t);
    $display("\n\n_________________________________________");
    $display("\n\n PRUEBA 5: Con el retardo aleatorio",$time);
    $display("\n\n_________________________________________\n\n");
    
    #1000
    //prueba retardo aleatorio
    this.test_generador_t = new();
    test_generador_t.tipo_prueba = uno_a_todos_modo0;
    test_generador_mbx_t.put(test_generador_t);
    $display("\n\n_________________________________________");
    $display("\n\n PRUEBA 6: Con el retardo aleatorio empezando por columnas",$time);
    $display("\n\n_________________________________________\n\n");
    
        #1000
    //prueba retardo aleatorio
    this.test_generador_t = new();
    test_generador_t.tipo_prueba = uno_a_todos_modo1;
    test_generador_mbx_t.put(test_generador_t);
    $display("\n\n_________________________________________");
    $display("\n\n PRUEBA 7: Con el retardo aleatorio empezando por filas",$time);
    $display("\n\n_________________________________________\n\n");
    
    
    
  endtask

endclass
