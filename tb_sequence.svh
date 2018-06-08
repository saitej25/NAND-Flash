/*--------------------------------------------------------------------------------
tb_sequences.svh - Create an Nand flash sequence class that generate randon sequence items

-Sits outside the UVM hierarcy. Has no parent item in its constructor. 
- Sends the data into UVM hierarchy through uvm sequencer.



- Derived from uvm_sequence. parameterized with sequence item type
- implement the body() method. 
- sequence is usually a for/repeat loop that creates transaction 'n' times,
  randomizes it and then following the API handshake with sequencer and driver
  
body() - Logic to genrate and send the sequence_item is written inside body method
-----------------------------------------------------------------------------------*/

`include "../src/uvm_macros.svh"
//`include "tb_seq_item.svh"
//import cmd_pkg::*;
import uvm_pkg::*;
import flash_pkg::*;

class NF_gen_seq extends uvm_sequence#(NF_seq_item);

	//`uvm_sequence_utils(NF_gen_seq, NF_sequencer)
	`uvm_object_utils(NF_gen_seq)


	// Constructor class
	function new(string name = "base_seq");
		super.new(name);      

	endfunction : new

	// Task to generate random sequences
	// Main Body Method
	// Launches this task when it starts our sequences
	// UVM calls the body task when someone starts the sequence
	virtual task body();
		NF_seq_item req;
		req = NF_seq_item::type_id::create("req");

		repeat(100) begin
			wait_for_grant();
			req.randomize();
			send_request(req);
			wait_for_item_done();
	    end

	endtask : body

endclass : NF_gen_seq


class NF_stable extends uvm_sequence#(NF_seq_item);

		`uvm_object_utils(NF_stable)

	// Constructor Class
	function new(string name = "all_ops");
		super.new(name);
	endfunction : new

	virtual task body();
	NF_seq_item  gen_seq;
	gen_seq = NF_seq_item::type_id::create("all_ops");   // generate handle of sequence item


	wait_for_grant();									// wait for sequence item grant
	gen_seq.seq_item_RWA = 16'h0C04;					// directed address	
	gen_seq.seq_item_BF_we = 1'b0;						// directed 
	gen_seq.seq_item_BF_nfc_cmd = stable;
	send_request(gen_seq);
	wait_for_item_done();

	endtask
endclass : NF_stable


class NF_reset extends uvm_sequence#(NF_seq_item);

		`uvm_object_utils(NF_reset)

	// Constructor Class
	function new(string name = "RESET");
		super.new(name);
	endfunction : new

	virtual task body();
	NF_seq_item  gen_seq;
	gen_seq = NF_seq_item::type_id::create("RESET");


	wait_for_grant();
	gen_seq.seq_item_BF_we = 1'b0;
	gen_seq.seq_item_BF_nfc_cmd = reset;
	$display("\n::::::::::::::::::  RESET COMMAND ::::::::::::::::::::");
	send_request(gen_seq);
	wait_for_item_done();

	endtask
endclass : NF_reset


class NF_erase extends uvm_sequence#(NF_seq_item);

		`uvm_object_utils(NF_erase)

	// Constructor Class
	function new(string name = "ERASE");
		super.new(name);
	endfunction : new

	virtual task body();
	NF_seq_item  gen_seq;
	gen_seq = NF_seq_item::type_id::create("ERASE");


	wait_for_grant();
	gen_seq.seq_item_RWA = 16'h0C04;
	gen_seq.seq_item_BF_we = 1'b0;
	gen_seq.seq_item_BF_nfc_cmd = erase;
	$display("\n:::::::::::::::::: ERASE COMMAND ::::::::::::::::::::");
	send_request(gen_seq);
	wait_for_item_done();

	endtask
endclass : NF_erase


