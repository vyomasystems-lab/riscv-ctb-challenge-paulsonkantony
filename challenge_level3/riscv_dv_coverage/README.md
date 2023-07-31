# RISCV-DV

Test generation using riscv-dv
```
run --target rv32i --test riscv_arithmetic_basic_test --testlist testlist.yaml --simulator pyflow
```

Coverage generation using riscv-dv
```
cov --dir out/spike_sim/ --simulator=pyflow --enable_visualization --target rv32imc
```

# Challenge
The challenge is to fix the tool problem in generating coverage and make rv32i ISA coverage 100%

# Report
[Coverage Report](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/challenge_level3/riscv_dv_coverage/cov_out_2023-07-31/CoverageReport.txt)

# Output

![Coverage Command Output](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Coverage%20Output.png)
