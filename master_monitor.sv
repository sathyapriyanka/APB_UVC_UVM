
// Apb_master_monitor
// ######################################################

class Apb_master_monitor extends uvm_monitor;
// ----------------------------Factory Registration --------------------/
	`uvm_component_utils(Apb_master_monitor)
   	Apb_master_seq_item Apb_monitor_master_item;
	Apb_master_agt_config  m_agt_config;
 	virtual apb_if intf;
  	uvm_analysis_port # (Apb_master_seq_item) m_mon_port;
//--------------------------- constructor new method -----------------/
 function new(string name = "Apb_master_monitor", uvm_component parent);
 super.new(name, parent);
              `uvm_info("Apb_master_MONITOR","object created",UVM_LOW);
 endfunction : new 
// ---------------------Build_phase Method ------------------------------//
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);
            m_agt_config = Apb_master_agt_config::type_id::create
            ("m_agt_config"); 
            Apb_monitor_master_item=Apb_master_seq_item::type_id::create
            ("Apb_monitor_master_item");   
              if(!uvm_config_db # (virtual apb_if) :: get (this,"","vms_if",m_agt_config.intf))
              begin
             `uvm_fatal ("Apb_master_monitor ","GET Failed");
              end
               m_mon_port = new("m_mon_port", this);
      
endfunction 
// ---------------------Connect_phase Method ------------------------------//
	function void connect_phase (uvm_phase phase);
	intf = m_agt_config.intf;
	endfunction
// ---------------------Run_phase Method ------------------------------//
task run_phase(uvm_phase phase);
	forever
               begin
	collect_data();
               end
endtask
  
task collect_data();
              repeat(2)
             @(intf.mstr_mon_cb);
             wait(intf.mstr_mon_cb.Pready==1 && intf.mstr_mon_cb.Penable==1);
              if(intf.mstr_mon_cb.Pwrite== 1)
              Apb_monitor_master_item.Pwdata = intf.mstr_mon_cb.Pwdata;
              else
              Apb_monitor_master_item.Prdata = intf.slv_mon_cb.Prdata;        
              Apb_monitor_master_item.Penable = intf.mstr_mon_cb.Penable;
              Apb_monitor_master_item.Psel= intf.mstr_mon_cb.Psel;   
              Apb_monitor_master_item.Paddr = intf.mstr_mon_cb.Paddr;
              Apb_monitor_master_item.Pwrite = intf.mstr_mon_cb.Pwrite;
              Apb_monitor_master_item.Pready = intf.mstr_mon_cb.Pready;
              Apb_monitor_master_item.Pslave_err= intf.mstr_mon_cb.Pslave_err;
// port connection
              m_mon_port.write(Apb_monitor_master_item);
              `uvm_info("MASTER_MONITOR",$sformatf("printing from monitor \n %s",Apb_monitor_master_item.sprint()),UVM_LOW)
       
endtask
endclass
