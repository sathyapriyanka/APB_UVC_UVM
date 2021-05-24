 
//Apb_env_config:
class Apb_env_config  extends  uvm_object;
// ----------------------------Factory Registration ------------------------------------------/
	`uvm_object_utils (Apb_env_config)
	bit has_scoreboard = 1;
	bit has_Apb_slave_agent = 1; 
               bit has_Apb_master_agent = 1; 
   	Apb_slave_agt_config    s_agt_config;
   	Apb_master_agt_config m_agt_config;
//--------------------------- constructor new method ----------------/
//virtual  apb_if vif;
function new (string name = "Apb_env_config");
super.new(name);
endfunction : new
endclass