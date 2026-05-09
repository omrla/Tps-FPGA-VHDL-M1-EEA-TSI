-- -------------------------------------------------------
-- Université de Bourgogne - M1 ESI
-- TP3 Exercice 3 : Banc de test de la minuterie
-- Fichier : minuterie_tb.vhd
--
-- IMPORTANT : Pour simuler rapidement, changez dans
--   minuterie_top.vhd la constante :
--     CLK_MAX  = 9    (au lieu de 99_999_999)
--     SCAN_MAX = 4    (au lieu de 99_999)
--   Cela accélère la simulation x10_000_000.
--   N'oubliez pas de remettre les vraies valeurs avant synthèse !
-- -------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity minuterie_tb is
end minuterie_tb;

architecture Behavioral of minuterie_tb is

    -- Composant sous test
    component minuterie_top is
        Port (
            clk  : in  STD_LOGIC;
            SW   : in  STD_LOGIC_VECTOR(7 downto 0);
            BTNR : in  STD_LOGIC;
            BTNL : in  STD_LOGIC;
            BTNC : in  STD_LOGIC;
            SEG  : out STD_LOGIC_VECTOR(6 downto 0);
            AN   : out STD_LOGIC_VECTOR(7 downto 0);
            LED  : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Période d'horloge : 10 ns (100 MHz)
    constant CLK_PERIOD : time := 10 ns;

    -- Signaux de stimulation
    signal clk_tb  : STD_LOGIC := '0';
    signal SW_tb   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal BTNR_tb : STD_LOGIC := '0';
    signal BTNL_tb : STD_LOGIC := '0';
    signal BTNC_tb : STD_LOGIC := '0';

    -- Signaux observés
    signal SEG_tb  : STD_LOGIC_VECTOR(6 downto 0);
    signal AN_tb   : STD_LOGIC_VECTOR(7 downto 0);
    signal LED_tb  : STD_LOGIC_VECTOR(3 downto 0);

    -- Durée d'un "tick" de 1Hz en simulation (dépend de CLK_MAX)
    -- Si CLK_MAX = 9  ? tick = 10 * 10 ns = 100 ns
    -- Si CLK_MAX = 99 ? tick = 100 * 10 ns = 1000 ns
    constant TICK : time := 100 ns;  -- à ajuster selon CLK_MAX

begin

    -- Instanciation du module sous test (UUT)
    UUT : minuterie_top
        port map (
            clk  => clk_tb,
            SW   => SW_tb,
            BTNR => BTNR_tb,
            BTNL => BTNL_tb,
            BTNC => BTNC_tb,
            SEG  => SEG_tb,
            AN   => AN_tb,
            LED  => LED_tb
        );

    -- -------------------------------------------------------
    -- Horloge : 100 MHz
    -- -------------------------------------------------------
    clk_process : process
    begin
        clk_tb <= '0'; wait for CLK_PERIOD / 2;
        clk_tb <= '1'; wait for CLK_PERIOD / 2;
    end process;

    -- -------------------------------------------------------
    -- Stimuli
    -- -------------------------------------------------------
    stim_proc : process
    begin

        -- ===================================================
        -- TEST 1 : Minuterie 0 min 5 sec
        --   SW[5:0] = "000101" (5)
        --   SW[7:6] = "00"     (0 min)
        -- ===================================================

        -- Configuration des switches : 0 min 5 sec
        SW_tb <= "00000101";   -- SW7:6=00 (min), SW5:0=000101 (5 sec)
        wait for 20 ns;

        -- Appui sur RESET (BTNC) : charge les switches dans la minuterie
        BTNC_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNC_tb <= '0';
        wait for 20 ns;

        -- Vérification : LED = "1111" (100% du temps restant)
        -- SEG devrait afficher 0:05

        -- Appui sur START (BTNR)
        BTNR_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNR_tb <= '0';

        -- Attendre 3 secondes de simulation (3 ticks)
        wait for TICK * 3;

        -- Appui sur STOP (BTNL) après ~3 secondes
        BTNL_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNL_tb <= '0';
        wait for TICK * 2;

        -- Relancer après arrêt
        BTNR_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNR_tb <= '0';

        -- Laisser la minuterie finir les 2 secondes restantes
        wait for TICK * 4;

        -- ===================================================
        -- TEST 2 : Minuterie 1 min 0 sec
        --   SW[7:6] = "01" (1 min), SW[5:0] = "000000" (0 sec)
        -- ===================================================

        SW_tb <= "01000000";
        wait for 20 ns;

        BTNC_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNC_tb <= '0';
        wait for 20 ns;

        BTNR_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNR_tb <= '0';

        -- Attendre quelques secondes pour observer les LEDs décliner
        wait for TICK * 20;

        -- ===================================================
        -- TEST 3 : Valeur limite de secondes > 59
        --   SW[5:0] = "111111" (63 dec) ? doit être capé à 59
        -- ===================================================

        -- Arrêt de la minuterie en cours
        BTNL_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNL_tb <= '0';

        SW_tb <= "00111111";   -- 0 min, 63 sec ? cap à 59
        wait for 20 ns;

        BTNC_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNC_tb <= '0';

        BTNR_tb <= '1';
        wait for CLK_PERIOD * 3;
        BTNR_tb <= '0';

        wait for TICK * 5;

        -- Fin de simulation
        wait;

    end process;

end Behavioral;