                                                                     
                                                                     
                                                                     
                                             
----------------------------------------------------------------------------------
-- sram_bram.vhd
--
-- Copyright (C) 2007 Jonas Diemer
-- Copyright (C) 2010 Jochem Govers
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
-- Dynamic BlockRAM interface.
-- 
-- This module should be used instead of sram.vhd if no external SRAM is present.
-- Instead, it will use internal BlockRAM (12 Blocks).
--
-- Modified to use BRAM6k32bit to fit on Butterfly Platform
-- Modified to dynamicaly alter the width and depth of the memory
-- depending on the enabled bit groups (Jochem Govers)
-- 32-bit/6k, 16-bit/12k, 8-bit/24k
----------------------------------------------------------------------------------

library IEEE;
use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity sram_bram is
    Port (
        clock : in  STD_LOGIC;
        output : out std_logic_vector(31 downto 0);          
        input : in std_logic_vector(31 downto 0);          
        read : in std_logic; 
        write : in std_logic;
        cmd : in std_logic_vector (3 downto 0);	--just to capture disabled groups
        wrFlags : in std_logic;
        test : out std_logic
    );
end sram_bram;

architecture Behavioral of sram_bram is

constant ADDRESS_WIDTH : integer := 15;
constant ADDRESS_MAX : integer := 6*1024-1;
constant RAM_BLOCKS : integer := 4;

signal Mode : std_logic_vector (1 downto 0) :="00";
signal GrpOne : integer range 0 to 3 := 0;
signal GrpTwo : integer range 0 to 3 := 1;
signal bramIn : std_logic_vector(31 downto 0);
signal bramOut : std_logic_vector(31 downto 0);

    COMPONENT BRAM6k32bit
        Port ( 
            CLK : in  STD_LOGIC;
            RE : in STD_LOGIC;
            WE : in  STD_LOGIC;
            MODE : in STD_LOGIC_VECTOR(1 downto 0);
            DOUT : out  STD_LOGIC_VECTOR (31 downto 0);
            DIN : in  STD_LOGIC_VECTOR (31 downto 0)
        );
    END COMPONENT;
begin

    process(Mode,input, bramOut, GrpOne, GrpTwo)
    begin
        output <= (others => '0');
        bramIn <= (others => '0');
        case Mode is
            when "01" =>
                -- 8 bit wide, 24k deep
                output(8*GrpOne+7 downto 8*GrpOne) <= bramOut(7 downto 0);
                bramIn(7 downto 0) <= input(8*GrpOne+7 downto 8*GrpOne);
            when "10" =>              
                -- 16 bit wide, 12k deep
                output(8*GrpOne+7 downto 8*GrpOne) <= bramOut(7 downto 0);
                output(8*GrpTwo+7 downto 8*GrpTwo) <= bramOut(15 downto 8);
                bramIn(7 downto 0) <= input(8*GrpOne+7 downto 8*GrpOne);
                bramIn(15 downto 8) <= input(8*GrpTwo+7 downto 8*GrpTwo);  
            when others =>
                -- 32 bit wide, 6k deep
                output <= bramOut;
                bramIn <= input;
        end case;
    end process;
   
    process(clock)
    begin
        if rising_edge(clock) then
            if wrFlags = '1' then
                GrpOne <= 0;
                GrpTwo <= 1;
                for i in cmd'range loop	
                    if (cmd(i) = '0') then
                        GrpOne <= i;
                        exit;
                    end if;                        
                end loop;

                for j in cmd'reverse_range loop
                    if (cmd(j) = '0') then
                        GrpTwo <= j;
                        exit;
                    end if;                        
                end loop;
                
                case cmd is
                    when "1110" | "1101" | "1011" | "0111" =>
                        -- 8 bit wide, 24k deep
                        Mode <= "01";
                    when "1100" | "0011" | "0110" | "1001" | "1010" | "0101" =>              
                        -- 16 bit wide, 12k deep
                        Mode <= "10";  
                    when others =>
                        -- 32 bit wide, 6k deep
                        -- also
                        -- 24 bit wide, 6k deep
                        Mode <= "11";
                end case;
            end if;
        end if;
    end process;

    -- sample block ram
    Sample_RAM :  BRAM6k32bit 
    PORT MAP(
        DIN => bramIn,
        RE => read,
        WE => write,
        MODE => Mode,
        CLK => clock,
        DOUT => bramOut
    );

