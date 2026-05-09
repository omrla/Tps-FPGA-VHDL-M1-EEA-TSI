library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lfsr4 is
    Port (
        clk : in  STD_LOGIC;           -- Horloge
        RAZ : in  STD_LOGIC;           -- Réinitialisation asynchrone (actif bas)
        Q   : out STD_LOGIC_VECTOR(3 downto 0) -- Sorties Q3 Q2 Q1 Q0
    );
end lfsr4;

architecture Behavioral of lfsr4 is

    -- Registre interne 4 bits
    signal reg : STD_LOGIC_VECTOR(3 downto 0);

    -- Signal de rétroaction : XOR de Q(1) et Q(0)
    signal feedback : STD_LOGIC;

begin

    -- Calcul de la rétroaction (XOR de Q1 et Q0)
    feedback <= reg(1) xor reg(0);

    -- Processus principal : registre à décalage avec RAZ asynchrone
    process(clk, RAZ)
    begin
        if RAZ = '0' then
            -- RAZ actif bas : initialisation asynchrone à "1000"
            -- (Q3 prépositionné à 1 via entrée S, Q2 Q1 Q0 remis à 0 via R)
            reg <= "1000";

        elsif rising_edge(clk) then
            -- Décalage vers la droite avec rétroaction XOR sur D3
            reg(3) <= feedback;   -- D3 = Q1 XOR Q0 (rétroaction)
            reg(2) <= reg(3);     -- D2 = Q3 (décalage)
            reg(1) <= reg(2);     -- D1 = Q2 (décalage)
            reg(0) <= reg(1);     -- D0 = Q1 (décalage)
        end if;
    end process;

    -- Affectation des sorties
    Q <= reg;

end Behavioral;