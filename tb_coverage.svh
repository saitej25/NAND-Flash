import flash_pkg::*;

class NF_coverage;

virtual flash_bfm b;

operations op_cmd;

function new (virtual flash_bfm b);
    this.b = b;   
    this.NF_inputs = new();
    this.NF_outputs = new();
endfunction : new


//========================================================================================
// Covergroup for all input signals, their transitions.

//===================================================================================== 
 covergroup NF_inputs;
 
  // Basic coverpoint for reset signal
  cov_rst: coverpoint b.rst { bins r1[] = {0,1}; }  
 
  // coverpoint for select signal
  cov_sel: coverpoint b.BF_sel { bins s1[] = {0,1}; }
  
  // coverpoint for Write enable signal
  cov_we: coverpoint b.BF_we { bins wr[] = {0,1}; }
  
  // coverpoint for 2048 locations inside a page. 
  cov_ad: coverpoint b.BF_ad { bins a1[] = {[0:2047]}; }

  // coverpoint for start of transaction signal 
  cov_start: coverpoint b.nfc_strt { bins strt = {1}; }
  
  // Coverpoint for the Row address signal. As RWA is 16 bit wide it covers around 64K locations
  // Thus we have split the range into groups. 
  cov_rwa: coverpoint b.RWA { 
                            bins zeros = {16'h0000};
							              bins range1 = {[16'h0001 : 16'h000F]};
							              bins range2 = {[16'h0010 : 16'h00FF]}; 
							              bins range3 = {[16'h0100 : 16'h0FFF]};
							              bins range4 = {[16'h1000 : 16'hFFFE]};
                            bins ones  = {16'hFFFF};
                          }							
  
  // coverpoint for input data signal
  cov_din: coverpoint b.BF_din { bins all_zeros[]  = {8'h00};
                                 bins all_ones[]   = {8'hFF};
                                 bins sll_others[] = {[8'h01:8'hFE]};
                          }

  // coverpoint for input command signal
  cov_cmd: coverpoint b.nfc_cmd { bins cmd[]              = {program_page, read_page, reset, erase, read_id}; 
                                  bins cmd_write_to_any   = ('b1 => {'d2, 'd3, 'd4, 'd5});
                                  bins cmds_read_to_any   = (3'b010 => {3'b001, 3'b011, 3'b100, 3'b101});
                                  bins cmds_reset_to_any  = (3'b011 => {3'b001, 3'b010, 3'b100, 3'b101});
                                  bins cmds_erase_to_any  = (3'b100 => {3'b001, 3'b010, 3'b101, 3'b011});
                                  bins cmds_readid_to_any = (3'b101 => {3'b001, 3'b010, 3'b100, 3'b011});
                                  bins cmds6[]            = (read_page[*1:5]);
                                  bins cmds7[]            = (program_page[*1:5]);
                 //  bins trans[] = (program_page=>stable, read_page=>stable, reset=>stable, erase=>stable, read_id=>stable); 
                             } 

  illegalcmd: coverpoint op_cmd {bins illegal_cmd[] = {3'b000,3'b110};} 
  
  
  
  // cross coverage
  
  cross cov_cmd, cov_start; // when start = 1, valid command
  
  cross cov_start, cov_sel; // when start = 1, sel = 1 during read and write
  
  cross cov_cmd, cov_sel; // for write, read, sel = 1
  
  cross cov_cmd, cov_we; // for we=1, cmd
  
  cross cov_we, cov_sel;
  
  cross cov_ad, cov_we {
       bins ad1 = binsof (cov_we) intersect {1} && ( binsof (cov_ad.a1) ); 
	   }
	   
  cross cov_we, cov_rwa {
        bins rwa_we1 = binsof (cov_we) intersect {1} && ( binsof (cov_rwa.zeros));
	   bins rwa_we2 = binsof (cov_we) intersect {1} && ( binsof (cov_rwa.ones));
      }

  cross cov_cmd, cov_rwa {
    bins RWA_PP_0 = binsof (cov_cmd) intersect {program_page} && (binsof(cov_rwa.zeros));
	  bins RWA_PP_1 = binsof (cov_cmd) intersect {program_page} && (binsof(cov_rwa.ones));
	  bins RWA_RP_0 = binsof (cov_cmd) intersect {read_page} && (binsof(cov_rwa.zeros));
	  bins RWA_RP_1 = binsof (cov_cmd) intersect {read_page} && (binsof(cov_rwa.ones));
	  bins RWA_ER_0 = binsof (cov_cmd) intersect {erase} && (binsof(cov_rwa.zeros));
	  bins RWA_ER_1 = binsof (cov_cmd) intersect {erase} && (binsof(cov_rwa.ones));
	  }
	  
 cross cov_cmd, cov_ad {
      bins PP_ad = binsof (cov_cmd) intersect {program_page} && (binsof(cov_ad.a1));
      bins RP_ad = binsof (cov_cmd) intersect {read_page} && (binsof(cov_ad.a1));
	}

endgroup






covergroup NF_outputs;
 
  coverpoint b.BF_dou { bins all_zeros_out  = {8'h00};
                        bins all_ones_out   = {8'hFF};
                        bins all_others_out = {[8'h01:8'hEF]};
                      }
  coverpoint b.DIO { bins all_DIO_zeros = {16'h0000};
                     bins all_DIO_ones  = {16'hFFFF};
                     bins all_DIO_others= {[16'h0001 :16'hFFFE]};
                     }
  //coverpoint b.BF_d { bins do3[] = {[0:255]}; }
  
  coverpoint b.PErr { bins PE[] = {0,1}; }
  
  coverpoint b.EErr { bins EE[] = {0}; }
  
  coverpoint b.RErr { bins RE[] = {0}; }
  
  coverpoint b.nfc_done { bins b5[] = {0,1}; }
 
endgroup

task execute();
   forever begin  : sampling_block
      @(negedge  b.clk);
      NF_inputs.sample();
      NF_outputs.sample();
   end : sampling_block
endtask : execute

 
 
endclass

 
 
 
 