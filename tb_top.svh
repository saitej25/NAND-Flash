

`include "../src/uvm_macros.svh"
//`include "tb_test.svh"
//`include "tb_sequence.svh"

import uvm_pkg::*;
import flash_pkg::*;
`include "tb_coverage.svh"

module tbench_top;


NF_coverage coverage_inst;
// instantiation of flash interface
flash_bfm bfm();



nfcm_top nfcm(
    .DIO(bfm.DIO),
    .CLE(bfm.CLE),
    .ALE(bfm.ALE),
    .WE_n(bfm.WE_n),
    .RE_n(bfm.RE_n),
    .CE_n(bfm.CE_n),
    .R_nB(bfm.R_nB),
    
    .CLK(bfm.clk),
    .RES(bfm.rst),
    .BF_sel(bfm.BF_sel),
    .BF_ad (bfm.BF_ad ),
    .BF_din(bfm.BF_din),
    .BF_we (bfm.BF_we ),
    .RWA   (bfm.RWA   ), 

    .BF_dou(bfm.BF_dr),
    .PErr(bfm.PErr), 
    .EErr(bfm.EErr), 
    .RErr(bfm.RErr),
      
    .nfc_cmd (bfm.nfc_cmd ), 
    .nfc_strt(bfm.nfc_strt),  
    .nfc_done(bfm.nfc_done)
);


flash_interface nand_flash(
    .DIO(bfm.DIO),
    .CLE(bfm.CLE),  // -- CLE
    .ALE(bfm.ALE),  //  -- ALE
    .WE_n(bfm.WE_n),    // -- ~WE
    .RE_n(bfm.RE_n),    //-- ~RE
    .CE_n(bfm.CE_n),    //-- ~CE
    .R_nB(bfm.R_nB),    //-- R/~B
    .rst(bfm.rst)
);

initial begin
    uvm_config_db#(virtual flash_bfm)::set(uvm_root::get(), "*","vif", bfm);
    $dumpfile("dump.vcd"); $dumpvars;
end // initial  

initial begin
    $display("inside top module not. about to run_test",);
    run_test("NF_test");
end // initial  

initial
begin

coverage_inst = new(bfm);
coverage_inst.execute();
end

endmodule // tbench_top
