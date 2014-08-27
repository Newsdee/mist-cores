-- Copyright (c) 2005-2006 Tobias Gubener
-- Subdesign CPC T-REX by TobiFlex
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



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity trex_mux is
port
	(
	fladdr_in	: in std_logic_vector(20 downto 0);
	flce_in		: in std_logic;
	Idedb		: inout std_logic_vector(15 downto 0);
	Idea		: in std_logic_vector(3 downto 0);
	ide1cs		: in std_logic;
	ide2cs		: in std_logic;
	io_wr		: in std_logic;
	io_rd		: in std_logic;
	wrena		: in std_logic;
	reset		: in std_logic;
	cfreset		: in std_logic;
--Pins
	fladdr		: inout std_logic_vector(20 downto 0);
	fldata		: inout std_logic_vector(7 downto 0);
	flrst		: inout std_logic;
	flwe		: out std_logic;
	floe		: inout std_logic;
	cf_cs0		: out std_logic;
	cf_cs1		: out std_logic
	);
end;

architecture rtl of trex_mux is
begin
	cf_cs1 <= idea(3) when cfreset='1' else '1';
	cf_cs0 <= ide1cs when cfreset='1' else '0';

	fladdr(2) <= fladdr_in(2) when flce_in='0' else Idedb(3) when wrena='1' else 'Z';
	Idedb(3)  <= fladdr(2) when io_rd='0' else 'Z';

	fladdr(3) <= fladdr_in(3) when flce_in='0' else Idedb(11) when wrena='1' else 'Z';
	Idedb(11) <= fladdr(3) when io_rd='0' else 'Z';
	
	fladdr(4) <= fladdr_in(4) when flce_in='0' else Idedb(4) when wrena='1' else 'Z';
	Idedb(4)  <= fladdr(4) when io_rd='0' else 'Z';
	
	fladdr(5) <= fladdr_in(5) when flce_in='0' else Idedb(12) when wrena='1' else 'Z';
	Idedb(12) <= fladdr(5) when io_rd='0' else 'Z';
	
	fladdr(6) <= fladdr_in(6) when flce_in='0' else Idedb(5) when wrena='1' else 'Z';
	Idedb(5)  <= fladdr(6) when io_rd='0' else 'Z';
	
	fladdr(7) <= fladdr_in(7) when flce_in='0' else Idedb(13) when wrena='1' else 'Z';
	Idedb(13) <= fladdr(7) when io_rd='0' else 'Z';
	
	fladdr(8) <= fladdr_in(8) when flce_in='0' else Idedb(6) when wrena='1' else 'Z';
	Idedb(6)  <= fladdr(8) when io_rd='0' else 'Z';
	
	fladdr(18)<= fladdr_in(18) when flce_in='0' else Idedb(14) when wrena='1' else 'Z';
	Idedb(14) <= fladdr(18) when io_rd='0' else 'Z';
	
	fladdr(19)<= fladdr_in(19) when flce_in='0' else Idedb(7) when wrena='1' else 'Z';
	Idedb(7)  <= fladdr(19) when io_rd='0' else 'Z';
	
	flrst     <= '1' when flce_in='0' else Idedb(15) when wrena='1' else 'Z';
	Idedb(15) <= flrst when io_rd='0' else 'Z';
	
	flwe 	  <= '1' when flce_in='0' else io_rd;-- when wrena='1' else '1';
	
	fladdr(20) <= fladdr_in(20) when flce_in='0' else io_wr;
	
	fladdr(9) <= fladdr_in(9) when flce_in='0' else 'Z';
	
	fladdr(10) <= fladdr_in(10) when flce_in='0' else cfreset;

	fladdr(11) <= fladdr_in(11);
	
	fladdr(12) <= fladdr_in(12) when flce_in='0' else 'Z';
	
	fladdr(13) <= fladdr_in(13) when flce_in='0' else idea(2);
	
	fladdr(14) <= fladdr_in(14) when flce_in='0' else idea(1);

	fladdr(15) <= fladdr_in(15) when flce_in='0' else '1';

	fladdr(16) <= fladdr_in(16) when flce_in='0' else idea(0);

	fladdr(1) <= fladdr_in(1) when flce_in='0' else Idedb(0) when wrena='1' else 'Z';
	Idedb(0) <= fladdr(1) when io_rd='0' else 'Z';

	floe <= '0' when flce_in='0' else Idedb(1) when wrena='1' else 'Z';
	Idedb(1) <= floe when io_rd='0' else 'Z';
	
	fldata(0) <= 'Z' when flce_in='0' else Idedb(8) when wrena='1' else 'Z';
	Idedb(8) <= fldata(0) when io_rd='0' else 'Z';
	
	fldata(1) <= 'Z' when flce_in='0' else Idedb(2) when wrena='1' else 'Z';
	Idedb(2) <= fldata(1) when io_rd='0' else 'Z';
	
	fldata(2) <= 'Z' when flce_in='0' else Idedb(9) when wrena='1' else 'Z';
	Idedb(9) <= fldata(2) when io_rd='0' else 'Z';
	
	fldata(4) <= 'Z' when flce_in='0' else Idedb(10) when wrena='1' else 'Z';
	Idedb(10) <= fldata(4) when io_rd='0' else 'Z';
	
	fladdr(0) <= fladdr_in(0);

	fladdr(17) <= fladdr_in(17);

end;
