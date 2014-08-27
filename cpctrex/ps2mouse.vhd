--
-- PS/2 serial port, input only
--
-- Version : 0242
--
-- Copyright (c) 2002 Daniel Wallner (jesus@opencores.org)
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- Please report bugs to the author, but before you do so, please
-- make sure that this is not a derivative work and that
-- you have the latest version of this file.
--
-- The latest version of this file can be found at:
--      http://www.fpgaarcade.com
--
-- Limitations :
--
-- File history :
--
--      0242 : First release
--
-- Changes for Mouse Support Tobias Gubener
-- Mouse Init by TobiFlex


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ps2mouse is
	port(
		Rst_n           : in std_logic;
		Clk             : in std_logic;
		T1MHz         	: in std_logic;
		PS2_Clk         : inout std_logic;
		PS2_Data        : inout std_logic;
		cpuclk			: in std_logic;
		addr			: in std_logic_vector(15 downto 0);
		iord			: in std_logic;
		risc			: in std_logic;
		raddr			: in std_logic_vector(15 downto 0);
		rio_rd			: in std_logic;
		DO		        : out std_logic_vector(7 downto 0);
		rdo		        : out std_logic_vector(7 downto 0));
		
end ps2mouse;

architecture rtl of ps2mouse is

	signal      PS2_Sample              : std_logic;
--	signal      PS2_Send              	: std_logic;
	signal      PS2_Data_s              : std_logic;

	signal      RX_Bit_Cnt              : unsigned(3 downto 0);
	signal      RX_Byte                 : unsigned(1 downto 0);
	signal      RX_ShiftReg             : std_logic_vector(7 downto 0);
	signal      RX_Received             : std_logic;
	signal      X_Move	 	            : std_logic_vector(8 downto 0);
	signal      Y_Move	 	            : std_logic_vector(8 downto 0);
	signal      Buttons	 	            : std_logic_vector(3 downto 0);
	signal		ioout					: std_logic_vector(7 downto 0);
	signal		iosel, ioseld			: std_logic;
	signal		riosel					: std_logic;
	signal		Tick1us					: std_logic;
	signal  	T1MHzd					: std_logic;
	signal  	initout					: std_logic;
	signal  	timeout					: std_logic;
	signal		host					: unsigned(6 downto 0);
	signal  	riscpass				: std_logic;
begin

--	iosel <= '1' when addr=X"FD20" and iord='0' else '0'; 
	iosel <= '1' when addr=X"FD10" and iord='0' else '0'; 
	riosel <= '1' when raddr=X"FD10" and rio_rd='0' else '0'; 
	DO <= "00000000" when iosel='1' and risc='1' else ioout when iosel='1' else "ZZZZZZZZ";
	rDO <="00000000" when riosel='1' and risc='0' else  ioout when riosel='1' else "ZZZZZZZZ";
--	DO <= "0000"&timeout&Buttons;
	PS2_Data <= 'Z' when initout='0' else '0';
	PS2_Clk <= 'Z' when host = "1111111" else '0';
--	LED <= "1100"&Buttons;
	process (Clk, Rst_n)
		variable PS2_Data_r             : std_logic_vector(1 downto 0);
		variable PS2_Clk_r              : std_logic_vector(1 downto 0);
		variable PS2_Clk_State  : std_logic;
	begin
		if Rst_n = '0' then
			PS2_Sample <= '0';
--			PS2_Send <= '0';
			PS2_Data_s <= '0';
			PS2_Data_r := "11";
			PS2_Clk_r := "11";
			PS2_Clk_State := '1';
		elsif Clk'event and Clk = '1' then
			T1MHzd<=T1MHz;
			Tick1us <= T1MHz and NOT T1MHzd;
			if Tick1us = '1' then
				PS2_Sample <= '0';

				-- Deglitch
				if PS2_Data_r = "00" then
					PS2_Data_s <= '0';
				end if;
				if PS2_Data_r = "11" then
					PS2_Data_s <= '1';
				end if;
				if PS2_Clk_r = "00" then
					if PS2_Clk_State = '1' then
						PS2_Sample <= '1';
					end if;
					PS2_Clk_State := '0';
				end if;
				if PS2_Clk_r = "11" then
