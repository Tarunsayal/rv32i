#!/usr/bin/env python3
"""
RV32I Assembler — generates program.mem for $readmemh
Supported: R-type, I-type (ADDI/ORI/XORI/ANDI/SLTI/SLLI/SRLI/SRAI)
           LOAD (LW/LH/LB/LHU/LBU), STORE (SW/SH/SB)
           BRANCH (BEQ/BNE/BLT/BGE/BLTU/BGEU)
           LUI, AUIPC, JAL, JALR

Usage:
    Edit the PROGRAM list below, then run:
        python assembler.py
    Generates program.mem — place it next to your Verilog files.
"""

# ─── WRITE YOUR PROGRAM HERE ─────────────────────────────────────────────────
PROGRAM = [
    "addi x1, x0, 5",
    "addi x2, x0, 5",
    "beq  x1, x2, 8",
    "addi x3, x0, 99",
    "addi x4, x0, 42",
]
# ─────────────────────────────────────────────────────────────────────────────

# Register name → number
def reg(name):
    name = name.strip().lower()
    abi = {
        "zero":0, "ra":1, "sp":2, "gp":3, "tp":4,
        "t0":5, "t1":6, "t2":7,
        "s0":8, "fp":8, "s1":9,
        "a0":10,"a1":11,"a2":12,"a3":13,"a4":14,"a5":15,"a6":16,"a7":17,
        "s2":18,"s3":19,"s4":20,"s5":21,"s6":22,"s7":23,
        "s8":24,"s9":25,"s10":26,"s11":27,
        "t3":28,"t4":29,"t5":30,"t6":31
    }
    if name in abi:
        return abi[name]
    if name.startswith("x"):
        return int(name[1:])
    raise ValueError(f"Unknown register: {name}")

def imm(val, bits):
    """Parse immediate, sign-check, return as unsigned int of given width."""
    v = int(val.strip(), 0)
    if v < 0:
        v = v & ((1 << bits) - 1)   # two's complement truncation
    if v >= (1 << bits):
        raise ValueError(f"Immediate {val} doesn't fit in {bits} bits")
    return v

def sign_extend(v, bits):
    if v >= (1 << (bits-1)):
        v -= (1 << bits)
    return v

# ── Encoders ─────────────────────────────────────────────────────────────────

def r_type(funct7, rs2, rs1, funct3, rd, opcode):
    return ((funct7 & 0x7f) << 25 | (rs2 & 0x1f) << 20 |
            (rs1 & 0x1f) << 15 | (funct3 & 0x7) << 12 |
            (rd  & 0x1f) << 7  | (opcode & 0x7f))

def i_type(imm12, rs1, funct3, rd, opcode):
    return ((imm12 & 0xfff) << 20 | (rs1 & 0x1f) << 15 |
            (funct3 & 0x7) << 12  | (rd  & 0x1f) << 7 |
            (opcode & 0x7f))

def s_type(imm12, rs2, rs1, funct3, opcode):
    imm_11_5 = (imm12 >> 5) & 0x7f
    imm_4_0  = imm12 & 0x1f
    return (imm_11_5 << 25 | (rs2 & 0x1f) << 20 | (rs1 & 0x1f) << 15 |
            (funct3 & 0x7) << 12 | imm_4_0 << 7 | (opcode & 0x7f))

def b_type(offset, rs2, rs1, funct3, opcode):
    # offset is signed, in bytes, must be even
    if offset & 1:
        raise ValueError("Branch offset must be even")
    o = offset & 0x1fff   # 13-bit two's complement
    imm12   = (o >> 12) & 1
    imm11   = (o >> 11) & 1
    imm10_5 = (o >> 5)  & 0x3f
    imm4_1  = (o >> 1)  & 0xf
    return (imm12 << 31 | imm10_5 << 25 | (rs2 & 0x1f) << 20 |
            (rs1 & 0x1f) << 15 | (funct3 & 0x7) << 12 |
            imm4_1 << 8 | imm11 << 7 | (opcode & 0x7f))

def u_type(imm20, rd, opcode):
    return ((imm20 & 0xfffff) << 12 | (rd & 0x1f) << 7 | (opcode & 0x7f))

def j_type(offset, rd, opcode):
    if offset & 1:
        raise ValueError("JAL offset must be even")
    o = offset & 0x1fffff  # 21-bit two's complement
    imm20    = (o >> 20) & 1
    imm19_12 = (o >> 12) & 0xff
    imm11    = (o >> 11) & 1
    imm10_1  = (o >> 1)  & 0x3ff
    return (imm20 << 31 | imm10_1 << 21 | imm11 << 20 |
            imm19_12 << 12 | (rd & 0x1f) << 7 | (opcode & 0x7f))

# ── Instruction dispatch ──────────────────────────────────────────────────────

