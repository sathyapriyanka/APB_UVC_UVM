// Apb_slave_sequencer
class Apb_slave_sequencer extends uvm_sequencer#(Apb_slave_seq_item);
// ------------------------Factory Registration --------------------------/
	`uvm_component_utils(Apb_slave_sequencer)
//--------------------------- constructor new method -------------------------/
function new(string name = "Apb_slave_sequencer", uvm_component parent);
super.new(name, parent);
                 `uvm_info("Apb_slave_sequencer","object created",UVM_LOW);
endfunction 
endclass : Apb_slave_sequencer