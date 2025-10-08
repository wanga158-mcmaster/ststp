#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vd_register.h"

using std::cout;

#define MAX_SIM_TIME 99
vluint64_t sim_time = 0;

template <typename T>
void chk(T expct, T exprm) {
    cout << "EXPECTED: " << expct << ", EXPERIMENTAL: " << exprm;
    if (expct != exprm) {
        cout << ", ERR!";
    }
    cout << "\n";
}

int main(int argc, char** argv, char** env) {
    srand(time(0));
    Vd_register *dut = new Vd_register;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_t = new VerilatedVcdC;
    dut->trace(m_t, 33);
    m_t->open("wf.vcd");

    dut->clk = 1;
    dut->rst_n = 1;

    dut->en = 1;
    dut->flush = 0;
    int pcc = 0; // posedge clock count
    int k;

    while (sim_time < MAX_SIM_TIME) {

        dut->clk ^= 1;
        dut->eval();
        if (dut->clk) {
            ++pcc;
            
            if (pcc == 2) {
                dut->rst_n = 0; // check reset
            }
            if (pcc == 3) {
                chk<int>(0, dut->dout);
                dut->rst_n = 1;
            }
            if (pcc == 4) {
                k = rand() % 128;
                dut->din = k; // check basic functionality
            }
            if (pcc == 5) {
                chk<int>(k, dut->dout);
            }
            if (pcc == 6) {
                dut->en = 0; // check enable
                dut->din = 129;
            }
            if (pcc == 7) {
                chk<int>(k, dut->dout);
            }
            if (pcc == 8) {
                dut->flush = 1; // check flush with enable
            }
            if (pcc == 9) {
                chk<int>(0, dut->dout);
            }
            if (pcc == 10) {
                dut->en = 1;
                dut->flush = 0;
                k = rand() % 128;
                dut->din = k;
            }
            if (pcc == 11) {
                chk<int>(k, dut->dout);
            }
            if (pcc == 12) {
                dut->flush = 1;
                dut->en = 0;
            }
            if (pcc == 13) {
                chk<int>(0, dut->dout);
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

verilator --trace -cc --x-assign unique --x-initial unique d_register.sv --exe d_register_tb.cpp

make -C obj_dir -f Vd_register.mk Vd_register

./obj_dir/Vd_register +verilator+rand+reset+2

*/