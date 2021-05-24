

// Apb_slave_driver	
class Apb_slave_driver extends uvm_driver #(Apb_slave_seq_item);
// -----------------------Factory Registration --------------------------/
          `uvm_component_utils(Apb_slave_driver); 
// instance of transaction class and virtual interface   
           Apb_slave_seq_item Apb_slave_driver_seq_item;
           Apb_slave_agt_config  s_agt_config;
           virtual apb_if intf;
//------------------------ constructor new method -------------------------/
function new(string name = "Apb_slave_driver", uvm_component parent);
super.new(name,parent);
           `uvm_info("Apb_slave_DRIVER","object created",UVM_LOW);
endfunction 
// ---------------------Build_phase Method ------------------------------//
function void build_phase(uvm_phase phase);
super.build_phase(phase);
            s_agt_config = Apb_slave_agt_config::type_id::create("s_agt_config");  
            if(!uvm_config_db # (virtual  apb_if) :: get (this,"","vms_if",s_agt_config.intf))
           `uvm_fatal("Apb_slave_driver","GET Failed");
endfunction 
// ---------------------Connect_phase Method ------------------------------//
function void connect_phase (uvm_phase phase);
           intf = s_agt_config.intf;
endfunction
// ---------------------Run_phase Method ------------------------------/
task run_phase (uvm_phase phase);
super.run_phase(phase);
           @(intf.slv_dr_cb);
           forever
           begin     
           seq_item_port.get_next_item(req);
           send_to_dut(req);
           seq_item_port.item_done(req);
           end
endtask   
 // ---------------------send to dut------------------------------/ 
task send_to_dut(Apb_slave_seq_item Apb_slave_driver_seq_item);
            @(intf.slv_dr_cb);
            if(intf.mstr_mon_cb.Pwrite==0 && intf.mstr_mon_cb.Psel==1)
            begin
            intf.slv_dr_cb.Prdata <= Apb_slave_driver_seq_item.Prdata;      	
            intf.slv_dr_cb.Pslave_err <=Apb_slave_driver_seq_item.Pslave_err;
            @(intf.slv_dr_cb);
            if(intf.slv_mon_cb.Penable==1) 
            intf.slv_dr_cb.Pready <=1 ;
            @(intf.slv_dr_cb);
            intf.slv_dr_cb.Pready <=0 ;
           `uvm_info("SLAVE_DRIVER",$sformatf("printing from slave drivern %s",Apb_slave_driver_seq_item.sprint()),UVM_LOW);
            end
            else  if(intf.mstr_mon_cb.Pwrite==1 && intf.mstr_mon_cb.Psel==1)
            begin
           @(intf.slv_dr_cb);
            if(intf.slv_mon_cb.Penable==1)       
            intf.slv_dr_cb.Pready <=1 ;     	
            intf.slv_dr_cb.Pslave_err <=Apb_slave_driver_seq_item.Pslave_err;
            @(intf.slv_dr_cb);
            intf.slv_dr_cb.Pready <=0 ;
           `uvm_info("SLAVE_DRIVER",$sformatf("printing from slave drivern %s",Apb_slave_driver_seq_item.sprint()),UVM_LOW);
            end
endtask 	  	 
endclass : Apb_slave_driver
