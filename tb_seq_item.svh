
/*---------------------------------------------------------------------------------------------------------

tb_seq_item.svh : Sequence Item file (Transaction generation)
 
-> Sequence item contains the actual data content of the object
	- Data property members, randomization and consttraints

-> Driver relies on the content of the sequence_items that it receives to 
	determine what type of pin level transaction to execute

-> sequence items are randomized inside sequence

-> Data members should be declared as rand and constraints should be implemented for legal values

-> request parameters = rand       response parameters = non-rand

uvm_sequence_item : base class that defines how the sequence item needs to be. That is the base methods
and base functionality needed for the sequence item.
----------------------------------------------------------------------------------------------------------*/

`include "../src/uvm_macros.svh"

import uvm_pkg::*;
//import cmd_pkg::*;
import flash_pkg::*;
class NF_seq_item extends uvm_sequence_item;


	// Utility and Field Macro
	`uvm_object_utils(NF_seq_item)
	// typedeef for different command type


	rand bit [15:0] seq_item_RWA;			// 16 bit RWA address	
	bit      [10:0] seq_item_BF_ad;			// Page address
	rand bit seq_item_BF_we;				// Write enable signal
	rand bit [7:0] seq_item_BF_din;				// Data input 
    rand operations seq_item_BF_nfc_cmd;	// command	




	// Constructor Class
	function new(string name = "NF_seq_item");
		super.new(name);
	endfunction : new


endclass : NF_seq_item