end Behavioral;

library IEEE;
use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BRAM6k32bit is
    Port ( 
        CLK : in  STD_LOGIC;
        RE : in STD_LOGIC;
        WE : in  STD_LOGIC;
        MODE : in STD_LOGIC_VECTOR(1 downto 0);
        DOUT : out  STD_LOGIC_VECTOR (31 downto 0);
        DIN : in  STD_LOGIC_VECTOR (31 downto 0)
    );
end BRAM6k32bit;

architecture Behavioral of BRAM6k32bit is
    component BRAM6k8bit is
    Port ( 
        CLK : in  STD_LOGIC;
        ADDR : in  STD_LOGIC_VECTOR (12 downto 0);
        WE : in  STD_LOGIC;
        EN : in STD_LOGIC;
        DOUT : out  STD_LOGIC_VECTOR (7 downto 0);
        DIN : in  STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;

constant ADDRESS_MAX : integer := 6*1024-1;
type Arr_d is array(3 downto 0) of std_logic_vector(7 downto 0);

signal ENA : std_logic_vector(3 downto 0) :=(others => '0');
signal DO : Arr_d;
signal DI : Arr_d;

signal Address : std_logic_vector(12 downto 0) := (others => '0');
signal Mode_Old : std_logic_vector(1 downto 0) := (others => '0');
signal overflow : std_logic := '0';

begin

    process(CLK)
    begin
        if falling_edge(CLK) then
            if MODE /= Mode_Old then
                case MODE is
                    when "01" =>
                        ENA <= "0001";
                    when "10" =>
                        ENA <= "0011";
                    when others =>
                        ENA <= "1111";
                end case;
				elsif overflow = '1' then
					if WE = '1' then
					  case MODE is
							when "01" =>
								 ENA <= ENA(2 downto 0) & ENA(3);
							when "10" =>
								 ENA <= ENA(1 downto 0) & ENA(3 downto 2);
							when others =>
								 ENA <= "1111";
					  end case;		
					elsif RE = '1' then
					  case MODE is
							when "01" =>
								 ENA <= ENA(0) & ENA(3 downto 1);
							when "10" =>
								 ENA <= ENA(1 downto 0) & ENA(3 downto 2);
							when others =>
								 ENA <= "1111";
					  end case;		
					end if;
				end if;
				Mode_Old <= MODE;
			end if;
	 end process;

    process(CLK)
    begin
        if falling_edge(CLK) then
		  overflow <= '0';
--            if MODE /= Mode_Old then
--                case MODE is
--                    when "01" =>
--                        ENA <= "0001";
--                    when "10" =>
--                        ENA <= "0011";
--                    when others =>
--                        ENA <= "1111";
--                end case;
--                Address <= (others => '0');
            if WE ='1' then
                if Address >= ADDRESS_MAX then
                    Address <= (others => '0');
						  overflow <= '1';
--                    case MODE is
--                        when "01" =>
--                            ENA <= ENA(2 downto 0) & ENA(3);
--                        when "10" =>
--                            ENA <= ENA(1 downto 0) & ENA(3 downto 2);
--                        when others =>
--                            ENA <= "1111";
--                    end case;
                else
                    Address <= Address + 1;
                end if;
            elsif RE = '1' then
                if Address = 0 then
                    Address <= conv_std_logic_vector(ADDRESS_MAX, 13);
						  overflow <= '1';
--                    case MODE is
--                        when "01" =>
--                            ENA <= ENA(0) & ENA(3 downto 1);
--                        when "10" =>
--                            ENA <= ENA(1 downto 0) & ENA(3 downto 2);
--                        when others =>
--                            ENA <= "1111";
--                    end case;
                else
                    Address <= Address - 1;
                end if;
            end if;
--            Mode_Old <= MODE;
        end if;
    end process;

    process(MODE, DIN, DO, ENA)
    variable i: integer;
    begin
        for i in 0 to 3 loop
            DI(i) <= (others => '0');
        end loop;
        DOUT <= (others => '0');

        case MODE is
            when "01" =>
                -- 8 bit memory
                for i in 0 to 3 loop
                    DI(i) <= DIN(7 downto 0);
                    if ENA(i) = '1' then
                        DOUT(7 downto 0)   <= DO(i);                        
                        --exit;
                    end if;
                end loop;

            when "10" =>
                -- 16 bit memory
                DI(2) <= DIN(7 downto 0);
                DI(3) <= DIN(15 downto 8);
                DI(0) <= DIN(7 downto 0);
                DI(1) <= DIN(15 downto 8);
                if ENA(2) = '1' or ENA(3) = '1' then
                    DOUT(7 downto 0)   <= DO(2);
                    DOUT(15 downto 8)   <= DO(3);
                else
                    DOUT(7 downto 0)   <= DO(0);
                    DOUT(15 downto 8)   <= DO(1);
                end if;
            when others =>
                -- 32 bit memory
                for i in 0 to 3 loop
                    DOUT(8*i+7 downto 8*i)   <= DO(i);
                    DI(i) <= DIN(8*i+7 downto 8*i);
                end loop;
        end case;
    end process;

    RAMGRP : for i in 0 to 3 generate
    RAMBG : BRAM6k8bit
    port map ( 
        CLK   => CLK,
        ADDR  => Address,
        WE    => WE,
        EN    => ENA(i),
        DOUT  => DO(i),
        DIN   => DI(i) 
    );
    end generate;

end Behavioral;

library IEEE;
use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity BRAM6k8bit is
    Port ( CLK : in  STD_LOGIC;
        ADDR : in  STD_LOGIC_VECTOR (12 downto 0);
        WE : in  STD_LOGIC;
        EN : in STD_LOGIC;
        DOUT : out  STD_LOGIC_VECTOR (7 downto 0);
        DIN : in  STD_LOGIC_VECTOR (7 downto 0));
end BRAM6k8bit;

architecture Behavioral of BRAM6k8bit is
type EN_a is array(2 downto 0) of std_logic;
type Arr_d is array(2 downto 0) of std_logic_vector(7 downto 0);
signal ENA : EN_a;
signal DOA : Arr_d;

begin

    process(ADDR, EN, DOA)
    variable i : integer;
    begin
        DOUT <= (others => '0');
        for i in 0 to 2 loop
            ENA(i) <= '0';
            if (EN ='1' and to_integer(unsigned(ADDR(12 downto 11))) = i) then
                ENA(i) <= '1';
                DOUT <= DOA(i);
            end if;
        end loop;
    end process;

    RAMB : for i in 0 to 2 generate
    RAMB16_S9_inst : RAMB16_S9
    generic map (
        INIT => X"0", --  Value of output RAM registers at startup
        SRVAL => X"0", --  Ouput value upon SSR assertion
        WRITE_MODE => "WRITE_FIRST" --  WRITE_FIRST, READ_FIRST or NO_CHANGE
    )
    port map (
        DO => DOA(i),      -- 8-bit Data Output
        DOP => open,     -- parity unused
        ADDR => ADDR(10 downto 0),  -- 11-bit Address Input
        CLK => CLK,    -- Clock
        DI => DIN,      -- 8-bit Data Input
        DIP => "0",
        EN => ENA(i),      -- RAM Enable Input
        SSR => '0',    -- Synchronous Set/Reset Input
        WE => WE       -- Write Enable Input
    );
    end generate;

end Behavioral;	 


