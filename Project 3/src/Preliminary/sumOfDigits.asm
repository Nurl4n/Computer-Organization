.data
	enterNum: .asciiz "Please enter a positive number: "
	summation: .asciiz "The summation of the digits of a positive integer is: "
.text
	main:
		li $v0, 4
		la $a0, enterNum
		syscall
		
		li $v0, 5
		syscall
		move $s1, $v0		# Integer saved in $t0
		
		addi $sp, $sp, -8
		sw $s1, 0($sp)		# The sum will be saved in $s0
		sw $s0, 4($sp)
		
		jal sumOfDigits
		
		li $v0, 4
		la $a0, summation
		syscall
		
		li $v0, 1
		move $a0, $s0
		syscall
		
		lw $s1, 0($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		
	# Stop execution
	li $v0, 10
	syscall
	
	sumOfDigits:
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		
		div $t0, $s1, 10
		bne $t0, 0, else
		
		## if 1 digit return itself
		move $s0, $s1
		addi $sp, $sp, 8
		jr $ra
		
		
	else:
		li $t0, 10
		div $s1, $t1		# dviding by 10, sets $hi to remainder
		mfhi $t2		# remainder saved in $t2
		sw $t2, 4($sp)		# $t2 saved in stack
		div $s1, $s1, 10	# $a0 divided by 10 so we get 1 less digit integer
		jal sumOfDigits
		
		lw $t2, 4($sp)
		add $s0, $s0, $t2
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		jr $ra
		
		
		
		
		
		