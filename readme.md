# Verilog Combination Lock

A fully synthesizable Verilog implementation of a digital combination lock using a Finite State Machine (FSM).

The design verifies a predefined input sequence and asserts an unlock signal for 30 seconds upon a correct combination. After the timeout expires, the system automatically locks itself.

## Features
- FSM-based control logic
- 30-second unlock timer
- Automatic re-locking
- Synchronous design
- Fully synthesizable Verilog
- Testbench included

## Tools Used
- Verilog HDL
- ModelSim / Vivado Simulator

## Applications
- Digital security systems
- FPGA-based access control
