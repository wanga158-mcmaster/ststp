#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vprogram_counter.h"

using std::cout;

#define MAX_SIM_TIME 333
vluint64_t sim_time = 0;

void chk(int expct, int exprm) {
    cout << "@t=" << sim_time << ", EXPECTED: " << expct << ", EXPERIMENTAL: " << exprm;
    if (expct != exprm) {
        cout << ", ERR!";
    }
    cout << "\n";
}

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Vprogram_counter *dut = new Vprogram_counter;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_t = new VerilatedVcdC;
    dut->trace(m_t, 33);
    m_t->open("wf.vcd");

    dut->clk = 1;
    dut->rst_n = 1;
    int pcc = 0; // posedge clock count
    int k = 0;

    while (sim_time < MAX_SIM_TIME) {
        dut->clk ^= 1;
        dut->eval();
        if (dut->clk) {
            ++pcc;
            if (pcc == 1) {
                dut->rst_n = 0; // reset
            }
            if (pcc == 2) {
                chk(0, dut->pc_out); // check reset
                dut->rst_n = 1; 
                dut->inc = 1; // check basic increment operation
                dut->ld = 0;
                dut->stll = 0;
            }
            if (pcc == 3) {
                chk(4, dut->pc_out);
            }
            if (pcc == 4) {
                chk(8, dut->pc_out);
                dut->stll = 1;
            }
            if (pcc == 5) {
                chk(8, dut->pc_out);
            }
            if (pcc == 6) {
                chk(8, dut->pc_out);
                dut->stll = 0;
                dut->ld = 1;
                dut->inc = 0;
                k = rand() % 256;
                dut->ld_dat = k;
            }
            if (pcc == 7) {
                chk(k, dut->pc_out);
            }
        }
        m_t->dump(sim_time);
        sim_time++;
    }

    m_t->close();
    delete dut;
    exit(EXIT_SUCCESS);

}

/*

verilator --trace --x-assign unique --x-initial unique -cc -I../../rtl/s1_fetch program_counter.sv --exe program_counter_tb.cpp

make -C obj_dir -f Vprogram_counter.mk Vprogram_counter

./obj_dir/Vprogram_counter +verilator+rand+reset+2

*/