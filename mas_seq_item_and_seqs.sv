// master_agt_config      
class Apb_master_agt_config extends uvm_object;
// ----------------------------Factory Registration -----------------/
              `uvm_object_utils (Apb_master_agt_config)
	virtual interface  apb_if  intf;
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	function new (string name  = "Apb_master_agt_config");
 	super.new(name);
	endfunction 
endclass
      // ######################################################

//MASTER_TRANSACTION:
class Apb_master_seq_item extends uvm_sequence_item;
// ----------------------------Factory Registration ------------------------/
         `uvm_object_utils(Apb_master_seq_item)      
          rand bit [31:0] Pwdata;
          rand bit [31:0] Paddr;  
          rand bit  Pwrite;
          rand bit Psel;
          rand  bit Penable;
          bit [31:0] Prdata;
          bit Pslave_err;
          bit Pready;
// constraints
         constraint  solving{ solve Paddr before Pwdata; }
         constraint  Pwrite_cons { Pwrite dist { 0 := 1, 1 := 1}; }
         constraint  C1{Paddr[31:0]>=32'd0;  Paddr[31:0] <32'd256; }
        //constraint  C2{Prdata[31:0]>=32'd0;  Prdata[31:0] <32'd256; }
        constraint c3{Psel==1;}
  
  //  ------------------Standard UVM Methods --------------------------------/
//----------------------- constructor new method -------------------------/
function new (string name="Apb_master_seq_item");
super.new(name);
endfunction : new
//----------------------- print -------------------------/
function void do_print(uvm_printer printer);
super.do_print(printer);
       printer.print_field("PRDATA", Prdata,32,UVM_DEC);
       printer.print_field("PADDR", Paddr,32,UVM_DEC);
       printer.print_field("PW_DATA", Pwdata,32,UVM_DEC);
       printer.print_field("P_WRITE", Pwrite,1,UVM_DEC);
       printer.print_field("P_sel", Psel,1,UVM_DEC);
       printer.print_field("P_enable", Psel,1,UVM_DEC);
       printer.print_field("P_ready", Pready,1,UVM_DEC);
endfunction
endclass : Apb_master_seq_item
      
//  #####################################################################

// Apb_master_sequence
class Apb_master_sequence extends uvm_sequence #(Apb_master_seq_item); 
// ----------------------------Factory Registration ------------------------/
	`uvm_object_utils(Apb_master_sequence)	
//instance of seq_item
 	Apb_master_seq_item Apb_master_sequence_seq_item;
function  new (string name = "Apb_master_sequence");
super.new(name);
              Apb_master_sequence_seq_item=Apb_master_seq_item::type_id::create("Apb_master_sequence_seq_item");
endfunction  : new
// ----------------------------body ------------------------/
task body();
                repeat(10)
	 begin
                `uvm_do_with(Apb_master_sequence_seq_item,{Pwrite==0;})
               // `uvm_do_with(Apb_master_sequence_seq_item,{Pwrite==1;})
              // `uvm_do_with(Apb_master_sequence_seq_item,{Pwdata<=32'd16;})
 	end
endtask
endclass : Apb_master_sequence
    
     
	