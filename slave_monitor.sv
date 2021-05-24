// Apb_slave_monitor
class Apb_slave_monitor extends uvm_monitor;
// ---------------------Factory Registration ------------------------/
  	`uvm_component_utils(Apb_slave_monitor)
  	Apb_slave_seq_item Apb_monitor_slave_item;
               Apb_slave_agt_config  s_agt_config;
               virtual apb_if intf;
               uvm_analysis_port # (Apb_slave_seq_item)  s_mon_port;
  //------------------------ constructor new method -----------------------/
function new(string name = "Apb_slave_monitor", uvm_component parent);
super.new(name, parent);
              `uvm_info("Apb_slave_MONITOR","object created",UVM_LOW);
endfunction : new 
// ---------------------Build_phase Method ------------------------------//
function void build_phase(uvm_phase phase);
super.build_phase(phase);
             s_agt_config = Apb_slave_agt_config::type_id::create ("s_agt_config"); 
             Apb_monitor_slave_item = Apb_slave_seq_item::type_id::create("Apb_monitor_slave_item");
             if(!uvm_config_db # (virtual  apb_if) :: get (this,"","vms_if",s_agt_config.intf))
             `uvm_fatal ("Apb_slave_monitor ","GET Failed");
              s_mon_port = new("s_mon_port", this);
endfunction 
// ---------------------Connect_phase Method ------------------------------//
function void connect_phase (uvm_phase phase);
	intf = s_agt_config.intf;
endfunction
// ---------------------Run_phase Method ------------------------------//
task run_phase (uvm_phase phase);
super.run_phase(phase);
                forever 
	 begin
 	 collect_data();// task to collect data
	 end
  	 endtask  
  // ---------------------collect data ------------------------------/
task collect_data();
               repeat(2)
               @(intf.slv_mon_cb);
               wait(intf.slv_mon_cb.Pready==1)
               if(intf.mstr_mon_cb.Pwrite==1)
               Apb_monitor_slave_item.Pwdata = intf.slv_mon_cb.Pwdata;
               else
               Apb_monitor_slave_item.Prdata = intf.slv_mon_cb.Prdata;
               Apb_monitor_slave_item.Pready =intf.slv_mon_cb.Pready; 
               Apb_monitor_slave_item.Pwrite =intf.slv_mon_cb.Pwrite;
               Apb_monitor_slave_item.Paddr  = intf.slv_mon_cb.Paddr;
               Apb_monitor_slave_item.Psel  = intf.slv_mon_cb.Psel;
              Apb_monitor_slave_item.Penable  = intf.slv_mon_cb.Penable;
               s_mon_port.write( Apb_monitor_slave_item);
              `uvm_info("SLAVE_MONITOR",$sformatf("printing from monitor \n %s",Apb_monitor_slave_item.sprint()),UVM_LOW)
endtask
endclass