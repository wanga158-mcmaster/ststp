#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vmux_gen.h"

#define MAX_SIM_TIME 99
vluint64_t sim_time = 0;

using std::cout;

int main(int argc, char** argv, char** env) {
    Vmux_gen *dut = new Vmux_gen;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_t = new VerilatedVcdC;
    dut->trace(m_t, 33);
    m_t->open("wf.vcd");

    dut->clk = 1;
    // dut->rst_n = 1;
    int pcc = 0; // posedge clock count

    while (sim_time < MAX_SIM_TIME) {

        dut->clk ^= 1;
        dut->eval();
        if (dut->clk) {
            ++pcc;
            if (pcc == 3) {
                for (int i = 0; i < 32; ++i) {
                    dut->A[i] = i + 1;
                }
                dut->s = 0;
            }
            if (pcc > 3 && (dut->s) < 32) {
                if (dut->aer != dut->s + 1) {
                    cout << "ERR" << dut->s << "\n";
                }
                ++(dut->s);
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

verilator --trace --x-assign unique --x-initial unique -cc mux_gen.sv --exe mux_gen_tb.cpp

make -C obj_dir -f Vmux_gen.mk Vmux_gen

./obj_dir/Vmux_gen

*/