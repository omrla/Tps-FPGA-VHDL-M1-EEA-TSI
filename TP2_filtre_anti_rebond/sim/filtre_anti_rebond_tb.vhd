library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debounce is
end tb_debounce;

architecture Behavioral of tb_debounce is

-- Component à tester
component debounce
    Port (
        clk : in STD_LOGIC;
        btn_in : in STD_LOGIC_VECTOR(4 downto 0);
        btn_out : out STD_LOGIC_VECTOR(4 downto 0)
    );
end component;

-- Signaux
signal clk_tb : STD_LOGIC := '0';
signal btn_in_tb : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
signal btn_out_tb : STD_LOGIC_VECTOR(4 downto 0);

constant clk_period : time := 10 ns;

begin

UUT: debounce
port map(
    clk => clk_tb,
    btn_in => btn_in_tb,
    btn_out => btn_out_tb
);

-- Génération horloge
clk_process : process
begin
    while true loop
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
    end loop;
end process;

-- Stimulus
stim_proc: process
begin

    wait for 100 ns;
    btn_in_tb(0) <= '1';
    wait for 20 ns;
    btn_in_tb(0) <= '0';
    wait for 20 ns;

    btn_in_tb(0) <= '1';
    wait for 20 ns;

    btn_in_tb(0) <= '0';
    wait for 20 ns;
    btn_in_tb(0) <= '1';
    wait for 2 ms;

    wait;

end process;

end Behavioral;