def assemble_one(line, pc):
    line = line.strip()
    if not line or line.startswith("#"):
        return None
    # strip inline comments
    line = line.split("#")[0].strip()
    if not line:
        return None

    parts = line.replace(",", " ").split()
    op = parts[0].lower()

    # ── R-type ───────────────────────────────────────────────────────────────
    R = {"add": (0x00,0x0), "sub": (0x20,0x0), "and": (0x00,0x7),
         "or":  (0x00,0x6), "xor": (0x00,0x4), "sll": (0x00,0x1),
         "srl": (0x00,0x5), "sra": (0x20,0x5), "slt": (0x00,0x2),
         "sltu":(0x00,0x3)}
    if op in R:
        rd, rs1, rs2 = reg(parts[1]), reg(parts[2]), reg(parts[3])
        f7, f3 = R[op]
        return r_type(f7, rs2, rs1, f3, rd, 0x33)

    # ── I-type ALU ───────────────────────────────────────────────────────────
    I_ALU = {"addi":0x0,"ori":0x6,"xori":0x4,"andi":0x7,"slti":0x2,"sltiu":0x3}
    if op in I_ALU:
        rd, rs1 = reg(parts[1]), reg(parts[2])
        v = int(parts[3].strip(), 0)
        v12 = v & 0xfff
        return i_type(v12, rs1, I_ALU[op], rd, 0x13)

    # ── Shifts (I-type but shamt only 5 bits) ────────────────────────────────
    if op in ("slli","srli","srai"):
        rd, rs1 = reg(parts[1]), reg(parts[2])
        shamt = int(parts[3].strip(), 0) & 0x1f
        f7 = 0x20 if op == "srai" else 0x00
        f3 = {"slli":0x1,"srli":0x5,"srai":0x5}[op]
        imm12 = (f7 << 5) | shamt
        return i_type(imm12, rs1, f3, rd, 0x13)

    # ── LOAD ─────────────────────────────────────────────────────────────────
    LOAD = {"lw":0x2,"lh":0x1,"lb":0x0,"lhu":0x5,"lbu":0x4}
    if op in LOAD:
        rd = reg(parts[1])
        # parse offset(rs1)
        off, base = parts[2].split("(")
        rs1 = reg(base.rstrip(")"))
        v = int(off.strip(), 0) & 0xfff
        return i_type(v, rs1, LOAD[op], rd, 0x03)

    # ── STORE ────────────────────────────────────────────────────────────────
    STORE = {"sw":0x2,"sh":0x1,"sb":0x0}
    if op in STORE:
        rs2 = reg(parts[1])
        off, base = parts[2].split("(")
        rs1 = reg(base.rstrip(")"))
        v = int(off.strip(), 0) & 0xfff
        return s_type(v, rs2, rs1, STORE[op], 0x23)

    # ── BRANCH ───────────────────────────────────────────────────────────────
    BR = {"beq":0x0,"bne":0x1,"blt":0x4,"bge":0x5,"bltu":0x6,"bgeu":0x7}
    if op in BR:
        rs1, rs2 = reg(parts[1]), reg(parts[2])
        offset = int(parts[3].strip(), 0)
        return b_type(offset, rs2, rs1, BR[op], 0x63)

    # ── LUI ──────────────────────────────────────────────────────────────────
    if op == "lui":
        rd = reg(parts[1])
        v = int(parts[2].strip(), 0) & 0xfffff
        return u_type(v, rd, 0x37)

    # ── AUIPC ────────────────────────────────────────────────────────────────
    if op == "auipc":
        rd = reg(parts[1])
        v = int(parts[2].strip(), 0) & 0xfffff
        return u_type(v, rd, 0x17)

    # ── JAL ──────────────────────────────────────────────────────────────────
    if op == "jal":
        rd = reg(parts[1])
        offset = int(parts[2].strip(), 0)
        return j_type(offset, rd, 0x6f)

    # ── JALR ─────────────────────────────────────────────────────────────────
    if op == "jalr":
        rd = reg(parts[1])
        rs1 = reg(parts[2])
        off = int(parts[3].strip(), 0) & 0xfff
        return i_type(off, rs1, 0x0, rd, 0x67)

    raise ValueError(f"Unknown instruction: {op}")


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    output = []
    errors = []

    for i, line in enumerate(PROGRAM):
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        pc = len(output) * 4
        try:
            enc = assemble_one(stripped, pc)
            if enc is not None:
                output.append((pc, enc, stripped))
        except Exception as e:
            errors.append(f"Line {i+1}: '{stripped}' → {e}")

    if errors:
        print("ERRORS:")
        for e in errors:
            print(f"  {e}")
        return

    # Write .mem file
    with open("program.mem", "w") as f:
        for _, enc, _ in output:
            f.write(f"{enc:08x}\n")

    # Print disassembly table
    print(f"{'PC':<8} {'Hex':<12} Assembly")
    print("-" * 45)
    for pc, enc, asm in output:
        print(f"0x{pc:04x}   {enc:08x}   {asm}")

    print(f"\n✓ program.mem written ({len(output)} instructions)")


if __name__ == "__main__":
    main()
