----------------------------------------------------------------------------------
-- BRAM4k32bit.vhd
--
-- Copyright (C) 2007 Jonas Diemer
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
-- Single Ported RAM, 32bit wide, 4k deep.
-- 
-- Instantiates 8 BRAM, each being 4k deep and 4 bit wide. These are
-- concatenated to form a 32bit wide, 4k deep RAM.
--
--
-- Modified by Jack Gassett to use 8 BRAM's in order to fit on s3e250 for Butterfly Platform
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity BRAM4k32bit is
    Port ( CLK : in  STD_LOGIC;
           ADDR : in  STD_LOGIC_VECTOR (11 downto 0);
           WE : in  STD_LOGIC;
           DOUT : out  STD_LOGIC_VECTOR (31 downto 0);
           DIN : in  STD_LOGIC_VECTOR (31 downto 0));
end BRAM4k32bit;

architecture Behavioral of BRAM4k32bit is

begin


	BlockRAMS: for i in 0 to 7 generate
   RAMB16_S4_inst : RAMB16_S4
   generic map (
      INIT => X"0", --  Value of output RAM registers at startup
      SRVAL => X"0", --  Ouput value upon SSR assertion
      WRITE_MODE => "WRITE_FIRST" --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      )
   port map (
      DO => DOUT(4*i+3 downto 4*i),      -- 4-bit Data Output
      ADDR => ADDR,  -- 12-bit Address Input
      CLK => CLK,    -- Clock
      DI => DIN(4*i+3 downto 4*i),      -- 4-bit Data Input
      EN => '1',      -- RAM Enable Input
      SSR => '0',    -- Synchronous Set/Reset Input
      WE => WE       -- Write Enable Input
   );
	end generate;







end Behavioral;

