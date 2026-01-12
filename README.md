# Computer Architecture Project

This repository contains all source code and reports for the **Computer Architecture** course project, including a vending machine, a single‑cycle RISC‑V CPU, and a pipelined RISC‑V CPU.

## Repository structure

- `Milestone 1 - Vending machine/` – Design and simulation of a simple vending machine in SystemVerilog.  
- `Milestone 2 - SingleCycle-RISCV/` – Single‑cycle RISC‑V (RV32I, with some load/store instructions omitted as required) and its testbenches.  
- `Milestone 3 - RISCV-Pipeline/` – 5‑stage pipelined RISC‑V CPU with Non‑forwarding, Forwarding, and Branch Prediction variants.  

# Computer Architecture Project

This repository contains all source code and reports for the **Computer Architecture** course project, including:
- a vending machine implemented in SystemVerilog,
- a single‑cycle RISC‑V CPU,
- several 5‑stage pipelined RISC‑V CPUs (non‑forwarding, forwarding, and branch prediction).
[file:4][file:5][file:6]

---

## Tree

```text
Milestone 1 - Vending machine/
├── src/                            # RTL + testbench (Quartus / ModelSim only)
└── report-1-vending-machine.pdf    # Milestone 1 report

Milestone 2 - SingleCycle-RISCV/
├── singlecycle
│   ├── 00_src/                         # RTL for single-cycle core
│   ├── 01_bench/                       # Driver, scoreboard, top testbench
│   ├── 02_test/                        # Test data (e.g. mem.dump)
│   ├── 10_sim/                         # Flist, makefile, sim config
│   ├── 11_xcelium/                     # Generated Xcelium run directory (can be ignored)
├── report-2-singlecyle-RISCV.pdf   # Milestone 2 report
└── milestone-2-problem.pdf         # Assignment description

Milestone 3 - RISCV-Pipeline/
├── nonforwarding/                  # 5-stage pipeline without forwarding
│   ├── 00_src/
│   ├── 01_bench/
│   ├── 02_test/
│   ├── 10_sim/
│   └── 11_xcelium/                      
├── forwarding/                     # 5-stage pipeline with forwarding
│   ├── 00_src/
│   ├── 01_bench/
│   ├── 02_test/
│   ├── 10_sim/
│   └── 11_xcelium/
├── branch/                        # 5-stage pipeline with 2-bit branch prediction
│   ├── 00_src/
│   ├── 01_bench/
│   ├── 02_test/
│   ├── 10_sim/
│   └── 11_xcelium/
├── report-3-RISCV-pipeline.pdf     # Milestone 3 report
└── milestone-3-problem.pdf         # Assignment description
```
-------------------------------------------

## Milestone 1 – Vending Machine
Implements a simple vending machine in SystemVerilog that accepts 5, 10, and 25 cent coins, dispenses a soda when the total reaches 20 cents or more, and outputs the remaining change using a compact 3‑bit code. The design is developed and tested entirely using Quartus and ModelSim. [file:4]

-------------------------------------------

## Milestone 2 – Single‑Cycle RISC‑V CPU
Implements a single‑cycle RV32I processor with dedicated modules for ALU, branch comparison, register file, load/store unit, immediate generator, control unit, and instruction memory. The LH, LB, LHU, LBU, SH, and SB instructions are omitted as required.

Target Hardware: Intel/Altera DE2 FPGA.

Verification: Validated using Cadence Xcelium on Linux (regression testing) and Quartus (synthesis & debugging). [file:5]

-------------------------------------------

## Milestone 3 – 5‑Stage RISC‑V Pipelines
Extends the single‑cycle design into a five‑stage RISC‑V pipeline (IF, ID, EX, MEM, WB). This milestone provides three distinct variants sharing the same test environment:

  1. Non-forwarding: Basic pipeline handling hazards via stalls.

  2. Forwarding: Optimized pipeline using data forwarding to minimize stalls.

  3. Branch Prediction: Pipeline integrated with a Branch Target Buffer (BTB) and 2-bit saturating counters.

    + Target Hardware: Intel/Altera DE2 FPGA.

    + Verification: Verified via Cadence Xcelium and Quartus. [file:6]

# Performance Overview

| Design            | Cycle count | Instruction count | IPC   | Branch mispredict rate |
|-------------------|------------|-------------------|-------|------------------------|
| Single‑Cycle      | 1140       | 1140              | 1.00  | N/A                    |
| Non‑Forwarding    | 2800       | 1140              | 0.407 | N/A                    |
| Forwarding        | 1543       | 1140              | 0.739 | N/A                    |
| Branch Prediction | 1543       | 1140              | 0.739 | ≈50.27 %               |


# Tools Used

- HDL: SystemVerilog.
- Simulation: Cadence Xcelium (Linux), ModelSim/Quartus Simulator (Windows).
- Synthesis/Hardware: Quartus Prime, DE2 FPGA Board.


