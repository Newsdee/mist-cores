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
-- CREATED		"Thu Jul 10 07:36:37 2014"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY KBSCAN IS 
	PORT
	(
		EPclk :  IN  STD_LOGIC;
		init :  IN  STD_LOGIC;
		kb_clk :  IN  STD_LOGIC;
		kb_data :  IN  STD_LOGIC;
		resetin :  IN  STD_LOGIC;
		scen :  OUT  STD_LOGIC;
		RDY :  OUT  STD_LOGIC;
		reset :  OUT  STD_LOGIC;
		speed :  OUT  STD_LOGIC;
		pal :  OUT  STD_LOGIC;
		Y :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END KBSCAN;

ARCHITECTURE bdf_type OF KBSCAN IS 

COMPONENT funk
	PORT(clk : IN STD_LOGIC;
		 ready : IN STD_LOGIC;
		 scen : IN STD_LOGIC;
		 init : IN STD_LOGIC;
		 scancode : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 reset : OUT STD_LOGIC;
		 speed : OUT STD_LOGIC;
		 pal : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	F0 :  STD_LOGIC;
SIGNAL	ini :  STD_LOGIC;
SIGNAL	par :  STD_LOGIC;
SIGNAL	RDY_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	reset_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	scen_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	startbit :  STD_LOGIC;
SIGNAL	Y_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	Ya7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC;
SIGNAL	DFF_107 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	DFF_72 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	DFF_106 :  STD_LOGIC;


BEGIN 



PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	Y_ALTERA_SYNTHESIZED(0) <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	Y_ALTERA_SYNTHESIZED(0) <= Y_ALTERA_SYNTHESIZED(1);
END IF;
END PROCESS;


SYNTHESIZED_WIRE_20 <= NOT(Y_ALTERA_SYNTHESIZED(5) AND Y_ALTERA_SYNTHESIZED(6) AND Ya7);


SYNTHESIZED_WIRE_10 <= startbit OR SYNTHESIZED_WIRE_25;


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	DFF_106 <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	DFF_106 <= DFF_107;
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_2)
BEGIN
IF (RISING_EDGE(SYNTHESIZED_WIRE_2)) THEN
	DFF_107 <= kb_data;
END IF;
END PROCESS;


SYNTHESIZED_WIRE_2 <= NOT(SYNTHESIZED_WIRE_25);



PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	startbit <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	startbit <= Y_ALTERA_SYNTHESIZED(0);
END IF;
END PROCESS;


pal <= NOT(SYNTHESIZED_WIRE_4);



SYNTHESIZED_WIRE_28 <= NOT(startbit OR SYNTHESIZED_WIRE_25);


SYNTHESIZED_WIRE_8 <= NOT(SYNTHESIZED_WIRE_5);



speed <= NOT(SYNTHESIZED_WIRE_6);



F0 <= NOT(Y_ALTERA_SYNTHESIZED(3) OR Y_ALTERA_SYNTHESIZED(3) OR Y_ALTERA_SYNTHESIZED(2) OR SYNTHESIZED_WIRE_7 OR Y_ALTERA_SYNTHESIZED(1) OR Y_ALTERA_SYNTHESIZED(0));


SYNTHESIZED_WIRE_21 <= Y_ALTERA_SYNTHESIZED(7) AND DFF_72;


reset_ALTERA_SYNTHESIZED <= resetin AND SYNTHESIZED_WIRE_8;


RDY_ALTERA_SYNTHESIZED <= F0 OR SYNTHESIZED_WIRE_27 OR startbit;


SYNTHESIZED_WIRE_26 <= SYNTHESIZED_WIRE_10 AND ini;


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	Ya7 <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	Ya7 <= par;
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	Y_ALTERA_SYNTHESIZED(6) <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	Y_ALTERA_SYNTHESIZED(6) <= Ya7;
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	Y_ALTERA_SYNTHESIZED(5) <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	Y_ALTERA_SYNTHESIZED(5) <= Y_ALTERA_SYNTHESIZED(6);
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	Y_ALTERA_SYNTHESIZED(4) <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	Y_ALTERA_SYNTHESIZED(4) <= Y_ALTERA_SYNTHESIZED(5);
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_28,ini)
BEGIN
IF (ini = '0') THEN
	Y_ALTERA_SYNTHESIZED(7) <= '0';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_28)) THEN
	Y_ALTERA_SYNTHESIZED(7) <= F0;
END IF;
END PROCESS;


SYNTHESIZED_WIRE_7 <= NOT(Y_ALTERA_SYNTHESIZED(4) AND Y_ALTERA_SYNTHESIZED(5) AND Y_ALTERA_SYNTHESIZED(6) AND Ya7);


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	Y_ALTERA_SYNTHESIZED(3) <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	Y_ALTERA_SYNTHESIZED(3) <= Y_ALTERA_SYNTHESIZED(4);
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_28,ini)
BEGIN
IF (ini = '0') THEN
	DFF_72 <= '0';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_28)) THEN
	DFF_72 <= SYNTHESIZED_WIRE_29;
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_28,ini)
BEGIN
IF (ini = '0') THEN
	SYNTHESIZED_WIRE_29 <= '0';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_28)) THEN
	SYNTHESIZED_WIRE_29 <= SYNTHESIZED_WIRE_27;
END IF;
END PROCESS;


SYNTHESIZED_WIRE_27 <= NOT(Y_ALTERA_SYNTHESIZED(0) OR Y_ALTERA_SYNTHESIZED(1) OR Y_ALTERA_SYNTHESIZED(2) OR SYNTHESIZED_WIRE_20 OR Y_ALTERA_SYNTHESIZED(3) OR Y_ALTERA_SYNTHESIZED(4));


scen_ALTERA_SYNTHESIZED <= SYNTHESIZED_WIRE_29 OR SYNTHESIZED_WIRE_21;


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	Y_ALTERA_SYNTHESIZED(2) <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	Y_ALTERA_SYNTHESIZED(2) <= Y_ALTERA_SYNTHESIZED(3);
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	Y_ALTERA_SYNTHESIZED(1) <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	Y_ALTERA_SYNTHESIZED(1) <= Y_ALTERA_SYNTHESIZED(2);
END IF;
END PROCESS;


PROCESS(SYNTHESIZED_WIRE_25,SYNTHESIZED_WIRE_26)
BEGIN
IF (SYNTHESIZED_WIRE_26 = '0') THEN
	par <= '1';
ELSIF (RISING_EDGE(SYNTHESIZED_WIRE_25)) THEN
	par <= DFF_106;
END IF;
END PROCESS;


PROCESS(EPclk)
BEGIN
IF (RISING_EDGE(EPclk)) THEN
	SYNTHESIZED_WIRE_25 <= kb_clk;
END IF;
END PROCESS;


b2v_inst : funk
PORT MAP(clk => EPclk,
		 ready => RDY_ALTERA_SYNTHESIZED,
		 scen => scen_ALTERA_SYNTHESIZED,
		 init => ini,
		 scancode => Y_ALTERA_SYNTHESIZED,
		 reset => SYNTHESIZED_WIRE_5,
		 speed => SYNTHESIZED_WIRE_6,
		 pal => SYNTHESIZED_WIRE_4);


ini <= reset_ALTERA_SYNTHESIZED AND init;

scen <= scen_ALTERA_SYNTHESIZED;
RDY <= RDY_ALTERA_SYNTHESIZED;
reset <= reset_ALTERA_SYNTHESIZED;
Y <= Y_ALTERA_SYNTHESIZED;

END bdf_type;