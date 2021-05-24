`ifndef APB__PKG
`define APB__PKG
package apb_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "slave_seq_item_and_seqs.sv"
`include "mas_seq_item_and_seqs.sv"
`include "master_sequencer.sv"
`include "slave_sequencer.sv"
`include "master_driver.sv"
`include "slave_driver.sv"
`include "master_monitor.sv"
`include "slave_monitor.sv"
`include "master_agent.sv"
`include "slave_agent.sv"
`include "env_config.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"
endpackage
`endif