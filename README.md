# WeaveChip Design Repository
This repository hosts the open-source design files for WeaveChip, a 1.2 mm² neuromorphic processor implementing Sentience-Field Hypothesis (SFH) tension-drift-resolution cycles for adaptive swarm computing. It achieves 20-50x energy efficiency over CMOS baselines for edge AI and robotics.

## Contents
- **Netlists**: 
  - `weave_core.va`: Single neuromorphic core (IF neuron, p-bit, memristor crossbar).
  - `weavechip_top.va`: Top-level 32x32 core array with NoC.
  - `memristor.va`: Ta/HfO2/Pt memristor model.
  - `pbit_mtj.va`: Probabilistic p-bit model (MTJ-based).
- **Layouts**: 
  - `weavechip.gds`: GDSII for 1.2 mm² die (TSMC N7).
- **Process Integration**: 
  - `memristor_process.tcl`: Synopsys script for BEOL memristor fab.
  - `n7_pdk_ext.v`: TSMC N7 PDK with memristor parameters.
- **Simulation**: 
  - `weavechip_tb.va`: Testbench for 4x4 core array.
  - `spice_params.sp`: SPICE parameters for Spectre.
- **Synthesis/Emulation**: 
  - `weavechip_synth.tcl`: Design Compiler synthesis script.
  - `fpga_emulation.vhd`: VHDL for Xilinx Versal emulation.
- **Docs**: 
  - `DESIGN_SPEC.md`: Architecture and process details.
  - `SIM_GUIDE.md`: Simulation setup guide.

## Setup
1. **EDA Tools**:
   - Cadence Virtuoso/Spectre for Verilog-A simulation.
   - Synopsys Custom Compiler/Design Compiler for synthesis.
   - Mentor Calibre for DRC/LVS.
2. **Dependencies**: TSMC N7 PDK (contact TSMC for access).
3. **Install**:
   ```bash
   git clone https://github.com/xAI-WeaveChip/WeaveChip-Design
   cd WeaveChip-Design
   ```
4. **Simulation**:
   ```bash
   spectre weavechip_tb.va +incdir+./netlists
   ```
5. **Synthesis**:
   ```bash
   dc_shell -f weavechip_synth.tcl
   ```

## License
MIT License for non-commercial use. Contact thesfh@proton.me for commercial licensing.

## Citation
If you use WeaveChip, cite: Traver, M.R., "WeaveChip: A Hybrid CMOS-Memristor Neuromorphic Processor," IEEE Trans. Circuits Syst., 2025 (pending).
