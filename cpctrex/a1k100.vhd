-- Copyright (C) 1991-2014 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.1.4 Build 182 03/12/2014 SJ Web Edition"
-- CREATED		"Thu Jul 10 07:33:52 2014"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY a1k100 IS 
	PORT
	(
		sysclk :  IN  STD_LOGIC;
		shiftclk :  IN  STD_LOGIC;
		kb_clk :  IN  STD_LOGIC;
		kb_data :  IN  STD_LOGIC;
		mouse_clk :  INOUT  STD_LOGIC;
		mouse_data :  INOUT  STD_LOGIC;
		fl_data :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		idedb :  INOUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		key :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		sdata :  INOUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		sw :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		sd_we :  OUT  STD_LOGIC;
		sd_ras :  OUT  STD_LOGIC;
		sd_cas :  OUT  STD_LOGIC;
		iauda :  OUT  STD_LOGIC;
		lrclk :  OUT  STD_LOGIC;
		bck :  OUT  STD_LOGIC;
		fl_ce :  OUT  STD_LOGIC;
		vsync :  OUT  STD_LOGIC;
		hsync :  OUT  STD_LOGIC;
		ide1cs :  OUT  STD_LOGIC;
		ide2cs :  OUT  STD_LOGIC;
		io_wr :  OUT  STD_LOGIC;
		io_rd :  OUT  STD_LOGIC;
		wrena :  OUT  STD_LOGIC;
		TxD :  OUT  STD_LOGIC;
		TFT_CLK :  OUT  STD_LOGIC;
		dqm :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		fl_addr :  OUT  STD_LOGIC_VECTOR(20 DOWNTO 0);
		idea :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		LED :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		sd_addr :  OUT  STD_LOGIC_VECTOR(12 DOWNTO 0);
		sd_ba :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
		sd_cs :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		video :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END a1k100;

ARCHITECTURE bdf_type OF a1k100 IS 

COMPONENT rz80
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 interrupt : IN STD_LOGIC;
		 IOdatain : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ramdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 IO_WR : OUT STD_LOGIC;
		 IO_RD : OUT STD_LOGIC;
		 intack : OUT STD_LOGIC;
		 mem_wr : OUT STD_LOGIC;
		 mem_oe : OUT STD_LOGIC;
		 refresh : OUT STD_LOGIC;
		 faster : OUT STD_LOGIC;
		 iorq : OUT STD_LOGIC;
		 slower : OUT STD_LOGIC;
		 dataout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 memaddr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ps2mouse
	PORT(Rst_n : IN STD_LOGIC;
		 Clk : IN STD_LOGIC;
		 T1MHz : IN STD_LOGIC;
		 cpuclk : IN STD_LOGIC;
		 iord : IN STD_LOGIC;
		 risc : IN STD_LOGIC;
		 rio_rd : IN STD_LOGIC;
		 PS2_Clk : INOUT STD_LOGIC;
		 PS2_Data : INOUT STD_LOGIC;
		 addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 raddr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 DO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 rdo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sdram
	PORT(sysclk : IN STD_LOGIC;
		 resetas : IN STD_LOGIC;
		 merq : IN STD_LOGIC;
		 wrin : IN STD_LOGIC;
		 rd : IN STD_LOGIC;
		 refresh : IN STD_LOGIC;
		 oe : IN STD_LOGIC;
		 vack : IN STD_LOGIC;
		 speed : IN STD_LOGIC;
		 rwr : IN STD_LOGIC;
		 rrefresh : IN STD_LOGIC;
		 faster : IN STD_LOGIC;
		 slower : IN STD_LOGIC;
		 iowait : IN STD_LOGIC;
		 Addrin : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
		 datain : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--		 fl_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 raddr : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
		 rdatain : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sdata : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 vaddr : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
		 sd_we : OUT STD_LOGIC;
		 sd_ras : OUT STD_LOGIC;
		 sd_cas : OUT STD_LOGIC;
		 cpuclk : OUT STD_LOGIC;
		 cpuena : OUT STD_LOGIC;
		 crt1MHz : OUT STD_LOGIC;
		 swait : OUT STD_LOGIC;
		 rclk : OUT STD_LOGIC;
		 rena : OUT STD_LOGIC;
		 rioclk : OUT STD_LOGIC;
		 reset : OUT STD_LOGIC;
--		 fl_ce : OUT STD_LOGIC;
		 rzclk : OUT STD_LOGIC;
		 ba : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 dataout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 dqm : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--		 fl_addr : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
		 rdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sd_cs : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 sdaddr : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		 video : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT kbscan
	PORT(init : IN STD_LOGIC;
		 kb_clk : IN STD_LOGIC;
		 EPclk : IN STD_LOGIC;
		 kb_data : IN STD_LOGIC;
		 resetin : IN STD_LOGIC;
		 RDY : OUT STD_LOGIC;
		 scen : OUT STD_LOGIC;
		 reset : OUT STD_LOGIC;
		 speed : OUT STD_LOGIC;
		 pal : OUT STD_LOGIC;
		 Y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ay8912
	PORT(cpuclk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 cs : IN STD_LOGIC;
		 bc0 : IN STD_LOGIC;
		 bdir : IN STD_LOGIC;
		 shiftclk : IN STD_LOGIC;
		 ioData : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 key : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PortAin : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 iauda : OUT STD_LOGIC;
		 lrclk : OUT STD_LOGIC;
		 bck : OUT STD_LOGIC;
		 chanA : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		 chanB : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		 chanC : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		 oData : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mycpc
	PORT(IOWR : IN STD_LOGIC;
		 intackin : IN STD_LOGIC;
		 mem_wr : IN STD_LOGIC;
		 vena : IN STD_LOGIC;
		 sysclk : IN STD_LOGIC;
		 cpuclk : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 riscview : IN STD_LOGIC;
		 adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 memdin : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 VSYNC : OUT STD_LOGIC;
		 vgahsync : OUT STD_LOGIC;
		 vgavsync : OUT STD_LOGIC;
		 ramcs : OUT STD_LOGIC;
		 C1MHz : OUT STD_LOGIC;
		 int : OUT STD_LOGIC;
		 vack : OUT STD_LOGIC;
		 DISP : OUT STD_LOGIC;
		 pixclk : OUT STD_LOGIC;
		 sdaddr : OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
		 vaddr : OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
		 video : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
     LROMena : OUT STD_LOGIC;
     HROMena : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT rs232
	PORT(read : IN STD_LOGIC;
		 RxD : IN STD_LOGIC;
		 Baudx4 : IN STD_LOGIC;
		 CTS : IN STD_LOGIC;
		 store : IN STD_LOGIC;
		 i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 RDY : OUT STD_LOGIC;
		 RTS : OUT STD_LOGIC;
		 snext : OUT STD_LOGIC;
		 TxD : OUT STD_LOGIC;
		 Y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT core
	PORT(clk : IN STD_LOGIC;
		 riscena : IN STD_LOGIC;
		 hsync : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 rioclk : IN STD_LOGIC;
		 vsyncin : IN STD_LOGIC;
		 IO_inA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 IO_inB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 IO_inC : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 joy : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 prgdata : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ramdatain : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 mem_oe : OUT STD_LOGIC;
		 mem_wr : OUT STD_LOGIC;
		 IO_WR : OUT STD_LOGIC;
		 IO_RD : OUT STD_LOGIC;
		 inA_stb : OUT STD_LOGIC;
		 inC_stb : OUT STD_LOGIC;
		 pal : OUT STD_LOGIC;
		 startena : OUT STD_LOGIC;
		 refresh : OUT STD_LOGIC;
		 ACS : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 prgadr : OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
		 tmatrixo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT D8255
	PORT(iowr : IN STD_LOGIC;
		 iord : IN STD_LOGIC;
		 ioclk : IN STD_LOGIC;
		 adr : IN STD_LOGIC_VECTOR(15 DOWNTO 8);
		 data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PAI : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PBI : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 DO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PAO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PCO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT scandoubler
	PORT(hsync_in : IN STD_LOGIC;
		 vsync_in : IN STD_LOGIC;
		 pixclk : IN STD_LOGIC;
		 bypass : IN STD_LOGIC;
		 video_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 vsync_out : OUT STD_LOGIC;
		 hsync_out : OUT STD_LOGIC;
		 video_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fdc_ide
	PORT(z80iord : IN STD_LOGIC;
		 z80iowr : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 intWR : IN STD_LOGIC;
		 intRD : IN STD_LOGIC;
		 sWR : IN STD_LOGIC;
		 sCE : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 txd_busy : IN STD_LOGIC;
		 speed : IN STD_LOGIC;
		 riscena : IN STD_LOGIC;
		 Idedb : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 IO_Adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 PBI : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ridata : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 z80addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Z80inData : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Ide1cs : OUT STD_LOGIC;
		 Ide2cs : OUT STD_LOGIC;
		 IO_WR : OUT STD_LOGIC;
		 IO_RD : OUT STD_LOGIC;
		 swait : OUT STD_LOGIC;
		 wrena : OUT STD_LOGIC;
		 rs232clk : OUT STD_LOGIC;
		 rs232stb : OUT STD_LOGIC;
		 Idea : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 rs232 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 z80outData : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	C1MHz :  STD_LOGIC;
SIGNAL	acs :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	addr :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	AI :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	AO :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	BI :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	CO :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	crtclk :  STD_LOGIC;
SIGNAL	DI :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	disp :  STD_LOGIC;
SIGNAL	DO :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ff_hsync :  STD_LOGIC;
SIGNAL	g :  STD_LOGIC;
SIGNAL	inA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	inB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	int :  STD_LOGIC;
SIGNAL	iord :  STD_LOGIC;
SIGNAL	iowait :  STD_LOGIC;
SIGNAL	iowr :  STD_LOGIC;
SIGNAL	ma :  STD_LOGIC_VECTOR(22 DOWNTO 0);
SIGNAL	pdata :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	pixclk :  STD_LOGIC;
SIGNAL	r :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	raddr :  STD_LOGIC_VECTOR(22 DOWNTO 0);
SIGNAL	Ramout :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	rclk :  STD_LOGIC;
SIGNAL	rdata :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	refresh :  STD_LOGIC;
SIGNAL	rena :  STD_LOGIC;
SIGNAL	reset :  STD_LOGIC;
SIGNAL	resetin :  STD_LOGIC;
SIGNAL	rioclk :  STD_LOGIC;
SIGNAL	rzclk :  STD_LOGIC;
SIGNAL	speed :  STD_LOGIC;
SIGNAL	stbA :  STD_LOGIC;
SIGNAL	t :  STD_LOGIC;
SIGNAL	vaddr :  STD_LOGIC_VECTOR(22 DOWNTO 0);
SIGNAL	vena :  STD_LOGIC;
SIGNAL	swait :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC;

signal ramdata : std_logic_vector(7 downto 0);
signal rom1_out : std_logic_vector(7 downto 0);
signal rom2_out : std_logic_vector(7 downto 0);
signal hrom_en : std_logic;
signal lrom_en : std_logic;


BEGIN 
ide1cs <= SYNTHESIZED_WIRE_1;

  boot_rom1_inst : entity work.sprom
    generic map
    (
      init_file		=> "OS6128.mif",
      widthad_a		=> 14
    )
    port map
    (
      clock			=> rzclk,
      address		=> addr(13 downto 0),
      q					=> rom1_out
    );
   
  boot_rom2_inst : entity work.sprom
    generic map
    (
      init_file		=> "BASIC1-1.mif",
      widthad_a		=> 14
    )
    port map
    (
      clock			=> rzclk,
      address		=> addr(13 downto 0),
      q					=> rom2_out
    );

    ramdata <= rom1_out when lrom_en='1' else rom2_out when hrom_en='1' else Ramout;
    
b2v_inst : rz80
PORT MAP(clk => rzclk,
		 reset => reset,
		 interrupt => int,
		 IOdatain => DI,
		 ramdata => ramdata,
		 IO_WR => iowr,
		 IO_RD => iord,
		 intack => SYNTHESIZED_WIRE_11,
		 mem_wr => SYNTHESIZED_WIRE_25,
		 mem_oe => SYNTHESIZED_WIRE_2,
		 faster => SYNTHESIZED_WIRE_8,
		 slower => SYNTHESIZED_WIRE_9,
		 dataout => DO,
		 memaddr => addr);
     
     


b2v_inst1 : ps2mouse
PORT MAP(Rst_n => reset,
		 Clk => rioclk,
		 T1MHz => C1MHz,
		 cpuclk => rioclk,
		 iord => iord,
		 risc => acs(6),
		 rio_rd => SYNTHESIZED_WIRE_24,
		 PS2_Clk => mouse_clk,
		 PS2_Data => mouse_data,
		 addr => addr,
		 raddr => raddr(15 DOWNTO 0),
		 DO => DI,
		 rdo => pdata);


t <= NOT(SYNTHESIZED_WIRE_1);



b2v_inst11 : sdram
PORT MAP(sysclk => sysclk,
		 resetas => key(3),
		 merq => SYNTHESIZED_WIRE_2,
		 wrin => SYNTHESIZED_WIRE_25,
		 rd => g,
		 refresh => refresh,
		 oe => SYNTHESIZED_WIRE_4,
		 vack => SYNTHESIZED_WIRE_5,
		 speed => speed,
		 rwr => SYNTHESIZED_WIRE_6,
		 rrefresh => SYNTHESIZED_WIRE_7,
		 faster => SYNTHESIZED_WIRE_8,
		 slower => SYNTHESIZED_WIRE_9,
		 iowait => iowait,
		 Addrin => ma,
		 datain => DO,
--		 fl_data => fl_data,
		 raddr => raddr,
		 rdatain => pdata,
		 sdata => sdata,
		 vaddr => vaddr,
		 sd_we => sd_we,
		 sd_ras => sd_ras,
		 sd_cas => sd_cas,
		 cpuena => vena,
		 rclk => rclk,
		 rena => rena,
		 rioclk => rioclk,
		 reset => resetin,
--		 fl_ce => fl_ce,
		 rzclk => rzclk,
		 ba => sd_ba,
		 dataout => Ramout,
		 dqm => dqm,
--		 fl_addr => fl_addr,
		 rdata => rdata,
		 sd_cs => sd_cs,
		 sdaddr => sd_addr,
		 video => SYNTHESIZED_WIRE_14);


SYNTHESIZED_WIRE_10 <= NOT(key(7));



SYNTHESIZED_WIRE_13 <= acs(6) XOR SYNTHESIZED_WIRE_10;


b2v_inst15 : kbscan
PORT MAP(init => stbA,
		 kb_clk => kb_clk,
		 EPclk => rioclk,
		 kb_data => kb_data,
		 resetin => resetin,
		 RDY => inB(4),
		 scen => inB(2),
		 reset => reset,
		 speed => speed,
		 pal => BI(4),
		 Y => inA);


b2v_inst16 : ay8912
PORT MAP(cpuclk => rioclk,
		 reset => reset,
		 cs => CO(7),
		 bc0 => CO(6),
		 bdir => CO(7),
		 shiftclk => shiftclk,
		 ioData => AO,
		 key => key,
		 PortAin => AI,
		 iauda => iauda,
		 lrclk => lrclk,
		 bck => bck,
		 oData => SYNTHESIZED_WIRE_17);



b2v_inst18 : mycpc
PORT MAP(IOWR => iowr,
		 intackin => SYNTHESIZED_WIRE_11,
		 mem_wr => SYNTHESIZED_WIRE_25,
		 vena => vena,
		 sysclk => sysclk,
		 cpuclk => rzclk,
		 RESET => reset,
		 riscview => SYNTHESIZED_WIRE_13,
		 adr => addr,
		 data => DO,
		 memdin => SYNTHESIZED_WIRE_14,
		 VSYNC => BI(0),
		 vgahsync => ff_hsync,
		 vgavsync => SYNTHESIZED_WIRE_26,
		 ramcs => SYNTHESIZED_WIRE_4,
		 C1MHz => C1MHz,
		 int => int,
		 vack => SYNTHESIZED_WIRE_5,
		 pixclk => pixclk,
		 sdaddr => ma,
		 vaddr => vaddr,
		 video => SYNTHESIZED_WIRE_19,
     LROMena => lrom_en,
     HROMena => hrom_en);


b2v_inst3 : rs232
PORT MAP(
     Baudx4 => SYNTHESIZED_WIRE_15,
		 store => SYNTHESIZED_WIRE_16,
		 i => r,
		 snext => SYNTHESIZED_WIRE_23,
     read => '0',
     RxD => '0',
     CTS => '0',
		 TxD => TxD);


b2v_inst5 : core
PORT MAP(clk => rclk,
		 riscena => rena,
		 hsync => ff_hsync,
		 reset => reset,
		 rioclk => rioclk,
		 vsyncin => BI(0),
		 IO_inA => inA,
		 IO_inB => inB,
		 IO_inC => CO,
		 prgdata => pdata,
		 ramdatain => rdata,
		 mem_wr => SYNTHESIZED_WIRE_6,
		 IO_WR => SYNTHESIZED_WIRE_21,
		 IO_RD => SYNTHESIZED_WIRE_24,
		 inA_stb => stbA,
		 refresh => SYNTHESIZED_WIRE_7,
		 ACS => acs,
		 prgadr => raddr,
     joy => (others => '0'),
		 tmatrixo => AI);


b2v_inst6 : D8255
PORT MAP(iowr => iowr,
		 iord => iord,
		 ioclk => rzclk,
		 adr => addr(15 DOWNTO 8),
		 data => DO,
		 PAI => SYNTHESIZED_WIRE_17,
		 PBI => BI,
		 DO => DI,
		 PAO => AO,
		 PCO => CO);


b2v_inst7 : scandoubler
PORT MAP(hsync_in => ff_hsync,
		 vsync_in => SYNTHESIZED_WIRE_26,
		 pixclk => pixclk,
		 bypass => sw(0),
		 video_in => SYNTHESIZED_WIRE_19,
		 vsync_out => vsync,
		 hsync_out => hsync,
		 video_out => video);


refresh <= NOT(SYNTHESIZED_WIRE_26 OR ff_hsync);


b2v_inst9 : fdc_ide
PORT MAP(z80iord => iord,
		 z80iowr => iowr,
		 clk => rioclk,
		 intWR => SYNTHESIZED_WIRE_21,
		 intRD => SYNTHESIZED_WIRE_24,
		 sWR => acs(0),
		 sCE => acs(1),
		 reset => reset,
		 txd_busy => SYNTHESIZED_WIRE_23,
		 speed => speed,
		 riscena => rena,
		 Idedb => idedb,
		 IO_Adr => raddr(15 DOWNTO 0),
		 PBI => BI,
		 ridata => pdata,
		 z80addr => addr,
		 Z80inData => DO,
		 Ide1cs => SYNTHESIZED_WIRE_1,
		 Ide2cs => ide2cs,
		 IO_WR => io_wr,
		 IO_RD => io_rd,
		 swait => iowait,
		 wrena => wrena,
		 rs232clk => SYNTHESIZED_WIRE_15,
		 rs232stb => SYNTHESIZED_WIRE_16,
		 Idea => idea,
		 rs232 => r,
		 z80outData => DI);

TFT_CLK <= pixclk;
LED(7) <= t;
LED(6 DOWNTO 0) <= r(6 DOWNTO 0);

g <= '0';
END bdf_type;