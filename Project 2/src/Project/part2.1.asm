.data
	enterSize: .asciiz "Enter the length of the array: "
	enterInput: .asciiz "Enter the value(s): "
	elements: .asciiz "The element(s) of array: "
	space: .asciiz " "

.text
	li $v0, 4
	la $a0, enterSize
	syscall
	
	li $v0, 5
	syscall
	# Keeps the length of the array
	move $v1, $v0
	
	# Keeps the length of the array in a temporary register $t0
	move $t0, $v1
	
	# Creates new array
	move $a0, $v1
	li $v0, 9
	syscall
	
	# Strores array address in $s0
	move $s0, $v0
	
	# Strores array address in $s1
	move $s1, $s0
	
	loop:
		beq $t0, 0, exitLoop
		li $v0, 4
		la $a0, enterInput
		syscall
		
		li $v0, 5
		syscall
		
		sw $v0, 0($s0)
		addi $s0, $s0, 4
		addi $t0, $t0, -1
		j loop
	exitLoop:
		move $t0, $v1
	
	li $v0, 4
	la $a0, elements
	syscall
	
	print:
		beq $t0, 0, exitPrint
		li $v0, 1
		lw $a0, 0($s1)
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		addi $s1, $s1, 4
		addi $t0, $t0, -1
		
		j print
	exitPrint:
