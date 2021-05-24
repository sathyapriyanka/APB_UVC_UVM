
// Apb_test
class Apb_test extends uvm_test;
// ----------------------------Factory Registration --------------------------------------/
	`uvm_component_utils(Apb_test)
// instance for sequence and env.
	bit has_Apb_master_agent = 1;
	bit has_Apb_slave_agent = 1;
   	Apb_master_sequence Apb_test_master_sequence;
	Apb_slave_sequence Apb_test_slave_sequence;
	Apb_env Apb_test_env;
	Apb_env_config e_config;
   	Apb_master_agt_config m_agt_config;
	Apb_slave_agt_config s_agt_config;

//--------------------------- constructor new method -------------------------/
function new(string name = "Apb_test", uvm_component parent);
super.new(name,parent);
              `uvm_info("Apb_test","object created",UVM_LOW);
endfunction : new 
// ---------------------Build_phase Method ------------------------------//
function void build_phase(uvm_phase phase);
super.build_phase(phase);
  	e_config = Apb_env_config::type_id::create("e_config");
               config_apb// task for master and slave agents
                uvm_config_db # (Apb_env_config):: set (this,"*","Apb_env_config", e_config);
                Apb_test_env=Apb_env::type_id::create ("Apb_test_env",this);
endfunction	
// ---------------------config_apb task ------------------------------//	
function  void  config_apb;	
   	if(has_Apb_master_agent)
	begin
               m_agt_config = Apb_master_agt_config::type_id::create ("m_agt_config");   
              if(!uvm_config_db # (virtual apb_if) :: get (this,"","vm_if",m_agt_config.intf))
              //   `uvm_fatal ("Apb_test","GET Failed")
	m_agt_config.is_active = UVM_ACTIVE;
	e_config.m_agt_config = m_agt_config;
	end
               if(has_Apb_slave_agent)
	begin
              s_agt_config = Apb_slave_agt_config::type_id::create ("s_agt_config");   
             if(!uvm_config_db # (virtual apb_if) :: get (this,"","vs_if",s_agt_config.intf))
            //  `uvm_fatal ("Apb_test","GET Failed");
	s_agt_config.is_active = UVM_ACTIVE;
	e_config.s_agt_config = s_agt_config;
	end
endfunction
// ---------------------Run_phase Method ------------------------------//
task  run_phase(uvm_phase phase);
	super.run_phase(phase);
// sequences starting 
 	phase.raise_objection(this);
              Apb_test_slave_sequence=Apb_slave_sequence::type_id::create("Apb_test_slave_sequence");
              Apb_test_master_sequence = Apb_master_sequence::type_id::create("Apb_test_master_sequence");
             `uvm_info("Apb_slave_TEST","Calling Apb_sequence",UVM_LOW)
              fork
              Apb_test_master_sequence.start(Apb_test_env.Apb_env_master_agt.Apb_agent_master_sequencer);
              Apb_test_slave_sequence.start(Apb_test_env.Apb_env_slave_agt.Apb_agent_slave_sequencer);
              join
              phase.phase_done.set_drain_time(this,100ns);
              phase.drop_objection(this);  
endtask : run_phase
endclass  
