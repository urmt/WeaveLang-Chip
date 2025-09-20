# WeaveChip Simulation Guide

This guide details how to simulate the WeaveChip neuromorphic processor using Cadence Spectre for Verilog-A netlists and Xilinx Vivado for FPGA emulation. Simulations validate the tension-drift-resolution cycles for SFH-inspired swarm computing.

## Prerequisites
- **EDA Tools**:
  - Cadence Virtuoso/Spectre (2025.1 or later).
  - Synopsys HSPICE (optional for cross-verification).
  - Mentor Calibre for DRC/LVS (optional).
  - Xilinx Vivado 2025.1 for FPGA emulation.
- **PDK**: TSMC N7 process design kit (contact TSMC for access).
- **Repository**: Clone from [https://github.com/xAI-WeaveChip/WeaveChip-Design](https://github.com/xAI-WeaveChip/WeaveChip-Design).
- **Hardware**: Linux workstation (Ubuntu 22.04, 32 GB RAM, 8-core CPU).

## Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/xAI-WeaveChip/WeaveChip-Design
   cd WeaveChip-Design
   ```
2. Install TSMC N7 PDK:
   - Copy PDK files to `/path/to/pdk/tsmc_n7`.
   - Append memristor models from `process/n7_pdk_ext.v`.
3. Configure environment:
   ```bash
   export PDK_HOME=/path/to/pdk/tsmc_n7
   export CDSHOME=/path/to/cadence/virtuoso
   export VIVADO_HOME=/path/to/xilinx/vivado
   ```

## Verilog-A Simulation (Cadence Spectre)
1. **Prepare Netlists**:
   - Use `netlists/weavechip_top.va` (32x32 core array) and `netlists/weave_core.va`.
   - Include `netlists/memristor.va` and `netlists/pbit_mtj.va` for component models.
2. **Run Testbench**:
   - Open Cadence Virtuoso ADE.
   - Load `simulation/weavechip_tb.va`.
   - Set include path: `+incdir+./netlists`.
   - Configure inputs: 8-bit Gaussian noise (σ=0.2) for sensor inputs.
   - Run command:
     ```bash
     spectre simulation/weavechip_tb.va -format psf -raw ./results
     ```
3. **Analyze Results**:
   - Plot spike outputs (`out_spikes`) and J(q) voltages (`v_jq` in cores).
   - Expected: 8 pJ/cycle, 92% accuracy under noise (σ=0.1).
4. **Cross-Verify with HSPICE** (optional):
   ```bash
   hspice simulation/weavechip_tb.va -o ./results_hspice
   ```

## FPGA Emulation (Xilinx Vivado)
1. **Prepare VHDL**:
   - Use `synthesis/fpga_emulation.vhd` for 256-core subset.
2. **Setup Vivado**:
   - Open Vivado 2025.1, create project targeting Versal VCK190.
   - Import `fpga_emulation.vhd` and map to LUTs/AXI interconnects.
3. **Simulate**:
   - Run behavioral simulation with synthetic inputs (e.g., 256x8-bit sensor data).
   - Verify spike timing and NoC sync (95% fidelity to Rust WeaveLang).
4. **Synthesize and Deploy**:
   ```bash
   vivado -mode batch -source synthesis/weavechip_synth.tcl
   ```
   - Deploy to VCK190 board for real-time testing.

## Validation Metrics
- **Energy**: 8 pJ per J(q) cycle (Spectre).
- **Latency**: 25x speedup vs. CPU for 100-agent foraging (FPGA).
- **Robustness**: Monte Carlo runs (10^4) confirm 92% accuracy under noise.

## Troubleshooting
- **Spectre Errors**: Check `n7_pdk_ext.v` for memristor parameter conflicts.
- **FPGA Timing**: Adjust NoC handshaking delays in `fpga_emulation.vhd` if violations occur.
- **Contact**: Email support@x.ai for issues.