----------------------------------------------------------------------------------
-- Logic_Sniffer.vhd
--
-- Copyright (C) 2006 Michael Poppitz
-- 
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or (at
-- your option) any later version.
--
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin St, Fifth Floor, Boston, MA 02110, USA
--
----------------------------------------------------------------------------------
--
-- Details: http://www.sump.org/projects/analyzer/
--
-- Logic Analyzer top level module. It connects the core with the hardware
-- dependend IO modules and defines all inputs and outputs that represent
-- phyisical pins of the fpga.
--
-- It defines two constants FREQ and RATE. The first is the clock frequency 
-- used for receiver and transmitter for generating the proper baud rate.
-- The second defines the speed at which to operate the serial port.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity logic_analyzer is
    GENERIC
	(
		MEMORY_DEPTH	: integer := 6;
		SPEED 	: std_logic_vector (1 downto 0) := "00"	--Sets the speed for UART communications
	);
	Port(
	   --resetSwitch : in std_logic;
		clk : in std_logic;

		target_clock : in std_logic;
		trigger_input : in std_logic;		
		trigger_output : out std_logic;		
		inputs : in std_logic_vector(15 downto 0);

		from_pc : in std_logic;
		to_pc : out std_logic;

		armed : out std_logic;
		triggered : out std_logic		
	);
end logic_analyzer;

