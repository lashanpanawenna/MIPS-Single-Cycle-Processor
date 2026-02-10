# MIPS Single Cycle Processor

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Language: Verilog](https://img.shields.io/badge/Language-Verilog-blue.svg)
![Language: C](https://img.shields.io/badge/Language-C-lightblue.svg)

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Architecture](#architecture)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Building & Running](#building--running)
- [Project Phases](#project-phases)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

---

## Project Overview

This project is an educational implementation of a **MIPS single cycle processor** created primarily using **Verilog (78.9%)**. The processor executes each instruction in a single clock cycle, following the streamlined architecture commonly described in undergraduate computer architecture courses and textbooks like "Computer Organization and Design" by Patterson & Hennessy.

The repository is organized into two major phases:
1. **Phase 1 (Step 1)**: Building the fundamental processor components (ALU, Register File, CPU, Control Flow)
2. **Phase 2 (Step 2)**: Extending with memory hierarchy (Data Memory, Caches, and Integration)

Supporting code in **C (19.6%)**, **Assembly (0.4%)**, and **Shell (1.1%)** provides a complete workflow for developing and testing programs on the simulated processor.

---

## Features

- ✅ 32-bit MIPS single-cycle processor implementation in Verilog
- ✅ Support for core MIPS instruction subset:
  - **Arithmetic operations**: `add`, `sub`, `addi`, etc.
  - **Logical operations**: `and`, `or`, `nor`, `xor`, etc.
  - **Memory access**: `lw` (load word), `sw` (store word)
  - **Control flow**: `beq` (branch if equal), `j` (jump)
  - **Other instructions**: As specified in the lab documentation
- ✅ Comprehensive register file (32 registers)
- ✅ Full ALU with arithmetic and logical operations
- ✅ Instruction and data memory modules
- ✅ Cache implementation (L1 cache in Phase 2)
- ✅ Complete control unit for instruction decoding
- ✅ Testbenches for functional verification
- ✅ Simulation-ready Verilog modules
- ✅ Supporting documentation and lab specifications

---

## Architecture

The processor follows the classic MIPS single-cycle datapath architecture with the following core components:

### Main Components

| Component | Function |
|-----------|----------|
| **Program Counter (PC)** | Tracks the address of the current instruction |
| **Instruction Memory** | Stores the program instructions |
| **Control Unit** | Decodes instructions and generates control signals |
| **Register File** | 32 32-bit registers for data storage and computation |
| **ALU** | Performs arithmetic and logical operations |
| **Data Memory** | Stores and retrieves data during execution |
| **Sign Extender** | Extends immediate values to 32 bits |
| **Multiplexers** | Routes data between components |

### Single-Cycle Execution Model

Each instruction is executed within a single clock cycle:

1. **Instruction Fetch (IF)**: Retrieve instruction from memory
2. **Instruction Decode (ID)**: Decode opcode and read register operands
3. **Execution (EX)**: Perform ALU operation or address calculation
4. **Memory Access (MEM)**: Access data memory if needed
5. **Write-Back (WB)**: Write results back to registers
