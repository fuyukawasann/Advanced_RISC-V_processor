# Advanced RISC-V Processor
Upload(Backup) our Verilog HDL Code which consists RISC-V processor and RISC-V Program

## Project Goal
- Make our own RISC-V processor using Verilog HDL.
- Take an advantage of running RISC-V program at short time.
- Improve software's algorithm fitting our processor.

## Environment
- Tool : Xilinx Vivado 2020.2
- FPGA : Libertron Artix-7

## Improvements
### Software (Assembly Code)
The fundamental assembly implementation of the Fibonacci sequence exhibited excessive use of Branch, Load, and Store instructions. Consequently, an effort was made to enhance the algorithm by reducing the reliance on these instructions, which are known to consume significant cycle time.

In the original implementation, the Fibonacci sequence computation commenced from the first term using a stacking approach for each iteration. However, this method revealed inefficiencies, as it necessitated repeated calculations to retrieve values from the stack until it was depleted.

In the improved version of the code, the usage of Load and Store instructions was minimized, and the design was oriented towards avoiding stalls. Rather than utilizing the stack for value assignment, temporary registers were employed. Specifically, registers x5, x6, and x7 were utilized in a circular pipeline configuration, while registers x28 and x29 were designated for limitation (set to 25) and iteration, respectively. This adjustment facilitated the calculation of the Fibonacci sequence in accordance with the principles of circular pipeline architecture.

As a result of these modifications, significant performance enhancements were achieved, as illustrated in Figure 02. Additionally, Figure 01 provides a representation of the computational methodology adopted in the improved code.

<div align="center"> 
 <img width="524" alt="image" src="https://github.com/user-attachments/assets/e902cefb-5c66-4536-96cb-7b016bf23dca">

 Figure01. Circular Pipe Register
</div>

The registers x5, x6, and x7 were utilized to compute the Fibonacci sequence, while register x28 stored the number of iterations required to complete the sequence, and register x29 indicated the current iteration count. Initially, to set the starting values, the number 1 was stored in x6. Subsequently, x29 was updated to reflect that one iteration had been performed.

In the next step, the second Fibonacci number was computed by adding the values in x5 (which holds 0) and x6 (which holds 1), and the result was stored in x7. At this point, the iteration count in x29 was incremented by 1. Following the circular rule, the third Fibonacci number was calculated by adding the values in x6 (1) and x7 (1), and this result (2) was stored in x5, followed by another increment of the iteration count.

In the final case, known as Case 3, the fourth Fibonacci number was derived by adding the values in x7 (1) and x5 (2), yielding a result of 3, which was also followed by an increment of the iteration count. To ensure that the computation would exit correctly after reaching the target sequence value (25 iterations), a conditional branch instruction (beq) was added at the beginning of each case to facilitate a jump to the exit point if the iteration limit was reached. Furthermore, to ensure that the final values were stored appropriately, each case was implemented to overwrite x10 with the instruction “add x10, x0, (value stored in the corresponding register).”

Based on this structured approach, once the execution reached Case 3, the instruction ‘j Case1’ was used to facilitate a jump back to Case 1. The concept of a circular pipeline was employed to simplify the storage rules when performing calculations solely within registers. The Fibonacci sequence inherently requires the addition of the two preceding values to compute the current value. While it is possible to allocate three spaces for this purpose, without the circular concept, the need to shift values for each iteration or to utilize a stack would arise. In contrast, the circular concept allows for the seamless calculation of the current value without the necessity for value movement. Therefore, the introduction of the circular pipeline concept significantly improved the efficiency of the algorithm.

### Hardware
The original plan involved implementing a Branch Predictor to enhance the Branch Condition. However, after optimizing the assembly code, it was observed that the Branch was taken only once. Given this finding, it was determined that implementing a Branch Predictor would not yield significant improvements over the current results. Consequently, the focus was shifted towards further software enhancements.

## Result
<div align="center">
 <img width="524" alt="image" src="https://github.com/user-attachments/assets/86b72bc5-a14a-4148-b8dd-6d9857a2c7a0">
</div>

We improve 62,764 cycles to 174 cycles.
