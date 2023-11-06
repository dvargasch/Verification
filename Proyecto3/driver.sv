class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)

//constructor explicito
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

//interfaz virtual
interface_ interfaz; 

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(interface_)::get(this, "", "interface_", interfaz))// se hace un ciclo if para obtener la interface virtual
`uvm_fatal("DRV", "Could not get interfaz ") // si se cumple da como resultado el error uvm fatal
endfunction

virtual task run_phase(uvm_phase phase); 
super.run_phase (phase);
forever begin
    item seq_item;
      `uvm_info("SEQ", $formatf("Could not get secuencia "), UVM_HIGHT)
      seq_item_port.get_next_item(seq_item);
      drive_item(seq_item);
      seq_item_port.item_done();
      
end
endtask
endclass