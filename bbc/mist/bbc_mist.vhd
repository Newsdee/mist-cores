--
-- bbc_mist.vhd
--
-- bbc micro toplevel for the MiST board
-- https://github.com/wsoltys/
--
-- Copyright (c) 2014 W. Soltys <wsoltys@gmail.com>
--
-- This source file is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published
-- by the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This source file is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- -----------------------------------------------------------------------

entity bbc_mist is
    port (
    
-- Clock
      CLOCK_27 : in std_logic_vector(1 downto 0);

-- SPI
      SPI_SCK : in std_logic;
      SPI_DI : in std_logic;
      SPI_DO : out std_logic;
      SPI_SS2 : in std_logic;
      SPI_SS3 : in std_logic;
      CONF_DATA0 : in std_logic;

-- LED
      LED : out std_logic;

-- Video
      VGA_R : out std_logic_vector(5 downto 0);
      VGA_G : out std_logic_vector(5 downto 0);
      VGA_B : out std_logic_vector(5 downto 0);
      VGA_HS : out std_logic;
      VGA_VS : out std_logic;

-- Audio
      AUDIO_L : out std_logic;
      AUDIO_R : out std_logic;
      
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
    SDRAM_CKE: out std_logic -- SDRAM Clock Enable
    
    );
end entity;

-- -----------------------------------------------------------------------

architecture rtl of bbc_mist is

-- System clocks
  signal clk96m: std_logic := '0';
  signal clk32m: std_logic := '0';
  signal clk24m: std_logic := '0';
  signal clk16m: std_logic := '0';
  signal clk12k : std_logic := '0';
  signal pll_locked : std_logic := '0';
  
  signal reset    : std_logic;
  signal audio    : std_logic;
  signal VGA_R_O  : std_logic_vector(3 downto 0);
  signal VGA_G_O  : std_logic_vector(3 downto 0);
  signal VGA_B_O  : std_logic_vector(3 downto 0);
  signal VGA_HS_O : std_logic;
  signal VGA_VS_O : std_logic;

-- User IO
  signal buttons: std_logic_vector(1 downto 0);
  signal status: std_logic_vector(7 downto 0);
  signal joy_0: std_logic_vector(7 downto 0);
  signal joy_1: std_logic_vector(7 downto 0);
  signal joy_ana_0: std_logic_vector(15 downto 0);
  signal joy_ana_1: std_logic_vector(15 downto 0);
  signal txd: std_logic;
  signal par_out_data: std_logic_vector(7 downto 0);
  signal par_out_strobe: std_logic;
  
-- signals to connect sd card emulation with io controller
  signal sd_lba: std_logic_vector(31 downto 0);
  signal sd_rd: std_logic;
  signal sd_wr: std_logic;
  signal sd_ack: std_logic;
  signal sd_conf: std_logic;
  signal sd_sdhc: std_logic;
  signal sd_allow_sdhc: std_logic;
  signal sd_allow_sdhcD: std_logic;
  signal sd_allow_sdhcD2: std_logic;
  signal sd_allow_sdhc_changed: std_logic;
-- data from io controller to sd card emulation
  signal sd_data_in: std_logic_vector(7 downto 0);
  signal sd_data_in_strobe: std_logic;
  signal sd_data_out: std_logic_vector(7 downto 0);
  signal sd_data_out_strobe: std_logic;
  
-- sd card emulation
  signal sd_cs: std_logic;
  signal sd_sck: std_logic;
  signal sd_sdi: std_logic;
  signal sd_sdo: std_logic;
  
-- sdram
  signal sdram_dqm  : std_logic_vector(1 downto 0);
  signal sdram_we_n : std_logic;
  signal sdram_oe_n : std_logic;
  signal sdram_addr : std_logic_vector(17 downto 0);
  signal sdram_di   : std_logic_vector(7 downto 0);
  signal sdram_do   : std_logic_vector(7 downto 0);
  signal bbc_sdram_dq   : std_logic_vector(15 downto 0);
  
-- roms
  signal fl_addr  : std_logic_vector(21 downto 0);
  signal fl_dq    : std_logic_vector(7 downto 0);
  signal basic_dq : std_logic_vector(7 downto 0);
  signal os_dq    : std_logic_vector(7 downto 0);
  signal mmc_dq   : std_logic_vector(7 downto 0);
  
