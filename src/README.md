# RV32I Single-Cycle Processor

A single-cycle RV32I RISC-V processor core implemented in Verilog HDL.

## Architecture

Single-cycle datapath - each instruction completes in one clock cycle (CPI = 1).
Eight submodules integrated through a top-level module.

## Module Hierarchy

riscTop (top level)
├── pc_counter        - 32-bit program counter with synchronous reset and branch logic
├── instructionMemory - Combinational instruction fetch unit
├── decoder           - Instruction decoder and control signal generator
├── immediateGen      - Immediate value extractor with sign extension (I, S, B type)
├── AluControl        - ALU operation selector
├── alu               - 32-bit ALU supporting 9 operations
├── registerFile      - 32x32 register file, x0 hardwired to zero
└── DataMemo          - 4KB word-addressed synchronous data memory

## Supported Instructions

| Type   | Instructions                        |
|--------|-------------------------------------|
| R-Type | ADD SUB AND OR XOR SLL SRL SRA SLT  |
| I-Type | ADDI                                |
| Load   | LW                                  |
| Store  | SW                                  |
| Branch | BEQ                                 |

## Verification

Simulated using Icarus Verilog. Ten RV32I instructions encoded manually into 
instruction memory covering R-type, I-type, load, store, and branch formats.
Expected register values traced by hand and verified against simulation output.

Verified results:
x1 = 5  (addi x1, x0, 5)
x2 = 5  (addi x2, x0, 5, after branch)
x3 = 8  (add  x3, x1, x2)
x4 = 2  (sub  x4, x1, x2)
x5 = 1  (and  x5, x1, x2)
x6 = 8  (lw   x6, 0(x0))

## Tools

- Icarus Verilog - simulation
- GTKWave - waveform analysis

## Status

Core datapath complete and verified. Remaining work - adding BNE, BLT, BGE, 
LUI, AUIPC, JAL, JALR to decoder and extending immediateGen for J-type and U-type.
