# Computer Architecture Project

This repository contains all source code and reports for the **Computer Architecture** course project, including a vending machine, a single‑cycle RISC‑V CPU, and a pipelined RISC‑V CPU.

## Repository structure

- `Milestone 1 - Vending machine/` – Design and simulation of a simple vending machine in SystemVerilog.  
- `Milestone 2 - SingleCycle-RISCV/` – Single‑cycle RISC‑V (RV32I, with some load/store instructions omitted as required) and its testbenches.  
- `Milestone 3 - RISCV-Pipeline/` – 5‑stage pipelined RISC‑V CPU with Non‑forwarding, Forwarding, and Branch Prediction variants.  

---# Computer Architecture Project

This repository contains all source code and reports for the **Computer Architecture** course project, including:
- a vending machine implemented in SystemVerilog,
- a single‑cycle RISC‑V CPU,
- several 5‑stage pipelined RISC‑V CPUs (non‑forwarding, forwarding, and branch prediction).
[file:4][file:5][file:6]

---

## Repository structure

```text
Milestone 1 - Vending machine/
├── src/                            # RTL + testbench (Quartus / ModelSim only)
└── report-1-vending-machine.pdf    # Milestone 1 report

Milestone 2 - SingleCycle-RISCV/
├── 00_src/                         # RTL for the single-cycle core
├── 10_sim/                         # Testbenches & scripts (Xcelium / ModelSim)
├── report-2-singlecyle-RISCV.pdf   # Milestone 2 report
└── milestone-2-problem.pdf         # Assignment description

Milestone 3 - RISCV-Pipeline/
├── singlecycle/
│   ├── 00_src/                     # RTL for single-cycle reference core
│   └── 10_sim/                     # Testbench for single-cycle reference
├── nonforwarding/
│   ├── 00_src/                     # 5-stage pipeline without forwarding
│   └── 10_sim/                     # Testbench for non-forwarding pipeline
├── forwarding/
│   ├── 00_src/                     # 5-stage pipeline with forwarding
│   └── 10_sim/                     # Testbench for forwarding pipeline
├── branch/
│   ├── 00_src/                     # 5-stage pipeline with 2-bit branch prediction
│   └── 10_sim/                     # Testbench for branch prediction pipeline
├── report-3-RISCV-pipeline.pdf     # Milestone 3 report
└── milestone-3-problem.pdf         # Assignment description


## Milestone 1 – Vending Machine

- Description: A vending machine that accepts 5, 10, and 25 cent coins, dispenses a soda when the total amount is at least 20 cents, and outputs the change using a 3‑bit code.  
- Implementation: SystemVerilog finite‑state machine with states `IDLE`, `FIVE`, `TEN`, `FIFTEEN`, `TWENTY`, `EQUALMORETWENTYFIVE`.  

Suggested directory layout:

- `src/` – `vendingmachine.sv`, `tb_vendingmachine.sv`.  
- `/` – `report-1-vending-machine.pdf`.  

Usage (example):

1. Open the project with your HDL tool (e.g., Quartus + ModelSim).  
2. Compile `vendingmachine.sv` and `tb_vendingmachine.sv`.  
3. Run the simulation and inspect the waveforms for the provided coin insertion test cases.  

---

## Milestone 2 – Single‑Cycle RISC‑V CPU

- Description: A single‑cycle RISC‑V RV32I processor implementing the main integer instruction set with separate ALU, Branch Comparison unit, Register File, Load/Store Unit, Control Unit, ImmGen, and Instruction Memory.  
- Note: Instructions LH, LB, LHU, LBU, SH, SB are intentionally not implemented according to the assignment specification.  
- Top module: `singlecycle.sv`, with I/O mapped to switches, LEDs, seven‑segment displays, and an LCD on an FPGA board.  

Typical directory layout:

- `rtl/` – `alu.sv`, `brc.sv`, `regfile.sv`, `lsu.sv`, `controlunit.sv`, `immgen.sv`, `instrmemory.sv`, `singlecycle.sv`, `constant.sv`.  
- `sim/` – Unit‑test and system‑level testbenches.  
- `/` – `report-2-singlecyle-RISCV.pdf`.
- `/` – `milestone-2-problem.pdf`.  

How to run:

1. Generate `instructionmemory.txt` from your RISC‑V assembly program using the Venus online assembler and place it next to `instrmemory.sv`.  
2. Build the project with Quartus and program the DE2 board to observe results on LEDs and seven‑segment displays.  
3. Alternatively, run the supplied ModelSim testbenches to verify ALU, BRC, Regfile, LSU, and the full single‑cycle CPU.  

---

## Milestone 3 – 5‑Stage RISC‑V Pipeline

- Description: Extension of the single‑cycle core into a classic 5‑stage pipeline (IF, ID, EX, MEM, WB) with three designs: Non‑forwarding, Forwarding, and Branch Prediction using a 2‑bit saturating counter.  
- Key components:
  - Pipeline registers between stages, Hazard Unit, and Forwarding Unit.  
  - Branch Predictor with a Branch Target Buffer (BTB) and 2‑bit counters per branch.  
  - Counters `countcycle`, `countjump`, and `countmiss` to compute IPC and branch misprediction rate.  

Reported performance:

| Design              | Cycle count | Instruction count | IPC   | Branch mispredict rate |
|---------------------|------------|-------------------|-------|-------------------------|
| Single‑Cycle        | 1140       | 1140              | 1.00  | N/A                     |
| Non‑Forwarding      | 2800       | 1140              | 0.407 | N/A                     |
| Forwarding          | 1543       | 1140              | 0.739 | N/A                     |
| Branch Prediction   | 1543       | 1140              | 0.739 | ≈50.27 %                |

Suggested directory layout:

- `../00_src` – Common modules plus pipeline top modules for non‑forwarding, forwarding, and branch‑prediction versions.  
- `../10_sim/` – Advanced testbench that runs the same RISC‑V program, reads performance counters, and checks correctness.  
- `/docs` – `report-3-RISCV-pipeline.pdf`.
- `/docs` – `milestone-3-problem.pdf`.  

---

## Tools and build notes

- Required: Quartus and ModelSim (or any SystemVerilog‑capable toolchain) compatible with the DE2 FPGA board.  
- Language: SystemVerilog (`always_ff`, `always_comb`, enumerated types, etc.).  

