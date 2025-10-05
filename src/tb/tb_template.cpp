#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "V_DUT.h"

#define MAX_SIM_TIME 99
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    V_DUT *dut = new V_DUT;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_t = new VerilatedVcdC;
    dut->trace(m_t, 33);
    m_t->open("wf.vcd");

    dut->clk = 0;
    dut->rst_n = 1;
    int pcc = 0; // posedge clock count

    while (sim_time < MAX_SIM_TIME) {

        dut->clk ^= 1;
        dut->eval();
        if (dut->clk) {
            ++pcc;
        }
        m_t->dump(sim_time);
        sim_time++;
    }

    m_t->close();
    delete dut;
    exit(EXIT_SUCCESS);

}

/*

verilator --trace -cc _DUT.sv --exe _DUT_tb.cpp

make -C obj_dir -f V_DUT.mk V_DUT

./obj_dir/V_DUT

*/