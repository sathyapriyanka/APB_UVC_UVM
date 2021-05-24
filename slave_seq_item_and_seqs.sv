//Apb_Slave_agt_config:
class Apb_slave_agt_config extends  uvm_object;
// ----------------------------Factory Registration ------------------------/
	`uvm_object_utils (Apb_slave_agt_config)
	virtual interface apb_if  intf;
	uvm_active_passive_enum  is_active = UVM_ACTIVE;
// ----------------------------new method ------------------------/
function new (string name  = "Apb_slave_agt_config");
super.new(name);
endfunction 
endclass: Apb_slave_agt_config
      // ######################################################

//SLAVE_TRANSACTION:
class Apb_slave_seq_item extends uvm_sequence_item;
             `uvm_object_utils(Apb_slave_seq_item)      
             rand bit [31:0] Prdata;
             rand  bit Pready;
             rand bit Pslave_err;
             bit[31:0] Pwdata;
             bit[31:0] Paddr;
             bit Pwrite;
             bit Psel;
             bit Penable;
// constraints
              constraint  C2{Prdata[31:0]>=32'd0;  Prdata[31:0] <32'd256; }
             //constraint  Pready_cons { Pready dist { 0 := 10, 1 := 10}; }
  	constraint Pslave_err_cons{Pslave_err== 0;}
  
//--------------------------- constructor new method ---------------------/
function new (string name="Apb_slave_seq_item");
super.new(name);
endfunction 
// ----------------------------Print method ------------------------/
function void do_print(uvm_printer printer);
super.do_print(printer);
    printer.print_field("PRDATA", Prdata,32,UVM_DEC);
    printer.print_field("Pready", Pready,1,UVM_DEC);
    printer.print_field("Pslave_err", Pslave_err,1,UVM_DEC);
    printer.print_field("PWDATA",Pwdata,32,UVM_DEC);
    printer.print_field("Paddr",Paddr,32,UVM_DEC);
    printer.print_field("Pwrite",Pwrite,1,UVM_DEC);
endfunction
endclass : Apb_slave_seq_item
      
//  #####################################################################
// Apb_slave_sequence
class Apb_slave_sequence extends uvm_sequence #(Apb_slave_seq_item); 
// ------------------------Factory Registration -------------------------/
	`uvm_object_utils(Apb_slave_sequence)	
// ----------------------------new method ------------------------/
function new (string name = "Apb_slave_sequence");
super.new(name);
endfunction  
// ----------------------------body ------------------------/
task body();
                repeat(10)
	 begin
               //`uvm_do(Apb_slave_sequence_seq_item);
	req = Apb_slave_seq_item::type_id::create("req");
  	start_item(req);
               req.randomize with {};
	finish_item(req);
  	get_response(req);
              //Apb_slave_sequence_seq_item.print();
	end
endtask 
endclass : Apb_slave_sequence
