library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_ms is
    Port (
        clk_tick : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        enable   : in  STD_LOGIC;
        count    : out UNSIGNED(15 downto 0)
    );
end counter_ms;

architecture Behavioral of counter_ms is
    signal cnt : UNSIGNED(15 downto 0) := (others => '0');
begin
    process(clk_tick, reset)
    begin
        if reset = '1' then
            cnt <= (others => '0');
        elsif rising_edge(clk_tick) then
            if enable = '1' then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    count <= cnt;
end Behavioral;
