library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cont_affich is
    Port (
        Clk   : in  STD_LOGIC;
        BTNC  : in  STD_LOGIC;  -- reset
        BTNU  : in  STD_LOGIC;  -- direction montante
        BTND  : in  STD_LOGIC;  -- direction descendante
        BTNL  : in  STD_LOGIC;  -- basculer vers groupe gauche (AN4-AN7)
        BTNR  : in  STD_LOGIC;  -- basculer vers groupe droite (AN0-AN3)
        Seg   : out STD_LOGIC_VECTOR(6 downto 0);
        Digit : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Cont_affich;

architecture Behavioral of Cont_affich is

    signal Val       : STD_LOGIC_VECTOR(13 downto 0);
    signal Dir       : STD_LOGIC := '0';

    -- '0' = groupe droit AN0-AN3, '1' = groupe gauche AN4-AN7
    signal groupe    : STD_LOGIC := '0';

    signal count_int : integer range 0 to 9999;
    signal d_thou    : integer range 0 to 9;
    signal d_hund    : integer range 0 to 9;
    signal d_tens    : integer range 0 to 9;
    signal d_unit    : integer range 0 to 9;

    -- multiplexage : 4 digits dans le groupe actif
    signal cnt_scan  : integer range 0 to 49_999 := 0;
    signal tick_scan : STD_LOGIC := '0';
    signal scan_idx  : integer range 0 to 3 := 0;
    signal disp_val  : integer range 0 to 9 := 0;

    constant DEBOUNCE : integer := 1_000_000;

    signal btnu_prev : STD_LOGIC := '0';
    signal btnd_prev : STD_LOGIC := '0';
    signal btnl_prev : STD_LOGIC := '0';
    signal btnr_prev : STD_LOGIC := '0';

    signal btnu_lock : integer range 0 to 1_000_000 := 0;
    signal btnd_lock : integer range 0 to 1_000_000 := 0;
    signal btnl_lock : integer range 0 to 1_000_000 := 0;
    signal btnr_lock : integer range 0 to 1_000_000 := 0;

    function seg7(v : integer range 0 to 9) return STD_LOGIC_VECTOR is
    begin
        case v is
            when 0      => return "1000000";
            when 1      => return "1111001";
            when 2      => return "0100100";
            when 3      => return "0110000";
            when 4      => return "0011001";
            when 5      => return "0010010";
            when 6      => return "0000010";
            when 7      => return "1111000";
            when 8      => return "0000000";
            when 9      => return "0010000";
            when others => return "1111111";
        end case;
    end function;

    component compteur_mod10
        Port (
            Clk  : in  STD_LOGIC;
            Raz  : in  STD_LOGIC;
            Dir  : in  STD_LOGIC;
            Val  : out STD_LOGIC_VECTOR(13 downto 0)
        );
    end component;

begin

    U_CNT : compteur_mod10
        port map (
            Clk  => Clk,
            Raz  => BTNC,
            Dir  => Dir,
            Val  => Val
        );

    -- extraction des 4 chiffres
    count_int <= to_integer(unsigned(Val));
    d_thou    <= count_int / 1000;
    d_hund    <= (count_int mod 1000) / 100;
    d_tens    <= (count_int mod 100)  / 10;
    d_unit    <= count_int mod 10;

    -- diviseur scan ~1 kHz
    process(Clk)
    begin
        if rising_edge(Clk) then
            if cnt_scan = 49_999 then
                cnt_scan  <= 0;
                tick_scan <= '1';
            else
                cnt_scan  <= cnt_scan + 1;
                tick_scan <= '0';
            end if;
        end if;
    end process;

    -- compteur de scan
    process(Clk)
    begin
        if rising_edge(Clk) then
            if tick_scan = '1' then
                if scan_idx = 3 then scan_idx <= 0;
                else scan_idx <= scan_idx + 1;
                end if;
            end if;
        end if;
    end process;

    -- multiplexage : même valeur affichée sur les 4 digits du groupe actif
    -- groupe='0' ? AN0(bit0) AN1(bit1) AN2(bit2) AN3(bit3) actifs, AN4-AN7 éteints
    -- groupe='1' ? AN4(bit4) AN5(bit5) AN6(bit6) AN7(bit7) actifs, AN0-AN3 éteints
    process(scan_idx, d_thou, d_hund, d_tens, d_unit, groupe)
    begin
        case scan_idx is
            when 0 =>
                disp_val <= d_unit;
                if groupe = '0' then
                    Digit <= "11111110"; -- AN0 actif
                else
                    Digit <= "11101111"; -- AN4 actif
                end if;
            when 1 =>
                disp_val <= d_tens;
                if groupe = '0' then
                    Digit <= "11111101"; -- AN1 actif
                else
                    Digit <= "11011111"; -- AN5 actif
                end if;
            when 2 =>
                disp_val <= d_hund;
                if groupe = '0' then
                    Digit <= "11111011"; -- AN2 actif
                else
                    Digit <= "10111111"; -- AN6 actif
                end if;
            when others =>
                disp_val <= d_thou;
                if groupe = '0' then
                    Digit <= "11110111"; -- AN3 actif
                else
                    Digit <= "01111111"; -- AN7 actif
                end if;
        end case;
    end process;

    Seg <= seg7(disp_val);

    -- boutons
    process(Clk)
    begin
        if rising_edge(Clk) then

            btnu_prev <= BTNU;
            btnd_prev <= BTND;
            btnl_prev <= BTNL;
            btnr_prev <= BTNR;

            if btnu_lock > 0 then btnu_lock <= btnu_lock - 1; end if;
            if btnd_lock > 0 then btnd_lock <= btnd_lock - 1; end if;
            if btnl_lock > 0 then btnl_lock <= btnl_lock - 1; end if;
            if btnr_lock > 0 then btnr_lock <= btnr_lock - 1; end if;

            -- BTNU : mode montant
            if BTNU = '1' and btnu_prev = '0' and btnu_lock = 0 then
                btnu_lock <= DEBOUNCE;
                Dir <= '0';
            end if;

            -- BTND : mode descendant
            if BTND = '1' and btnd_prev = '0' and btnd_lock = 0 then
                btnd_lock <= DEBOUNCE;
                Dir <= '1';
            end if;

            -- BTNL : basculer vers groupe gauche AN4-AN7
            if BTNL = '1' and btnl_prev = '0' and btnl_lock = 0 then
                btnl_lock <= DEBOUNCE;
                groupe <= '1';
            end if;

            -- BTNR : basculer vers groupe droit AN0-AN3
            if BTNR = '1' and btnr_prev = '0' and btnr_lock = 0 then
                btnr_lock <= DEBOUNCE;
                groupe <= '0';
            end if;

        end if;
    end process;

end Behavioral;