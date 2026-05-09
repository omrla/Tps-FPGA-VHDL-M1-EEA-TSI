----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 15:09:29
-- Design Name: 
-- Module Name: Exercice_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Exercice_tb is
--  Port ( );
end Exercice_tb;

architecture Behavioral of Exercice_tb is
    component Exercice is
    Port ( A : in std_logic;
           B : in std_logic;
           C : in std_logic;
           S : out std_logic_vector(1 downto 0));
    end component;
    signal A_test, B_test, C_test : std_logic := '0';
    signal S_test : std_logic_vector(1 downto 0) := "00";

begin
 UUT : Exercice port map (A => A_test,
                          B => B_test,
                          C => C_test,
                          S => S_test);
    p_test : process
    begin
        A_test <= '0' ; B_test <= '0'; C_test <= '0'; wait for 20ns;
        A_test <= '0' ; B_test <= '0'; C_test <= '1'; wait for 20ns;
        A_test <= '0' ; B_test <= '1'; C_test <= '0'; wait for 20ns;
        A_test <= '0' ; B_test <= '1'; C_test <= '1'; wait for 20ns;
        A_test <= '1' ; B_test <= '0'; C_test <= '0'; wait for 20ns;
        A_test <= '1' ; B_test <= '0'; C_test <= '1'; wait for 20ns;
        A_test <= '1' ; B_test <= '1'; C_test <= '0'; wait for 20ns;
        A_test <= '1' ; B_test <= '1'; C_test <= '1'; wait;
    end process p_test;

end Behavioral;
