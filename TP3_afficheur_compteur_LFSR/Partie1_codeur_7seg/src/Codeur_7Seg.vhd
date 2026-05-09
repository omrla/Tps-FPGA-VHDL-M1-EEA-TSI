----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.03.2026 09:11:10
-- Design Name: 
-- Module Name: Codeur_7Seg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Codeur_7Seg is
    Port (
        SW    : in  STD_LOGIC_VECTOR(3 downto 0);
        Clk   : in  STD_LOGIC;
        Seg   : out STD_LOGIC_VECTOR(6 downto 0);
        Digit : out STD_LOGIC_VECTOR(7 downto 0)  -- AN7..AN0 sur 8 bits
    );
end Codeur_7Seg;

architecture Behavioral of Codeur_7Seg is

    signal refresh : integer range 0 to 50000 := 0;
    signal sel_aff : STD_LOGIC := '0';

    function to_seg7(val : integer) return STD_LOGIC_VECTOR is
    begin
        case val is
            when 0      => return "1000000"; -- 0
            when 1      => return "1111001"; -- 1
            when 2      => return "0100100"; -- 2
            when 3      => return "0110000"; -- 3
            when 4      => return "0011001"; -- 4
            when 5      => return "0010010"; -- 5
            when 6      => return "0000010"; -- 6
            when 7      => return "1111000"; -- 7
            when 8      => return "0000000"; -- 8
            when 9      => return "0010000"; -- 9
            when others => return "1111111";
        end case;
    end function;

begin


    -- Compteur 1kHz
    process(Clk)
    begin
        if rising_edge(Clk) then
            if refresh = 50000 then
                refresh <= 0;
                sel_aff <= not sel_aff;
            else
                refresh <= refresh + 1;
            end if;
        end if;
    end process;

    -- Multiplexage AN0, AN1
    -- AN2-AN7 toujours à '1' (éteints)
    process(sel_aff, SW)
        variable val     : integer range 0 to 15;
        variable val_diz : integer range 0 to 1;
    begin
        val := 0;
        if SW(3) = '1' then val := val + 8; end if;
        if SW(2) = '1' then val := val + 4; end if;
        if SW(1) = '1' then val := val + 2; end if;
        if SW(0) = '1' then val := val + 1; end if;

        -- Calcul de la dizaine
        if val >= 10 then
            val_diz := 1;
        else
            val_diz := 0;
        end if;

        if sel_aff = '0' then
            -- AN0 actif, reste éteints
            Digit <= "11111110";
            Seg   <= to_seg7(val mod 10);
        else
            -- AN1 actif, reste éteints
            Digit <= "11111101";
            Seg   <= to_seg7(val_diz);
        end if;
    end process;

end Behavioral;