----------------------------------------------------------------------------------
-- spi_slave.vhd
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
-- spi_slave
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity spi_slave is
--	generic (
--		FREQ : integer;
--		SCALE : integer;
--		RATE : integer
--	);
	Port (
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
end spi_slave;

architecture Behavioral of spi_slave is


	
	COMPONENT spi_receiver
	PORT(
		rx : IN std_logic;
		clock : IN std_logic;
		sclk : IN std_logic;
	   reset : in STD_LOGIC;
		op : out std_logic_vector(7 downto 0);
		data : out std_logic_vector(31 downto 0);
	   execute : out STD_LOGIC;
		transmitting : in std_logic;
		cs : in std_logic
	   );
	END COMPONENT;

	COMPONENT spi_transmitter
	PORT(
		data : IN std_logic_vector(31 downto 0);
		disabledGroups : in std_logic_vector (3 downto 0);
		write : IN std_logic;
		id : in std_logic;
		xon : in std_logic;
		xoff : in std_logic;
		clock : IN std_logic;
		sclk : IN std_logic;
		reset : in std_logic;
		tx : OUT std_logic;
		cs : in std_logic;
		busy : out std_logic
		);
	END COMPONENT;

signal executeReg, executePrev, id, xon, xoff, wrFlags, busyReg : std_logic;
signal disabledGroupsReg : std_logic_vector(3 downto 0);
signal opcode : std_logic_vector(7 downto 0);
signal opdata : std_logic_vector(31 downto 0);

begin
	cmd <= opdata & opcode;
	execute <= executeReg;
	busy <= busyReg;
	
	-- process special uart commands that do not belong in core decoder
	process(clock)
	begin
		if rising_edge(clock) then
			id <= '0'; xon <= '0'; xoff <= '0'; wrFlags <= '0';
			executePrev <= executeReg;
			if executePrev = '0' and executeReg = '1' then
				case opcode is
					when x"02" => id <= '1';
					when x"11" => xon <= '1';
					when x"13" => xoff <= '1';
					when x"82" => wrFlags <= '1';
					when others =>
				end case;
			end if;
		end if;
	end process;

	process(clock)
	begin
		if rising_edge(clock) then
			if wrFlags = '1' then
				disabledGroupsReg <= opdata(5 downto 2);
			end if;
		end if;
	end process;

	
	Inst_spi_receiver: spi_receiver
	PORT MAP(
		rx => mosi,
		clock => clock,
		sclk => sclk,
		reset => reset,
		op => opcode,
		data => opdata,
		execute => executeReg,
		transmitting => busyReg,
		cs => cs
	);

	Inst_spi_transmitter: spi_transmitter
	PORT MAP(
		data => data,
		disabledGroups => disabledGroupsReg,
		write => send,
		id => id,
		xon => xon,
		xoff => xoff,
		clock => clock,
		sclk => sclk,
		reset => reset,
		tx => miso,
		cs => cs,
		busy => busyReg
	);

end Behavioral;

