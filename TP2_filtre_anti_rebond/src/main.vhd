library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Port (
        clk : in STD_LOGIC;
        btn_in : in STD_LOGIC_VECTOR(4 downto 0);
        btn_out : out STD_LOGIC_VECTOR(4 downto 0)
    );
end debounce;

architecture Behavioral of debounce is

    -- Déclaration d'un tableau pour gérer les compteurs des 5 boutons
    type counter_array is array (4 downto 0) of unsigned(19 downto 0);

    signal counter : counter_array := (others => (others => '0'));
    signal btn_sync : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal btn_mem : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            for i in 0 to 4 loop
                
                -- Synchronisation
                btn_sync(i) <= btn_in(i);
                
                -- Process 1 : compteur
                -- Le compteur s'incrémente UNIQUEMENT si l'entrée est différente 
                -- de l'état actuellement mémorisé en sortie.
                if btn_sync(i) /= btn_mem(i) then
                    counter(i) <= counter(i) + 1;
                else
                    counter(i) <= (others => '0');
                end if;
                
                -- Process 2 : validation état
                -- Si le signal est resté stable et différent de la mémoire pendant 
                -- 65536 cycles, on met à jour la mémoire avec ce nouvel état.
                if counter(i) = x"FFFF" then
                    btn_mem(i) <= btn_sync(i);
                end if;
                
            end loop;
        end if;
    end process;

    -- Affectation finale de la sortie
    btn_out <= btn_mem;

end Behavioral;