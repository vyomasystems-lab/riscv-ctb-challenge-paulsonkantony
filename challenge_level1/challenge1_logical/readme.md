# Challenge 1 - Logical
**Bug**

``and s7, ra, z4``

**Fix**

``and s7, ra, s4``

z4 is not a valid register.

![Fixed Code 1.1.1](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Fixed_Code_1.1.1.png)

**Bug**

``andi s5, t1, s0``

**Fix**

``andi s5, t1, 0x0``

andi requires the second operand to be an immediate value

![Fixed Code 1.1.2](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Fixed_Code_1.1.2.png)

### Output
![Output 1.1.3](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Output_1.1.3.png)
