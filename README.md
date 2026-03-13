# FPGA Reaction Timer Game (VHDL)

This project implements a reaction timer game in VHDL for an FPGA board.

## Features
- Start/stop button control
- Finite State Machine (FSM)
- Millisecond counter
- False-start detection
- 4-digit seven-segment display output
- LED indicator for "GO"

## How it works
1. Press `start`
2. System waits for a delay
3. LED turns on
4. Press `stop` as quickly as possible
5. Reaction time is displayed in milliseconds

If the stop button is pressed too early, the system reports a false start.

## Modules
- `reaction_timer_top.vhd`: top-level integration
- `clock_divider.vhd`: generates slower timing pulses
- `reaction_fsm.vhd`: game state logic
- `counter_ms.vhd`: millisecond counter
- `seven_seg_decoder.vhd`: seven-segment decoder

## Possible improvements
- Add true random delay using LFSR
- Add score history
- Add UART output
- Add debouncing module
