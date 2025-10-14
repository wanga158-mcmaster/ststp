#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vsignal_sel_tb.h"

using std::cout;

vluint64_t sim_time = 0;
Vsignal_sel_tb * dut;
VerilatedVcdC * m_t;

#DEFINE chk(a, b) chk_f(a, b, #b)

int main(int argc, char** argv, char** env) {
    srand(time(0));
    Verilated::commandArgs(argc, argv);
    dut = new Vsignal_sel_tb;
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

verilator --timing --trace -cc -I../../rtl/lib/ -I../../rtl/s1_fetch/ -I../../rtl/s2_decode/ -I../../rtl/s3_execute/ -I../../rtl/s4_writeback/ signal_sel_tb.sv --exe signal_sel_tb.cpp

make -C obj_dir -f Vsignal_sel_tb.mk Vsignal_sel_tb

./obj_dir/Vsignal_sel_tb

*/