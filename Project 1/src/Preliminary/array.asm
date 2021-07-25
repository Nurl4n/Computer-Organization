.data
	myArray: .space 80
	reversedArray: .space 80
	messageSize: .asciiz "Enter the number of elements: "
	messageValue: .asciiz "Enter the value: "
	elementsOfArray: .asciiz "The element(s) of the array: "
	newLine: .asciiz "\n"
	space: .asciiz " "
.text
	main:
		li $v0, 4
		la $a0, messageSize
		syscall
	
		# Asks the user for the number of elements
		li $v0, 5
		syscall
	
		# Number to control while loop
		addi $t1, $v0, 0
		mul $t1, $t1, 4
	
		li $v0, 4
		la $a0, newLine
		syscall
		
		# Number to control indexes of the array
		addi $t0, $zero, 0
		
		#Jumps to the function which asks the user for inputs
		jal whileToCreate
		
		# Number to control indexes of the array
		addi $t0, $zero, 0
	
		li $v0, 4
		la $a0, elementsOfArray
		syscall
		
		#Jumps to the function which prints the array
		jal whileToPrint
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		# Index of reversed Array
		addi $t3, $zero, 0
		
		# Jumps to copy the array from back to end
		jal copyArray
		
		# Jumps to reverse the original array
		jal reverseArray
		
		# Index resetted
		addi $t0, $zero, 0
		
		li $v0, 4
		la $a0, elementsOfArray
		syscall
		
		#Jumps to the function which prints the array
		jal whileToPrint		
	
	li $v0, 10
	syscall
	
	# This procedure asks the user for array inputs and save them in the array
	whileToCreate:
		beq $t0, $t1, exitOfToCreate
		li $v0, 4
		la $a0, messageValue
		syscall
		
		# User enters a number
		li $v0, 5
		syscall
		# Saving value in another register
		addi $s0, $v0, 0
				
		# save the entered number to the array
		sw $s0, myArray($t0)
		
		# Resetting index of array
		addi $t0, $t0, 4
		
		j whileToCreate
	exitOfToCreate:
		jr $ra
	
	# This procedure prints the array
	whileToPrint:
		beq $t0, $t1, exitOfToPrint
		
		# Loading values to another temporary register to print
		lw $t2, myArray($t0)
		
		li $v0, 1
		addi $a0, $t2, 0
		syscall
		li $v0, 4
		la $a0, space
		syscall
		# Resetting index of array
		addi $t0, $t0, 4
		
		j whileToPrint
	exitOfToPrint:
		jr $ra
	
	# Copies the array backwards to the temporary array	
	copyArray:
		beq $t0, 0, exitCopy
		lw $t2, myArray($t3)
		move $s0, $t2
		sw $s0, reversedArray($t3)
		
		# Resetting indexes of arrays
		addi $t0, $t0, -4
		addi $t3, $t3, 4
		
		j copyArray		
	exitCopy:
		jr $ra 
	
		# Reverses the original array
	reverseArray:
		# We must decrement the value of $t3 beforhand, bcz after we ve incremented $t3 
		# it passes the last possible index of our array, so after decerement $t3 is gonna
		# give us the last index of the array in this procedure (function)
		addi $t3, $t3, -4
		beq $t0, $t1, exitReverse
		lw $t2, reversedArray($t3)
		move $s0, $t2
		sw $s0, myArray($t0)
		
		addi $t0, $t0, 4
		
		j reverseArray
	exitReverse:
		jr $ra