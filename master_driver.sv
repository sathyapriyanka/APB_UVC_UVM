
// Apb_master_driver	
class Apb_master_driver extends uvm_driver #(Apb_master_seq_item);
// --------------------Factory Registration --------------------------/
         `uvm_component_utils(Apb_master_driver)
// instance of transaction class and virtual interface    
          Apb_master_agt_config  m_agt_config;
          virtual apb_if intf;
          Apb_master_seq_item Apb_master_driver_seq_item;
          Apb_slave_seq_item Apb_slave_driver_seq_item;
          bit [31:0]temp;
//--------------------------- constructor new method -------------------------/
function new(string name = "Apb_master_driver", uvm_component parent);
super.new(name,parent);
       `uvm_info("Apb_master_DRIVER","object created",UVM_LOW);
endfunction 
// ---------------------Build_phase Method ------------------------------//
function void build_phase(uvm_phase phase);
super.build_phase(phase);
        m_agt_config = Apb_master_agt_config::type_id::create("m_agt_config"); 
        if(!uvm_config_db # (virtual  apb_if) :: get (this,"","vms_if",m_agt_config.intf))
        `uvm_fatal("Apb_master_driver","GET Failed");
endfunction
// ---------------------Connect_phase Method ------------------------------//
function void connect_phase (uvm_phase phase);
          intf = m_agt_config.intf;
endfunction
// ---------------------Run_phase Method ------------------------------//
task run_phase(uvm_phase phase);
         forever
         begin
         seq_item_port.get_next_item(req);
         send_to_dut(req);
         seq_item_port.item_done(req);
end
endtask
// ---------------------sending to dut ------------------------------//	
task send_to_dut(Apb_master_seq_item Apb_master_driver_seq_item);	@(intf.mstr_dr_cb);
        if(Apb_master_driver_seq_item.Pwrite==1 && Apb_master_driver_seq_item.Psel==1)
        begin
        intf.mstr_dr_cb.Pwrite <=Apb_master_driver_seq_item.Pwrite;
        intf.mstr_dr_cb.Psel <= Apb_master_driver_seq_item.Psel;
        intf.mstr_dr_cb.Paddr   <= Apb_master_driver_seq_item.Paddr;
        intf.mstr_dr_cb.Pwdata  <= Apb_master_driver_seq_item.Pwdata;
        intf.mstr_dr_cb.Penable <= 0;
       @(intf.mstr_dr_cb)
        intf.mstr_dr_cb.Penable <= 1;
        wait(intf.slv_mon_cb.Pready==1)
        intf.mstr_dr_cb.Penable <= 0;
        intf.mstr_dr_cb.Psel     <= 0;
        end     
        else if(Apb_master_driver_seq_item.Pwrite==0 && Apb_master_driver_seq_item.Psel==1)
        begin
        intf.mstr_dr_cb.Pwrite<=0;
        intf.mstr_dr_cb.Psel <= Apb_master_driver_seq_item.Psel;
        intf.mstr_dr_cb.Paddr   <= Apb_master_driver_seq_item.Paddr;
        intf.mstr_dr_cb.Penable <= 0;
        @(intf.mstr_dr_cb)
        intf.mstr_dr_cb.Penable <= 1;
        wait(intf.mstr_mon_cb.Pready==1)
        intf.mstr_dr_cb.Penable <= 0;
        intf.mstr_dr_cb.Psel     <= 0;
        end	   
       `uvm_info("MASTER_DRIVER",$sformatf("printing from write drivern %s",Apb_master_driver_seq_item.sprint()),UVM_LOW);
endtask
endclass : Apb_master_driver

// ###########################################################