architecture behavioral of logic_analyzer is
	COMPONENT clockman
	PORT(
		clkin : in  STD_LOGIC;
		clk0 : out std_logic
		);
	END COMPONENT;

	COMPONENT DCM32to100
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
	END COMPONENT;

	COMPONENT eia232
	generic (
		FREQ : integer;
		SCALE : integer;
		RATE : integer
	);
	PORT(
		clock : IN std_logic;
		reset : in std_logic;
		speed : IN std_logic_vector(1 downto 0);
		rx : IN std_logic;
		data : IN std_logic_vector(31 downto 0);
		send : IN std_logic;          
		tx : OUT std_logic;
		cmd : OUT std_logic_vector(39 downto 0);
		execute : OUT std_logic;
		busy : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT spi_slave
	PORT(
		clock : IN std_logic;
		reset : IN std_logic;
		miso : OUT std_logic;
		data : IN std_logic_vector(31 downto 0);
		send : IN std_logic;          
		mosi : IN std_logic;
		--ss : OUT std_logic;
		sclk : IN std_logic;
		cmd : OUT std_logic_vector(39 downto 0);
		execute : OUT std_logic;
		busy : OUT std_logic;
		cs : in std_logic
		);
	END COMPONENT;	
	
	COMPONENT core
	generic (
		MEMORY_DEPTH : integer
	);	
	PORT(
		clock : IN std_logic;
		extReset : IN std_logic;
		cmd : IN std_logic_vector(39 downto 0);
		execute : IN std_logic;
		input : IN std_logic_vector(31 downto 0);
		inputClock : IN std_logic;
		sampleReady50 : OUT std_logic;
      output : out  STD_LOGIC_VECTOR (31 downto 0);
      outputSend : out  STD_LOGIC;
      outputBusy : in  STD_LOGIC;
		memoryIn : IN std_logic_vector(31 downto 0);          
		memoryOut : OUT std_logic_vector(31 downto 0);
		memoryRead : OUT std_logic;
		memoryWrite : OUT std_logic;
		extTriggerIn : in  STD_LOGIC;
		extTriggerOut : out  STD_LOGIC;
		extClockOut : out STD_LOGIC;		
		armLED : out  STD_LOGIC;
		triggerLED : out  STD_LOGIC;
		numberScheme : out STD_LOGIC;
		wrFlags :	out STD_LOGIC;
		testMode : out STD_LOGIC		
		);
	END COMPONENT;
	
	COMPONENT sram_bram
	generic (
	 	ADDRESS_WIDTH : integer;
		MEMORY_DEPTH : integer
	);
	PORT(
		clock : IN std_logic;
		input : IN std_logic_vector(31 downto 0);
		output : OUT std_logic_vector(31 downto 0);
		read : IN std_logic;
		write : IN std_logic;
		cmd : in std_logic_vector (3 downto 0);	--just to capture disabled groups
		wrFlags : in std_logic		
		);
	END COMPONENT;
	
signal resetSwitch : std_logic := '0';
signal switch : std_logic_vector (1 downto 0) := "10";	--Set baud rate to 115000 bps
signal xtalClock : std_logic;
signal cmd : std_logic_vector (39 downto 0);
signal memoryIn, memoryOut : std_logic_vector (31 downto 0);
signal probeInput : std_logic_vector (31 downto 0);
signal output : std_logic_vector (31 downto 0);
signal clock_100MHz : std_logic;
signal read, write, execute, send, busyReg, testModeReg, numberSchemeReg, wrFlagsReg : std_logic;
signal testmodeState : std_logic := '0'; 	--Puts the OLS into a test mode. The Wing connector outputs a test pattern that can be captured by the Buffered connector with a ribbon cable.
signal numbering : std_logic := '0';		--Selects the number scheme on the OLS. 0 is Inside scheme 1 is Outside scheme

signal test_counter : std_logic_vector (40 downto 0);

constant FREQ : integer := 100000000;				-- limited to 100M by onboard SRAM
constant TRXSCALE : integer := 54; 					-- 16 times the desired baud rate. Example 100000000/(16*115200) = 54
constant RATE : integer := 115200;					-- maximum & base rate


begin

probeInput <= "ZZZZZZZZZZZZZZZZ" & inputs;

----Multiplexer to connect test mode and number schemes
--	process(clock_100MHz)
--	subtype SLV2 is std_logic_vector(1 downto 0);
--	begin
--		if rising_edge(clock_100MHz) then
--			case SLV2'(testModeReg & numberSchemeReg) is
--				-- Inside Number Scheme
--				when "00" => 
--					inputs(31 downto 16) <= (others => 'Z');
--					probeInput <= inputs;
--				-- Outside Number Scheme
--				when "01" =>
--					inputs(31 downto 16) <= (others => 'Z');
--					probeInput(31 downto 16) <= inputs(15 downto 0);
--					probeInput(15 downto 0) <= inputs(31 downto 16);					
--				-- Test Mode
--				when "10" =>
--					test_counter <= test_counter + 1;
--					probeInput(15 downto 0) <= inputs(15 downto 0);
--					inputs (31) <= test_counter(10);
--					inputs (30) <= test_counter(4);
--					inputs (29) <= test_counter(10);
--					inputs (28) <= test_counter(4);
--					inputs (27) <= test_counter(10);
--					inputs (26) <= test_counter(4);
--					inputs (25) <= test_counter(10);
--					inputs (24) <= test_counter(4);
--					inputs (23) <= test_counter(10);
--					inputs (22) <= test_counter(4);
--					inputs (21) <= test_counter(10);
--					inputs (20) <= test_counter(4);
--					inputs (19) <= test_counter(10);
--					inputs (18) <= test_counter(4);
--					inputs (17) <= test_counter(10);
--					inputs (16) <= test_counter(4);
--				when others =>
--					inputs(31 downto 16) <= (others => 'Z');
--					probeInput <= inputs;				
--			end case;
--		end if;
--	end process;
	
	Inst_DCM32to100: DCM32to100 PORT MAP(
		CLKIN_IN => clk,
		CLKFX_OUT => clock_100MHz,
		CLK0_OUT => open
	);	

	Inst_eia232: eia232
	generic map (
		FREQ => FREQ,
		SCALE => TRXSCALE,
		RATE => RATE
	)
	PORT MAP(
		clock => clock_100MHz,
		reset => resetSwitch,
		speed => SPEED,
		rx => from_pc,
		tx => to_pc,
		cmd => cmd,
		execute => execute,
		data => output,
		send => send,
		busy => busyReg
	);
	
	Inst_core: core 
    GENERIC MAP (
		MEMORY_DEPTH => MEMORY_DEPTH
	)	
	PORT MAP(
		clock => clock_100MHz,
		extReset => resetSwitch,
		cmd => cmd,
		execute => execute,
		input => probeInput,
		inputClock => target_clock,
		output => output,
		outputSend => send,
		outputBusy => busyReg,
		memoryIn => memoryIn,
		memoryOut => memoryOut,
		memoryRead => read,
		memoryWrite => write,
		extTriggerIn => trigger_input,
		extTriggerOut => trigger_output,		
		extClockOut => open,
		armLED => armed,
		triggerLED => triggered,
		numberScheme => numberSchemeReg,
		wrFlags => wrFlagsReg,		
		testMode => testModeReg		
	);

	RAM4_Impl:if MEMORY_DEPTH = 4 generate	
	Inst_sram: sram_bram
    GENERIC MAP (
		ADDRESS_WIDTH => 12,
		MEMORY_DEPTH => MEMORY_DEPTH
	)
	PORT MAP(
		clock => clock_100MHz,
		input => memoryOut,
		output => memoryIn,
		read => read,
		write => write,
		cmd => cmd(13 downto 10),
		wrFlags => wrFlagsReg		
	);
	end generate;

	RAM6_Impl:if MEMORY_DEPTH = 6 generate	
	Inst_sram: sram_bram
    GENERIC MAP (
		ADDRESS_WIDTH => 13,
		MEMORY_DEPTH => MEMORY_DEPTH
	)
	PORT MAP(
		clock => clock_100MHz,
		input => memoryOut,
		output => memoryIn,
		read => read,
		write => write,
		cmd => cmd(13 downto 10),
		wrFlags => wrFlagsReg		
	);
	end generate;

	RAM8_Impl:if MEMORY_DEPTH = 8 generate	
	Inst_sram: sram_bram
    GENERIC MAP (
		ADDRESS_WIDTH => 13,
		MEMORY_DEPTH => MEMORY_DEPTH
	)
	PORT MAP(
		clock => clock_100MHz,
		input => memoryOut,
		output => memoryIn,
		read => read,
		write => write,
		cmd => cmd(13 downto 10),
		wrFlags => wrFlagsReg		
	);
	end generate;
	
	RAM12_Impl:if MEMORY_DEPTH = 12 generate	
	Inst_sram: sram_bram
    GENERIC MAP (
		ADDRESS_WIDTH => 14,
		MEMORY_DEPTH => MEMORY_DEPTH
	)
	PORT MAP(
		clock => clock_100MHz,
		input => memoryOut,
		output => memoryIn,
		read => read,
		write => write,
		cmd => cmd(13 downto 10),
		wrFlags => wrFlagsReg		
	);
	end generate;	
	
	RAM16_Impl:if MEMORY_DEPTH = 16 generate	
	Inst_sram: sram_bram
    GENERIC MAP (
		ADDRESS_WIDTH => 14,
		MEMORY_DEPTH => MEMORY_DEPTH
	)
	PORT MAP(
		clock => clock_100MHz,
		input => memoryOut,
		output => memoryIn,
		read => read,
		write => write,
		cmd => cmd(13 downto 10),
		wrFlags => wrFlagsReg		
	);
	end generate;	
	
	RAM24_Impl:if MEMORY_DEPTH = 24 generate	
	Inst_sram: sram_bram
    GENERIC MAP (
		ADDRESS_WIDTH => 15,
		MEMORY_DEPTH => MEMORY_DEPTH
	)
	PORT MAP(
		clock => clock_100MHz,
		input => memoryOut,
		output => memoryIn,
		read => read,
		write => write,
		cmd => cmd(13 downto 10),
		wrFlags => wrFlagsReg		
	);
	end generate;	

	RAM27_Impl:if MEMORY_DEPTH = 27 generate	
	Inst_sram: sram_bram
    GENERIC MAP (
		ADDRESS_WIDTH => 15,
		MEMORY_DEPTH => MEMORY_DEPTH
	)
	PORT MAP(
		clock => clock_100MHz,
		input => memoryOut,
		output => memoryIn,
		read => read,
		write => write,
		cmd => cmd(13 downto 10),
		wrFlags => wrFlagsReg		
	);
	end generate;

end Behavioral;