--					if PS2_Clk_State = '0' then
--						PS2_Send <= '1';
--					end if;
					PS2_Clk_State := '1';
				end if;

				-- Double synchronise
				PS2_Data_r(1) := PS2_Data_r(0);
				PS2_Clk_r(1) := PS2_Clk_r(0);
				PS2_Data_r(0) := PS2_Data;
				PS2_Clk_r(0) := PS2_Clk;
			end if;
		end if;
	end process;

	process (Clk, Rst_n)
		variable Cnt : integer;
	begin
		if Rst_n = '0' then
			RX_Bit_Cnt <= (others => '0');
			RX_ShiftReg <= (others => '0');
			RX_Received <= '0';
			Cnt := 0;
		elsif Clk'event and Clk = '1' then
			RX_Received <= '0';
			timeout <= '0';
			if Tick1us = '1' then

				if PS2_Sample = '1' then
					if RX_Bit_Cnt = "0000" then
						if PS2_Data_s = '0' then -- Start bit
							RX_Bit_Cnt <= RX_Bit_Cnt + 1;
						end if;
					elsif RX_Bit_Cnt = "1001" then -- Parity bit
						RX_Bit_Cnt <= RX_Bit_Cnt + 1;
						-- Ignoring parity
					elsif RX_Bit_Cnt = "1010" then -- Stop bit
						if PS2_Data_s = '1' then
							RX_Received <= '1';
						end if;
						RX_Bit_Cnt <= "0000";
					else
						RX_Bit_Cnt <= RX_Bit_Cnt + 1;
						RX_ShiftReg(6 downto 0) <= RX_ShiftReg(7 downto 1);
						RX_ShiftReg(7) <= PS2_Data_s;
					end if;
				end if;


				-- TimeOut
				if Cnt = 1023 then -- or initout='1' then
					RX_Bit_Cnt <= "0000";
					Cnt := 0;
					timeout <= '1';
				elsif PS2_Sample = '1' then
					Cnt := 0;
				else	
					Cnt := Cnt + 1;
				end if;
			end if;
		end if;
	end process;


--Mouse init by TobiFlex
	process (Clk, Rst_n)
		variable initbyte : std_logic_vector(8 downto 0);
	begin
		if Rst_n = '0' then
			initbyte := "011110100";		--F4
			initout <= '0';
			host <= (others => '0');
		elsif Clk'event and Clk = '1' then
			if Tick1us = '1' then
				if host = "1111110" then 
					initout <= '1';
				end if;	
				if host = "1111111" then 
--					if PS2_Send = '1' then
					if PS2_Sample = '1' then
						initout <= NOT initbyte(0);
						initbyte :=('1'&initbyte(8 downto 1));
					end if;
				else
					host <= host + 1;
				end if;	
			end if;
		end if;
	end process;
	
-- byte 0: YV, XV, YS, XS, 1, 0, R, L
-- byte 1: X7..X0
-- byte 2: Y7..Y0
--
-- Where YV, XV are set to indicate overflow conditions.
--       XS, YS are set to indicate negative quantities (sign bits).
--        R,  L are set to indicate buttons pressed, left and right.

	process (Clk, Rst_n, risc)
	begin
		if Rst_n = '0' then
			X_Move <= (others => '0');
			Y_Move <= (others => '0');
			Buttons <= (others => '0');
			RX_Byte <= (others => '0');
			riscpass <= '0';
		elsif Clk'event and Clk = '1' then
			if risc='0' then
				riscpass <= '0';	
			end if;
			if timeout='1' then	--TimeOut
				RX_Byte <= "00";
			end if;
			if RX_Received = '1' then
				if RX_Byte = "00" and RX_ShiftReg(3)='1' then
					RX_Byte <= "01";
					Buttons <= '1' & RX_ShiftReg(2 downto 0);
					X_Move(8) <= RX_ShiftReg(4);
					Y_Move(8) <= RX_ShiftReg(5);
				elsif RX_Byte = "01" then
					RX_Byte <= "10";
					X_Move(7 downto 0) <= RX_ShiftReg;
				elsif RX_Byte = "10" then
					RX_Byte <= "00";
--					RX_Byte <= "11";
					Y_Move(7 downto 0) <= RX_ShiftReg;
--					Y_Move(8 downto 0) <= "000000000" - (Y_Move(8)&RX_ShiftReg);
--					Y_Move(8 downto 0) <= not ((Y_Move(8)&RX_ShiftReg)-1);
--				else
--					RX_Byte <= "00";
				end if;
			else
				ioseld <= (iosel and not risc) OR (riosel and risc);
				if ((iosel and not risc) OR (riosel and risc))='0' and ioseld='1' then
					if risc='1' then
						riscpass <= not riscpass;
					end if;
					if (not risc or riscpass)='1' then
						if ioout(7 downto 6)="01" then
							X_Move <= (others => '0');
						elsif ioout(7 downto 6)="10" then
							Y_Move <= (others => '0');
						elsif ioout(7 downto 5)="110" then
							Buttons(3) <= '0';
						end if;
					end if;	
				end if;
			end if;
		end if;
	end process;
	
	process(X_move, Y_move, Buttons)
	begin
		if X_move(7 downto 0)/= "00000000" then
			if X_move(7 downto 5)="000" or X_move(7 downto 5)="111" then
				ioout <= ("01"&X_Move(5 downto 0));
			elsif X_move(7)='0' then
				ioout <= ("01011111");
			else
				ioout <= ("01100000");
			end if;	
		elsif Y_move(7 downto 0) /= "00000000" then	
			if Y_move(7 downto 5)="000" or Y_move(7 downto 5)="111" then
				ioout <= ("10"&Y_Move(5 downto 0));
			elsif Y_move(7)='0' then
				ioout <= ("10011111");
			else
				ioout <= ("10100000");
			end if;	
		elsif Buttons(3)='1' then
			ioout <= "11000" & Buttons(2 downto 0) ;
		else
			ioout <= "00000000";
		end if;	
	end process;
end;
