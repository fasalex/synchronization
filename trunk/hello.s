	.file	"hello.c"
	.section	.rodata
	.align 8
.LC4:
	.long	-1717986918
	.long	1071225241
	.align 8
.LC5:
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
	subl	$184, %esp
	movl	$2, -108(%ebp)
	movl	$10, -104(%ebp)
	movb	$8, -9(%ebp)
	cmpb	$2, -9(%ebp)
	ja	.L2
	movl	-116(%ebp), %eax
	movl	%eax, -124(%ebp)
	jmp	.L4
.L2:
	movb	$1, -11(%ebp)
	jmp	.L5
.L6:
	movzbl	-9(%ebp), %eax
	subl	$1, %eax
	movb	%al, -10(%ebp)
	jmp	.L7
.L8:
	cmpl	$0, -116(%ebp)
	jle	.L9
	movl	$2, -112(%ebp)
.L9:
	subb	$1, -10(%ebp)
.L7:
	movzbl	-10(%ebp), %eax
	cmpb	-11(%ebp), %al
	ja	.L8
	addb	$1, -11(%ebp)
.L5:
	movzbl	-11(%ebp), %eax
	cmpb	-9(%ebp), %al
	jb	.L6
	movl	-116(%ebp), %eax
	movl	%eax, -124(%ebp)
