# RV32I Single-Cycle Processor

A fully functional single-cycle RISC-V RV32I processor 
implemented in Verilog from scratch.

Built as a hands-on VLSI front-end learning project at 
Vishwakarma Institute of Technology, Pune.

## Architecture
- Harvard architecture — separate instruction and data memory
- Single-cycle execution — every instruction completes in one clock cycle
- Supports R-type, I-type, S-type, B-type instructions

## Modules
| Module | Status | Description |
|---|---|---|
| PC Register | Done | 32-bit program counter |
| Instruction Memory | Done | Async read, ROM |
| Decoder + Control | Done | Full control signal generation |
| Immediate Generator | Done | I/S/B type sign extension |
| Register File | Done | 32x32-bit, sync write async read |
| ALU | Done | 10 operations, zero flag |
| Data Memory | Done | 1024x32-bit, sync write async read |
| ALU Control | In progress | |
| Top-level integration | Pending | |

## Tools
- Verilog HDL
- iverilog + GTKWave for simulation

## How to simulate
iverilog -o sim tb/DataMemoTB.v src/DataMemo.v
vvp sim
