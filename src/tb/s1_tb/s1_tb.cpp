#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vs1_tb.h"

using std::cout;

vluint64_t sim_time = 0;
Vs1_tb * dut;
VerilatedVcdC * m_t;

int main(int argc, char** argv, char** env) {
    srand(time(0));
    Verilated::commandArgs(argc, argv);
    dut = new Vs1_tb;
    Verilated::traceEverOn(true);
    m_t = new VerilatedVcdC;
    dut->trace(m_t, 33);
    m_t->open("wf.vcd");

    while (!Verilated::gotFinish()) {
        dut->eval();
        m_t->dump(Verilated::time());
        Verilated::timeInc(1);
    }

    m_t->close();
    delete dut;
    exit(EXIT_SUCCESS);

}

/*

verilator --timing --trace -cc -I../../rtl/lib/ -I../../rtl/s1_fetch s1_tb.sv --exe s1_tb.cpp

make -C obj_dir -f Vs1_tb.mk Vs1_tb

./obj_dir/Vs1_tb

*/  