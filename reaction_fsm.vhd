library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reaction_fsm is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        start_btn     : in  STD_LOGIC;
        stop_btn      : in  STD_LOGIC;
        delay_tick    : in  STD_LOGIC;
        timer_done    : in  STD_LOGIC;
        counter_reset : out STD_LOGIC;
        counter_en    : out STD_LOGIC;
        led_go        : out STD_LOGIC;
        false_start   : out STD_LOGIC
    );
end reaction_fsm;

architecture Behavioral of reaction_fsm is
    type state_type is (IDLE, WAIT_DELAY, TIMING, RESULT, FALSE_START);
    signal state, next_state : state_type := IDLE;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process(state, start_btn, stop_btn, delay_tick, timer_done)
    begin
        next_state    <= state;
        counter_reset <= '0';
        counter_en    <= '0';
        led_go        <= '0';
        false_start   <= '0';

        case state is
            when IDLE =>
                counter_reset <= '1';
                if start_btn = '1' then
                    next_state <= WAIT_DELAY;
                end if;

            when WAIT_DELAY =>
                if stop_btn = '1' then
                    next_state <= FALSE_START;
                elsif delay_tick = '1' then
                    next_state <= TIMING;
                end if;

            when TIMING =>
                counter_en <= '1';
                led_go <= '1';
                if stop_btn = '1' then
                    next_state <= RESULT;
                elsif timer_done = '1' then
                    next_state <= RESULT;
                end if;

            when RESULT =>
                led_go <= '0';
                if start_btn = '1' then
                    next_state <= IDLE;
                end if;

            when FALSE_START =>
                false_start <= '1';
                if start_btn = '1' then
                    next_state <= IDLE;
                end if;
        end case;
    end process;

end Behavioral;
