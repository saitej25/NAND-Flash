
`include "../src/uvm_macros.svh"
import uvm_pkg::*;

class NF_agent extends uvm_agent;

// Declaring agent components
NF_driver      driver;
NF_sequencer   sequencer;
NF_monitor  monitor;

// Factory registration of UVM component
`uvm_component_utils(NF_agent)

// constructor class
function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction : new

// build phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(get_is_active() == UVM_ACTIVE) begin
		driver    = NF_driver::type_id::create("driver", this);
		sequencer = NF_sequencer::type_id::create("sequencer", this);
	end // if(get_is_active() == UVM_ACTIVE)
	 monitor = NF_monitor::type_id::create("monitor", this);	
endfunction : build_phase

//Connect phase
function void connect_phase(uvm_phase phase);
	if(get_is_active() == UVM_ACTIVE) begin
		driver.seq_item_port.connect(sequencer.seq_item_export);
		uvm_report_info("NF_agent::", "connect_phase, Connected Driver to Sequencer");
	end // if(get_is_active() == UVM_ACTIVE)
endfunction : connect_phase

endclass : NF_agent



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