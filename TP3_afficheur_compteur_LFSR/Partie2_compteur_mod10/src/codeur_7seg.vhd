library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity codeur_7seg is
    Port (
        SW  : in  STD_LOGIC_VECTOR(3 downto 0);  -- valeur à afficher
        Seg : out STD_LOGIC_VECTOR(6 downto 0)   -- segments (actif bas)
    );
end codeur_7seg;

architecture Behavioral of codeur_7seg is
begin
    process(SW)
    begin
        case SW is
            when "0000" => Seg <= "1000000"; -- 0
            when "0001" => Seg <= "1111001"; -- 1
            when "0010" => Seg <= "0100100"; -- 2
            when "0011" => Seg <= "0110000"; -- 3
            when "0100" => Seg <= "0011001"; -- 4
            when "0101" => Seg <= "0010010"; -- 5
            when "0110" => Seg <= "0000010"; -- 6
            when "0111" => Seg <= "1111000"; -- 7
            when "1000" => Seg <= "0000000"; -- 8
            when "1001" => Seg <= "0010000"; -- 9
            when others => Seg <= "1111111"; -- éteint
        end case;
    end process;
end Behavioral;