-- PS/2 Keyboard
  signal ps2_keyboard_clk_in : std_logic;
  signal ps2_keyboard_dat_in : std_logic;
  
-- PS/2 Mouse
  signal ps2_mouse_clk_in : std_logic;
  signal ps2_mouse_dat_in : std_logic;
  
-- DataIO handling
  signal forceReset : std_logic := '1';
  signal downl : std_logic := '0';
  signal size : std_logic_vector(25 downto 0) := (others=>'0');
  signal io_dout: std_logic_vector(7 downto 0);
  signal io_addr: std_logic_vector(25 downto 0);
  signal io_we: std_logic := '0';
  signal vic_joy: std_logic_vector(4 downto 0);
  signal io_is_prg : std_logic := '1';
  
  signal vic_audio : std_logic_vector( 3 downto 0);
  signal audio_pwm : std_logic;
  
  signal flash_clk : unsigned(22 downto 0) := (others => '0');

  -- config string used by the io controller to fill the OSD
  constant CONF_STR : string := "BBC;PRG;";

  function to_slv(s: string) return std_logic_vector is
    constant ss: string(1 to s'length) := s;
    variable rval: std_logic_vector(1 to 8 * s'length);
    variable p: integer;
    variable c: integer;
  
  begin  
    for i in ss'range loop
      p := 8 * i;
      c := character'pos(ss(i));
      rval(p - 7 to p) := std_logic_vector(to_unsigned(c,8));
    end loop;
    return rval;

  end function;
  
  component user_io
    generic ( STRLEN : integer := 0 );
    port (
      SPI_CLK, SPI_SS_IO, SPI_MOSI :in std_logic;
      SPI_MISO : out std_logic;
      conf_str : in std_logic_vector(8*STRLEN-1 downto 0);
      joystick_0 : out std_logic_vector(7 downto 0);
      joystick_1 : out std_logic_vector(7 downto 0);
      joystick_analog_0 : out std_logic_vector(15 downto 0);
      joystick_analog_1 : out std_logic_vector(15 downto 0);
      status: out std_logic_vector(7 downto 0);
      switches : out std_logic_vector(1 downto 0);
      buttons : out std_logic_vector(1 downto 0);
      sd_lba : in std_logic_vector(31 downto 0);
      sd_rd : in std_logic;
      sd_wr : in std_logic;
      sd_ack : out std_logic;
      sd_conf : in std_logic;
      sd_sdhc : in std_logic;
      sd_dout : out std_logic_vector(7 downto 0);
      sd_dout_strobe : out std_logic;
      sd_din : in std_logic_vector(7 downto 0);
      sd_din_strobe : out std_logic;
      ps2_clk : in std_logic;
      ps2_kbd_clk : out std_logic;
      ps2_kbd_data : out std_logic;
      ps2_mouse_clk : out std_logic;
      ps2_mouse_data : out std_logic;
      serial_data : in std_logic_vector(7 downto 0);
      serial_strobe : in std_logic
    );
  end component user_io;
  
  component sd_card
    port ( 
      io_lba : out std_logic_vector(31 downto 0);
      io_rd : out std_logic;
      io_wr : out std_logic;
      io_ack : in std_logic;
      io_sdhc : out std_logic;
      io_conf : out std_logic;
      io_din : in std_logic_vector(7 downto 0);
      io_din_strobe : in std_logic;
      io_dout : out std_logic_vector(7 downto 0);
      io_dout_strobe : in std_logic;
      allow_sdhc : in std_logic;
      sd_cs : in std_logic;
      sd_sck : in std_logic;
      sd_sdi : in std_logic;
      sd_sdo : out std_logic
    );
  end component sd_card;
  
  component sdram is
    port( sd_data : inout std_logic_vector(15 downto 0);
          sd_addr : out std_logic_vector(12 downto 0);
          sd_dqm : out std_logic_vector(1 downto 0);
          sd_ba : out std_logic_vector(1 downto 0);
          sd_cs : out std_logic;
          sd_we : out std_logic;
          sd_ras : out std_logic;
          sd_cas : out std_logic;
          init : in std_logic;
          clk : in std_logic;
          clkref : in std_logic;
          din : in std_logic_vector(7 downto 0);
          dout : out std_logic_vector(7 downto 0);
          addr : in std_logic_vector(24 downto 0);
          oe : in std_logic;
          we : in std_logic
    );
  end component;
  
--  component data_io is
--    port ( sck: in std_logic;
--           ss: in std_logic;
--           sdi: in std_logic;
--           downloading: out std_logic;
--           size: out std_logic_vector(25 downto 0);
--           clk: in std_logic;
--           wr: out std_logic;
--           a: out std_logic_vector(25 downto 0);
--           d: out std_logic_vector(7 downto 0));
--  end component;

  component osd
    port (
      pclk, sck, ss, sdi, hs_in, vs_in, scanline_ena_h : in std_logic;
      red_in, blue_in, green_in : in std_logic_vector(5 downto 0);
      red_out, blue_out, green_out : out std_logic_vector(5 downto 0);
      hs_out, vs_out : out std_logic
    );
  end component osd;

begin

-- -----------------------------------------------------------------------
-- MiST
-- -----------------------------------------------------------------------

  reset <= status(0) or buttons(1) or forceReset or not pll_locked;
  
  flash_clkgen : process (clk16m)
  begin
    if rising_edge(clk16m) then
      flash_clk <= flash_clk + 1;
      if flash_clk(22) = '1' then
        forceReset <= '0';
      end if;
    end if;     
  end process;
  
  bbc_inst : entity work.bbc_micro_de1
    port map (
      CLOCK_24  => clk24m & clk24m,
      CLOCK_27  => "00",
      CLOCK_50  => '0',
      EXT_CLOCK => clk32m,
      RESET_L   => not reset,
      SW        => "1100000000",
      KEY       => "1111",
      
      VGA_R     => VGA_R_O,
      VGA_G     => VGA_G_O,
      VGA_B     => VGA_B_O,
      VGA_HS    => VGA_HS_O,
      VGA_VS    => VGA_VS_O,
      
      UART_RXD  => '0',
      UART_TXD  => open,
      
      PS2_CLK   => ps2_keyboard_clk_in,
      PS2_DAT   => ps2_keyboard_dat_in,
      
      AUD_XCK     => open,
      AUD_BCLK    => open,
      AUD_ADCLRCK => open,
      AUD_ADCDAT  => '0',
      AUD_DACLRCK => open,
      AUD_DACDAT  => open,
      
      SRAM_ADDR => sdram_addr,
      SRAM_DQ   => bbc_sdram_dq,
      SRAM_OE_N => sdram_oe_n,
      SRAM_WE_N => sdram_we_n,
      
      FL_ADDR   => fl_addr,
      FL_DQ     => fl_dq,
      
      SD_nCS    => sd_cs,
      SD_MOSI   => sd_sdi,
      SD_SCLK   => sd_sck,
      SD_MISO   => sd_sdo
    
    );

  --  OSD
  osd_inst : osd
    port map (
      pclk => clk16m,
      sdi => SPI_DI,
      sck => SPI_SCK,
      ss => SPI_SS3,
      red_in => VGA_R_O & "00",
      green_in => VGA_G_O & "00",
      blue_in => VGA_B_O & "00",
      hs_in => VGA_HS_O,
      vs_in => VGA_VS_O,
      scanline_ena_h => '0', --status(2),
      red_out => VGA_R,
      green_out => VGA_G,
      blue_out => VGA_B,
      hs_out => VGA_HS,
      vs_out => VGA_VS
    );
    
  -- sdram interface
  SDRAM_CKE <= '1';
  SDRAM_DQMH <= sdram_dqm(1);
  SDRAM_DQML <= sdram_dqm(0);

  sdram_inst : sdram
    port map( sd_data => SDRAM_DQ,
              sd_addr => SDRAM_A,
              sd_dqm => sdram_dqm,
              sd_cs => SDRAM_nCS,
              sd_ba => SDRAM_BA,
              sd_we => SDRAM_nWE,
              sd_ras => SDRAM_nRAS,
              sd_cas => SDRAM_nCAS,
              clk => clk96m,
              clkref => clk32m,
              init => not pll_locked,
              din => sdram_di,
              addr => "0000000" & sdram_addr,
              we => not sdram_we_n,
              oe => not sdram_oe_n,
              dout => sdram_do
    );

--  ram_inst : entity work.spram
--    generic map
--    (
--      widthad_a	=> 14
--    )
--    port map
--    (
--      clock	=> clk32m,
--      address	=> sdram_addr(13 downto 0),
--      wren	=> not sdram_we_n,
--      data	=> sdram_di,
--      q	=> sdram_do
--    );
    
  bbc_sdram_dq(7 downto 0) <= sdram_do when sdram_we_n = '1' else "ZZZZZZZZ";
  sdram_di     <= bbc_sdram_dq(7 downto 0) when sdram_we_n = '0' else "ZZZZZZZZ";
   
  
-- -----------------------------------------------------------------------
-- ROMs
--------------------------------------------------------------------------

  basic : entity work.BBC_BASIC_ROM 
    port map (
      CLK   => clk16m,
      ADDR  => fl_addr(13 downto 0),
      DATA  => basic_dq
    );
    
  os : entity work.BBC_OS12_ROM 
    port map (
      CLK   => clk16m,
      ADDR  => fl_addr(13 downto 0),
      DATA  => os_dq
    );
    
  supermmc : entity work.BBC_SUPERMMC_ROM 
    port map (
      CLK   => clk16m,
      ADDR  => fl_addr(13 downto 0),
      DATA  => mmc_dq
    );

  fl_dq <= os_dq    when fl_addr(16 downto 14) = "111" else
           mmc_dq   when fl_addr(16 downto 14) = "010" else
           basic_dq when fl_addr(16 downto 14) = "011" else
           "ZZZZZZZZ";

-- -----------------------------------------------------------------------
-- Clocks and PLL
-- -----------------------------------------------------------------------
  pllInstance : entity work.pll27
    port map (
      inclk0 => CLOCK_27(0),
      c0 => clk96m,
      c1 => SDRAM_CLK,
      c2 => clk12k,
      locked => pll_locked
    );
    
  clkdiv16 : entity work.clk_div
    generic map (
      DIVISOR => 2
    )
    port map (
      clk    => clk32m,
      reset  => '0',
      clk_en => clk16m
    );

  clkdiv24 : entity work.clk_div
    generic map (
      DIVISOR => 4
    )
    port map (
      clk    => clk96m,
      reset  => '0',
      clk_en => clk24m
    );
    
  clkdiv32 : entity work.clk_div
    generic map (
      DIVISOR => 3
    )
    port map (
      clk    => clk96m,
      reset  => '0',
      clk_en => clk32m
    );

-- ------------------------------------------------------------------------
-- User IO
-- ------------------------------------------------------------------------

  user_io_d : user_io
    generic map (STRLEN => CONF_STR'length)
    port map (
      SPI_CLK => SPI_SCK,
      SPI_SS_IO => CONF_DATA0,
      SPI_MISO => SPI_DO,
      SPI_MOSI => SPI_DI,
      conf_str => to_slv(CONF_STR),
      status => status,
      -- connection to io controller
      sd_lba => sd_lba,
      sd_rd => sd_rd,
      sd_wr => sd_wr,
      sd_ack => sd_ack,
      sd_sdhc => sd_sdhc,
      sd_conf => sd_conf,
      sd_dout => sd_data_in,
      sd_dout_strobe => sd_data_in_strobe,
      sd_din => sd_data_out,
      sd_din_strobe => sd_data_out_strobe,
      joystick_0 => joy_0,
      joystick_1 => joy_1,
      joystick_analog_0 => joy_ana_0,
      joystick_analog_1 => joy_ana_1,
      -- switches => switches,
      BUTTONS => buttons,
      ps2_clk => clk12k,
      ps2_kbd_clk => ps2_keyboard_clk_in,
      ps2_kbd_data => ps2_keyboard_dat_in,
      ps2_mouse_clk => ps2_mouse_clk_in,
      ps2_mouse_data => ps2_mouse_dat_in,
      serial_data => par_out_data,
      serial_strobe => par_out_strobe
  );
  
  sd_card_d: component sd_card
    port map
    (
      -- connection to io controller
      io_lba => sd_lba,
      io_rd => sd_rd,
      io_wr => sd_wr,
      io_ack => sd_ack,
      io_conf => sd_conf,
      io_sdhc => sd_sdhc,
      io_din => sd_data_in,
      io_din_strobe => sd_data_in_strobe,
      io_dout => sd_data_out,
      io_dout_strobe => sd_data_out_strobe,
      allow_sdhc => '0', -- BBC does not support SDHC
      -- connection to host
      sd_cs => sd_cs,
      sd_sck => sd_sck,
      sd_sdi => sd_sdi,
      sd_sdo => sd_sdo
    );
    
  -- Joystick


  --
  -- Audio
  --


end architecture;
