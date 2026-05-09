LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY machine_etats_top_tb IS
END machine_etats_top_tb;

ARCHITECTURE behavior OF machine_etats_top_tb IS

    COMPONENT machine_etats_top
        GENERIC (
            DEBOUNCE_MAX : INTEGER;
            HOLD_MAX     : INTEGER
        );
        PORT (
            clk          : IN  STD_LOGIC;
            un_dollar    : IN  STD_LOGIC;
            deux_dollars : IN  STD_LOGIC;
            film         : OUT STD_LOGIC;
            monnaie      : OUT STD_LOGIC;
            seg          : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            an           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            dp           : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk          : STD_LOGIC := '0';
    SIGNAL un_dollar    : STD_LOGIC := '0';
    SIGNAL deux_dollars : STD_LOGIC := '0';
    SIGNAL film         : STD_LOGIC;
    SIGNAL monnaie      : STD_LOGIC;
    SIGNAL seg          : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL an           : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL dp           : STD_LOGIC;

    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    uut : machine_etats_top 
        GENERIC MAP (
            DEBOUNCE_MAX => 2, -- Court pour la simulation
            HOLD_MAX     => 10 -- Court pour la simulation
        )
        PORT MAP (
            clk          => clk,
            un_dollar    => un_dollar,
            deux_dollars => deux_dollars,
            film         => film,
            monnaie      => monnaie,
            seg          => seg,
            an           => an,
            dp           => dp
        );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    stim_proc : PROCESS
    BEGIN
        WAIT FOR 100 ns;
        WAIT FOR clk_period * 10;
        
        un_dollar    <= '0';
        deux_dollars <= '1';
        WAIT FOR clk_period * 5;
        un_dollar    <= '0';
        deux_dollars <= '0';
        WAIT FOR clk_period * 3;
        
        un_dollar    <= '0';
        deux_dollars <= '1';
        WAIT FOR clk_period * 5;
        un_dollar    <= '0';
        deux_dollars <= '0';
        WAIT FOR clk_period * 3;
        
        un_dollar    <= '0';
        deux_dollars <= '1';
        WAIT FOR clk_period * 5;
        un_dollar    <= '0';
        deux_dollars <= '0';
        WAIT FOR clk_period * 5;
        
        WAIT FOR clk_period * 3;
        un_dollar    <= '1';
        deux_dollars <= '0';
        WAIT FOR clk_period * 5;
        un_dollar    <= '0';
        deux_dollars <= '0';
        WAIT FOR clk_period * 5;
        
        un_dollar    <= '1';
        deux_dollars <= '0';
        WAIT FOR clk_period * 5;
        un_dollar    <= '0';
        deux_dollars <= '0';
        WAIT FOR clk_period * 3;
        
        un_dollar    <= '1';
        deux_dollars <= '0';
        WAIT FOR clk_period * 3;
        un_dollar    <= '0';
        deux_dollars <= '0';
        WAIT FOR clk_period * 3;
        
        un_dollar    <= '1';
        deux_dollars <= '0';
        WAIT FOR clk_period * 3;

        un_dollar    <= '0';
        deux_dollars <= '0';
        WAIT FOR clk_period * 3;
        
        un_dollar    <= '1';
        deux_dollars <= '0';
        WAIT FOR clk_period * 3;

        un_dollar    <= '0';
        deux_dollars <= '0';
        WAIT FOR clk_period * 15; -- Attente un peu plus longue pour laisser le "HOLD" s'ecouler
        
        assert false report "Simulation terminée !" severity failure;
    END PROCESS;
END behavior;