.data
	myArray: .space 400
	messageChoose: .asciiz "\nChoose one of the options above: "
	sortMessage: .asciiz "\n\n1. Sort the array"
	secndMinSecndMaxMessage: .asciiz "\n2. Find 2nd minimum and 2nd maximum numbers"
	medianMessage: .asciiz "\n3. Find median of the array"
	quit: .asciiz "\n4. Quit"
	enterSize: .asciiz "Enter the length of the array: "
	enterInput: .asciiz "Enter the value(s): "
	beforeSorted: .asciiz "(Before Sorted) -> The element(s) of the array: "
	afterSorted: .asciiz "\n(After Sorted) -> The element(s) of the array: "
	secondMin: .asciiz "\nSecond min value is: "
	secondMax: .asciiz "\nSecond max value is: "
	median: .asciiz "\nMedian of the array is: "
	notEnoughElement: .asciiz "\nThe number of the elments in the array is less than 4, so cannot choose 2nd max and 2nd min values."
	
	space: .asciiz " "
	endl: .asciiz "\n"

.text
	main:
		li $v0, 4
		la $a0, enterSize
		syscall
	
		li $v0, 5
		syscall
	
		# Keeps the length of the array
		move $a1, $v0
	
		# Keeps the length of the array in a temporary register $t0 (to control the loops)
		move $t0, $a1
	
		# Creates new array
		move $a0, $a1
		li $v0, 9
		syscall
	
		# Strores array address in $a0
		move $a0, $v0
	
		# Strores array address in $s0
		move $s0, $a0
		# Stores array address in $s1
		move $s1, $a0
		
		# jumps to get inputs from the user and save them in array
		jal initializeArray
		# Prints message
		li $v0, 4
		la $a0, beforeSorted
		syscall
		# Prints the element(s) of the array
		jal printArray
		
		#-------------------Calls----------------------#
		whileForUser:
			# 1st choice
			li $v0, 4
			la $a0, sortMessage
			syscall
			
			# 2nd choice
			li $v0, 4
			la $a0, secndMinSecndMaxMessage
			syscall
			
			# 3rd choice
			li $v0, 4
			la $a0, medianMessage
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
			j exitWhileForUser
			
			option1:
				# Sorts the array
				jal bubbleSort
		
				# Prints message
				li $v0, 4
				la $a0, afterSorted
				syscall
			
				# Prints the element(s) of the array
				jal printArray
				
				# Goes back to options menu
				j whileForUser
			
			
			option2:
				# Strores array address in $s0
				jal SecMinSecMax
				
				# Goes back to options menu
				j whileForUser	
				
				
			option3:
				# Finding Median
				li $v0, 4
				la $a0, median
				syscall
			
				jal findMedian
			
				move $s3, $v1
			
				li $v0, 1
				move $a0, $s3
				syscall
				
				# Goes back to options menu
				j whileForUser	
				
				
		exitWhileForUser:
			
	# End of execution
	li $v0, 10
	syscall
		
	initializeArray:
		beq $t0, 0, exitInitializeArray
		li $v0, 4
		la $a0, enterInput
		syscall
	
		li $v0, 5
		syscall
	
		sw $v0, 0($s0)
		addi $s0, $s0, 4
		addi $t0, $t0, -1
		j initializeArray
	exitInitializeArray:
		move $t0, $a1
		move $s0, $s1
		jr $ra
		
	printArray:
		beq $t0, 0, exitPrintArray
		li $v0, 1
		lw $a0, 0($s0)
		syscall
	
		li $v0, 4
		la $a0, space
		syscall
		
		addi $s0, $s0, 4
		addi $t0, $t0, -1
		
		j printArray
	exitPrintArray:
		move $s0, $s1
		move $t0, $a1
		jr $ra

	bubbleSort:
		li $t1, 1
		sort:
			# Checks if we reached to the end of array
			beq $t1, $t0, exitBubbleSort
			# Strores array address in $s0
			move $s0, $s1
			# Keeps index of the array
			li $t2, 0
			# How many times to iterate
			sub $t4, $t0, $t1
			#addi $t4, $t4, 1
			loopToCompare:
				beq $t2, $t4, exitLoopToCompare
				lw $t8, 0($s0)
				lw $t9, 4($s0)
				slt $t5, $t9, $t8
				beq $t5, 1, swap
				
				addi $t2, $t2, 1
				addi $s0, $s0, 4
				j loopToCompare
				
				swap:				
					sw $t9, 0($s0)
					sw $t8, 4($s0)
				endSwap:
					addi $t2, $t2, 1
					addi $s0, $s0, 4
					j loopToCompare
		
			exitLoopToCompare:
				addi $t1, $t1, 1
				j sort
	exitBubbleSort:
		# Restore the length of array to $t0
		move $t0, $a1
		addi $t1, $zero, 1
		# Strores array address in $s0
		move $s0, $s1
		jr $ra
	
	SecMinSecMax:
		# Saving last address of $ra in stack
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		# Checks if there are enough number of elements
		slti $t5, $t0, 4
		bne $t5, 1, continue
		li $v0, 4
		la $a0, notEnoughElement
		syscall
		j exitSecMinSecMax
			
		continue:
			jal bubbleSort
			
			# To take secondMin element
			addi $s0, $s0, 4
			lw $v0, 0($s0)
				
			addi $t4, $t0, -3		
			loop:
				beq $t4, 0, exit
				addi $s0, $s0, 4
				addi $t4, $t4, -1
				j loop
			exit:
				lw $v1, 0($s0)
			
			move $s3, $v0
		
			li $v0, 4
			la $a0, secondMin
			syscall
			
			move $a0, $s3
			li $v0, 1
			syscall
			
			li $v0, 4
			la $a0, secondMax
			syscall
			
			# Puts second min value from $v1 to $a0 and prints it
			move $a0, $v1
			li $v0, 1
			syscall
	exitSecMinSecMax:
		li $v1, 0
		move $s0, $s1
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra


	findMedian:
		# Saving last address of $ra in stack
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal bubbleSort
		
		move $t5, $t0
		sra $t5, $t5, 1
		
		# Check if length is odd or even
		li $t7, 2
		div $t0, $t7
		mfhi $t6
		bne $t6, 0, next
		addi $t5, $t5, -1
		next:
			move $t0, $a1
		goToMedian:
			beq $t5, 0 exitFindMedian
			addi $s0, $s0, 4
			addi $t5, $t5, -1
			j goToMedian
		
	exitFindMedian:
		
		lw $v1, 0($s0)
		move $s0, $s1
		li $t5, 0
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
