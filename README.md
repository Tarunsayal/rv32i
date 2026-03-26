# RV32I Single-Cycle Processor Implementation

A hardware implementation of a single-cycle RV32I RISC-V processor core written 
in Verilog HDL.

## Architecture Overview
This design implements a single-cycle datapath for the RV32I base integer 
instruction set architecture. Each instruction completes execution within a 
single clock cycle. The datapath consists of 8 submodules integrated through 
a top-level module.

## Module Hierarchy
```
riscTop (top level)
├── pc_counter        - 32-bit program counter with synchronous reset and branch logic
├── instructionMemory - Combinational instruction fetch unit
├── decoder           - Instruction decoder and control signal generator
├── immediateGen      - Immediate value extractor with sign extension (I, S, B type)
├── AluControl        - ALU operation selector
├── alu               - 32-bit ALU supporting 9 operations
├── RegisterFile      - 32x32 register file with x0 hardwired to zero
└── DataMemo          - 4KB word-addressed synchronous data memory
```

## Datapath Signal Flow
```
PC → InstructionMemory → Decoder → RegisterFile → ALU → DataMemory → WriteBack → RegisterFile
```

## Supported ISA
| Type   | Instructions                          |
|--------|---------------------------------------|
| R-Type | ADD SUB AND OR XOR SLL SRL SRA SLT   |
| I-Type | ADDI ANDI ORI XORI SLLI SRLI SRAI SLTI|
| Load   | LW                                    |
| Store  | SW                                    |
| Branch | BEQ                                   |

## Implementation Notes
- Single-cycle design: CPI = 1
- Word-aligned memory access using address bits [11:2]
- x0 register hardwired to zero, write protected in hardware
- Branch resolution: PC = PC + immediate when Branch=1 and zeroflag=1

## Status
Core datapath complete. Testbench under development.
