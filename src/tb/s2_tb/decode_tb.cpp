#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "V_DUT.h"

using std::cout;

#define MAX_SIM_TIME 99
vluint64_t sim_time = 0;
V_DUT * dut;
VerilatedVcdC * m_t;

#DEFINE chk(a, b) chk_f(a, b, #b)

void chk_f(int expct, int exprm, std::string s) {
    cout << "@t=" << sim_time << " for " << s << ", EXPECTED: " << expct << ", EXPERIMENTAL: " << exprm;
    if (expct != exprm) {
        cout << ", ERR!";
    }
    cout << "\n";
}

int main(int argc, char** argv, char** env) {
    srand(time(0));
    Verilated::commandArgs(argc, argv);
    dut = new V_DUT;
    Verilated::traceEverOn(true);
    m_t = new VerilatedVcdC;
    dut->trace(m_t, 33);
    m_t->open("wf.vcd");

    dut->clk = 1;
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

verilator --trace --x-assign unique --x-initial unique -cc -I../../rtl/lib/ -I../../rtl/s1_fetch/ -I../../rtl/s2_decode/ -I../../rtl/s3_execute/ -I../../rtl/s4_writeback _DUT.sv --exe _DUT_tb.cpp

make -C obj_dir -f V_DUT.mk V_DUT

./obj_dir/V_DUT +verilator+rand+reset+2

*/