	.file	"hello.c"
	.section	.rodata
	.align 8
.LC0:
	.long	-1717986918
	.long	1071225241
	.align 8
.LC1:
	.long	1202590843
	.long	1069841121
	.text
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ecx
	subl	$116, %esp
	movl	$2, -64(%ebp)
	movl	$10, -60(%ebp)
	movb	$8, -9(%ebp)
	movl	$0, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	$0, -40(%ebp)
	movl	$0, -36(%ebp)
	movl	$1, -32(%ebp)
	movl	$0, -28(%ebp)
	fnstcw	-122(%ebp)
	movzwl	-122(%ebp), %eax
	movb	$12, %ah
	movw	%ax, -124(%ebp)
	jmp	.L2
.L3:
	movl	-28(%ebp), %edx
	movl	-72(%ebp), %eax
	imull	-60(%ebp), %eax
	addl	-76(%ebp), %eax
	movl	%eax, -120(%ebp,%edx,4)
	movl	-28(%ebp), %eax
	movl	-120(%ebp,%eax,4), %eax
	addl	$1, %eax
	addl	%eax, -36(%ebp)
	fildl	-48(%ebp)
	fildl	-28(%ebp)
	fldl	.LC0
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fldcw	-124(%ebp)
	fistpl	-48(%ebp)
	fldcw	-122(%ebp)
	fildl	-44(%ebp)
	fildl	-28(%ebp)
	fldl	.LC1
	fmulp	%st, %st(1)
	fildl	-28(%ebp)
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fldcw	-124(%ebp)
	fistpl	-44(%ebp)
	fldcw	-122(%ebp)
	fildl	-40(%ebp)
	movl	-28(%ebp), %eax
	movl	-120(%ebp,%eax,4), %eax
	addl	-32(%ebp), %eax
	pushl	%eax
	fildl	(%esp)
	leal	4(%esp), %esp
	fldl	.LC0
	fmulp	%st, %st(1)
	fildl	-28(%ebp)
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fldcw	-124(%ebp)
	fistpl	-40(%ebp)
	fldcw	-122(%ebp)
	addl	$1, -28(%ebp)
.L2:
	movzbl	-9(%ebp), %eax
	cmpl	-28(%ebp), %eax
	jg	.L3
	movzbl	-9(%ebp), %eax
	movl	%eax, %edx
	imull	-40(%ebp), %edx
	movl	-36(%ebp), %eax
	imull	-48(%ebp), %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movzbl	-9(%ebp), %eax
	movl	%eax, %edx
	imull	-44(%ebp), %edx
	movl	-48(%ebp), %eax
	imull	-48(%ebp), %eax
	movl	%edx, %ebx
	subl	%eax, %ebx
	movl	%ebx, %eax
	movl	%ecx, %edx
	movl	%eax, %ebx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	%ebx
	movl	%eax, -24(%ebp)
	movl	-24(%ebp), %eax
	movl	%eax, %edx
	imull	-48(%ebp), %edx
	movl	-36(%ebp), %eax
	movl	%eax, %ecx
	subl	%edx, %ecx
	movl	%ecx, %edx
	movzbl	-9(%ebp), %eax
	movl	%eax, %ebx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	%ebx
	movl	%eax, -20(%ebp)
	fildl	-20(%ebp)
	fildl	-24(%ebp)
	fldl	.LC0
	fmulp	%st, %st(1)
	movzbl	-9(%ebp), %eax
	shrb	%al
	movzbl	%al, %eax
	pushl	%eax
	fildl	(%esp)
	leal	4(%esp), %esp
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fldcw	-124(%ebp)
	fistpl	-16(%ebp)
	fldcw	-122(%ebp)
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-60(%ebp)
	movl	%edx, -76(%ebp)
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-60(%ebp)
	movl	%eax, -80(%ebp)
	addl	$116, %esp
	popl	%ecx
	popl	%ebx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)"
	.section	.note.GNU-stack,"",@progbits
