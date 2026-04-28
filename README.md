# 32-bit Multicycle RISC-V Processor 🚀

This repository contains the RTL implementation of a 32-bit Multicycle RISC-V Processor written in SystemVerilog. The architecture is based on the RISC-V subset and follows the multicycle design principles, separating the instruction execution into multiple distinct stages (Fetch, Decode, Execute, Memory, Writeback) managed by a Finite State Machine (FSM).

## 🛠️ Architecture Overview

The processor is divided into two main modules:
* **Datapath (`datapath.sv`):** Contains the registers, ALU, multiplexers, and internal buses required to route data and perform arithmetic/logic operations.
* **Controller (`controller.sv` & `mainfsm.sv`):** The brain of the processor. It includes a multi-state FSM that generates the control signals for the datapath and memory based on the current instruction and clock cycle.

### Supported Instructions
The processor supports the following base RISC-V instructions:
* **Memory:** `lw`, `sw`
* **Arithmetic/Logic (R-Type):** `add`, `sub`, `and`, `or`, `slt`
* **Immediate (I-Type):** `addi`
* **Control Flow:** `beq`, `jal`

## ⚙️ Tools and Technologies
* **Hardware Description Language:** SystemVerilog
* **Synthesis & Analysis:** Intel Quartus Prime
* **Simulation & Verification:** Questa / ModelSim

## 🔬 Simulation and Verification

The system includes a fully functional testbench (`testbench.sv`) that verifies the processor's execution logic. A custom assembly program (loaded via `riscvtest.txt`) is executed by the processor. 

**Success Criteria:**
The testbench automatically checks if the processor successfully calculates and stores the expected data into the memory. The simulation halts and prints **"Simulation succeeded"** when the processor writes the value `71` (`0x00000047`) to the memory address `84` (`0x00000054`), proving that the FSM, ALU, and memory interfaces are functioning flawlessly.

## 🚀 How to Run the Simulation

1. Clone this repository.
2. Open your preferred HDL simulator (e.g., Questa or ModelSim).
3. Compile all `.sv` files in the project directory.
4. Make sure the `riscvtest.txt` file is in the root simulation directory.
5. Run the simulation on the `testbench` module.
6. Observe the waveform results and the console output for the success message.

## 📁 File Structure
* `top.sv` - Top-level wrapper module.
* `riscv.sv` - The RISC-V processor core (instantiates datapath and controller).
* `datapath.sv` - Datapath wiring and components.
* `controller.sv` - Top-level controller.
* `mainfsm.sv` - Finite State Machine for state transitions.
* `aludec.sv` - ALU decoder logic.
* `alu.sv` - Arithmetic Logic Unit.
* `mem.sv` - Unified memory module for instructions and data.
* `testbench.sv` - Verification environment.
