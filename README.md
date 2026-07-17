# Single-Cycle RISC-V Processor (RV32I Subset)

A simple, single-cycle RISC-V processor implemented in **SystemVerilog**, supporting a basic subset of the RV32I instruction set. This project includes the complete datapath, control unit, and testbench.

##  Supported Instructions

This processor currently supports the following instruction types:

- **R-Type:** `ADD`, `SUB`, `AND`, `OR`, `SLT`
- **I-Type:** `ADDI`, `LW`
- **S-Type:** `SW`
- **B-Type:** `BEQ`
- **J-Type:** `JAL`

##  Architecture & Modules

The design follows the standard single-cycle datapath architecture:

- `riscv_cpu`: Top-level module connecting all components, handling PC logic, and write-back multiplexing.
- `control`: Generates control signals based on the 7-bit opcode.
- `alu_control`: Generates ALU operation codes based on `ALUOp`, `funct3`, and `funct7[5]`.
- `alu`: Arithmetic Logic Unit supporting ADD, SUB, AND, OR, and SLT (signed).
- `regfile`: 32x32-bit register file with synchronous write and asynchronous read (x0 hardwired to 0).
- `imm_gen`: Sign-extends immediates for I, S, B, and J-type instructions.
- `imem`: Instruction memory (initialized via `program.hex`).
- `dmem`: Data memory with separate read/write logic.
- `tb_cpu`: Testbench that generates the clock/reset, dumps VCD waveforms, and displays register/memory states at the end of simulation.

## RTL Architecture

##  How to Simulate

This project uses the `$readmemh` function to load instructions, so you must provide a `program.hex` file in the simulation directory.

### Using Icarus Verilog

1. Compile the design and testbench:
    
    ```bash
    iverilog -o riscv_cpu.vvp riscv_cpu.v tb_cpu.v
    ```
    

2. Run the simulation:
    
    bash
    
    vvp riscv_cpu.vvp
    
3. View the waveform (using GTKWave):
    
    bash
    
    gtkwave wave.vcd
    

### Expected Testbench Output

At the end of the simulation (`#500`), the testbench will print the state of the first 16 registers and the first 4 memory locations in the console.

##  Notes

- The data memory and instruction memory are limited to 256 words (1 KB) each for simulation purposes.
- Memory addresses are word-aligned using `addr[9:2]`.
- The `JAL` instruction correctly saves `PC + 4` into the destination register (`rd`).
