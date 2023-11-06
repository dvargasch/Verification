class secuencia extends uvm_sequence;
    `uvm_object_utils (secuencia);

    function new (string name = "mi secuencia");
    super.new (name);
    endfunction
//`uvm_declare_p_sequencer ()
rand int num;

constraint cons1 { soft num inside {[2:5]};}

virtual task body();
for (int i = 0; i<num; i++) begin
    reg_item seq_item = reg_item ::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.randomize();
    'uvm_info("SEQ", $sformatf ("Genera un nuevo item: %s" , seq_item. convert2str())UVM_HIGH)
    seq_item.print();
    finish_item(seq_item);
end

`uvm_info ("SEQ", $sformatf ("Se han generado %0d items", num), UVM_LOW)
endtask
endclass



