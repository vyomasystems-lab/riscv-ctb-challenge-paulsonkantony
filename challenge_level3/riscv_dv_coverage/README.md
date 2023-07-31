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
![image](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/assets/62837052/fdcb3f08-3afc-4692-a879-429865bab5ec)

# Output

![Coverage Command Output](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/coverage_part1.png)
![Coverage Command Output](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/coverage_part2.png)

# Issues faced
**
Bug 1**
```
riscv_instr_cov_test.py: error: unrecognized arguments: +disable_compressed_instr=1

Mon, 31 Jul 2023 20:44:16 ERROR    ERROR return code: True/2, cmd: python3 /tools/riscv-dv/pygen/pygen_src/test/riscv_instr_cov_test.py  --trace_csv=out_2023-07-31/spike_sim/riscv_arithmetic_basic_test.0.csv,out_2023-07-31/spike_sim/riscv_arithmetic_basic_test.1.csv,out_2023-07-31/spike_sim/riscv_jump_stress_test.0.csv,out_2023-07-31/spike_sim/riscv_loop_test.0.csv   --enable_visualization --num_of_tests=1 --start_idx=0 --asm_file_name=cov_out_2023-07-31/asm_test/riscv_instr_cov_test --log_file_name=cov_out_2023-07-31/sim_riscv_instr_cov_test_0_0.log  --target=rv32i  --gen_test=riscv_instr_cov_test  --seed=2137299175 +disable_compressed_instr=1
```
**
*Fix***

Run the command without the invalid argument

```
python3 /tools/riscv-dv/pygen/pygen_src/test/riscv_instr_cov_test.py  --trace_csv=out_2023-07-31/spike_sim/riscv_arithmetic_basic_test.0.csv,out_2023-07-31/spike_sim/riscv_arithmetic_basic_test.1.csv,out_2023-07-31/spike_sim/riscv_jump_stress_test.0.csv,out_2023-07-31/spike_sim/riscv_loop_test.0.csv   --enable_visualization --num_of_tests=1 --start_idx=0 --asm_file_name=cov_out_2023-07-31/asm_test/riscv_instr_cov_test --log_file_name=cov_out_2023-07-31/sim_riscv_instr_cov_test_0_0.log  --target=rv32i  --gen_test=riscv_instr_cov_test  --seed=2137299175
```
**
 Bug 2**

```
Mon, 31 Jul 2023 21:04:48 INFO     Traceback (most recent call last):
  File "/tools/riscv-dv/pygen/pygen_src/test/riscv_instr_cov_test.py", line 211, in <module>
    cov_test.run_phase()
  File "/tools/riscv-dv/pygen/pygen_src/test/riscv_instr_cov_test.py", line 87, in run_phase
    if not self.sample():
  File "/tools/riscv-dv/pygen/pygen_src/test/riscv_instr_cov_test.py", line 145, in sample
    self.assign_trace_info_to_instr(instruction)
  File "/tools/riscv-dv/pygen/pygen_src/test/riscv_instr_cov_test.py", line 170, in assign_trace_info_to_instr
    instruction.update_src_regs(operands)
  File "/tools/riscv-dv/pygen/pygen_src/isa/riscv_cov_instr.py", line 446, in update_src_regs
    self.rs1 = self.get_gpr(operands[2])
  File "/tools/riscv-dv/pygen/pygen_src/isa/riscv_cov_instr.py", line 577, in get_gpr
    return riscv_reg_t[reg_name]
  File "/usr/local/lib/python3.8/enum.py", line 387, in __getitem__
    return cls._member_map_[name]
KeyError: '-9'
```

Change the code in riscv_cov_instr.py

```
if self.category.name == "LOAD":
                # load rd, imm(rs1)
                self.rs1 = self.get_gpr(operands[1])
                self.rs1_value.set_val(self.get_gpr_state(operands[1]))
                self.imm.set_val(get_val(operands[2]))
```
```
if self.category.name == "STORE":
                self.rs2 = self.get_gpr(operands[1])
                self.rs2_value.set_val(self.get_gpr_state(operands[1]))
                self.rs1 = self.get_gpr(operands[0])
                self.rs1_value.set_val(self.get_gpr_state(operands[0]))
                self.imm.set_val(get_val(operands[2]))
```

 

