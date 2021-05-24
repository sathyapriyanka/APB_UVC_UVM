// Apb_env
class Apb_env extends uvm_env;
// ----------------------------Factory Registration ------------------------------------------/
	`uvm_component_utils(Apb_env)

 	Apb_slave_agt Apb_env_slave_agt;
	Apb_master_agt Apb_env_master_agt;
	Apb_slave_agt_config  s_agt_config;
   	Apb_master_agt_config m_agt_config;
	Apb_env_config  e_config;
               Apb_scoreboard sb;
//--------------------------- constructor new method -------------------------/
function new(string name, uvm_component parent);
super.new(name,parent);
endfunction 
// ---------------------Build_phase Method ------------------------------//
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
            if(!uvm_config_db # (Apb_env_config) :: get (this,"","Apb_env_config",e_config))
            `uvm_fatal ("Apb_env ","GET Failed");
             if(e_config.has_Apb_slave_agent)
             Apb_env_slave_agt = Apb_slave_agt :: type_id :: create("Apb_env_slave_agt", this);
              if(e_config.has_Apb_master_agent)
              Apb_env_master_agt = Apb_master_agt :: type_id :: create("Apb_env_master_agt", this);
             sb =Apb_scoreboard::type_id::create("sb",this);
             uvm_config_db # (Apb_slave_agt_config) :: set (this,"*","Apb_slave_agt_config",s_agt_config);
endfunction:build_phase
     
function void connect_phase(uvm_phase phase);
           Apb_env_master_agt.Apb_agent_master_monitor.m_mon_port.connect(sb.m_fifo.analysis_export);
           Apb_env_slave_agt.Apb_agent_slave_monitor.s_mon_port.connect(sb.s_fifo.analysis_export);
    
endfunction: connect_phase
endclass
