	.file	"hello.c"
	.text
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	subl	$80, %esp
	movl	$2, -24(%ebp)
	movl	$10, -20(%ebp)
	movb	$8, -5(%ebp)
	cmpb	$2, -5(%ebp)
	ja	.L2
	movl	-32(%ebp), %eax
	movl	%eax, -40(%ebp)
	jmp	.L4
.L2:
	movb	$1, -7(%ebp)
	jmp	.L5
.L6:
	movzbl	-5(%ebp), %eax
	subl	$1, %eax
	movb	%al, -6(%ebp)
	jmp	.L7
.L8:
	cmpl	$0, -32(%ebp)
	jle	.L9
	movl	$2, -28(%ebp)
.L9:
	subb	$1, -6(%ebp)
.L7:
	movzbl	-6(%ebp), %eax
	cmpb	-7(%ebp), %al
	ja	.L8
	addb	$1, -7(%ebp)
.L5:
	movzbl	-7(%ebp), %eax
	cmpb	-5(%ebp), %al
	jb	.L6
	movl	-32(%ebp), %eax
	movl	%eax, -40(%ebp)
.L4:
	movl	-40(%ebp), %eax
	imull	-20(%ebp), %eax
	addl	-36(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-36(%ebp), %eax
	addl	%eax, -16(%ebp)
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-20(%ebp)
	movl	%eax, -40(%ebp)
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-20(%ebp)
	movl	%edx, -36(%ebp)
	addl	$80, %esp
	popl	%ecx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)"
	.section	.note.GNU-stack,"",@progbits
