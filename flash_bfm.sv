/************************************************************************************************************************************************
*																		*
* 							  FLASH MEMORY CONTROLLER - BFM								*															*
*																		*
************************************************************************************************************************************************/

//`timescale 1 ns / 1 fs

parameter clk_cycle = 10;
parameter clk_width = clk_cycle/2;

import flash_pkg::*;
//import cmd_pkg::*;

interface flash_bfm;

/********************************* Interface variables *****************************************/
 bit clk,rst;

 wire [7:0] DIO;
 logic CLE;		// -- CLE
 logic ALE;		//  -- ALE
 logic WE_n;		// -- ~WE
 logic RE_n; 		//-- ~RE
 logic CE_n; 		//-- ~CE
 logic R_nB; 		//-- R/~B

 logic BF_sel;
 logic [10:0] BF_ad;
 logic [7:0] BF_din;
 logic BF_we;
 logic [15:0] RWA; 	//-- row addr
 logic [7:0] BF_dr;
 reg [7:0] BF_dou;

 logic PErr ; 		// -- progr err
 logic EErr ; 		// -- erase err
 logic RErr ;
 reg [3:0]page;
 reg [11:0]block;

 bit [2:0] nfc_cmd; 	// -- command see below       
 logic nfc_strt;	//  -- pos edge (pulse) to start
 logic nfc_done;	//  -- operation finished if '1'
/***********************************************************************************************/

/********************************* Internal variables ******************************************/
 bit check_start;
 int check_counter;

 bit sb_checkstart1,sb_checkstart2,sb_checkstart3,sb_checkstart4;
 int sb_counter1, sb_counter2,sb_counter3,sb_counter4;
 
 bit sb_checkstart;
int count = 0;
/************************************** System clock *******************************************/
initial clk = 0;
always	#clk_width clk = ~clk;
//assign BF_dou = (nfc_done)? 
/***********************************************************************************************/

/************************************ Checker Counter ******************************************/
always@ (posedge clk or posedge check_start) begin
	if(check_start)
		check_counter = check_counter + 1;
	else begin
		check_counter = 0;
		check_start = 0;
	end
end
/***********************************************************************************************/

/********************************* Scoreboard Counters *****************************************/
always@(posedge clk  or posedge sb_checkstart1) begin
	if(sb_checkstart1)
     		sb_counter1 =sb_counter1+1;
  	else 
      		sb_counter1=0;
end

always@(posedge clk or posedge sb_checkstart2) begin
  	if(sb_checkstart2)
     		sb_counter2 =sb_counter2+1;
  	else 
      		sb_counter2=0;
end

always@(posedge clk or posedge sb_checkstart3) begin
  	if(sb_checkstart3)
     		sb_counter3 =sb_counter3+1;
  	else 
      		sb_counter3=0;
end

always@(posedge clk or posedge sb_checkstart4 ) begin
  	if(sb_checkstart4)
     		sb_counter4 =sb_counter4+1;
  	else 
      		sb_counter4=0;
end
/***********************************************************************************************/

/************************************** Send task **********************************************/
task send(input int cmd, input logic [15:0] address);

	case(cmd)
		program_page :	begin
					@(posedge clk) ;
  					//#3;
    					RWA=address;
    					nfc_cmd=3'b001;
    					nfc_strt=1'b1;      
    					BF_sel=1'b1;
    					@(posedge clk) ;
    					//#3;
    					nfc_strt=1'b0; 
    					BF_ad=0;
				end
		
		read_page :	begin
					@(posedge clk);
    				//	#3;
    					RWA=address;
    					nfc_cmd=3'b010;
    					nfc_strt=1'b1;
    					BF_sel=1'b1;
    					BF_we=1'b0;
    					BF_ad= 0;
    					@(posedge clk) ;
    					//#3;
    					nfc_strt=1'b0; 
					  
             
				end

		erase : 	begin
					@(posedge clk) ;
    				//	#3;
    					RWA=address;
    					nfc_cmd=3'b100;
    					nfc_strt=1'b1;	
    					@(posedge clk) ;
    					//#3;
    					nfc_strt=1'b0; 
              erase_cycle(address);
              @(posedge clk);
              wait(nfc_done);
              @(posedge clk);
              nfc_cmd = 3'b111;
				end

		reset : 	begin
					@(posedge clk) ;
    					nfc_cmd=3'b011;
    					nfc_strt=1'b1;
					@(posedge clk) ;
    					nfc_strt=1'b0; 
            wait(nfc_done);
            @(posedge clk) ;
            nfc_cmd=3'b111;                                           
            $display($time,"  %m  \t \t  << reset function over >>"); 
				end
				
		read_id : 	begin
					@(posedge clk) ;
    				//	#3;
   			  	      	RWA=address;
    					nfc_cmd=3'b101;
    					nfc_strt=1'b1;
    					BF_sel=1'b1;
    					@(posedge clk) ;
    				//	#3;
    					nfc_strt=1'b0;    
			  	end	
	endcase
	
endtask : send
/***********************************************************************************************/

/******************************** write buffer task ********************************************/
task write_buffer(input bit bf_we, input reg[15:0] address, input bit[7:0] bf_din, input int i);
	@(posedge clk);
	//#3;
  page = address[3:0];
  block = address[15:4];
  
	BF_we = bf_we;
	BF_din <= bf_din;
     	BF_ad <= i;//#3 i; 
  temp_mem[block][page][i] <= bf_din;          
endtask : write_buffer

task read_buffer(input int i);                                                                
       		@(posedge clk);                                                                
       		BF_ad<=#3 i; 
endtask : read_buffer


task erase_cycle(input reg[15:0] address);
  page = address[3:0];
  block= address[15:4];

  for (int i = 0; i < 16 ; i = i+1) begin
    for (int j = 0; j < 2048; j = j+1)begin
         temp_mem[block][i][j] <= 8'b0;
    end 
  end

endtask : erase_cycle
/***********************************************************************************************/

/********************************* System reset task *******************************************/
task system_reset(input int count);
	@(posedge clk)
	rst <= 1'b1;
  BF_sel<=1'b0;                   
  BF_ad<=0;            
  BF_din<=0;            
  BF_we<=0;                   
  RWA<=0; 
  nfc_cmd<=3'b110;
  nfc_strt<=1'b0; 
        $display($time,"Entered reset block to check if it is entering in same clk");
  @(posedge clk)
  @(posedge clk);
	rst <= 1'b0;
endtask : system_reset


task read_buffer_mem(input logic [15:0] address);
   page = address[3:0];
  block = address[15:4];
  @(posedge clk);
  wait(nfc_done);
  @(posedge clk);
  //#3;
  //
  BF_ad<= BF_ad+1;
  for(int i=0;i<2048;i=i+1)begin
    BF_dou <= temp_mem[block][page][i];
    @(posedge clk);

    BF_ad <= BF_ad+1;
  end // for(i=0;i<2048;i=i+1)
  nfc_cmd=3'b111;
  if(RErr)                                         
     $display($time,"  %m  \t \t  << ecc error >>");    
   else                                             
     $display($time,"  %m  \t \t  << ecc no error >>"); 

  kill_time(10);
  kill_time(10);
endtask

/***********************************************************************************************/

/************************************ Kill time task *******************************************/
task kill_time(input int count);                                                         
  begin                                                                 
    @(posedge clk);                                                 
    @(posedge clk);                                                 
    @(posedge clk);                                                 
    @(posedge clk);                                                 
    @(posedge clk);                                                 
  end                                                                   
endtask : kill_time
/***********************************************************************************************/

endinterface : flash_bfm                                                                         



