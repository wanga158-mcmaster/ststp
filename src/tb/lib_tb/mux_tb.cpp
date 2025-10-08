#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vmux.h"

#define MAX_SIM_TIME 99
int pcc = 0; // posedge clock count
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    // Verilated::commandArgs(argc, argv);
    Vmux *dut = new Vmux;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_t = new VerilatedVcdC;
    dut->trace(m_t, 33);
    m_t->open("wf.vcd");

    dut->clk = 1;
    // dut->rst_n = 1;

    while (sim_time < MAX_SIM_TIME) {

        dut->clk ^= 1;
        dut->eval();
        if (dut->clk) {
            ++pcc;
            if (pcc == 3) {
                dut->a = 3;
                dut->b = 33;
                dut->s = 0;
            }
            if (pcc == 4) {
                if (dut->aer != 3) {
                    std::cout << "ERR0\n";
                }
            }
            if (pcc == 5) {
                dut->s = 1;
            }
            if (pcc == 6) {
                if (dut->aer != 33) {
                    std::cout << "ERR1\n";
                }
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

verilator --trace --x-assign unique --x-initial unique -cc mux.sv --exe mux_tb.cpp

make -C obj_dir -f Vmux.mk Vmux

./obj_dir/Vmux +verilator+rand+reset+2

*/