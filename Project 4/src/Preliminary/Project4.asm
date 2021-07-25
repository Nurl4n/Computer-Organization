.data
	message1: .asciiz "\n1. Enter the size of the matrix (N): "
	message2: .asciiz "\n2. Allocate array."
	message3: .asciiz "\n3. Enter the matrix element to be accessed: "
	message4: .asciiz "\n4. Summation of matrix elements row-major: "
	message5: .asciiz "\n5. Summation of matrix elements column-major: "
	message6: .asciiz "\n6. Display row and column member of this value: "
	quit: .asciiz "\n7. Quit"
	messageChoose: .asciiz "\nChoose one of the options above: "
	enterSize: .asciiz "\nEnter the size of the matrix: "
	arrayAllocated: .asciiz "\Array has been allocated with its proper size.\n"
	enterRowNo: .asciiz "\nEnter row number: " 
	enterColumnNo: .asciiz "\nEnter column number: "
	content: .asciiz "\nThe content is: "
	rowSummations: .asciiz "\Row summations are:\n"
	columnSummations: .asciiz "\Column summations are:\n"
	enterElement: .asciiz "\nEnter element that is in the matrix: "
	
	space: .asciiz " "
	endl: .asciiz "\n"
	
	# $a1 keeps the dimension of matrix
	# $t0 as the length of array
	# $t1 used as the inputs of the array
	# $t2 used as option number user chosed
	# $s0, $s1 keeps the address of the array
	# $s2 row no entered by the user
	# $s3 column no entered by the user
	# $s4 element entered by the user
	
