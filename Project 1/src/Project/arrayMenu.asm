.data
	myArray: .space 400
	messageSize: .asciiz "Enter the number of elements: "
	messageValue: .asciiz "Enter the value(s): "
	messageChoose: .asciiz "Choose one of the options above: "
	summationGTIN: .asciiz "1. Find summation of numbers stored in the array which is greater than an input number. \n"
	summationEO: .asciiz "2. Find summation of even and odd numbers and display them.\n"
	occurencesDCIN: .asciiz "3. Display the number of occurrences of the array elements divisible by a certain input number.\n"
	sum: .asciiz "The sum is: "
	sumEven: .asciiz "The sum of even numbers is: "
	sumOdd: .asciiz "The sum of odd numbers is: "
	numOfOccur: .asciiz "The number of occurences is: "
	quit: .asciiz "4. Quit\n"
	userInput: .asciiz "Enter the input: "
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
	
		# Number to control whileToCreate loop
		addi $t1, $v0, 0
		mul $t1, $t1, 4
	
		#li $v0, 4
		#la $a0, newLine
		#syscall
		
		# Number to control indexes of the array
		addi $t0, $zero, 0
		
		#Jumps to the function which asks the user for inputs
		jal whileToCreate
		
		####addi $t0, $zero, 0
		#####jal whileToPrint
		
		whileForUser:
					
			# 1st choice
			li $v0, 4
			la $a0, summationGTIN
			syscall
			
			# 2nd choice
			li $v0, 4
			la $a0, summationEO
			syscall
			
			# 3rd choice
			li $v0, 4
			la $a0, occurencesDCIN
			syscall
			
			# 4th choice
			li $v0, 4
			la $a0, quit
			syscall
			
			# Print the user to choose 
			li $v0, 4
			la $a0, messageChoose
			syscall
			
			# Prints options to choose for users
			li $v0, 5
			syscall
			# Save the chosen option to $t2
			move $t2, $v0
			
			# $t2 is used for keeping what user chose from the menu
			beq $t2, 1, option1
			beq $t2, 2, option2
			beq $t2, 3, option3
			beq $t2, 4, exitUserLoop
			
			option1:
				# Prints the user for the input number
				li $v0, 4
				la $a0, userInput
				syscall
				
				# Asks to the user for the input
				li $v0, 5
				syscall
				
				# $t3 keeps the input eneterd by user
				move $t3, $v0
							
				# register to keep the sum
				addi $s1, $zero, 0
				addi $sp, $sp, -4
				sw $s1, 0($sp)
				
				# initialize array index to 0
				addi $t0, $zero, 0
				whileToSum:
					beq $t0, $t1, exitWileToSum
					# Compare and sum up
					# if $t3 < myArray($t0) $s2 = 1
					# if $s2 == 1 $s1 += myArray($t0)
					lw $t4, myArray($t0)
					slt $s2, $t3, $t4
					beq $s2, 0, goLoop
					add $s1, $s1,$t4
					addi $t0, $t0, 4
					j whileToSum
					
					goLoop:
						addi $t0, $t0, 4
						j whileToSum
				exitWileToSum:
					# Prints the expected sum
					li $v0, 4
					la $a0, sum
					syscall	
					li $v0, 1
					addi $a0, $s1, 0
					syscall
					li $v0, 4
					la $a0, newLine
					syscall
					# Initializes $t0 to 0
					addi $t0, $zero, 0
					# Loads previos value of $s0 back
					lw $s1, 0($sp)
					# deallcoates memory
					addi $sp, $sp, 4
					
					j whileForUser
			
			option2:	
				# register to keep the sums
				addi $s1, $zero, 0
				addi $s2, $zero, 0
				addi $s3, $zero, 0
				addi $sp, $sp, -12
				sw $s1, 0($sp)
				sw $s2, 4($sp)
				sw $s3, 8($sp)
				addi $s3, $zero, 2
				# Initializes $t0 to 0
				addi $t0, $zero, 0
				whileToSumEO:
					beq $t0, $t1, exitWileToSumEO
					# Check and sum up
					# if $t4 / 2 => hi = 0 even 
					# if $t4 / 2 => hi = 1 odd
					lw $t4, myArray($t0)
					div $t4, $s3
					mfhi $s4
					beq $s4, 1, odd #bne $s4, 0, odd
					add $s1, $s1, $t4
					addi $t0, $t0, 4
					j whileToSumEO
					
					odd:
						add $s2, $s2, $t4
						addi $t0, $t0, 4
					j whileToSumEO
					
				exitWileToSumEO:
					# Prints the sum of even numbers
					li $v0, 4
					la $a0, sumEven
					syscall	
					li $v0, 1
					addi $a0, $s1, 0
					syscall
					li $v0, 4
					la $a0, newLine
					syscall
					# Prints the sum of odd numbers
					li $v0, 4
					la $a0, sumOdd
					syscall	
					li $v0, 1
					addi $a0, $s2, 0
					syscall
					li $v0, 4
					la $a0, newLine
					syscall
					# Initializes $t0 to 0
					addi $t0, $zero, 0
					# Loads previos value of $s0 back
					lw $s1, 0($sp)
					lw $s2, 4($sp)
					lw $s3, 8($sp)
					# deallcoates memory
					addi $sp, $sp, 12
					
					j whileForUser
			option3:
				# Prints the user for the input number
				li $v0, 4
				la $a0, userInput
				syscall
				
				# Asks to the user for the input
				li $v0, 5
				syscall
				
				# $t3 keeps the input eneterd by user
				move $s3, $v0
							
				# register to keep the number of occurences
				addi $s1, $zero, 0
				addi $s4, $zero, 0
				addi $sp, $sp, -8
				sw $s1, 0($sp)
				sw $s4, 4($sp)
				
				# initialize array index to 0
				addi $t0, $zero, 0
				
				whileToFindOccur:
					beq $t0, $t1, exitWileToFindOccur
					# Divide and sum up
					lw $t4, myArray($t0)
					div $t4, $s3
					mfhi $s4
					bne $s4, 0, goLoopFind
					addi $s1, $s1, 1
					addi $t0, $t0, 4
					j whileToFindOccur
					
					goLoopFind:
						addi $t0, $t0, 4
						j whileToFindOccur
				exitWileToFindOccur:
					# Prints the expected sum
					li $v0, 4
					la $a0, numOfOccur
					syscall	
					li $v0, 1
					addi $a0, $s1, 0
					syscall
					li $v0, 4
					la $a0, newLine
					syscall
					# Initializes $t0 to 0
					addi $t0, $zero, 0
					# Loads previos value of $s0 back
					lw $s1, 0($sp)
					lw $s4, 4($sp)
					# deallcoates memory
					addi $sp, $sp, 8
					
					j whileForUser
		exitUserLoop:
	
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
	
	# Find summation of numbers stored in the array which is greater than an input number.
	#summation:
