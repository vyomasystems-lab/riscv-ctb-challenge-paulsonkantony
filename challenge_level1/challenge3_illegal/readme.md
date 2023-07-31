# Challenge 1 - Illegal Instruction

### Fixed Code

![Fixed Code 1.3.1](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Fixed_Code_1.3.1.png)

**Line 15 – Logical Error**\
Removed jump statement to prevent program end when control returns from trap

**Line 25 – Logical Error**\
Added line go to next legal instruction

**Line 26 – Logical Error**\
Added line to update the return PC address

### Output
![Output 1.3.2](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Output_1.3.2.png)
