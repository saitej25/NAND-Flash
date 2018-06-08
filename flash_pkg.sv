/************************************************************************************************************************************************
*																		*
* 							  FLASH MEMORY CONTROLLER PACKAGE							*															*
*																		*
************************************************************************************************************************************************/

package flash_pkg;
	typedef enum bit [2:0] {program_page  	= 3'b001,
				read_page  	= 3'b010,
				erase  		= 3'b100,
				reset  		= 3'b011,
				read_id  	= 3'b101,
				sys_reset   = 3'b110,
				stable		= 3'b000
				} operations;

operations op, exp_op, scr_op;

parameter TRUE = 1'b1;
parameter FALSE = 1'b0;
parameter SIGNAL_WIDTH=4;
parameter SB_DEPTH=24;
parameter LUT=3;
parameter PAGES_BITS = 4;
parameter BLOCK_BITS = 12; 
parameter DEBUG = TRUE;

`include "tb_seq_item.svh"
`include "tb_sequencer.svh"
`include "tb_sequence.svh"
`include "tb_driver.svh"
`include "tb_monitor.svh"
`include "tb_agent.svh"
`include "tb_scoreboard.svh"
`include "tb_coverage.svh"
`include "tb_environment.svh"
`include "tb_test.svh"

//`include "tb_top.svh" 
























reg [7:0] temp_mem [0:2**BLOCK_BITS -1][0:2**PAGES_BITS - 1][0:2047];
endpackage : flash_pkg
