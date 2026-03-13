library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Generic (
        DIVISOR : integer := 50000
    );
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        tick_out : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal count : integer range 0 to DIVISOR-1 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count <= 0;
            tick_out <= '0';
        elsif rising_edge(clk) then
            if count = DIVISOR-1 then
                count <= 0;
                tick_out <= '1';
            else
                count <= count + 1;
                tick_out <= '0';
            end if;
        end if;
    end process;
end Behavioral;
