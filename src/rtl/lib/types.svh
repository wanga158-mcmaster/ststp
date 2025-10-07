`ifndef _TYPES_H
`define _TYPES_H

/* fetch -> decode interface */

typedef struct packed {
    logic [31:0] instr_addr // instruction address of operation

} f_d_WI;

/* decode -> execute interface */

typedef enum bit [4:0] {
    ARITHMETIC,
    MEMORY,
    BRANCH,
    JUMP
} OP_TYPES;

typedef enum bit [5:0] {
    ADD,
    SUB,
    XOR,
    OR,
    AND,
    SLL,
    SRL,
    SRA,
    SLT,
    SLTU,
    EQ,
    LUI,
    AUIPC,
    MUL,
    MULH,
    MULSU,
    MULU,
    DIV,
    DIVU,
    REM,
    REMU
} ARITHMETIC_TYPES;

typedef enum bit [5:0] {
    LB,
    LH,
    LW,
    LBU,
    LHU,
    SB,
    SH,
    SW
} MEMORY_TYPES;

typedef enum bit [5:0] {
    BEQ,
    BNE,
    BLT,
    BGE,
    BLTU,
    BGEU
} BRANCH_TYPES;

typedef enum bit [5:0] {
    JAL,
    JALR
} JUMP_TYPES;

typedef struct packed {
    logic [31:0] instr_dat, // instruction data
    logic [31:0] instr_addr, // instruction address
    logic [4:0] op_type, // general type of operation
    logic [6:0] op_spec, // specific operation of type
    logic [4:0] rs1_ind, // first source register index
    logic [4:0] rs2_ind, // second source register index
    logic [4:0] rd_ind, // destination register index
    logic [31:0] rs1_dat, // first source register data
    logic [31:0] rs2_dat, // second source register data
    logic [31:0] imm_val // immediate value

} d_e_WI;

/* execute -> writeback interface */

typedef struct packed {
    logic [4:0] op_type,  // general type of operation
    logic [5:0] op_spec, // specific operation of type
    logic [4:0] rd_ind, // destination register index
    logic [31:0] reg_dat, // value of register operations
    logic [31:0] jmp_addr, // value of jump address
    logic jmp_tk, // take jump or no

} e_w_WI;

/* writeback -> fetch interface */

typedef struct packed {
    logic [31:0] jmp_addr, // value of jump address
    logic jmp_tk // take jump or no

} w_f_WI;

/* writeback -> decode interface */

typedef struct packed {
    logic [4:0] rd_ind,  // destination register index
    logic reg_tk, // take register data or no
    logic mem_tk, // take data memory data or no
    logic [31:0] reg_dat, // register data
    logic [31:0] mem_dat, // storage memory data
    logic flush
} w_f_WI;

/* writeback -> execute interface */

typedef struct packed {
    logic flush
} w_e_WI;

`endif