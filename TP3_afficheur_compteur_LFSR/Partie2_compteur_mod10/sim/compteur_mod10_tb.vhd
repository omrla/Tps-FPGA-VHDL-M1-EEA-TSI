----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.03.2026 09:28:32
-- Design Name: 
-- Module Name: compteur_mod10_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL; 

entity compteur_mod10_tb  is
end compteur_mod10_tb;

architecture Behavioral of compteur_mod10_tb  is


    component compteur_mod10
        Port (
            Clk : in  STD_LOGIC;
            Raz : in  STD_LOGIC;
            Val : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;


    signal Clk_t : STD_LOGIC := '0';
    signal Raz_t : STD_LOGIC := '0';
    signal Val_t : STD_LOGIC_VECTOR(3 downto 0);

    constant CLK_PERIOD : time := 10 ns; 

begin


    clk_process : process
    begin
        Clk_t <= '0'; wait for CLK_PERIOD/2;
        Clk_t <= '1'; wait for CLK_PERIOD/2;
    end process;


    UUT : compteur_mod10
        port map (
            Clk => Clk_t,
            Raz => Raz_t,
            Val => Val_t
        );

    stim_process : process
    begin


        Raz_t <= '1';
        wait for 5 * CLK_PERIOD;  


        Raz_t <= '0';
        wait for 10 * CLK_PERIOD;  

        Raz_t <= '1';
        wait for 3 * CLK_PERIOD;  
        Raz_t <= '0';


        wait for 15 * CLK_PERIOD;

        wait; 
    end process;

end Behavioral;