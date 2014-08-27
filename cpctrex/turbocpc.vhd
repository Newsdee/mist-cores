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
-- CREATED		"Thu Jul 10 07:31:50 2014"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY turbocpc IS 
	PORT
	(
  
    -- Clocks
    CLOCK_27    : in std_logic_vector(1 downto 0); -- 27 MHz


    -- SDRAM
    SDRAM_nCS : out std_logic; -- Chip Select
    SDRAM_DQ : inout std_logic_vector(15 downto 0); -- SDRAM Data bus 16 Bits
    SDRAM_A : out std_logic_vector(12 downto 0); -- SDRAM Address bus 13 Bits
    SDRAM_DQMH : out std_logic; -- SDRAM High Data Mask
    SDRAM_DQML : out std_logic; -- SDRAM Low-byte Data Mask
    SDRAM_nWE : out std_logic; -- SDRAM Write Enable
    SDRAM_nCAS : out std_logic; -- SDRAM Column Address Strobe
    SDRAM_nRAS : out std_logic; -- SDRAM Row Address Strobe
    SDRAM_BA : out std_logic_vector(1 downto 0); -- SDRAM Bank Address
    SDRAM_CLK : out std_logic; -- SDRAM Clock
    SDRAM_CKE: out std_logic; -- SDRAM Clock Enable
    
    -- SPI
    SPI_SCK : in std_logic;
    SPI_DI : in std_logic;
    SPI_DO : out std_logic;
    SPI_SS2 : in std_logic;
    SPI_SS3 : in std_logic;
    CONF_DATA0 : in std_logic;

    -- VGA output
    

    VGA_HS,                                             -- H_SYNC
    VGA_VS : out std_logic;                             -- V_SYNC
    VGA_R,                                              -- Red[5:0]
    VGA_G,                                              -- Green[5:0]
    VGA_B : out std_logic_vector(5 downto 0);           -- Blue[5:0]
    
    -- Audio
    AUDIO_L,
    AUDIO_R : out std_logic;
    
    -- LEDG
    LED : out std_logic
    
    
--		PS2_clk :  IN  STD_LOGIC;
--		PS2_data :  IN  STD_LOGIC;
--		CLOCK_50 :  IN  STD_LOGIC;
--		PS2_mdata :  INOUT  STD_LOGIC;
--		PS2_mclk :  INOUT  STD_LOGIC;
--		fl_rst_n :  INOUT  STD_LOGIC;
--		fl_oe_n :  INOUT  STD_LOGIC;
--		I2C_SDAT :  INOUT  STD_LOGIC;
--		CLOCK_27 :  IN  STD_LOGIC_VECTOR(1 TO 1);
--		dram_dq :  INOUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
--		fl_addr :  INOUT  STD_LOGIC_VECTOR(20 DOWNTO 0);
--		fl_dq :  INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		key :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		sw :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
--		nv_cs0_n :  OUT  STD_LOGIC;
--		nv_cs1_n :  OUT  STD_LOGIC;
--		fl_we_n :  OUT  STD_LOGIC;
--		TVRES :  OUT  STD_LOGIC;
--		fl_ce_n :  OUT  STD_LOGIC;
--		dram_cs_n :  OUT  STD_LOGIC;
--		dram_ba_0 :  OUT  STD_LOGIC;
--		dram_ba_1 :  OUT  STD_LOGIC;
--		dram_udqm :  OUT  STD_LOGIC;
--		dram_ldqm :  OUT  STD_LOGIC;
--		dram_cke :  OUT  STD_LOGIC;
--		dram_we_n :  OUT  STD_LOGIC;
--		dram_ras_n :  OUT  STD_LOGIC;
--		dram_cas_n :  OUT  STD_LOGIC;
--		dram_clk :  OUT  STD_LOGIC;
--		UART_TxD :  OUT  STD_LOGIC;
--		VGA_VS :  OUT  STD_LOGIC;
--		VGA_HS :  OUT  STD_LOGIC;
--		I2C_SCLK :  OUT  STD_LOGIC;
--		AUD_XCK :  OUT  STD_LOGIC;
--		AUD_BCLK :  OUT  STD_LOGIC;
--		AUD_DACDAT :  OUT  STD_LOGIC;
--		AUD_DACLRCK :  OUT  STD_LOGIC;
--		dram_addr :  OUT  STD_LOGIC_VECTOR(11 DOWNTO 0);
--		gled :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		VGA_B :  OUT  STD_LOGIC_VECTOR(0 TO 3);
--		VGA_G :  OUT  STD_LOGIC_VECTOR(0 TO 3);
--		VGA_R :  OUT  STD_LOGIC_VECTOR(0 TO 3)
	);
