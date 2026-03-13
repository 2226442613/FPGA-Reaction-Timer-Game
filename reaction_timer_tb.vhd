library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reaction_timer_tb is
end reaction_timer_tb;

architecture Behavioral of reaction_timer_tb is
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '1';
    signal start_btn : STD_LOGIC := '0';
    signal stop_btn  : STD_LOGIC := '0';
    signal led_go    : STD_LOGIC;
    signal false_led : STD_LOGIC;
    signal seg0, seg1, seg2, seg3 : STD_LOGIC_VECTOR(6 downto 0);

begin
    uut: entity work.reaction_timer_top
        port map (
            clk       => clk,
            reset     => reset,
            start_btn => start_btn,
            stop_btn  => stop_btn,
            led_go    => led_go,
            false_led => false_led,
            seg0      => seg0,
            seg1      => seg1,
            seg2      => seg2,
            seg3      => seg3
        );

    clk <= not clk after 10 ns; -- 50 MHz

    process
    begin
        wait for 100 ns;
        reset <= '0';

        -- start game
        wait for 100 ns;
        start_btn <= '1';
        wait for 40 ns;
        start_btn <= '0';

        -- wait long enough, then react
        wait for 50 ms;
        stop_btn <= '1';
        wait for 40 ns;
        stop_btn <= '0';

        wait;
    end process;

end Behavioral;
