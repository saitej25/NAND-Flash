`include "../src/uvm_macros.svh"
//`include "tb_seq_item.svh"
//`include "tb_sequence.svh"
import uvm_pkg::*;

class NF_driver extends uvm_driver#(NF_seq_item);	
	logic [7:0]memory[0:2047];
int count = 0;
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

			$display("seq_item_RWA vlue:",tr.seq_item_BF_we);
			$display("seq_item_RWA vlue:",tr.seq_item_BF_ad);

		@(this.vif.clk);
		case (tr.seq_item_BF_nfc_cmd)
			3'b000	  : stable();
			3'b001    : drive_write(tr.seq_item_RWA);
			3'b010    : read_cycle(tr.seq_item_RWA);
			3'b011    : reset();
			3'b100    : erase_cycle(tr.seq_item_RWA);
			3'b101    : read_id_cycle(tr.seq_item_RWA);
			3'b110    : drive_reset();
								
		endcase // tr.seq_item_BF_nfc_cmd

		seq_item_port.item_done();
	end // forever
endtask : run_phase




// Task for reset command
virtual task drive_reset();
	vif.system_reset(2);
	kill_time(10);
	kill_time(10);	
endtask : drive_reset


// Task for write command
virtual task drive_write(input logic [15:0] address);
	vif.send(3'b001, address);
	for (int i = 0; i<2048; i++) begin
		memory[i] = $random % 256;
		vif.write_buffer(1'b1,address, memory[i],i);
	end

  // @(posedge vif.clk) ;
  // @(posedge vif.clk) ;

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

 	kill_time(10);
 	kill_time(10);

endtask : drive_write


virtual task read_cycle(input logic [15:0]address);
	vif.send(3'b010,address);
	vif.read_buffer_mem(address);
endtask	
// Task for read command	
 

virtual task reset();
	begin
		vif.send(3'b011, 16'h1234);
		kill_time(5);
		kill_time(5);
	end
endtask : reset

task kill_time(input int count);                                                         
  begin 
	repeat(count) begin                                                                
    @(posedge vif.clk);                                                 
    @(posedge vif.clk);                                                 
    @(posedge vif.clk);                                                 
    @(posedge vif.clk);                                                 
    @(posedge vif.clk);  
    end                                               
  end                                                                   
endtask // of kill_time; 

task erase_cycle(input logic [15:0]address);
	begin
		vif.send(3'b100,address);
		   if(vif.EErr)                                         
     $display($time,"  %m  \t \t  << erase error >>");    
   else                                             
     $display($time,"  %m  \t \t  << erase no error >>"); 
 		kill_time(10);
 		kill_time(10);
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
	kill_time(10);
	kill_time(10);
	vif.rst = 1'b0;
endtask : stable

task read_id_cycle;
    input [15:0]  address;    
begin
    @(posedge vif.clk) ;
    vif.RWA=address;
    vif.nfc_cmd=3'b101;
    vif.nfc_strt=1'b1;
    vif.BF_sel=1'b1;
    @(posedge vif.clk) ;
    vif.nfc_strt=1'b0;    
    @(posedge vif.clk) ;
   wait(vif.nfc_done);
   @(posedge vif.clk) ;
   vif.nfc_cmd=3'b111;
      $display($time,"  %m  \t \t  << read id function over >>");     
end      
endtask

endclass : NF_driver 