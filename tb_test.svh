
`include "../src/uvm_macros.svh"
//`include "tb_agnt_env.svh"
//`include "tb_sequence.svh"

//`include "tb_sequence.svh"
import uvm_pkg::*;


class NF_test extends uvm_test;
	`uvm_component_utils(NF_test)

	NF_env    		  env;
	NF_stable 		 stable_seq;
	NF_reset  		 reset_seq;
	NF_erase  		 erase_seq;
	NF_program_page	 program_seq;
	NF_read_page	 read_seq; 	

	NF_seq_1  seq1;
	NF_seq_2  seq2;
	NF_seq_3  seq3;
	NF_seq_4  seq4;
	NF_seq_5  seq5;
	NF_reset_stable reset_stable_seq;
	NF_rand_wr_rd   rand_seq1;
	NF_wrap_around wrap_arnd_seq;

//	uvm_report_info("Inside UVM TEst", "%s", UVM_NONE);
	function new(string name = "NF_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		env = NF_env::type_id::create("env", this);
		stable_seq = NF_stable::type_id::create("stable_seq");
		reset_seq  = NF_reset::type_id::create("reset_seq");
		erase_seq  = NF_erase::type_id::create("erase_seq");
		program_seq= NF_program_page::type_id::create("program_seq");
		read_seq = NF_read_page::type_id::create("read");

		reset_stable_seq = NF_reset_stable::type_id::create("reset_stable_seq");
		
		seq1 = NF_seq_1::type_id::create("seq1");
		seq2 = NF_seq_2::type_id::create("seq2");
		seq3 = NF_seq_3::type_id::create("seq3");
		seq4 = NF_seq_4::type_id::create("seq4");
		seq5 = NF_seq_5::type_id::create("seq5");
		rand_seq1 = NF_rand_wr_rd::type_id::create("gen_seq");
		wrap_arnd_seq = NF_wrap_around::type_id::create("wrap_arnd_seq");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq1.start(env.agent.sequencer);
		seq2.start(env.agent.sequencer);
		seq3.start(env.agent.sequencer);
		reset_stable_seq.start(env.agent.sequencer);
		seq4.start(env.agent.sequencer);
		seq5.start(env.agent.sequencer);
		$display("-----------------NOW EXECUTING RAND SEQUENCE--------------------");
	//	rand_seq1.start(env.agent.sequencer); 
		wrap_arnd_seq.start(env.agent.sequencer);
		phase.drop_objection(this);


	endtask : run_phase
endclass : NF_test