.L4:
	movl	-124(%ebp), %eax
	imull	-104(%ebp), %eax
	addl	-120(%ebp), %eax
	movl	%eax, -100(%ebp)
	movl	-120(%ebp), %eax
	addl	%eax, -100(%ebp)
	movl	-100(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-104(%ebp)
	movl	%eax, -124(%ebp)
	movl	-100(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-104(%ebp)
	movl	%edx, -120(%ebp)
	cmpb	$1, -9(%ebp)
	jbe	.L13
	movb	$1, -11(%ebp)
	jmp	.L15
.L16:
	movzbl	-9(%ebp), %eax
	subl	$1, %eax
	movb	%al, -10(%ebp)
	jmp	.L17
.L18:
	cmpl	$0, -116(%ebp)
	jle	.L19
	movl	$2, -112(%ebp)
.L19:
	subb	$1, -10(%ebp)
.L17:
	movzbl	-10(%ebp), %eax
	cmpb	-11(%ebp), %al
	ja	.L18
	addb	$1, -11(%ebp)
.L15:
	movzbl	-11(%ebp), %eax
	cmpb	-9(%ebp), %al
	jb	.L16
.L13:
	movl	$0, -92(%ebp)
	movl	$1, -80(%ebp)
	movl	$10, -72(%ebp)
	movl	$1, -84(%ebp)
	movl	$1, -68(%ebp)
	movl	$1, -88(%ebp)
	movb	$0, -11(%ebp)
	jmp	.L22
.L23:
	movl	-116(%ebp), %eax
	imull	-104(%ebp), %eax
	addl	-120(%ebp), %eax
	movl	%eax, -96(%ebp)
	movl	-92(%ebp), %eax
	imull	-88(%ebp), %eax
	movl	%eax, -92(%ebp)
	movl	-88(%ebp), %eax
	imull	-80(%ebp), %eax
	imull	-88(%ebp), %eax
	addl	-72(%ebp), %eax
	movl	%eax, -80(%ebp)
	movl	-80(%ebp), %eax
	movl	%eax, %edx
	imull	-68(%ebp), %edx
	movl	-68(%ebp), %eax
	imull	-80(%ebp), %eax
	imull	-68(%ebp), %eax
	addl	-84(%ebp), %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	%ecx
	movl	%eax, -76(%ebp)
	movl	-68(%ebp), %eax
	movl	%eax, %edx
	imull	-92(%ebp), %edx
	movl	-96(%ebp), %eax
	subl	%edx, %eax
	imull	-76(%ebp), %eax
	addl	%eax, -92(%ebp)
	movl	-76(%ebp), %eax
	movl	%eax, %edx
	imull	-68(%ebp), %edx
	movl	$1, %eax
	movl	%eax, %ebx
	subl	%edx, %ebx
	movl	%ebx, %edx
	movl	-80(%ebp), %eax
	imull	%edx, %eax
	movl	%eax, -80(%ebp)
	addb	$1, -11(%ebp)
.L22:
	movzbl	-11(%ebp), %eax
	cmpb	-9(%ebp), %al
	jb	.L23
	movl	-92(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-104(%ebp)
	movl	%edx, -120(%ebp)
	movl	-92(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-104(%ebp)
	movl	%eax, -124(%ebp)
	movl	$0, -64(%ebp)
	movl	$0, -56(%ebp)
	movb	$0, -11(%ebp)
	fnstcw	-186(%ebp)
	movzwl	-186(%ebp), %eax
	movb	$12, %ah
	movw	%ax, -188(%ebp)
	jmp	.L25
.L26:
	movzbl	-11(%ebp), %ecx
	movl	-116(%ebp), %eax
	imull	-104(%ebp), %eax
	addl	-120(%ebp), %eax
	movl	%eax, %edx
	sarl	$31, %edx
	xorl	%edx, %eax
	subl	%edx, %eax
	movl	%eax, -184(%ebp,%ecx,4)
	movzbl	-11(%ebp), %eax
	movl	-184(%ebp,%eax,4), %eax
	cmpl	$8, %eax
	jg	.L27
	movl	$0x3f4ccccd, %eax
	movl	%eax, -52(%ebp)
	jmp	.L29
.L27:
	movzbl	-11(%ebp), %eax
	movl	-184(%ebp,%eax,4), %eax
	cmpl	$17, %eax
	jg	.L30
	movl	$0x3e99999a, %eax
	movl	%eax, -52(%ebp)
	jmp	.L29
.L30:
	movzbl	-11(%ebp), %eax
	movl	-184(%ebp,%eax,4), %eax
	cmpl	$26, %eax
	jg	.L32
	movl	$0x3dcccccd, %eax
	movl	%eax, -52(%ebp)
	jmp	.L29
.L32:
	movl	$0x3f000000, %eax
	movl	%eax, -52(%ebp)
.L29:
	movzbl	-11(%ebp), %edx
	movzbl	-11(%ebp), %eax
	movl	-184(%ebp,%eax,4), %eax
	pushl	%eax
	fildl	(%esp)
	leal	4(%esp), %esp
	fmuls	-52(%ebp)
	fldcw	-188(%ebp)
	fistpl	-192(%ebp)
	fldcw	-186(%ebp)
	movl	-192(%ebp), %eax
	movl	%eax, -184(%ebp,%edx,4)
	movzbl	-11(%ebp), %eax
	movl	-184(%ebp,%eax,4), %eax
	addl	%eax, -56(%ebp)
	addb	$1, -11(%ebp)
.L25:
	movzbl	-11(%ebp), %eax
	cmpb	-9(%ebp), %al
	jb	.L26
	movzbl	-9(%ebp), %eax
	subl	$1, %eax
	imull	-56(%ebp), %eax
	movl	%eax, -60(%ebp)
	movb	$0, -11(%ebp)
	jmp	.L35
.L36:
	cmpl	$0, -60(%ebp)
	je	.L37
	movzbl	-11(%ebp), %ecx
	movzbl	-11(%ebp), %eax
	movl	-184(%ebp,%eax,4), %edx
	movl	-56(%ebp), %eax
	movl	%eax, %ebx
	subl	%edx, %ebx
	movl	%ebx, %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-60(%ebp)
	movl	%eax, -144(%ebp,%ecx,4)
	jmp	.L39
.L37:
	movzbl	-11(%ebp), %eax
	movl	$0, -144(%ebp,%eax,4)
.L39:
	movzbl	-11(%ebp), %eax
	movl	-184(%ebp,%eax,4), %edx
	movzbl	-11(%ebp), %eax
	movl	-144(%ebp,%eax,4), %eax
	imull	%edx, %eax
	addl	%eax, -64(%ebp)
	addb	$1, -11(%ebp)
.L35:
	movzbl	-11(%ebp), %eax
	cmpb	-9(%ebp), %al
	jb	.L36
	movl	-64(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-104(%ebp)
	movl	%edx, -120(%ebp)
	movl	-64(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-104(%ebp)
	movl	%eax, -124(%ebp)
	movl	$0, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	$0, -40(%ebp)
	movl	$0, -36(%ebp)
	movl	$1, -32(%ebp)
	movl	$0, -28(%ebp)
	jmp	.L41
.L42:
	movl	-28(%ebp), %edx
	movl	-116(%ebp), %eax
	imull	-104(%ebp), %eax
	addl	-120(%ebp), %eax
	movl	%eax, -184(%ebp,%edx,4)
	movl	-28(%ebp), %eax
	movl	-184(%ebp,%eax,4), %eax
	addl	$1, %eax
	addl	%eax, -36(%ebp)
	fildl	-48(%ebp)
	fildl	-28(%ebp)
	fldl	.LC4
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fldcw	-188(%ebp)
	fistpl	-48(%ebp)
	fldcw	-186(%ebp)
	fildl	-44(%ebp)
	fildl	-28(%ebp)
	fldl	.LC5
	fmulp	%st, %st(1)
	fildl	-28(%ebp)
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fldcw	-188(%ebp)
	fistpl	-44(%ebp)
	fldcw	-186(%ebp)
	fildl	-40(%ebp)
	movl	-28(%ebp), %eax
	movl	-184(%ebp,%eax,4), %eax
	addl	-32(%ebp), %eax
	pushl	%eax
	fildl	(%esp)
	leal	4(%esp), %esp
	fldl	.LC4
	fmulp	%st, %st(1)
	fildl	-28(%ebp)
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fldcw	-188(%ebp)
	fistpl	-40(%ebp)
	fldcw	-186(%ebp)
	addl	$1, -28(%ebp)
.L41:
	movzbl	-9(%ebp), %eax
	cmpl	-28(%ebp), %eax
	jg	.L42
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
	fldl	.LC4
	fmulp	%st, %st(1)
	movzbl	-9(%ebp), %eax
	shrb	%al
	movzbl	%al, %eax
	pushl	%eax
	fildl	(%esp)
	leal	4(%esp), %esp
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fldcw	-188(%ebp)
	fistpl	-16(%ebp)
	fldcw	-186(%ebp)
	movl	-60(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-104(%ebp)
	movl	%edx, -120(%ebp)
	movl	-60(%ebp), %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-104(%ebp)
	movl	%eax, -124(%ebp)
	addl	$184, %esp
	popl	%ecx
	popl	%ebx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)"
	.section	.note.GNU-stack,"",@progbits
