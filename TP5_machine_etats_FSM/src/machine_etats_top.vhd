LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY machine_etats_top IS
    GENERIC (
        -- Valeurs réelles pour la carte Nexys A7
        DEBOUNCE_MAX : INTEGER := 2_000_000;
        HOLD_MAX     : INTEGER := 99_999_999
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
END machine_etats_top;

ARCHITECTURE Behavioral OF machine_etats_top IS

    TYPE etats IS (etat_0, etat_1, etat_2, etat_3, etat_4, etat_5, etat_6);
    SIGNAL etat_present  : etats := etat_0;
    SIGNAL etat_prochain : etats;
    SIGNAL etat_num      : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Compteurs sans limites fixes (gérés par les GENERIC)
    SIGNAL compteur_hold  : INTEGER := 0;
    SIGNAL hold_done      : STD_LOGIC := '0';

    SIGNAL cnt_1          : INTEGER := 0;
    SIGNAL cnt_2          : INTEGER := 0;
    SIGNAL btn1_stable    : STD_LOGIC := '0';
    SIGNAL btn2_stable    : STD_LOGIC := '0';
    SIGNAL btn1_prev      : STD_LOGIC := '0';
    SIGNAL btn2_prev      : STD_LOGIC := '0';
    SIGNAL btn1_pulse     : STD_LOGIC := '0';
    SIGNAL btn2_pulse     : STD_LOGIC := '0';

BEGIN
    an <= "11111110";
    dp <= '1';

    PROCESS(etat_num)
    BEGIN
        CASE etat_num is   
            WHEN "000" => seg <= "1000000"; -- 0
            WHEN "001" => seg <= "1111001"; -- 1
            WHEN "010" => seg <= "0100100"; -- 2
            WHEN "011" => seg <= "0110000"; -- 3
            WHEN "100" => seg <= "0011001"; -- 4
            WHEN "101" => seg <= "0010010"; -- 5
            WHEN "110" => seg <= "0000010"; -- 6
            WHEN OTHERS => seg <= "1111111";
        END CASE;
    END PROCESS;

    Pro_hold : PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF etat_present = etat_5 OR etat_present = etat_6 THEN
                IF compteur_hold = HOLD_MAX THEN
                    hold_done     <= '1';
                    compteur_hold <= 0;
                ELSE
                    hold_done     <= '0';
                    compteur_hold <= compteur_hold + 1;
                END IF;
            ELSE
                compteur_hold <= 0;
                hold_done     <= '0';
            END IF;
        END IF;
    END PROCESS;

    Pro_debounce1 : PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF un_dollar = '1' THEN
                IF cnt_1 = DEBOUNCE_MAX THEN
                    btn1_stable <= '1';
                ELSE
                    cnt_1 <= cnt_1 + 1;
                END IF;
            ELSE
                cnt_1       <= 0;
                btn1_stable <= '0';
            END IF;
        END IF;
    END PROCESS;

    Pro_debounce2 : PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF deux_dollars = '1' THEN
                IF cnt_2 = DEBOUNCE_MAX THEN
                    btn2_stable <= '1';
                ELSE
                    cnt_2 <= cnt_2 + 1;
                END IF;
            ELSE
                cnt_2       <= 0;
                btn2_stable <= '0';
            END IF;
        END IF;
    END PROCESS;

    Pro_edge : PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            btn1_prev  <= btn1_stable;
            btn2_prev  <= btn2_stable;
            btn1_pulse <= btn1_stable AND NOT btn1_prev;
            btn2_pulse <= btn2_stable AND NOT btn2_prev;
        END IF;
    END PROCESS;

    Pro_1 : PROCESS(etat_present, btn1_pulse, btn2_pulse, hold_done)
    BEGIN
        CASE etat_present IS

            WHEN etat_0 =>
                film     <= '0';
                monnaie  <= '0';
                etat_num <= "000";
                IF btn1_pulse = '1' THEN etat_prochain <= etat_1;
                ELSIF btn2_pulse = '1' THEN etat_prochain <= etat_2;
                ELSE etat_prochain <= etat_0;
                END IF;

            WHEN etat_1 =>
                film     <= '0';
                monnaie  <= '0';
                etat_num <= "001";
                IF btn1_pulse = '1' THEN etat_prochain <= etat_2;
                ELSIF btn2_pulse = '1' THEN etat_prochain <= etat_3;
                ELSE etat_prochain <= etat_1;
                END IF;

            WHEN etat_2 =>
                film     <= '0';
                monnaie  <= '0';
                etat_num <= "010";
                IF btn1_pulse = '1' THEN etat_prochain <= etat_3;
                ELSIF btn2_pulse = '1' THEN etat_prochain <= etat_4;
                ELSE etat_prochain <= etat_2;
                END IF;

            WHEN etat_3 =>
                film     <= '0';
                monnaie  <= '0';
                etat_num <= "011";
                IF btn1_pulse = '1' THEN etat_prochain <= etat_4;
                ELSIF btn2_pulse = '1' THEN etat_prochain <= etat_5;
                ELSE etat_prochain <= etat_3;
                END IF;

            WHEN etat_4 =>
                film     <= '0';
                monnaie  <= '0';
                etat_num <= "100";
                IF btn1_pulse = '1' THEN etat_prochain <= etat_5;
                ELSIF btn2_pulse = '1' THEN etat_prochain <= etat_6;
                ELSE etat_prochain <= etat_4;
                END IF;

            WHEN etat_5 =>
                film     <= '1';
                monnaie  <= '0';
                etat_num <= "101";
                IF hold_done = '1' THEN etat_prochain <= etat_0;
                ELSE etat_prochain <= etat_5;
                END IF;

            WHEN etat_6 =>
                film     <= '1';
                monnaie  <= '1';
                etat_num <= "110";
                IF hold_done = '1' THEN etat_prochain <= etat_0;
                ELSE etat_prochain <= etat_6;
                END IF;

            WHEN OTHERS =>
                film          <= '0';
                monnaie       <= '0';
                etat_num      <= "000";
                etat_prochain <= etat_0;

        END CASE;
    END PROCESS;

    Pro_2 : PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            etat_present <= etat_prochain;
        END IF;
    END PROCESS;
END Behavioral;