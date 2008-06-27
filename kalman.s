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
	subl	$112, %esp
	movl	$2, -52(%ebp)
	movl	$10, -48(%ebp)
	movb	$8, -5(%ebp)
	cmpb	$1, -5(%ebp)
	jbe	.L2
	movb	$1, -7(%ebp)
	jmp	.L4
.L5:
	movzbl	-5(%ebp), %eax
	subl	$1, %eax
	movb	%al, -6(%ebp)
	jmp	.L6
.L7:
	cmpl	$0, -60(%ebp)
	jle	.L8
	movl	$2, -56(%ebp)
.L8:
	subb	$1, -6(%ebp)
.L6:
	movzbl	-6(%ebp), %eax
	cmpb	-7(%ebp), %al
	ja	.L7
	addb	$1, -7(%ebp)
.L4:
	movzbl	-7(%ebp), %eax
	cmpb	-5(%ebp), %al
	jb	.L5
.L2:
	movl	$0, -36(%ebp)
	movl	$1, -24(%ebp)
	movl	$10, -16(%ebp)
	movl	$1, -28(%ebp)
	movl	$1, -12(%ebp)
	movl	$1, -32(%ebp)
	movb	$0, -7(%ebp)
	jmp	.L11
.L12:
	movl	-60(%ebp), %eax
	imull	-48(%ebp), %eax
	addl	-64(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	-36(%ebp), %eax
	imull	-32(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	-32(%ebp), %eax
	imull	-24(%ebp), %eax
	imull	-32(%ebp), %eax
	addl	-16(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-24(%ebp), %eax
	movl	%eax, %edx
	imull	-12(%ebp), %edx
	movl	-12(%ebp), %eax
	imull	-24(%ebp), %eax
	imull	-12(%ebp), %eax
	addl	-28(%ebp), %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	%ecx
	movl	%eax, -20(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, %edx
	imull	-36(%ebp), %edx
	movl	-40(%ebp), %eax
	subl	%edx, %eax
	imull	-20(%ebp), %eax
	addl	%eax, -36(%ebp)
	movl	-20(%ebp), %eax
	movl	%eax, %edx
	imull	-12(%ebp), %edx
	movl	$1, %eax
	movl	%eax, %ecx
	subl	%edx, %ecx
	movl	%ecx, %edx
	movl	-24(%ebp), %eax
	imull	%edx, %eax
	movl	%eax, -24(%ebp)
	addb	$1, -7(%ebp)
.L11:
	movzbl	-7(%ebp), %eax
	cmpb	-5(%ebp), %al
	jb	.L12
	movl	-36(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-48(%ebp)
	movl	%edx, -64(%ebp)
	movl	-36(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-48(%ebp)
	movl	%eax, -68(%ebp)
	addl	$112, %esp
	popl	%ecx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)"
	.section	.note.GNU-stack,"",@progbits
