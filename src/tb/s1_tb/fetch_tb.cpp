#include "bits/stdc++.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vfetch.h"
#include "Vfetch___024unit.h"

using std::cout;

#define MAX_SIM_TIME 333

vluint64_t sim_time = 0;
Vfetch * dut;
VerilatedVcdC * m_t;

int MEM[51200];

void chk(int expct, int exprm, std::string s) {
    cout << "@t=" << sim_time << " for " << s << ", EXPECTED: " << expct << ", EXPERIMENTAL: " << exprm;
    if (expct != exprm) {
        cout << ", ERR!";
    }
    cout << "\n";
}

int instr_addr_out_m; // memory returns data from last cycle instr_addr_out_m

void reset_fetch_chk(int pcc) {
    if (pcc == 3) {
        dut->rst_n = 0; // reset fetch
        dut->w_in = 0;
        dut->rst_addr = 0;
    }
    if (pcc == 4) {
        dut->rst_n = 1;
        chk(1, dut->stall_out_ft, "stall_out_ft");
        chk(0, dut->instr_addr_out_m, "instr_addr_out_m");
        chk(0, dut->instr_dat_out, "instr_dat_out");
        instr_addr_out_m = 0;
    }
}

void mem_pc_chk(int pcc) {
    if (pcc > 4 && pcc < 92) {
        dut->instr_dat_in = MEM[instr_addr_out_m]; // simulate memory module
        dut->eval(); // update dut
        chk(MEM[dut->f_out], dut->instr_dat_out, "instr_dat_out"); // check that the address and the value are the same
    }
    if (pcc >= 4 && pcc < 92) {
        instr_addr_out_m = dut->instr_addr_out_m;
    }
}

void jmp_chk(int pcc) {
    if (pcc == 111) {
        long long x;
        x = 1200;
        x <<= 1;
        x += 1;
        dut->w_in = x;
    }
    if (pcc == 112) {
        dut->w_in = 0;
        chk(0, dut->instr_dat_out, "instr_dat_out");
        chk(0, dut->f_out, "f_out.instr_addr");
        chk(1200, dut->instr_addr_out_m, "instr_addr_out_m");
        chk(1, dut->stall_out_ft, "stall_out_ft");
    }
    if (pcc == 113) {
        chk(1200, dut->f_out, "f_out.instr_addr");
        chk(1204, dut->instr_addr_out_m, "instr_addr_out_m");
        chk(0, dut->stall_out_ft, "stall_out_ft");
    }
}

int main(int argc, char** argv, char** env) {
    srand(time(0));
    Verilated::commandArgs(argc, argv);
    dut = new Vfetch;
    Verilated::traceEverOn(true);
    m_t = new VerilatedVcdC;
    dut->trace(m_t, 99);
    m_t->open("wf.vcd");

    dut->clk = 1;
    dut->rst_n = 1;
    int pcc = 0; // posedge clock count
    for (int i = 0; i < 51200; ++i) {
        MEM[i] = rand() % 4096; // init memory to random values
    }

    while (sim_time < MAX_SIM_TIME) {

        dut->clk ^= 1;
        dut->eval();
        if (dut->clk) {
            ++pcc;
            reset_fetch_chk(pcc); // check reset is working correctly
            mem_pc_chk(pcc); // check fetch is passing address corresponding to correct value
            jmp_chk(pcc); // check if jump is working correctly
        }
        m_t->dump(sim_time);
        sim_time++;
    }

    m_t->close();
    delete dut;
    exit(EXIT_SUCCESS);

}

/*

verilator --trace --x-assign unique --x-initial unique -cc -I../../rtl/s1_fetch/ fetch.sv --exe -trace-structs fetch_tb.cpp

make -C obj_dir -f Vfetch.mk Vfetch

./obj_dir/Vfetch +verilator+rand+reset+2

*/