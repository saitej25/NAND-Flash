vlib work
vlog -work work +cover ./ACounter.v
	vlog +cover cmd_pkg.sv
	vlog +cover ErrLoc.v
	vlog +cover H_gen.v
	vlog +cover MFSM.v
	vlog +cover mybuf.sv
	vlog +cover nfcm_top.v
	vlog +cover flash_pkg.sv
	vlog +cover flash_interface.v
	vlog +cover flash_bfm.sv
	vlog +cover TFSM.v
	vlog +cover tb_coverage.svh
	vlog +cover tb_top.svh

	
	vsim -novopt -coverage work.tbench_top 
	
	add wave -position insertpoint sim:/tbench_top/bfm/*