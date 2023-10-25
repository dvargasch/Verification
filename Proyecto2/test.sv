
class test #(parameter rows = 4, parameter columns = 4, parameter pckg_sz = 40, parameter f_depth = 4,parameter drvrs = 16);

  //Transacciones
  trans_test_gen trans_test_gen_t;

  //Mailboxes
  test_generador_mbx test_gen_mb_t;

  function new();
    this.trans_test_gen_t = new();
  endfunction 

  task run();
    this.trans_test_gen_t = new();
    trans_test_gen_t.tipo_prueba = mode_1;
    test_gen_mb_t.put(trans_test_gen_t);
    $display("TEST: CASO-modo_0",$time);

  endtask


endclass
