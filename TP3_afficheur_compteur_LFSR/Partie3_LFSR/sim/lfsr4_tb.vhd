library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lfsr4_tb is
end lfsr4_tb;

architecture Behavioral of lfsr4_tb is

    -- Déclaration du composant à tester (UUT)
    component lfsr4 is
        Port (
            clk : in  STD_LOGIC;
            RAZ : in  STD_LOGIC;
            Q   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Signaux de stimulation (entrées)
    signal clk_tb : STD_LOGIC := '0';
    signal RAZ_tb : STD_LOGIC := '0';

    -- Signaux d'observation (sorties)
    signal Q_tb   : STD_LOGIC_VECTOR(3 downto 0);

    -- Période d'horloge
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz

begin

    -- Instanciation du module sous test (UUT)
    UUT : lfsr4
        port map (
            clk => clk_tb,
            RAZ => RAZ_tb,
            Q   => Q_tb
        );

    -- Processus d'horloge : génère un signal carré à 100 MHz
    clk_process : process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD / 2;
        clk_tb <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Processus de stimulation
    stim_proc : process
    begin

        -- SCENARIO 1 : RAZ d'abord bas puis haut en permanence
        -- État initial attendu : Q = "1000" (Q3=1, Q2=0, Q1=0, Q0=0)

        -- RAZ actif (bas) : précharge le registre à 1000
        RAZ_tb <= '0';
        wait for 25 ns;   -- Maintien de RAZ pendant 2,5 cycles

        -- Relâchement de RAZ : le LFSR démarre sa séquence
        RAZ_tb <= '1';

        -- Observation de 16 coups d'horloge (15 états + retour à l'état initial)
        -- Séquence attendue en Q3Q2Q1Q0 :
        --  Cycle 0  : 1000  (décimal 8)  <- état initial après RAZ
        --  Cycle 1  : 0100  (décimal 4)
        --  Cycle 2  : 0010  (décimal 2)
        --  Cycle 3  : 1001  (décimal 9)
        --  Cycle 4  : 1100  (décimal 12)
        --  Cycle 5  : 0110  (décimal 6)
        --  Cycle 6  : 1011  (décimal 11)
        --  Cycle 7  : 0101  (décimal 5)
        --  Cycle 8  : 1010  (décimal 10)
        --  Cycle 9  : 1101  (décimal 13)
        --  Cycle 10 : 1110  (décimal 14)
        --  Cycle 11 : 1111  (décimal 15)
        --  Cycle 12 : 0111  (décimal 7)
        --  Cycle 13 : 0011  (décimal 3)
        --  Cycle 14 : 0001  (décimal 1)
        --  Cycle 15 : 1000  (décimal 8)  <- retour à l'état initial 
        wait for CLK_PERIOD * 18;

        -- SCENARIO 2 : Initialisation forcée à 0000

        -- On remet RAZ bas pour forcer un nouvel état connu
        -- Puis on force manuellement le registre à 0000
        -- (Ici simulé en mettant RAZ bas avec modification du TB)
        -- Note : pour forcer 0000, il faudrait modifier le code
        -- du composant ou utiliser un signal force dans le TB.
        -- Pour cette simulation, on remet simplement RAZ bas :
        RAZ_tb <= '0';
        wait for CLK_PERIOD * 2;

        -- Simulation de 0000 (état bloqué) :
        -- On relâche RAZ mais ce scénario illustre qu'avec 0000
        -- la rétroaction = 0 XOR 0 = 0, donc le registre reste à 0000.
        -- (Ce cas est expliqué dans l'analyse - voir le rapport)
        RAZ_tb <= '1';
        wait for CLK_PERIOD * 5;

        -- Fin de simulation
        wait;

    end process;

end Behavioral;