package cmd_pkg;
	typedef enum bit[2:0] {
					program_page = 3'b001,
					reset = 3'b011,
					erase = 3'b100,
					read_page = 3'b010,
					read_id = 3'b101,
					sys_reset = 3'b110
					} kind_cmd;
endpackage