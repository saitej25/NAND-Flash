if [file exists "work"] {vdel -all}
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


    vopt tbench_top -o top_optimized  +acc +cover=sbfec+tbench_top(rtl).
	vsim top_optimized -coverage
	set NoQuitOnFinish 1
	onbreak {resume}
	log /* -r
	run -all
	coverage save tbench_top.ucdb
	vcover report tbench_top.ucdb 
	vcover report tbench_top.ucdb -cvg -details
