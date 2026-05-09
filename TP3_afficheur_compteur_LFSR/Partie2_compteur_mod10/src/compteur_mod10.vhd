library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity compteur_mod10 is
    Port (
        Clk  : in  STD_LOGIC;
        Raz  : in  STD_LOGIC;
        Dir  : in  STD_LOGIC;
        Val  : out STD_LOGIC_VECTOR(13 downto 0)
    );
end compteur_mod10;

architecture Behavioral of compteur_mod10 is

    signal count    : integer range 0 to 9999 := 0;
    signal tick_1hz : STD_LOGIC;

    component Div_Freq
        Generic ( DIV_VALUE : integer := 100_000_000 );
        Port (
            Clk  : in  STD_LOGIC;
            Tick : out STD_LOGIC
        );
    end component;

begin

    U_DIV : Div_Freq
        generic map ( DIV_VALUE => 10_000_000 )
        port map ( Clk => Clk, Tick => tick_1hz );

    process(Clk, Raz)
    begin
        if Raz = '1' then
            count <= 0;
        elsif rising_edge(Clk) then
            if tick_1hz = '1' then
                if Dir = '0' then
                    if count = 9999 then count <= 0;
                    else count <= count + 1;
                    end if;
                else
                    if count = 0 then count <= 9999;
                    else count <= count - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    Val <= std_logic_vector(to_unsigned(count, 14));
end Behavioral;