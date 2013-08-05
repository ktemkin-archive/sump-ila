----------------------------------------------------------------------------------
-- simple_logic_analyzer.vhd
-- Simplified logic analyzer for use in schematic designs.
--
-- Copyright (C) 2013 Binghamton University
-- Copyright (C) 2013 Kyle J. Temkin <ktemkin@binghamton.edu>
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

library ieee;
use ieee.std_logic_1164.all;

entity simple_logic_analyzer is
  port(
    clk : in std_logic;    

    --UART connections (via FTDI chip, here).
    from_pc : in std_logic;
    to_pc   : out std_logic;   

    -- Input channels.
    -- We leave this as scalars, here, so they show up as 
    -- discrete signals 
    c7, c6, c5, c4, c3, c2, c1, c0 : std_logic
  );
end simple_logic_analyzer;

architecture Behavioral of simple_logic_analyzer is

  signal inputs : std_logic_vector(15 downto 0);

begin

  --Create the "input" vectors from the individual inputs.
  inputs <= ( 7 => c7, 6 => c6, 5 => c5, 4 => c4, 3 => c3, 2 => c2, 1 => c1, 0 => c0, others => '0');

  LOGIC_ANALYZER: 
  entity logic_analyzer port map(
		clk => clk,
		target_clock => clk,
		trigger_input => '0',
		trigger_output => open,
		inputs => inputs,
		from_pc => from_pc,
		to_pc => to_pc,
		armed => open,
		triggered => open
	);

end Behavioral;

