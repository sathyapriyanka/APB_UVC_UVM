class Apb_scoreboard extends uvm_scoreboard;
// ----------------------------Factory Registration ------------------------------------------/
            `uvm_component_utils(Apb_scoreboard)
// analysis fifo declaration
             uvm_tlm_analysis_fifo#(Apb_slave_seq_item)s_fifo;
             uvm_tlm_analysis_fifo#(Apb_master_seq_item)m_fifo;
             Apb_env_config e_config;
             Apb_master_seq_item mstr_data_get; 
             Apb_slave_seq_item slv_data_get;
             Apb_master_seq_item mstr_cov_data; 
             Apb_slave_seq_item slv_cov_data;
             Apb_slave_seq_item ref_slv_data; 
// coverage
covergroup master_cover;
            option.per_instance=1;
            MASTER_PADDR : coverpoint mstr_cov_data.Paddr { bins low = {[0:3]};
                                                         bins  mid = {[4:10]}; 
                                                         bins high = {[11:15]};
                                                         }
             MASTER_PWDATA : coverpoint mstr_cov_data.Pwdata{bins low ={[0:4]};   
                                                         bins mid ={[5:12]}; 
                                                         bins high ={[13:15]};
                                                         }
             MASTER_PRDATA :coverpoint mstr_cov_data.Prdata{bins low={[0:2]};
                                                        bins  mid={[3:11]}; 
                                                        bins high={[21:15]};
                                                        }
             endgroup
  

covergroup slave_cover;
             SLAVE_PWDATA : coverpoint slv_cov_data.Pwdata{bins low = {[0:5]};
                                                    bins    mid ={[6:10]}; 
                                                    bins high ={[11:15]};
                                                   }
              SLAVE_PRDATA :  coverpoint slv_cov_data.Prdata{bins low={[0:5]};
                                                   bins   mid={[6:10]}; 
                                                  bins   high={[11:15]};}
endgroup     
//_________________________new method______________________________//
   // --------------/
function new(string name, uvm_component parent);
super.new(name, parent);
	  `uvm_info("scoreboard","object created",UVM_LOW)
                  master_cover = new();
                  slave_cover = new();
endfunction
//_________________________build phase_____________________________//  
function void  build_phase(uvm_phase phase);
super.build_phase(phase);
                if(!uvm_config_db # (Apb_env_config)::get (this,"","Apb_env_config",e_config))
                `uvm_fatal ("Apb_SB","GET Failed");
                 m_fifo = new("m_fifo",this);
                 s_fifo = new("s_fifo",this);
	  ref_slv_data = Apb_slave_seq_item::type_id::create("ref_slv_data");
endfunction
//_________________________run phase_____________________________//  

task run_phase(uvm_phase phase);  
               forever
               begin 
               begin
               m_fifo.get(mstr_data_get);
               `uvm_info("SCOREBOARD", " WRITE_CHANNEL_INFO from SCOREBOARD", UVM_LOW)
               mstr_cov_data = mstr_data_get;
               mstr_cov_data.print();
               master_cover.sample();
               end		
               begin
               s_fifo.get(slv_data_get);
              `uvm_info("SCOREBOARD", " READ_CHANNEL_INFO from SCOREBOARD", UVM_LOW)
               slv_cov_data = slv_data_get;
               slv_cov_data.print();
	slave_cover.sample();
               end
              check_data(mstr_data_get,slv_data_get);
              end
endtask
 
//_________________________comparision task_____________________________//  
task  check_data(Apb_master_seq_item mstr_data_get,Apb_slave_seq_item slv_data_get);
              if(mstr_data_get.Paddr == slv_data_get.Paddr)
              begin
            `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE PADDR MATCHED %h=%h",mstr_data_get.Paddr,slv_data_get.Paddr), UVM_LOW)
              end
             else
          `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE PADDR MIS-MATCHED ", UVM_LOW)
          if(mstr_data_get.Pwdata == slv_data_get.Pwdata)
          begin
          `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE PWDATA MATCHED %h=%h",mstr_data_get.Pwdata,slv_data_get.Pwdata), UVM_LOW)
           end
         else
          `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE PWDATA MIS-MATCHED ", UVM_LOW) 
         if(mstr_data_get.Pready == slv_data_get.Pready)
         begin
         `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE Pready MATCHED %h=%h",mstr_data_get.Pready,slv_data_get.Pready), UVM_LOW)
         end
         else
          `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE Pready MIS-MATCHED ", UVM_LOW) 
         if(mstr_data_get.Pwrite == slv_data_get.Pwrite)
         begin
         `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE PWrite MATCHED %h=%h",mstr_data_get.Pwrite,slv_data_get.Pwrite), UVM_LOW)
         end
         else
         `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE Pwrite MIS-MATCHED ", UVM_LOW) 
         if(mstr_data_get.Prdata == slv_data_get.Prdata)
        `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE PRDATA MATCHED %h=%h",mstr_data_get.Prdata,slv_data_get.Prdata), UVM_LOW)
        else
       `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE PRDATA mis MATCHED %h=%h",mstr_data_get.Prdata,slv_data_get.Prdata), UVM_LOW)
        if(mstr_data_get.Penable == slv_data_get.Penable)
        begin
        `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE Penable MATCHED %h=%h",mstr_data_get.Penable,slv_data_get.Penable), UVM_LOW)
        end
        else
        `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE Penable MIS-MATCHED ", UVM_LOW)
        if(mstr_data_get.Psel == slv_data_get.Psel)
        begin
        `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE Psel MATCHED %h=%h",mstr_data_get.Psel,slv_data_get.Psel), UVM_LOW)
        end
        else
          `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE Psel MIS-MATCHED ", UVM_LOW)
endtask      
endclass: Apb_scoreboard
	
