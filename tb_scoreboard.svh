
`include "../src/uvm_macros.svh"

import uvm_pkg::*;
//import cmd_pkg::*;
import flash_pkg::*;

//`include "tb_seq_item.svh"

class NF_scoreboard extends uvm_scoreboard;

	reg [7:0] mem_page [0:2**BLOCK_BITS -1][0:2**PAGES_BITS - 1][0:2047];
	reg [3:0] page;
	reg [11:0] block;
	int read_error_count;

	//bit mem_row [0:7];
	
		`uvm_component_utils(NF_scoreboard)
		uvm_analysis_imp#(NF_seq_item, NF_scoreboard)item_collected_export;
	
	//queue for the packet received
	NF_seq_item pkt_queue[$];
	
	// new constructor class
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new		
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		item_collected_export = new("item_collected_export", this);
	//	foreach(mem_int[i]) mem_int[i] = 8'hFF;
	endfunction : build_phase
	
	
	

	virtual function void write(NF_seq_item pkt);	

		case(pkt.seq_item_BF_nfc_cmd) 
			3'b001 : call_write(pkt.seq_item_RWA, pkt.seq_item_BF_ad, pkt.seq_item_BF_din);		// function call if a write command is detected
			3'b010 : call_read (pkt.seq_item_RWA, pkt.seq_item_BF_ad, pkt.seq_item_BF_din);		// function call if a read command is detected
			3'b100 : call_erase(pkt.seq_item_RWA);												// function call if a erase command is detected
		endcase
	
	endfunction : write	
	
	
	
	// function to register a write operation in the scoreboard
	virtual function call_write(input [15:0] seq_item_RWA, input[10:0]seq_item_BF_ad, input [7:0]seq_item_BF_din);
		page = seq_item_RWA[3:0];
  		block = seq_item_RWA[15:4];
		mem_page[block][page][seq_item_BF_ad] = seq_item_BF_din;		// write the data to the internal memory
	endfunction : call_write
	
	
	
	// Function to verify a read operation in the scoreboard.
	virtual function call_read(input [15:0] seq_item_RWA, input[10:0]seq_item_BF_ad, input [7:0]seq_item_BF_din);		
		page = seq_item_RWA[3:0];
  		block = seq_item_RWA[15:4];
		if((mem_page[block][page][seq_item_BF_ad] != seq_item_BF_din) && (seq_item_BF_ad < 7'hff)) begin //compare the data with the internal memory
 				$display("DATA MISS-MATCH at location %h -> Data written : %p Data read: %h",seq_item_BF_ad, mem_page[block][page][seq_item_BF_ad], seq_item_BF_din);
		end // if(mem_page[seq_item_BF_ad] != seq_item_BF_din)
		else begin
			//$display("DATA MATCH for ROW address %h", seq_item_RWA);
		end
	endfunction : call_read

	// 
	virtual function call_erase(input [15:0] seq_item_RWA);
		page = seq_item_RWA[3:0];
  		block = seq_item_RWA[15:4];
  		  for (int i = 0; i < 16 ; i = i+1) begin
   			 for (int j = 0; j < 2048; j = j+1)begin
         		mem_page[block][i][j] <= 8'b0;
    		 end 
  		  end
	endfunction



endclass : NF_scoreboard