class NF_program_page extends uvm_sequence#(NF_seq_item);

		`uvm_object_utils(NF_program_page)

	// Constructor Class
	function new(string name = "PROGRAM_PAGE");
		super.new(name);
	endfunction : new

	virtual task body();
	NF_seq_item  gen_seq;
	gen_seq = NF_seq_item::type_id::create("PROGRAM_PAGE");	 //create handle of sequence item


	wait_for_grant();										// wait for sequence item grant
	gen_seq.seq_item_RWA = 16'h0006;						// assign directed address
	gen_seq.seq_item_BF_we = 1'b1;							// drive write enable
	gen_seq.seq_item_BF_nfc_cmd = program_page;				// provide write command
	$display("\n:::::::::::::::::: PROGRAM_PAGE :::::::::::::::::::::");
	$display("--------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
	send_request(gen_seq);									// send the packet to sequncer
	wait_for_item_done();

	endtask
endclass : NF_program_page


class NF_read_page extends uvm_sequence#(NF_seq_item);

		`uvm_object_utils(NF_read_page)

	// Constructor Class
	function new(string name = "READ_PAGE");
		super.new(name);
	endfunction : new

	virtual task body();
	NF_seq_item  gen_seq;
	gen_seq = NF_seq_item::type_id::create("READ_PAGE");


	wait_for_grant();
	gen_seq.seq_item_RWA = 16'h0C04;
	gen_seq.seq_item_BF_we = 1'b0;
	gen_seq.seq_item_BF_nfc_cmd = read_page;
	$display("\n:::::::::::::::::: READ_PAGE ::::::::::::::::::::::::");
	$display("-------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
	send_request(gen_seq);
	wait_for_item_done();

	endtask
endclass : NF_read_page


















//==============================================================================
// Sequence item of Write command
class NF_seq_1 extends uvm_sequence#(NF_seq_item);

	`uvm_object_utils(NF_seq_1)

	// Constructor Class
	function new(string name = "all_ops");
		super.new(name);
	endfunction : new

	virtual task body();
		NF_seq_item  gen_seq;
		gen_seq = NF_seq_item::type_id::create("all_ops");
/*
		wait_for_grant();
		gen_seq.seq_item_RWA = 16'h1234;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = sys_reset;
		send_request(gen_seq);
		wait_for_item_done();
*/

		wait_for_grant();
		gen_seq.seq_item_RWA = 16'h0006;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = stable;
		send_request(gen_seq);
		wait_for_item_done();

		// reset
		wait_for_grant();
		//gen_seq.seq_item_RWA = 16'h1234;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = reset;
		$display("\n::::::::::::::::::  RESET COMMAND ::::::::::::::::::::");
		send_request(gen_seq);
		wait_for_item_done();

		// erase
		wait_for_grant();
		gen_seq.seq_item_RWA = 16'h0006;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = erase;
		$display("\n:::::::::::::::::: ERASE COMMAND ::::::::::::::::::::");
		send_request(gen_seq);
		wait_for_item_done();

		// program page
		wait_for_grant();
		gen_seq.seq_item_RWA = 16'h0006;
		gen_seq.seq_item_BF_we = 1'b1;
		gen_seq.seq_item_BF_nfc_cmd = program_page;
		$display("\n:::::::::::::::::: PROGRAM_PAGE :::::::::::::::::::::");
		$display("--------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
		send_request(gen_seq);
		wait_for_item_done();
		

		wait_for_grant();
		gen_seq.seq_item_RWA = 16'h0006;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = read_page;
		$display("\n:::::::::::::::::: READ_PAGE ::::::::::::::::::::::::");
		$display("-------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
		send_request(gen_seq);
		wait_for_item_done();

		wait_for_grant();
		gen_seq.seq_item_RWA = 16'h0006;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = reset;
		$display("\n::::::::::::::::::  RESET COMMAND ::::::::::::::::::::");
		send_request(gen_seq);
		wait_for_item_done();
	   


/*
		wait_for_grant();
		gen_seq.seq_item_RWA = 16'h1234;
		gen_seq.seq_item_BF_we = 1'b1;
		gen_seq.seq_item_BF_nfc_cmd = program_page;
		send_request(gen_seq);
		wait_for_item_done();

*/
		
	endtask

endclass


//===============================================================================
// Writing to the same block but different page.
// Reading from the same address to which it was written
class NF_seq_2 extends uvm_sequence#(NF_seq_item);

`uvm_object_utils(NF_seq_2)

	// Constructor Class
	function new(string name = "5_writes");
		super.new(name);
	endfunction : new


	virtual task body();
		logic [15:0] base_w = 16'h00EF;
		logic [15:0] base_r = 16'h00EF;
		NF_seq_item  gen_seq;
		gen_seq = NF_seq_item::type_id::create("5_writes");
		 
		repeat(5) begin
			wait_for_grant();
			//	gen_seq.randomize();
				gen_seq.seq_item_RWA = base_w + 16'h0001;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = program_page; 
				base_w = gen_seq.seq_item_RWA;
				$display("\n:::::::::::::::::: PROGRAM_PAGE :::::::::::::::::::::");
				$display("--------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();
	    end

	  	repeat(5) begin
			wait_for_grant();
			//	gen_seq.randomize();
				gen_seq.seq_item_RWA = base_r + 16'h0001;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = read_page; 
				base_r = gen_seq.seq_item_RWA;
				$display("\n:::::::::::::::::: READ_PAGE ::::::::::::::::::::::::");
				$display("------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();
	  	end

	  	wait_for_grant();
		gen_seq.seq_item_RWA = 16'h0C04;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = reset;
		$display("\n::::::::::::::::::  RESET COMMAND ::::::::::::::::::::");
		send_request(gen_seq);
		wait_for_item_done();

				wait_for_grant();
		gen_seq.seq_item_RWA = 16'h0C04;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = stable;
		send_request(gen_seq);
		wait_for_item_done();

		// reset
		wait_for_grant();
		//gen_seq.seq_item_RWA = 16'h1234;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = reset;
		$display("\n::::::::::::::::::  RESET COMMAND ::::::::::::::::::::");
		send_request(gen_seq);
		wait_for_item_done();

		// erase
		wait_for_grant();
		gen_seq.seq_item_RWA = 16'h0C04;
		gen_seq.seq_item_BF_we = 1'b0;
		gen_seq.seq_item_BF_nfc_cmd = erase;
		$display("\n:::::::::::::::::: ERASE COMMAND ::::::::::::::::::::");
		send_request(gen_seq);
		wait_for_item_done();

	endtask : body

endclass

class NF_reset_stable extends uvm_sequence#(NF_seq_item);

`uvm_object_utils(NF_reset_stable)

	// Constructor Class
	function new(string name = "5_writes");
		super.new(name);
	endfunction : new


	virtual task body();
		logic [15:0] base_w = 16'h0A00;
		logic [15:0] base_r = 16'h0A00;
		NF_seq_item  gen_seq;
		gen_seq = NF_seq_item::type_id::create("5_writes");
		 
			wait_for_grant();
				gen_seq.seq_item_RWA = 16'h0C04;
				gen_seq.seq_item_BF_we = 1'b0;
				gen_seq.seq_item_BF_nfc_cmd = stable;
				send_request(gen_seq);
			wait_for_item_done();
	
				// reset
			wait_for_grant();
				//gen_seq.seq_item_RWA = 16'h1234;
				gen_seq.seq_item_BF_we = 1'b0;
				gen_seq.seq_item_BF_nfc_cmd = reset;
				$display("\n::::::::::::::::::  RESET COMMAND ::::::::::::::::::::");
				send_request(gen_seq);
			wait_for_item_done();


	endtask : body

endclass



//Writing to different blocks with same page.
// Reading from the same locations
class NF_seq_3 extends uvm_sequence#(NF_seq_item);

`uvm_object_utils(NF_seq_3)

	// Constructor Class
	function new(string name = "5_writes");
		super.new(name);
	endfunction : new


	virtual task body();
		logic [15:0] base_w = 16'h0A00;
		logic [15:0] base_r = 16'h0A00;
		NF_seq_item  gen_seq;
		gen_seq = NF_seq_item::type_id::create("5_writes");
		 
		repeat(5) begin
			wait_for_grant();
			//	gen_seq.randomize();
				gen_seq.seq_item_RWA = base_w + 16'h0010;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = program_page; 
				base_w = gen_seq.seq_item_RWA;
				$display("\n:::::::::::::::::: PROGRAM_PAGE :::::::::::::::::::::");
				$display("-------------------RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();
	    end

	  	repeat(5) begin
			wait_for_grant();
			//	gen_seq.randomize();
				gen_seq.seq_item_RWA = base_r + 16'h0010;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = read_page; 
				base_r = gen_seq.seq_item_RWA;
				$display("\n:::::::::::::::::: READ_PAGE ::::::::::::::::::::::::");
				$display("------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();
	  	end


	endtask : body

endclass


//Write and read from first and last locations
class NF_seq_4 extends uvm_sequence#(NF_seq_item);

`uvm_object_utils(NF_seq_4)

	// Constructor Class
	function new(string name = "5_writes");
		super.new(name);
	endfunction : new


	virtual task body();
		logic [15:0] base_w = 16'h0A00;
		logic [15:0] base_r = 16'h0A00;
		NF_seq_item  gen_seq;
		gen_seq = NF_seq_item::type_id::create("5_writes");

			wait_for_grant();
				gen_seq.seq_item_RWA = 16'h0000;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = program_page; 				
				$display("\n:::::::::::::::::: PROGRAM_PAGE :::::::::::::::::::::");
				$display("-------------------RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();
	    
			wait_for_grant();
				gen_seq.seq_item_RWA = 16'h0000;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = read_page;
				$display("\n:::::::::::::::::: READ_PAGE ::::::::::::::::::::::::");
				$display("------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();

			wait_for_grant();
				gen_seq.seq_item_RWA = 16'hFFFF;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = program_page; 				
				$display("\n:::::::::::::::::: PROGRAM_PAGE :::::::::::::::::::::");
				$display("-------------------RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();
	    
			wait_for_grant();
				gen_seq.seq_item_RWA = 16'hFFFF;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = read_page;
				$display("\n:::::::::::::::::: READ_PAGE ::::::::::::::::::::::::");
				$display("------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();
	  	


	endtask : body

endclass 


// write followed by erase followed by read
class NF_seq_5 extends uvm_sequence#(NF_seq_item);

`uvm_object_utils(NF_seq_5)

	// Constructor Class
	function new(string name = "5_writes");
		super.new(name);
	endfunction : new


	virtual task body();
		logic [15:0] base_w = 16'h0A00;
		logic [15:0] base_r = 16'h0A00;
		NF_seq_item  gen_seq;
		gen_seq = NF_seq_item::type_id::create("5_writes");


			wait_for_grant();
				gen_seq.seq_item_RWA = 16'h1234;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = program_page; 				
				$display("\n:::::::::::::::::: PROGRAM_PAGE :::::::::::::::::::::");
				$display("-------------------RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();

					// erase
			wait_for_grant();
				gen_seq.seq_item_RWA = 16'h1234;
				gen_seq.seq_item_BF_we = 1'b0;
				gen_seq.seq_item_BF_nfc_cmd = erase;
				$display("\n:::::::::::::::::: ERASE COMMAND ::::::::::::::::::::");
				send_request(gen_seq);
			wait_for_item_done();
	    
			wait_for_grant();
				gen_seq.seq_item_RWA = 16'h1234;
				gen_seq.seq_item_BF_we = 1'b0;
				gen_seq.seq_item_BF_nfc_cmd = read_page;
				$display("\n:::::::::::::::::: READ_PAGE ::::::::::::::::::::::::");
				$display("------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();

	endtask : body
endclass 

// write followed by erase followed by read
class NF_rand_wr_rd extends uvm_sequence#(NF_seq_item);

`uvm_object_utils(NF_rand_wr_rd)

	// Constructor Class
	function new(string name = "5_writes");
		super.new(name);
	endfunction : new


	virtual task body();

		NF_seq_item  rand_seq;
		rand_seq = NF_seq_item::type_id::create("rand_seq");

		repeat(100) begin
		wait_for_grant();
			rand_seq.randomize() with {rand_seq.seq_item_RWA <= 'd10; rand_seq.seq_item_RWA >= 'b0; 
									   rand_seq.seq_item_BF_nfc_cmd <= 'd2;  rand_seq.seq_item_BF_nfc_cmd > 'd0;};
		send_request(rand_seq);
		wait_for_item_done();
	    end

	endtask : body

endclass


// Memory Wrap around condition.
class NF_wrap_around extends uvm_sequence#(NF_seq_item);

`uvm_object_utils(NF_wrap_around)

	// Constructor Class
	function new(string name = "NF_wrap_around");
		super.new(name);
	endfunction : new


	virtual task body();

		NF_seq_item  gen_seq;
		gen_seq = NF_seq_item::type_id::create("gen_seq");

			wait_for_grant();
				gen_seq.seq_item_RWA = 16'hFFFF + 16'h0001;
				gen_seq.seq_item_BF_we = 1'b1;
				gen_seq.seq_item_BF_nfc_cmd = program_page	; 				
				$display("\n:::::::::::::::::: PROGRAM_PAGE :::::::::::::::::::::");
				$display("-------------------RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();

			wait_for_grant();
				gen_seq.seq_item_RWA = 16'hFFFF + 16'h0001;
				gen_seq.seq_item_BF_we = 1'b0;
				gen_seq.seq_item_BF_nfc_cmd = read_page;
				$display("\n:::::::::::::::::: READ_PAGE ::::::::::::::::::::::::");
				$display("------------------- RWA : %h ----------------------", gen_seq.seq_item_RWA);
			send_request(gen_seq);
			wait_for_item_done();

	    

	endtask : body

endclass

