// Apb_master_sequencer
class Apb_master_sequencer extends uvm_sequencer#(Apb_master_seq_item);
// ----------------------Factory Registration --------------------------------/
	`uvm_component_utils(Apb_master_sequencer)
//--------------------------- constructor new method -------------------------/
function new(string name = "Apb_master_sequencer", uvm_component parent);
super.new(name, parent);
              `uvm_info("Apb_master_SEQUENCER","object created",UVM_LOW);
endfunction 
endclass : Apb_master_sequencer