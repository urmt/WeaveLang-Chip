* WeaveChip SPICE Parameters for TSMC N7
* File: spice_params.sp
* Description: CMOS FinFET and memristor/p-bit parameters for Spectre/HSPICE
* Usage: Include in simulation via .include directive

* CMOS FinFET Parameters (TSMC N7, 0.7V nominal)
.param vdd_nom=0.7      * Supply voltage (V)
.param vth_n=0.3        * NMOS threshold voltage (V)
.param vth_p=-0.3       * PMOS threshold voltage (V)
.param tox=1.2e-9       * Gate oxide thickness (m)
.param lgate=7e-9       * Gate length (m)
.param wfin=5e-9        * Fin width (m)
.param cgate=2e-15      * Gate capacitance (F)
.param ileak=1e-12      * Leakage current (A)

* Memristor Parameters (Ta/HfO2/Pt)
.param mem_ron=1e3      * Low resistance (Ohm)
.param mem_roff=1e6     * High resistance (Ohm)
.param mem_vset=1.5     * SET voltage (V)
.param mem_vreset=-1.2  * RESET voltage (V)
.param mem_d=5e-9       * Device thickness (m)
.param mem_uv=1e-14     * Mobility (m^2/Vs)
.param mem_cpar=1e-15   * Parasitic capacitance (F)
.param mem_endurance=1e6 * Write endurance (cycles)

* P-bit Parameters (CoFeB/MgO MTJ)
.param mtj_rap=5e3      * Anti-parallel resistance (Ohm)
.param mtj_rp=2e3       * Parallel resistance (Ohm)
.param mtj_hext=0.01    * External magnetic field (T)
.param mtj_alpha=0.02   * Damping factor
.param mtj_gamma=2.21e5 * Gyromagnetic ratio (m/A-s)
.param mtj_sigma=0.2    * Thermal noise (V)
.param mtj_cpar=0.5e-15 * Parasitic capacitance (F)

* Selector Diode (1T1R)
.param diode_vf=0.3     * Forward voltage (V)
.param diode_ron=100    * On resistance (Ohm)
.param diode_is=1e-12   * Saturation current (A)

* Simulation Settings
.param tstep=1e-9       * Time step (s)
.param tsim=1e-3        * Simulation time (s)

* Include TSMC N7 models
.include 'tsmc_n7_std.models'

* End of SPICE Parameters