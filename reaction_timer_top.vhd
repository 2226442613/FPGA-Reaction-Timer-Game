library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reaction_timer_top is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        start_btn : in  STD_LOGIC;
        stop_btn  : in  STD_LOGIC;
        led_go    : out STD_LOGIC;
        false_led : out STD_LOGIC;
        seg0      : out STD_LOGIC_VECTOR(6 downto 0);
        seg1      : out STD_LOGIC_VECTOR(6 downto 0);
        seg2      : out STD_LOGIC_VECTOR(6 downto 0);
        seg3      : out STD_LOGIC_VECTOR(6 downto 0)
    );
end reaction_timer_top;

architecture Structural of reaction_timer_top is

    signal tick_1ms       : STD_LOGIC;
    signal delay_tick     : STD_LOGIC;
    signal counter_reset  : STD_LOGIC;
    signal counter_en     : STD_LOGIC;
    signal false_start    : STD_LOGIC;
    signal count_val      : UNSIGNED(15 downto 0);

    signal d0, d1, d2, d3 : STD_LOGIC_VECTOR(3 downto 0);

    signal display_value  : integer range 0 to 9999 := 0;
    signal temp_count     : integer := 0;

    signal delay_counter  : integer range 0 to 3000 := 0;
    signal delay_done     : STD_LOGIC := '0';

begin

    -- 50 MHz -> 1 ms tick
    clkdiv_ms : entity work.clock_divider
        generic map (DIVISOR => 50000)
        port map (
            clk      => clk,
            reset    => reset,
            tick_out => tick_1ms
        );

    -- pseudo fixed delay of 2 seconds before LED turns on
    process(clk, reset)
    begin
        if reset = '1' or counter_reset = '1' then
            delay_counter <= 0;
            delay_done <= '0';
        elsif rising_edge(clk) then
            if tick_1ms = '1' then
                if delay_counter < 2000 then
                    delay_counter <= delay_counter + 1;
                    delay_done <= '0';
                else
                    delay_done <= '1';
                end if;
            end if;
        end if;
    end process;

    fsm_inst : entity work.reaction_fsm
        port map (
            clk           => clk,
            reset         => reset,
            start_btn     => start_btn,
            stop_btn      => stop_btn,
            delay_tick    => delay_done,
            timer_done    => '0',
            counter_reset => counter_reset,
            counter_en    => counter_en,
            led_go        => led_go,
            false_start   => false_start
        );

    counter_inst : entity work.counter_ms
        port map (
            clk_tick => tick_1ms,
            reset    => reset or counter_reset,
            enable   => counter_en,
            count    => count_val
        );

    false_led <= false_start;

    process(count_val)
    begin
        temp_count := to_integer(count_val);
        if temp_count > 9999 then
            display_value <= 9999;
        else
            display_value <= temp_count;
        end if;
    end process;

    d0 <= STD_LOGIC_VECTOR(to_unsigned(display_value mod 10, 4));
    d1 <= STD_LOGIC_VECTOR(to_unsigned((display_value / 10) mod 10, 4));
    d2 <= STD_LOGIC_VECTOR(to_unsigned((display_value / 100) mod 10, 4));
    d3 <= STD_LOGIC_VECTOR(to_unsigned((display_value / 1000) mod 10, 4));

    seg_decoder0 : entity work.seven_seg_decoder port map(digit => d0, seg => seg0);
    seg_decoder1 : entity work.seven_seg_decoder port map(digit => d1, seg => seg1);
    seg_decoder2 : entity work.seven_seg_decoder port map(digit => d2, seg => seg2);
    seg_decoder3 : entity work.seven_seg_decoder port map(digit => d3, seg => seg3);

end Structural;
