interface interfaz #(parameter rows = 4, parameter columns =4, parameter pckg_sz =40, parameter f_depth = 4) (
    input bit clk);

    
    logic pndng[rows*2+columns*2];
  logic [pckg_sz-1:0] data_out[rows*2+columns*2];
    logic popin[rows*2+columns*2];
    logic pop[rows*2+columns*2];
    logic [pckg_sz-1:0]data_out_i_in[rows*2+columns*2];
    logic pndng_i_in[rows*2+columns*2];
    logic reset;
endinterface
