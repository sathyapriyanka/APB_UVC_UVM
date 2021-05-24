// Code your testbench here
// or browse Examples

import uvm_pkg::*;
`include "uvm_macros.svh";

// #######################################################

//APB_Interface:

interface  apb_if (input bit clk);
               logic [31:0] Paddr;
	logic [31:0] Pwdata;
	logic Psel;
	logic Pwrite;
	logic Penable;
	logic Pready;
	logic [31:0] Prdata;
	logic Pslave_err;
  
clocking slv_dr_cb @(posedge clk);
	default input  #1 output  #1;
 	output  Prdata;
 	output  Pready;
 	output Pslave_err;
 	input  Paddr;
  	input  Pwdata;
  	input Psel;
  	input Pwrite;
  	input Penable;
endclocking
  
clocking  slv_mon_cb @(posedge clk);
	default input  #1 output  #1;
  	input  Prdata;
  	input  Pready;
  	input Pslave_err;	
  	input  Paddr;
  	input  Pwdata;
  	input Psel;
  	input Pwrite;
  	input Penable;
endclocking
  
clocking mstr_dr_cb @(posedge clk);
	default input  #1 output  #1;
  	input  Prdata;
  	input Pready;
  	input  Pslave_err;
 	output  Paddr;
 	output  Pwdata;
 	output Psel;
 	output Pwrite;
 	output Penable;
endclocking

clocking  mstr_mon_cb @(posedge clk);
	default input  #1 output  #1;
  	input  Prdata;
  	input  Pready;
  	input Pslave_err;
  	input  Paddr;
  	input  Pwdata;
  	input Psel;
  	input Pwrite;
  	input Penable;
endclocking
  modport BFM_slv (clocking slv_dr_cb);
  modport MON_slv (clocking slv_mon_cb);
  modport BFM_mstr (clocking mstr_dr_cb);
  modport MON_mstr (clocking mstr_mon_cb);   
endinterface
    
    //////////////////////////////////////////////////////////////////////    
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "packages.sv"
// Top module
  
module top ();
bit clk;
apb_if   masslav_if ( clk );
// clock generation  
	always
	# 5 clk = ~clk;  
 // DB Config 
 	initial
 	begin
               uvm_config_db # (virtual apb_if) :: set (null,"*","vms_if",masslav_if);
               run_test("Apb_test");		// Call run_test
 	end
 	initial
 	begin
   	$dumpfile("Apb_slave_uvm_new.vcd");
 	$dumpvars();
 	end
 	initial  
	#1000 $finish;
endmodule 



