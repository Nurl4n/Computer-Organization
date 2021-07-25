.data
	x: .asciiz "Enter value for x: "
	y: .asciiz "Enter value for y: "
	endl: .asciiz "\n"
	result: "The result is: "
	
.text
	main:
	
		li $v0, 4
		la $a0, x
		syscall
	
		li $v0, 5
		syscall
		move $t0, $v0
	
		li $v0, 4
		la $a0, endl
		syscall
	
		li $v0, 4
		la $a0, y
		syscall
	
		li $v0, 5
		syscall
		move $t1, $v0
	
		li $v0, 4
		la $a0, endl
		syscall
		
		jal calculate
		
		li $v0, 4
		la $a0, result
		syscall
		
		li $v0, 1
		move $a0, $s0
		syscall
		
	# Execution stops
	li $v0, 10
	syscall
	
	calculate:
		sll $t0,$t0,1
		add $t0, $t0, $t1
		addi $t2, $zero, 4
		div $t0, $t2
		mfhi $s0
		
		jr $ra
		
		
