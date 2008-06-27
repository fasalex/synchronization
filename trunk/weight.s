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
	pushl	%ebx
	pushl	%ecx
	subl	$120, %esp
	movl	$2, -44(%ebp)
	movl	$10, -40(%ebp)
	movb	$8, -9(%ebp)
	movl	$0, -28(%ebp)
	movl	$0, -20(%ebp)
	movb	$0, -11(%ebp)
	jmp	.L2
.L3:
	movzbl	-11(%ebp), %ecx
	movl	-52(%ebp), %eax
	imull	-40(%ebp), %eax
	addl	-56(%ebp), %eax
	movl	%eax, %edx
	sarl	$31, %edx
	xorl	%edx, %eax
	subl	%edx, %eax
	movl	%eax, -120(%ebp,%ecx,4)
	movzbl	-11(%ebp), %eax
	movl	-120(%ebp,%eax,4), %eax
	cmpl	$8, %eax
	jg	.L4
	movl	$0x3f4ccccd, %eax
	movl	%eax, -16(%ebp)
	jmp	.L6
.L4:
	movzbl	-11(%ebp), %eax
	movl	-120(%ebp,%eax,4), %eax
	cmpl	$17, %eax
	jg	.L7
	movl	$0x3e99999a, %eax
	movl	%eax, -16(%ebp)
	jmp	.L6
.L7:
	movzbl	-11(%ebp), %eax
	movl	-120(%ebp,%eax,4), %eax
	cmpl	$26, %eax
	jg	.L9
	movl	$0x3dcccccd, %eax
	movl	%eax, -16(%ebp)
	jmp	.L6
.L9:
	movl	$0x3f000000, %eax
	movl	%eax, -16(%ebp)
.L6:
	movzbl	-11(%ebp), %edx
	movzbl	-11(%ebp), %eax
	movl	-120(%ebp,%eax,4), %eax
	pushl	%eax
	fildl	(%esp)
	leal	4(%esp), %esp
	fmuls	-16(%ebp)
	fnstcw	-122(%ebp)
	movzwl	-122(%ebp), %eax
	movb	$12, %ah
	movw	%ax, -124(%ebp)
	fldcw	-124(%ebp)
	fistpl	-128(%ebp)
	fldcw	-122(%ebp)
	movl	-128(%ebp), %eax
	movl	%eax, -120(%ebp,%edx,4)
	movzbl	-11(%ebp), %eax
	movl	-120(%ebp,%eax,4), %eax
	addl	%eax, -20(%ebp)
	addb	$1, -11(%ebp)
.L2:
	movzbl	-11(%ebp), %eax
	cmpb	-9(%ebp), %al
	jb	.L3
	movzbl	-9(%ebp), %eax
	subl	$1, %eax
	imull	-20(%ebp), %eax
	movl	%eax, -24(%ebp)
	movb	$0, -11(%ebp)
	jmp	.L12
.L13:
	cmpl	$0, -24(%ebp)
	je	.L14
	movzbl	-11(%ebp), %ecx
	movzbl	-11(%ebp), %eax
	movl	-120(%ebp,%eax,4), %edx
	movl	-20(%ebp), %eax
	movl	%eax, %ebx
	subl	%edx, %ebx
	movl	%ebx, %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-24(%ebp)
	movl	%eax, -80(%ebp,%ecx,4)
	jmp	.L16
.L14:
	movzbl	-11(%ebp), %eax
	movl	$0, -80(%ebp,%eax,4)
.L16:
	movzbl	-11(%ebp), %eax
	movl	-120(%ebp,%eax,4), %edx
	movzbl	-11(%ebp), %eax
	movl	-80(%ebp,%eax,4), %eax
	imull	%edx, %eax
	addl	%eax, -28(%ebp)
	addb	$1, -11(%ebp)
.L12:
	movzbl	-11(%ebp), %eax
	cmpb	-9(%ebp), %al
	jb	.L13
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-40(%ebp)
	movl	%edx, -56(%ebp)
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-40(%ebp)
	movl	%eax, -60(%ebp)
	addl	$120, %esp
	popl	%ecx
	popl	%ebx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)"
	.section	.note.GNU-stack,"",@progbits
