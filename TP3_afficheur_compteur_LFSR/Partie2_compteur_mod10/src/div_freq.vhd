library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Div_Freq is
    Generic (
        DIV_VALUE : integer := 100_000_000
    );
    Port (
        Clk  : in  STD_LOGIC;
        Tick : out STD_LOGIC  -- impulsion d'UN seul cycle
    );
end Div_Freq;

architecture Behavioral of Div_Freq is
    signal cnt : integer range 0 to DIV_VALUE-1 := 0;
begin
    process(Clk)
    begin
        if rising_edge(Clk) then
            if cnt = DIV_VALUE - 1 then
                cnt  <= 0;
                Tick <= '1';
            else
                cnt  <= cnt + 1;
                Tick <= '0';
            end if;
        end if;
    end process;
end Behavioral;