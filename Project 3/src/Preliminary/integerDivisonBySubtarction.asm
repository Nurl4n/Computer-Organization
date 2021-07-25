.data
	enterDividend: .asciiz "Please enter the dividend (positive integer): "
	enterDivisor: .asciiz "Please enter the divisor (positive integer): "
	result:	.asciiz "Possible number of division is: "
	remainder: .asciiz "\nThe remainder is: "
	
.text
	main:
		li $v0, 4
		la $a0, enterDividend
		syscall
		
		li $v0, 5
		syscall
		move $t0, $v0 # dividend saved in $t0
		
		li $v0, 4
		la $a0, enterDivisor
		syscall
		
		li $v0, 5
		syscall
		move $t1, $v0	# divisor saved in $t1
		
		addi $sp, $sp, -4
		sw $s0, 0($sp)		# $s0 will be used to count how many times the dividend can be divided by divisor
		
		jal dvideRecBySub
		
		li $v0, 4
		la $a0, result
		syscall
		
		li $v0, 1
		move $a0, $s0
		syscall
		
		li $v0, 4
		la $a0, remainder
		syscall
		
		li $v0, 1
		move $a0, $a1
		syscall
		
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		
	# Stop execution
	li $v0, 10
	syscall
	
	dvideRecBySub:
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		slt $t3, $t0, $t1		# if dividend is less than divisor stop division
		beq $t3, 0, else
		
		move $a1, $t0			# remainder saved in $a0
		addi $sp, $sp, 4
		jr $ra
	
	else:
		sub $t0, $t0, $t1
		jal dvideRecBySub
		
		addi $s0, $s0, 1
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
		
		
		
	
	