.text
	main:
		#-------------------Calls----------------------#
		
		# 1st choice
		li $v0, 4
		la $a0, message1
		syscall
		
		# 2nd choice
		li $v0, 4
		la $a0, message2
		syscall
		
		# 3rd choice
		li $v0, 4
		la $a0, message3
		syscall
			
		# 4th choice
		li $v0, 4
		la $a0, message4
		syscall
			
		# 5th choice
		li $v0, 4
		la $a0, message5
		syscall
		
		# 6th choice
		li $v0, 4
		la $a0, message6
		syscall
		
		# 7th choice
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
		beq $t2, 4, option4
		beq $t2, 5, option5
		beq $t2, 6, option6
		j exitMain
			
		option1:
			# Ask user to enter the size of the array
			li $v0, 4
			la $a0, enterSize
			syscall
			
			# User enters size
			li $v0, 5
			syscall
	
			# Keeps the size of the matrix
			move $a1, $v0
			# Goes back to options menu
			j main
		option2:
			# Keeps the size of the matrix in a temporary register $t0 (to control the loops)
			mul $t0, $a1, $a1
	
			# Creates new array
			move $a0, $t0
			li $v0, 9
			syscall
	
			# Strores matrix address in $a0
			move $a0, $v0
			
			# Strores array address in $s0
			move $s0, $v0
			move $s1, $v0
			
			# $t1 holds inputs to the array
			addi $t1, $0, 1
			jal initializeArray
			j main
		
		option3:
			# Print the user to choose 
			li $v0, 4
			la $a0, enterRowNo
			syscall
				
			# Row number entered by the user
			li $v0, 5
			syscall
			# Save the chosen row no to $s2
			move $s2, $v0
			
			# Print the user to choose 
			li $v0, 4
			la $a0, enterColumnNo
			syscall
				
			# Column number entered by the user
			li $v0, 5
			syscall
			# Save the chosen column no to $s3
			move $s3, $v0
		
			# jumps to calculate and display the content of the given matrix positions
			jal displayByRC
			
			j main
			
		option4:
			# Keeps number of rows in $t8
			move $t8, $a1
			
			# Print row summations
			li $v0, 4
			la $a0, rowSummations
			syscall
			
			# Finds the sum of the rows and prints
			jal rowSum
			
			j main
		
		option5:
			# Keeps number of rows in $t8
			move $t8, $a1
			
			# Print column summations 
			li $v0, 4
			la $a0, columnSummations
			syscall
			
			# Finds the sum of the rows and prints
			jal columnSum
			
			j main
			
		option6:
			# Message about asking user to enter the element
			li $v0, 4
			la $a0, enterElement
			syscall
			
			# Element entered by the user
			li $v0, 5
			syscall
			
			move $s4, $v0
			
			# Keeps number of rows in $t8, $t9
			li $t8, 1
			li $t9, 1
			addi $t4, $a1, 1
			addi $t5, $a1, 1
			j findElement
			
			j main
			
	exitMain:
			
	# End of execution
	li $v0, 10
	syscall
		
	initializeArray:
		beq $t0, 0, exitInitializeArray
	
		sw $t1, 0($s0)
		addi $s0, $s0, 4
		addi $t1, $t1, 1
		addi $t0, $t0, -1
		j initializeArray
	exitInitializeArray:
		mul $t0, $a1, $a1
		move $s0, $s1
		# Array allocated message
		li $v0, 4
		la $a0, arrayAllocated
		syscall
		
		jr $ra
	
	displayByRC:
		addi $t9, $s2, -1
		addi $t8, $s3, -1
		mul $t8, $t8, $a1
		add $t7, $t8, $t9
		loop:
			beq $t7, $0, exitLoop
			addi $s0, $s0, 4
			addi $t7, $t7, -1
			j loop
		exitLoop:
			lw $t7, 0($s0)
			
			# Print the content message
			li $v0, 4
			la $a0, content
			syscall
			# Print the content
			li $v0, 1
			move $a0, $t7
			syscall		
	exitDisplayByRC:
		move $s0, $s1
		jr $ra
	
	rowSum:
		beq $t8, $0, exitRowSum
		addi $t6, $0, 0
		move $t4, $a1
		loopRow:
			beq $t4, 0, exitLoopRow
			lw $t7, 0($s0)
			add $t6, $t6, $t7
			move $t5, $a1
			loopColumn:
				beq $t5, 0, exitLoopColumn
				addi $s0, $s0, 4
				addi $t5, $t5, -1
				j loopColumn
			exitLoopColumn:
				addi $t4, $t4, -1
				j loopRow
		exitLoopRow:
			# Print the row sum
			li $v0, 1
			move $a0, $t6
			syscall
			# Print end line
			li $v0, 4
			la $a0, endl
			syscall
			addi $t8, $t8, -1
			move $s0, $s1
			sub $t9, $a1, $t8
			loopNextRow:
				beq $t9, 0, exitLoopNextRow
				addi $s0, $s0, 4
				addi $t9, $t9, -1
				j loopNextRow
			exitLoopNextRow:
				j rowSum
	exitRowSum:
		move $s0, $s1
		jr $ra
	
	columnSum:
		beq $t8, $0, exitColumnSum
		addi $t6, $0, 0
		move $t4, $a1
		loopColumnIn:
			beq $t4, 0, exitLoopColumnIn
			lw $t7, 0($s0)
			add $t6, $t6, $t7
			addi $t4, $t4, -1
			addi $s0, $s0, 4
			j loopColumnIn
		exitLoopColumnIn:
			# Print the row sum
			li $v0, 1
			move $a0, $t6
			syscall
			# Print end line
			li $v0, 4
			la $a0, endl
			syscall
			#addi $s0, $s0, 4
			addi $t8, $t8, -1
			j columnSum
	exitColumnSum:
		move $s0, $s1
		jr $ra
	
	
	findElement:
		beq $t8, $t4, exitFindElement
		li $t9, 1
		loopFindElement:
			beq $t9, $t4, exitLoopFindElement
			lw $t7, 0($s0)
			beq $t7, $s4, foundElement
			addi $t9, $t9, 1
			addi $s0, $s0, 4
			j loopFindElement
		exitLoopFindElement:
			addi $t8, $t8, 1
			j findElement
	exitFindElement:
		move $s0, $s1
		jr $ra
	foundElement:
		# Print the row
		li $v0, 1
		move $a0, $t9
		syscall
		# Print end line
		li $v0, 4
		la $a0, space
		syscall
		# Print the column
		li $v0, 1
		move $a0, $t8
		syscall
		move $s0, $s1
		jr $ra