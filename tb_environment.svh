


`include "../src/uvm_macros.svh"
import uvm_pkg::*;

class NF_env extends uvm_env;

	NF_agent agent;
	NF_scoreboard scoreboard;

	`uvm_component_utils(NF_env);

// Constructir class
function new(string name, uvm_component parent = null);
	super.new(name, parent);
endfunction : new	

// buildphase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	agent = NF_agent::type_id::create("agent", this);
	scoreboard = NF_scoreboard::type_id::create("scoreboard", this);
	//scb = NF_scoreboard::type_id::create("NF_scoreboard", this);
endfunction : build_phase

// connect phase
function void connect_phase(uvm_phase phase);
	agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
endfunction : connect_phase


endclass : NF_env