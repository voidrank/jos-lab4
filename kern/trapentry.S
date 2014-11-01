/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(t_divide_handle, T_DIVIDE)
TRAPHANDLER_NOEC(t_debug_handle, T_DEBUG)
TRAPHANDLER_NOEC(t_nmi_handle, T_NMI)
TRAPHANDLER_NOEC(t_brkpt_handle, T_BRKPT)
TRAPHANDLER_NOEC(t_oflow_handle, T_OFLOW)
TRAPHANDLER_NOEC(t_bound_handle, T_BOUND)
TRAPHANDLER_NOEC(t_illop_handle, T_ILLOP)
TRAPHANDLER_NOEC(t_device_handle, T_DEVICE)
TRAPHANDLER(t_dblflt_handle, T_DBLFLT)
TRAPHANDLER(t_tss_handle, T_TSS)
TRAPHANDLER(t_segnp_handle, T_SEGNP)
TRAPHANDLER(t_stack_handle, T_STACK)
TRAPHANDLER(t_gpflt_handle, T_GPFLT)
TRAPHANDLER(t_pgflt_handle, T_PGFLT)
TRAPHANDLER_NOEC(t_fperr_handle, T_FPERR)
TRAPHANDLER(t_align_handle, T_ALIGN)
TRAPHANDLER_NOEC(t_mchk_handle, T_MCHK)
TRAPHANDLER_NOEC(t_simderr_handle, T_SIMDERR)

TRAPHANDLER_NOEC(t_syscall_handle, T_SYSCALL)

TRAPHANDLER_NOEC(t_irq0_handle, IRQ_OFFSET)
TRAPHANDLER_NOEC(t_irq1_handle, IRQ_OFFSET+1)
TRAPHANDLER_NOEC(t_irq2_handle, IRQ_OFFSET+2)
TRAPHANDLER_NOEC(t_irq3_handle, IRQ_OFFSET+3)
TRAPHANDLER_NOEC(t_irq4_handle, IRQ_OFFSET+4)
TRAPHANDLER_NOEC(t_irq5_handle, IRQ_OFFSET+5)
TRAPHANDLER_NOEC(t_irq6_handle, IRQ_OFFSET+6)
TRAPHANDLER_NOEC(t_irq7_handle, IRQ_OFFSET+7)
TRAPHANDLER_NOEC(t_irq8_handle, IRQ_OFFSET+8)
TRAPHANDLER_NOEC(t_irq9_handle, IRQ_OFFSET+9)
TRAPHANDLER_NOEC(t_irq10_handle, IRQ_OFFSET+10)
TRAPHANDLER_NOEC(t_irq11_handle, IRQ_OFFSET+11)
TRAPHANDLER_NOEC(t_irq12_handle, IRQ_OFFSET+12)
TRAPHANDLER_NOEC(t_irq13_handle, IRQ_OFFSET+13)
TRAPHANDLER_NOEC(t_irq14_handle, IRQ_OFFSET+14)
TRAPHANDLER_NOEC(t_irq15_handle, IRQ_OFFSET+15)

/*
 * lab 3: Your code here for _alltraps
 */

_alltraps:
	pushw	$0
	pushw	%ds
	pushw	$0
	pushw	%es
	pushal

	movl	$GD_KD, %eax
	movw	%ax, %ds
	movw	%ax, %es

	pushl	%esp

	call	trap
