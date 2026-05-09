----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 14:09:29
-- Design Name: 
-- Module Name: Circuit1_tb - Behavioral
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

entity Circuit1_tb is
--  Port ( );
end Circuit1_tb;

architecture Behavioral of Circuit1_tb is
    component Circuit1 is
    Port ( A : in std_logic;
           B : in std_logic;
           C : out std_logic_vector (2 downto 0));
    end component;
    signal A_test, B_test : std_logic := '0';
    signal C_test : std_logic_vector(2 downto 0) := "000";
begin
    UUT : Circuit1 port map (A => A_test,
                             B => B_test,
                             C => C_test);
    p_test : process
    begin
        A_test <= '0' ; B_test <= '0'; wait for 20ns;
        A_test <= '0' ; B_test <= '1'; wait for 20ns;
        A_test <= '1' ; B_test <= '0'; wait for 20ns;
        A_test <= '1' ; B_test <= '1'; wait;
    end process p_test;
end Behavioral;
