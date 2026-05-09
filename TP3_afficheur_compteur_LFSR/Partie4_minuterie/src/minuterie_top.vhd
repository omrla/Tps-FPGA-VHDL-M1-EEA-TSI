-- -------------------------------------------------------
-- Université de Bourgogne - M1 ESI
-- TP3 Exercice 3 : Minuterie décrémentale
-- Fichier : minuterie_top.vhd
--
-- UTILISATION SUR LA CARTE :
--   1. Régler SW[5:0] = secondes, SW[7:6] = minutes
--   2. Appuyer BTNC pour charger la valeur des switches
--   3. Appuyer BTNR pour démarrer
--   4. Appuyer BTNL pour arrêter
--   5. BTNC remet à zéro et recharge les switches
--
-- IMPORTANT SIMULATION : changer CLK_MAX=9, SCAN_MAX=4
-- IMPORTANT SYNTHESE   : CLK_MAX=99_999_999, SCAN_MAX=99_999
-- -------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity minuterie_top is
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
end minuterie_top;

architecture Behavioral of minuterie_top is

    -- ==============================================================
    -- CONSTANTES
    -- SYNTHESE FPGA  : CLK_MAX = 99_999_999, SCAN_MAX = 99_999
    -- SIMULATION     : CLK_MAX = 9,           SCAN_MAX = 4
    -- ==============================================================
    constant CLK_MAX  : integer := 9;
    constant SCAN_MAX : integer := 4;

    -- Diviseur 1 Hz
    signal cnt_1hz  : integer range 0 to 99_999_999 := 0;
    signal en_1hz   : STD_LOGIC := '0';

    -- Diviseur scan affichage (~1 kHz)
    signal cnt_scan  : integer range 0 to 99_999 := 0;
    signal en_scan   : STD_LOGIC := '0';
    signal digit_sel : integer range 0 to 2 := 0;

    -- Registres minuterie
    -- Initialisés à 1 min 0 sec : les 4 LEDs s'allument dès le démarrage
    signal running    : STD_LOGIC              := '0';
    signal min_cnt    : integer range 0 to 3   := 1;
    signal sec_cnt    : integer range 0 to 59  := 0;
    signal total_init : integer range 0 to 239 := 60;

    -- Digit courant à afficher
    signal digit_val : integer range 0 to 9 := 0;

begin


    process(clk)
    begin
        if rising_edge(clk) then
            en_1hz <= '0';
            if cnt_1hz = CLK_MAX then
                cnt_1hz <= 0;
                en_1hz  <= '1';
            else
                cnt_1hz <= cnt_1hz + 1;
            end if;
        end if;
    end process;


    process(clk)
    begin
        if rising_edge(clk) then
            en_scan <= '0';
            if cnt_scan = SCAN_MAX then
                cnt_scan <= 0;
                en_scan  <= '1';
            else
                cnt_scan <= cnt_scan + 1;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if en_scan = '1' then
                if digit_sel = 2 then
                    digit_sel <= 0;
                else
                    digit_sel <= digit_sel + 1;
                end if;
            end if;
        end if;
    end process;


    process(clk)
        variable sec_sw : integer range 0 to 59;
        variable min_sw : integer range 0 to 3;
    begin
        if rising_edge(clk) then

            -- Lecture des switches
            min_sw := to_integer(unsigned(SW(7 downto 6)));
            if to_integer(unsigned(SW(5 downto 0))) > 59 then
                sec_sw := 59;
            else
                sec_sw := to_integer(unsigned(SW(5 downto 0)));
            end if;

            if BTNC = '1' then
                -- Reset : recharge la valeur des switches
                min_cnt    <= min_sw;
                sec_cnt    <= sec_sw;
                total_init <= min_sw * 60 + sec_sw;
                running    <= '0';

            elsif BTNR = '1' then
                running <= '1';

            elsif BTNL = '1' then
                running <= '0';

            elsif en_1hz = '1' and running = '1' then
                if min_cnt = 0 and sec_cnt = 0 then
                    running <= '0';          -- fin automatique
                elsif sec_cnt = 0 then
                    sec_cnt <= 59;
                    min_cnt <= min_cnt - 1;
                else
                    sec_cnt <= sec_cnt - 1;
                end if;
            end if;

        end if;
    end process;


    process(digit_sel, min_cnt, sec_cnt)
    begin
        AN        <= "11111111";
        digit_val <= 0;

        case digit_sel is
            when 0 =>
                digit_val <= sec_cnt mod 10;
                AN(0)     <= '0';
            when 1 =>
                digit_val <= sec_cnt / 10;
                AN(1)     <= '0';
            when 2 =>
                digit_val <= min_cnt;
                AN(2)     <= '0';
            when others => null;
        end case;
    end process;


    process(digit_val)
    begin
        --               gfedcba
        case digit_val is
            when 0  => SEG <= "1000000";
            when 1  => SEG <= "1111001";
            when 2  => SEG <= "0100100";
            when 3  => SEG <= "0110000";
            when 4  => SEG <= "0011001";
            when 5  => SEG <= "0010010";
            when 6  => SEG <= "0000010";
            when 7  => SEG <= "1111000";
            when 8  => SEG <= "0000000";
            when 9  => SEG <= "0010000";
            when others => SEG <= "1111111";
        end case;
    end process;


   process(min_cnt, sec_cnt, total_init)
    variable remaining : integer range 0 to 239;
    variable rem4      : integer range 0 to 956;
    variable t2        : integer range 0 to 478;
    variable t3        : integer range 0 to 717;
begin
    remaining := min_cnt * 60 + sec_cnt;
    rem4      := remaining * 4;
    t2        := total_init * 2;
    t3        := total_init * 3;

    if total_init = 0 or remaining = 0 then
        LED <= "0000";
    elsif rem4 <= total_init then
        LED <= "0001";
    elsif rem4 <= t2 then
        LED <= "0011";
    elsif rem4 <= t3 then
        LED <= "0111";
    else
        LED <= "1111";
    end if;
end process;

end Behavioral;