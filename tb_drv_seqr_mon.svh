
//-----------------------------------------------------------------------------------------------------------
// Class for sequencer. derived from base class uvm_sequencer.
// Parameterized to type transaction(sequence) :apb_rw. meaning the sequencer will 
// pass the transaction(sequence) apb_rw onto the driver
// If a response is needed, a response sequence can also be parameterized



`include "../src/uvm_macros.svh"
//`include "tb_seq_item.svh"
`include "tb_sequence.svh"
import uvm_pkg::*;

// Memory array for internal storage.
//logic [7:0]memory[0:2047];

//logic [7:0] temp;

//===========================================================================
// Sequencer Class
class NF_sequencer extends uvm_sequencer #(NF_seq_item);

// class registration in uvm_factory
`uvm_object_utils(NF_sequencer)

// Constructor class 
function new(string name = "NF_sequencer");
	super.new(name);
endfunction : new	

endclass : NF_sequencer

//============================================================================
// Driver Class

class NF_driver extends uvm_driver#(NF_seq_item);	
	logic [7:0]memory[0:2047];

logic [7:0] temp;

// Class registration in uvm_factory
	`uvm_component_utils(NF_driver)

// Since the driver interacts with the DUT via the interface, we need to create a 
// virtual interface handle in the driver class
	virtual flash_bfm vif;

// Constructor Class
function new(string name = "NF_driver", uvm_component parent = null);
	super.new(name, parent);
endfunction : new

// Build Phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual flash_bfm)::get(this, "", "vif",vif))
		`uvm_fatal("NO_VIF", {"Virtual Interface must be set for:", get_full_name(), ".vif"});
endfunction : build_phase

// Run Phase
virtual task run_phase(uvm_phase phase);
	forever begin
		NF_seq_item tr;

		@(this.vif.clk);
		seq_item_port.get_next_item(tr);
		$display("seq_id_cmd: %d", tr.seq_item_BF_nfc_cmd);

		@(this.vif.clk);
		case (tr.seq_item_BF_nfc_cmd)
			3'b011    : reset();
			3'b010    : read_cycle(tr.seq_item_RWA);
			3'b110    : drive_reset();
			3'b001    : drive_write(tr.seq_item_RWA);
			3'b100    : erase_cycle(tr.seq_item_RWA);
			3'b000	  : stable();
						
		endcase // tr.seq_item_BF_nfc_cmd
	/*	if(tr.seq_item_BF_nfc_cmd != 3'b110) begin	
							vif.BF_we = 1'b0;	
							wait(this.vif.nfc_done);
							@(posedge vif.clk);
							#3;
							vif.nfc_cmd = 3'b111;
							//read_buffer();			
						end
		if(tr.seq_item_BF_nfc_cmd == 3'b010) begin
			$display("inside READ BUFFER LOOP");
			read_buffer();
		end // if(tr.send_item_BF_nfc_cmd != 3'b010)

		vif.BF_sel = 1'b0;
*/
		seq_item_port.item_done();
	end // forever
endtask : run_phase

virtual task read_buffer();
	$display("INSIDE READ BUFFER");
	@(posedge vif.clk);
	wait(vif.nfc_done);
	@(posedge vif.clk);
	//#3;
	vif.nfc_cmd=3'b111;
	vif.BF_ad<= vif.BF_ad+1;
	for(int i=0;i<2048;i=i+1)begin
		@(posedge vif.clk);
		temp<=memory[i];
		vif.BF_ad<= vif.BF_ad+1;
	end // for(i=0;i<2048;i=i+1)

	if(vif.RErr)                                         
     $display($time,"  %m  \t \t  << ecc error >>");    
   else                                             
     $display($time,"  %m  \t \t  << ecc no error >>"); 

 	kill_time;
 	kill_time;
endtask : read_buffer


// Task for reset command
virtual task drive_reset();
	vif.system_reset(2);
	$display("RESET DONE");
	kill_time;
	kill_time;
	//vif.send(3'b011, 16'h1234); 	
endtask : drive_reset


// Task for write command
virtual task drive_write(input logic [15:0] address);
	$display("ENTERING WRITE, address: %h", address);
	vif.send(3'b001, address);
	for (int i = 0; i<2048; i++) begin
		memory[i] = $random % 256;
		vif.write_buffer(1'b1,memory[i],i);
	end

   @(posedge vif.clk) ;
   @(posedge vif.clk) ;
   //#3;
   vif.BF_we=1'b0;  
   wait(vif.nfc_done);
   @(posedge vif.clk) ;
   //#3;
   vif.nfc_cmd=3'b111;
   vif.BF_sel=1'b0;
   if(vif.PErr)                                         
     $display($time,"  %m  \t \t  << Writing error >>");    
   else                                             
     $display($time,"  %m  \t \t  << Writing no error >>"); 

 	kill_time;
 	kill_time;

endtask : drive_write


virtual task read_cycle(input logic [15:0]address);

	$display("ENTERING READ CYCLE");
	vif.send(3'b010,address);
	read_buffer();
endtask	
// Task for read command	
 

virtual task reset();
	begin
		vif.send(3'b011, 16'h1234);
		kill_time;
		kill_time;
	end
endtask : reset

task kill_time;                                                         
  begin                                                                 
    @(posedge vif.clk);                                                 
    @(posedge vif.clk);                                                 
    @(posedge vif.clk);                                                 
    @(posedge vif.clk);                                                 
    @(posedge vif.clk);                                                 
  end                                                                   
endtask // of kill_time; 

task erase_cycle(input logic [15:0]address);
	begin
		vif.send(3'b100,address);
		   if(vif.EErr)                                         
     $display($time,"  %m  \t \t  << erase error >>");    
   else                                             
     $display($time,"  %m  \t \t  << erase no error >>"); 
 		kill_time;
 		kill_time;
	end
endtask : erase_cycle  

task stable();
	vif.rst = 1'b1;
	vif.BF_sel = 1'b0;
	vif.BF_ad  = 0;
	vif.BF_din = 0;
	vif.BF_we  = 0;
	vif.RWA    = 0;
	vif.nfc_cmd = 3'b111;
	vif.nfc_strt = 1'b0;
	//temp = 8'b24;
	kill_time;
	kill_time;
	vif.rst = 1'b0;
endtask : stable

endclass : NF_driver 


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
		//$display("-----Inside monitor-----1");
		//if(vif.nfc_strt)begin
		//	$display("-----Inside monitor-----2");
			if((vif.nfc_cmd == 3'b001) && (vif.BF_we))begin
	//			trans_collected.seq_item_BF_nfc_cmd = 3'b001;//vif.nfc_cmd;
				trans_collected.seq_item_RWA = vif.RWA;
				trans_collected.seq_item_BF_ad = vif.BF_ad;
				//$display("vif.nfc_cmd :, RWA: %h", vif.RWA);
				trans_collected.seq_item_BF_din = vif.BF_din;
			//	$display("DATA WRITE::: seq_item_BF_ad : %h , trans_collected.seq_item_BF_din : %h",trans_collected.seq_item_BF_ad, trans_collected.seq_item_BF_din);
			end // if(vif.nfc_strt)end

			item_collected_port.write(trans_collected);
	end // forever
endtask : run_phase



endclass : NF_monitor