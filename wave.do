onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench_top/nfcm/HI
add wave -noupdate /tbench_top/nfcm/LO
add wave -noupdate /tbench_top/nfcm/DIO
add wave -noupdate -expand -label {Contributors: DIO} -group {Contributors: sim:/tbench_top/nfcm/DIO} /tbench_top/nand_flash/dat_en
add wave -noupdate -expand -label {Contributors: DIO} -group {Contributors: sim:/tbench_top/nfcm/DIO} /tbench_top/nand_flash/datout
add wave -noupdate -expand -label {Contributors: DIO} -group {Contributors: sim:/tbench_top/nfcm/DIO} /tbench_top/nfcm/DOS
add wave -noupdate -expand -label {Contributors: DIO} -group {Contributors: sim:/tbench_top/nfcm/DIO} /tbench_top/nfcm/FlashDataOu
add wave -noupdate /tbench_top/nfcm/CLE
add wave -noupdate /tbench_top/nand_flash/datout
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/ALE
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/CE_n
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/CLE
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/RE_n
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/block_addr
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/command
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/con
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/con2
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/con2_835
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/memory
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/page_addr
add wave -noupdate -expand -label {Contributors: datout} -group {Contributors: sim:/tbench_top/nand_flash/datout} /tbench_top/nand_flash/rst
add wave -noupdate /tbench_top/nand_flash/dat_en
add wave -noupdate -expand -label {Contributors: dat_en} -group {Contributors: sim:/tbench_top/nand_flash/dat_en} /tbench_top/nand_flash/ALE
add wave -noupdate -expand -label {Contributors: dat_en} -group {Contributors: sim:/tbench_top/nand_flash/dat_en} /tbench_top/nand_flash/CE_n
add wave -noupdate -expand -label {Contributors: dat_en} -group {Contributors: sim:/tbench_top/nand_flash/dat_en} /tbench_top/nand_flash/CLE
add wave -noupdate -expand -label {Contributors: dat_en} -group {Contributors: sim:/tbench_top/nand_flash/dat_en} /tbench_top/nand_flash/RE_n
add wave -noupdate -expand -label {Contributors: dat_en} -group {Contributors: sim:/tbench_top/nand_flash/dat_en} /tbench_top/nand_flash/command
add wave -noupdate -expand -label {Contributors: dat_en} -group {Contributors: sim:/tbench_top/nand_flash/dat_en} /tbench_top/nand_flash/con2
add wave -noupdate -expand -label {Contributors: dat_en} -group {Contributors: sim:/tbench_top/nand_flash/dat_en} /tbench_top/nand_flash/con2_835
add wave -noupdate -expand -label {Contributors: dat_en} -group {Contributors: sim:/tbench_top/nand_flash/dat_en} /tbench_top/nand_flash/rst
add wave -noupdate /tbench_top/nfcm/ALE
add wave -noupdate /tbench_top/nfcm/WE_n
add wave -noupdate /tbench_top/nfcm/RE_n
add wave -noupdate /tbench_top/nfcm/CE_n
add wave -noupdate /tbench_top/nfcm/R_nB
add wave -noupdate /tbench_top/nfcm/CLK
add wave -noupdate /tbench_top/nfcm/RES
add wave -noupdate /tbench_top/nfcm/BF_sel
add wave -noupdate /tbench_top/nfcm/BF_ad
add wave -noupdate /tbench_top/nfcm/BF_din
add wave -noupdate /tbench_top/nfcm/BF_we
add wave -noupdate /tbench_top/nfcm/RWA
add wave -noupdate /tbench_top/nfcm/BF_dou
add wave -noupdate /tbench_top/nfcm/PErr
add wave -noupdate /tbench_top/nfcm/EErr
add wave -noupdate /tbench_top/nfcm/RErr
add wave -noupdate /tbench_top/nfcm/nfc_cmd
add wave -noupdate /tbench_top/nfcm/nfc_strt
add wave -noupdate /tbench_top/nfcm/nfc_done
add wave -noupdate /tbench_top/nfcm/ires
add wave -noupdate /tbench_top/nfcm/res_t
add wave -noupdate /tbench_top/nfcm/FlashDataIn
add wave -noupdate /tbench_top/nfcm/FlashCmd
add wave -noupdate /tbench_top/nfcm/FlashDataOu
add wave -noupdate /tbench_top/nfcm/adc_sel
add wave -noupdate /tbench_top/nfcm/QA_1
add wave -noupdate /tbench_top/nfcm/QB_1
add wave -noupdate /tbench_top/nfcm/BF_data2flash
add wave -noupdate /tbench_top/nfcm/ECC_data
add wave -noupdate /tbench_top/nfcm/Flash_BF_sel
add wave -noupdate /tbench_top/nfcm/Flash_BF_we
add wave -noupdate /tbench_top/nfcm/DIS
add wave -noupdate /tbench_top/nfcm/F_we
add wave -noupdate /tbench_top/nfcm/rar_we
add wave -noupdate /tbench_top/nfcm/addr_data
add wave -noupdate /tbench_top/nfcm/rad_1
add wave -noupdate /tbench_top/nfcm/rad_2
add wave -noupdate /tbench_top/nfcm/cad_1
add wave -noupdate /tbench_top/nfcm/cad_2
add wave -noupdate /tbench_top/nfcm/amx_sel
add wave -noupdate /tbench_top/nfcm/CntEn
add wave -noupdate /tbench_top/nfcm/tc3
add wave -noupdate /tbench_top/nfcm/tc2048
add wave -noupdate /tbench_top/nfcm/cnt_res
add wave -noupdate /tbench_top/nfcm/acnt_res
add wave -noupdate /tbench_top/nfcm/CntOut
add wave -noupdate /tbench_top/nfcm/DOS
add wave -noupdate /tbench_top/nfcm/t_start
add wave -noupdate /tbench_top/nfcm/t_done
add wave -noupdate /tbench_top/nfcm/t_cmd
add wave -noupdate /tbench_top/nfcm/WCountRes
add wave -noupdate /tbench_top/nfcm/WCountCE
add wave -noupdate /tbench_top/nfcm/TC4
add wave -noupdate /tbench_top/nfcm/TC8
add wave -noupdate /tbench_top/nfcm/cmd_we
add wave -noupdate /tbench_top/nfcm/cmd_reg
add wave -noupdate /tbench_top/nfcm/SetPrErr
add wave -noupdate /tbench_top/nfcm/SetErErr
add wave -noupdate /tbench_top/nfcm/SetRrErr
add wave -noupdate /tbench_top/nfcm/WrECC
add wave -noupdate /tbench_top/nfcm/WrECC_e
add wave -noupdate /tbench_top/nfcm/enEcc
add wave -noupdate /tbench_top/nfcm/Ecc_en
add wave -noupdate /tbench_top/nfcm/ecc_en_tfsm
add wave -noupdate /tbench_top/nfcm/setDone
add wave -noupdate /tbench_top/nfcm/set835
add wave -noupdate /tbench_top/nfcm/ALE_i
add wave -noupdate /tbench_top/nfcm/CLE_i
add wave -noupdate /tbench_top/nfcm/WE_ni
add wave -noupdate /tbench_top/nfcm/CE_ni
add wave -noupdate /tbench_top/nfcm/RE_ni
add wave -noupdate /tbench_top/nfcm/DOS_i
add wave -noupdate /tbench_top/nfcm/FlashDataOu_i
add wave -noupdate /tbench_top/nfcm/WC_tmp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28993268617 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits fs
update
WaveRestoreZoom {209238347257500 fs} {209242655407500 fs}
