#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vmemory.h"

#define MAX_SIM_TIME 99
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    Vmemory *dut = new Vmemory;
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
            if (pcc == 3) {
                dut->read_en = 1;
            }
            if (pcc == 4) {
                dut->write_en = 1;
                dut->write_addr = 0;
                dut->write_data = 3;
            }
            if (pcc == 5) {
                dut->write_en = 1;
                dut->write_addr = 1;
                dut->write_data = 33;
            }
            if (pcc == 6) {
                dut->write_en = 1;
                dut->write_addr = 2;
                dut->write_data = 333;
            }
            if (pcc == 7) {
                dut->write_en = 1;
                dut->write_addr = 3;
                dut->write_data = 3333;
            }
            if (pcc == 8) {
                dut->read_addr = 0;
            }
            if (pcc == 9) {
                if (dut->read_data != 3) {
                    std::cout << "err0\n";
                }
                dut->read_addr = 1;
            }
            if (pcc == 10) {
                if (dut->read_data != 33) {
                    std::cout << "err1\n";
                }
                dut->read_addr = 2;
            }
            if (pcc == 11) {
                if (dut->read_data != 333) {
                    std::cout << "err2\n";
                }
                dut->read_addr = 3;
            }
            if (pcc == 12) {
                if (dut->read_data != 3333) {
                    std::cout << "err3\n";
                }
                dut->read_addr = 0;
            }
            if (pcc == 13) {
                dut->rst_n = 0;
                dut->read_en = 1;
                dut->write_en = 0;
                dut->read_addr = 0;
            }
            if (pcc == 15) {
                if (dut->read_data != 0) {
                    std::cout << "err4\n";
                }
                dut->read_addr = 1;
            }
            if (pcc == 16) {
                if (dut->read_data != 0) {
                    std::cout << "err5\n";
                }
                dut->read_addr = 2;
            }
            if (pcc == 17) {
                if (dut->read_data != 0) {
                    std::cout << "err6\n";
                }
                dut->read_addr = 3;
            }
            if (pcc == 18) {
                if (dut->read_data != 0) {
                    std::cout << "err7\n";
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


verilator --trace -cc memory.sv --exe memory_tb.cpp

make -C obj_dir -f Vmemory.mk Vmemory

./obj_dir/Vmemory

*/