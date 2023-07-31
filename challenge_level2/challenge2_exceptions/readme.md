# Challenge 2 - Exceptions

### Fixed Code - Code based on YAML file from Challenge 2.1

![Fixed Code 2.2.1](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Fixed_Code_2.2.1.png)

**Line 28** \
Custom Trap Handler has to be enabled for illegal instruction handling

![Fixed Code 2.2.2](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Fixed_Code_2.2.2.png)

**Line 181** \
ecause02 must be equal to 10 to generate 10 illegal instructions.

![Machine Cause Register 2.2.3](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Image_2.2.3.png)

MCAUSE stores the cause of the trap. The definition for MCAUSE value for traps caused by illegal instruction is as follows:

Interrupt = 1

Exception Code = 02

![Output 2.2.4](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Output_2.2.4.png)
![Output 2.2.5](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Output_2.2.5.png)
![Output 2.2.6](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Output_2.2.6.png)
