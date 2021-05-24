// Apb_master_agent
class Apb_master_agt extends uvm_agent;
// ----------------------------Factory Registration -------------------------/
              `uvm_component_utils(Apb_master_agt)
// instance of driver and sequencer
 	Apb_master_driver   Apb_agent_master_driver;
 	Apb_master_sequencer   Apb_agent_master_sequencer;
 	Apb_master_monitor   Apb_agent_master_monitor;
	Apb_master_agt_config   m_agt_config;
//--------------------------- constructor new method -------------------------/
function new(string name = "Apb_master_agt", uvm_component parent);
super.new(name, parent);
             `uvm_info("Apb_master_AGENT","object created",UVM_LOW);
endfunction : new 
// ---------------------Build_phase Method ------------------------------//
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	m_agt_config = Apb_master_agt_config::type_id::create ("m_agt_config");   
               if(m_agt_config.is_active == UVM_ACTIVE)
	begin    
  	Apb_agent_master_driver = Apb_master_driver :: type_id :: create ("Apb_agent_master_driver", this);
  	Apb_agent_master_sequencer = Apb_master_sequencer :: type_id :: create ("Apb_agent_master_sequencer", this);
               Apb_agent_master_monitor = Apb_master_monitor :: type_id :: create ("Apb_agent_master_monitor", this);
  	end
 	endfunction
// ---------------------Connect_phase Method ------------------------------//
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
            if(m_agt_config.is_active == UVM_ACTIVE)
            Apb_agent_master_driver.seq_item_port.connect(Apb_agent_master_sequencer.seq_item_export);
             uvm_top.print_topology(); // For Topology Printing
endfunction 
endclass : Apb_master_agt
      