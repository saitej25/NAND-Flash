`include "../src/uvm_macros.svh"
//`include "tb_seq_item.svh"
//`include "tb_sequence.svh"
import uvm_pkg::*;

// Memory array for internal storage.
//logic [7:0]memory[0:2047];

//logic [7:0] temp;

//===========================================================================
// Sequencer Class
class NF_sequencer extends uvm_sequencer #(NF_seq_item);

// class registration in uvm_factory
`uvm_component_utils(NF_sequencer)

// Constructor class 
function new(string name,uvm_component parent);
	super.new(name);
endfunction : new	

endclass : NF_sequencer
