#include "bits/stdc++.h"

using namespace std;

/* assumptions are listed below.
1. the instruction exists
2. the instructions are separated by a newline character
3. the instruction is in lowercase
4. the register is named x0, x1, etc
5. the registers/immediate are separated by just a comma

examples:

addi x0,x0,0
add x3,x3,x3

*/

string instr;
map<string, string> fmt; // maps instruction to format, i.e. add to r-type
string cur_op, opcode;
int rd_ind, rs1_ind, rs2_ind;

#define setup_map(_t) setup_map(_t, #_t)

void setup_map_f(const vector<string> & ops, string fmt_type) {
    for (auto & op : ops) {
        fmt.insert(op, fmt_type);
    }
}

void get_instr() {
    int ind;
    for (ind = 0; instr[ind] != ' '; ++ind) {
        cur_op.push_back(instr[ind]);
    } // get instruction
    // remove instruction from operation
    instr = instr.substr(ind + 1, instr.length() - (ind + 1 + 1));
}

void parse_r() {
    string regs[3];
    int ind = 0;
    for (int i = 0; i < 3; ++i) {
        while (instr[ind] != ',' && instr[ind] != ' ') {
            regs[i].push_back(instr[ind]);
            ++ind;
        }
        ++ind;
    }
}

int main()
{
    ifstream _IN("IN.txt");
    ofstream _OUT("OUT.txt");
    
    vector<string> r_type[] = {
        "add",
        "sub",
        "xor",
        "or",
        "and",
        "sll",
        "srl",
        "sra",
        "slt",
        "sltu"
    };
    vector<string> i_type[] = {
        "addi",
        "xori",
        "ori",
        "andi",
        "slli",
        "srli",
        "srai",
        "slti",
        "sltui",
        "lb",
        "lh",
        "lw",
        "lbu",
        "lhu",
        "jalr"
    };
    vector<string> s_type[] = {
        "sb",
        "sh",
        "sw"
    };
    vector<string> b_type[] = {
        "beq",
        "bne",
        "blt",
        "bge",
        "bltu",
        "bgeu"
    };
    vector<string> j_type[] = {
        "jal"
    };
    vector<string> u_type[] = {
        "lui",
        "auipc"
    };

    setup_map(r_type);
    setup_map(i_type);
    setup_map(s_type);
    setup_map(b_type);
    setup_map(j_type);
    setup_map(u_type);
    
    while (getline(_IN, instr)) {
        /* get operation */
        cur_op.clear();
        cur_opcode.clear();
        get_instr();
        string cur_fmt = fmt[op];
        if (cur_fmt == "r_type") {
            parse_r();
        } else if (cur_fmt == "i_type") {

        } else if (cur_fmt == "s_type") {

        } else if (cur_fmt == "b_type") {

        } else if (cur_fmt == "j_type") {

        } else if (cur_fmt == "u_type") {

        }
        _OUT << cur_opcode << "\n";
    }
    assert(_IN.eof());
    return 0;
}