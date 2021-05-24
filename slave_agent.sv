// Apb_slave_agent
 class Apb_slave_agt extends uvm_agent;
// ---------------------Factory Registration ---------------------------/
	`uvm_component_utils(Apb_slave_agt)
// instance of driver and sequencer
 	Apb_slave_driver   Apb_agent_slave_driver;
 	Apb_slave_sequencer   Apb_agent_slave_sequencer;
 	Apb_slave_monitor   Apb_agent_slave_monitor;
	Apb_slave_agt_config   s_agt_config;
//--------------------------- constructor new method -------------------------/
	function new(string name = "Apb_slave_agt", uvm_component parent);
 	super.new(name, parent);
	endfunction : new 
// ---------------------Build_phase Method ------------------------------//
 	function void build_phase(uvm_phase phase);
 	super.build_phase(phase);
               if(!uvm_config_db # (Apb_slave_agt_config) :: get (this,"","Apb_slave_agt_config",s_agt_config))
               `uvm_fatal ("Apb_slave_agent ","GET Failed");	
              Apb_agent_slave_monitor = Apb_slave_monitor :: type_id :: create ("Apb_agent_slave_monitor", this);
              s_agt_config = Apb_slave_agt_config::type_id::create ("s_agt_config");  
              if(s_agt_config.is_active == UVM_ACTIVE)
              begin    
	Apb_agent_slave_driver = Apb_slave_driver :: type_id :: create ("Apb_agent_slave_driver", this);
	Apb_agent_slave_sequencer = Apb_slave_sequencer :: type_id :: create ("Apb_agent_slave_sequencer", this);
  	end
endfunction
// ---------------------Connect_phase Method ------------------------------//
function void connect_phase(uvm_phase phase);
 	if(s_agt_config.is_active == UVM_ACTIVE)
	Apb_agent_slave_driver.seq_item_port.connect(Apb_agent_slave_sequencer.seq_item_export);
               uvm_top.print_topology(); // For Topology Printing
endfunction 
endclass : Apb_slave_agt