END turbocpc;

ARCHITECTURE bdf_type OF turbocpc IS 

COMPONENT a1k100
	PORT(sysclk : IN STD_LOGIC;
		 shiftclk : IN STD_LOGIC;
		 kb_clk : IN STD_LOGIC;
		 kb_data : IN STD_LOGIC;
		 mouse_clk : INOUT STD_LOGIC;
		 mouse_data : INOUT STD_LOGIC;
		 fl_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 idedb : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 key : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sdata : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 sw : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 vsync : OUT STD_LOGIC;
		 hsync : OUT STD_LOGIC;
		 iauda : OUT STD_LOGIC;
		 lrclk : OUT STD_LOGIC;
		 bck : OUT STD_LOGIC;
		 sd_we : OUT STD_LOGIC;
		 sd_ras : OUT STD_LOGIC;
		 sd_cas : OUT STD_LOGIC;
		 fl_ce : OUT STD_LOGIC;
		 ide1cs : OUT STD_LOGIC;
		 ide2cs : OUT STD_LOGIC;
		 io_wr : OUT STD_LOGIC;
		 io_rd : OUT STD_LOGIC;
		 wrena : OUT STD_LOGIC;
		 TxD : OUT STD_LOGIC;
		 dqm : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 fl_addr : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
		 idea : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sd_addr : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		 sd_ba : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 sd_cs : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 video : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT i2c_av_config
GENERIC (A_PATH_CTRL : INTEGER;
			CLK_Freq : INTEGER;
			D_PATH_CTRL : INTEGER;
			Dummy_DATA : INTEGER;
			I2C_Freq : INTEGER;
			LUT_SIZE : INTEGER;
			POWER_ON : INTEGER;
			SAMPLE_CTRL : INTEGER;
			SET_ACTIVE : INTEGER;
			SET_FORMAT : INTEGER;
			SET_HEAD_L : INTEGER;
			SET_HEAD_R : INTEGER;
			SET_LIN_L : INTEGER;
			SET_LIN_R : INTEGER
			);
	PORT(iCLK : IN STD_LOGIC;
		 iRST_N : IN STD_LOGIC;
		 I2C_SDAT : INOUT STD_LOGIC;
		 I2C_SCLK : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT clock
	PORT(inclk0 : IN STD_LOGIC;
		 c0 : OUT STD_LOGIC;
		 c1 : OUT STD_LOGIC
	);
END COMPONENT;

--COMPONENT altpll1
--	PORT(inclk0 : IN STD_LOGIC;
--		 c0 : OUT STD_LOGIC
--	);
--END COMPONENT;

COMPONENT trex_mux
	PORT(flce_in : IN STD_LOGIC;
		 ide1cs : IN STD_LOGIC;
		 ide2cs : IN STD_LOGIC;
		 io_wr : IN STD_LOGIC;
		 io_rd : IN STD_LOGIC;
		 wrena : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 cfreset : IN STD_LOGIC;
		 flrst : INOUT STD_LOGIC;
		 floe : INOUT STD_LOGIC;
		 fladdr : INOUT STD_LOGIC_VECTOR(20 DOWNTO 0);
		 fladdr_in : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
		 fldata : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Idea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Idedb : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 flwe : OUT STD_LOGIC;
		 cf_cs0 : OUT STD_LOGIC;
		 cf_cs1 : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	ba :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	dqm :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	fl_ce_n_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	idea :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	idedb :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	sd_cs :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	sdaddr :  STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL	sdata :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	sysclk :  STD_LOGIC;
SIGNAL	vcc :  STD_LOGIC;
SIGNAL	video :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(20 DOWNTO 0);


BEGIN 



b2v_inst : a1k100
PORT MAP(sysclk => sysclk,
		 shiftclk => SYNTHESIZED_WIRE_0,
		 kb_clk => '0',
		 kb_data => '0',
--		 mouse_clk => PS2_mclk,
--		 mouse_data => PS2_mdata,
		 fl_data => (others => '0'),
		 idedb => idedb,
		 key => (others => '0'),
		 sdata => sdata,
		 sw => (others => '0'),
		 vsync => VGA_VS,
		 hsync => VGA_HS,
--		 iauda => AUD_DACDAT,
--		 lrclk => AUD_DACLRCK,
--		 bck => AUD_BCLK,
		 sd_we => SDRAM_nWE,
		 sd_ras => SDRAM_nRAS,
		 sd_cas => SDRAM_nCAS,
		 fl_ce => fl_ce_n_ALTERA_SYNTHESIZED,
		 ide1cs => SYNTHESIZED_WIRE_1,
		 ide2cs => SYNTHESIZED_WIRE_2,
		 io_wr => SYNTHESIZED_WIRE_3,
		 io_rd => SYNTHESIZED_WIRE_4,
		 wrena => SYNTHESIZED_WIRE_5,
--		 TxD => UART_TxD,
		 dqm => dqm,
		 fl_addr => SYNTHESIZED_WIRE_6,
		 idea => idea,
		 LED => open,
		 sd_addr => sdaddr,
		 sd_ba => ba,
		 sd_cs => sd_cs,
		 video => video);


--b2v_inst1 : i2c_av_config
--GENERIC MAP(A_PATH_CTRL => 5,
--			CLK_Freq => 50000000,
--			D_PATH_CTRL => 6,
--			Dummy_DATA => 0,
--			I2C_Freq => 20000,
--			LUT_SIZE => 11,
--			POWER_ON => 7,
--			SAMPLE_CTRL => 9,
--			SET_ACTIVE => 10,
--			SET_FORMAT => 8,
--			SET_HEAD_L => 3,
--			SET_HEAD_R => 4,
--			SET_LIN_L => 1,
--			SET_LIN_R => 2
--			)
--PORT MAP(iCLK => CLOCK_50,
--		 iRST_N => key(3),
--		 I2C_SDAT => I2C_SDAT,
--		 I2C_SCLK => I2C_SCLK);



b2v_inst13 : clock
PORT MAP(inclk0 => CLOCK_27(1),
		 c0 => sysclk,
		 c1 => SYNTHESIZED_WIRE_0);


--b2v_inst3 : altpll1
--PORT MAP(inclk0 => CLOCK_50,
--		 c0 => AUD_XCK);


b2v_inst4 : trex_mux
PORT MAP(flce_in => fl_ce_n_ALTERA_SYNTHESIZED,
		 ide1cs => SYNTHESIZED_WIRE_1,
		 ide2cs => SYNTHESIZED_WIRE_2,
		 io_wr => SYNTHESIZED_WIRE_3,
		 io_rd => SYNTHESIZED_WIRE_4,
		 wrena => SYNTHESIZED_WIRE_5,
		 reset => '0',
		 cfreset => '0',
--		 flrst => fl_rst_n,
--		 floe => fl_oe_n,
--		 fladdr => fl_addr,
		 fladdr_in => SYNTHESIZED_WIRE_6,
--		 fldata => fl_dq,
		 Idea => idea,
		 Idedb => idedb
--		 flwe => fl_we_n,
--		 cf_cs0 => nv_cs0_n,
--		 cf_cs1 => nv_cs1_n
     );

SDRAM_DQ <= sdata;
--fl_ce_n <= fl_ce_n_ALTERA_SYNTHESIZED;
SDRAM_nCS <= sd_cs(0);
SDRAM_BA <= ba;
SDRAM_DQMH <= dqm(1);
SDRAM_DQML <= dqm(0);
SDRAM_CKE <= vcc;
SDRAM_CLK <= sysclk;
SDRAM_A(11 DOWNTO 0) <= sdaddr(11 DOWNTO 0);
VGA_B(4 downto 0) <= video(15 DOWNTO 11);
VGA_G(5 downto 0) <= video(10 DOWNTO 5);
VGA_R(4 downto 0) <= video(4 DOWNTO 0);

END bdf_type;