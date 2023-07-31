# Challenge 3 - Capture the Bug
## Approach

Directed Tests were not used at all because we must spend a good amount of time to understand the functionality of Design and identify different verification scenarios to cover functionality.

Since the design itself is not made available, it was more feasible to do random tests rather than to do directed tests with specific test cases.

The YAML files used for the randomly generated tests target specific areas of functionality as listed below:

 1. Arithmetic
 2. Branching
 3. Control and Status Registers
 4. Recursions
 5. Exceptions

Since correlating dump files with instructions is tough especially when thousands of instructions are involved, a python script (aapg_report.py) was created to generate an excel report consolidating all test dumps from the AAPG workflow.

The key parts of interest in the generated artefacts are diff.dump and test.disass. 
 - diff.dump provides the lines that differ between the output of the simulator and the buggy design
 - It provides the instruction that caused a wrong register load.
 - It can also provide the Program Counter addresses that do not match indicating a control hazard
 - test.disass is the assembly program that was simulated to generate the outputs for both the simulator and the buggy design
 - The python script's task is to correlate the buggy instructions with lines in the disassembled code

The generated report has 4 sheets

1. Overview

   ![Overview Sheet](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Challenge3_Sheet1.png)
   
   The test_name columns gives the name of the test
   The pc_match column indicates whether there was a mismatch in the PC which might point to a control hazard
   The no_of_instructions column gives the number of instructions (approximately) in the test

3. default, with_hazards, without_hazards

   ![Instruction_Sheet](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Challenge3_Sheet2.png)

   These three sheets have the same template
   The instr column gives the name of the instruction that gave the incorrect register output or mismatched PC address
   The count column gives the number of times the instruction caused an incorrect output across all sub-tests
   The source column lists out the name of the test cases that instruction caused an error in.

   All three types of tests run the same set of 5 YAML files mentioned before. The difference is the probability of Data Hazards in each set of tests
   default: 0.5
   with_hazards: 0.9
   without_hazards: 0.0

   without_hazards is included to provide a greater insight in the raw functionality of instruction by removing the possiblity of hazards

## Analysis

ori, or, lw, add, sub, xor
These are the list of instructions that consistently give wrong output across all the tests

CSR tests always show PC mismatches which indicates that either there is a control hazard in the design or the right values are not being loaded in the registers
lw instruction is always seen in the list of instructions that fail in CSR tests hence it could be the culprit that is causing the mismatch.

## Output - Failing Test
![Challenge3_Output](https://github.com/vyomasystems-lab/riscv-ctb-challenge-paulsonkantony/blob/main/images/Challenge3_Out.png)

