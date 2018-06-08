
//-----------------------------------------------------------------------------------------------------------
// Class for sequencer. derived from base class uvm_sequencer.
// Parameterized to type transaction(sequence) :apb_rw. meaning the sequencer will 
// pass the transaction(sequence) apb_rw onto the driver
// If a response is needed, a response sequence can also be parameterized



`include "../src/uvm_macros.svh"
//`include "tb_seq_item.svh"
//`include "tb_sequence.svh"
import uvm_pkg::*;


//============================================================
class NF_monitor extends uvm_monitor;

// virtual interface
virtual flash_bfm vif;

uvm_analysis_port #(NF_seq_item) item_collected_port;

NF_seq_item trans_collected;

`uvm_component_utils(NF_monitor)

// constructor class
function new(string name, uvm_component parent);
	super.new(name, parent);
	trans_collected = new();
	item_collected_port = new("item_collected_port", this);
endfunction : new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual flash_bfm)::get(this, "", "vif", vif))
		`uvm_fatal("NOVIF",{"Virtual interface must be set for: ", get_full_name(), ".vif"});
endfunction 

// run phase
virtual task run_phase(uvm_phase phase);
	forever begin
		@(negedge vif.clk);
			// WRITE SEQUENCE
			if((vif.nfc_cmd == 3'b001) && (vif.BF_we))begin
				trans_collected.seq_item_RWA = vif.RWA;
				trans_collected.seq_item_BF_ad = vif.BF_ad;
				trans_collected.seq_item_BF_nfc_cmd = program_page;
				trans_collected.seq_item_BF_din = vif.BF_din;
			//	$display("MONITOR:::: DATA WRITE:::   trans_collected.seq_item_RWA : %h, trans_collected.seq_item_BF_nfc_cmd : %b seq_item_BF_ad : %h , trans_collected.seq_item_BF_din : %h",trans_collected.seq_item_RWA, trans_collected.seq_item_BF_nfc_cmd, trans_collected.seq_item_BF_ad, trans_collected.seq_item_BF_din);
				item_collected_port.write(trans_collected);
			end 
			// READ SEQUENCE
			else if((vif.nfc_cmd == 3'b010) && (vif.nfc_done == 1'b1) && (vif.BF_ad < 7'hff)) begin
				trans_collected.seq_item_RWA = vif.RWA;
				trans_collected.seq_item_BF_ad = vif.BF_ad - 1;
				trans_collected.seq_item_BF_nfc_cmd = read_page;
				trans_collected.seq_item_BF_din = vif.BF_dou;
				item_collected_port.write(trans_collected);
			end	
			// ERASE SEQUENCE
			else if((vif.nfc_cmd == 3'b100))begin
				trans_collected.seq_item_RWA = vif.RWA;
				trans_collected.seq_item_BF_nfc_cmd = erase;
				item_collected_port.write(trans_collected);
			end

	end // forever
endtask : run_phase
 



endclass : NF_monitor