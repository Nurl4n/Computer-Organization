.data
	hexNo: .space 20
	userInput: .asciiz "Please enter the hexadecimal number that you want to conver to decimal: "
	invalidHexNo: .asciiz "You have entered an invalid hexadecimal number, please enter a valid number to convert. \n"
	endl: "\n"

.text
	main:
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		
		input:		
			li $v0, 4
			la $a0, userInput
			syscall
		
			li $v0, 8
			la $a0, hexNo
			li $a1, 9           # User can enter at max length of 8 string
			syscall
			
			addi $t2, $zero, 0	  # Beginning length of string hexNo
			# To find how long is the string
			size:
				lb $t0, 0($a0)
				beq $t0, '\0', exitSize
				addi $t2, $t2, 1
				addi $a0, $a0, 1
				j  size
			exitSize:
				addi $t2, $t2, -1
				move $t1, $t2
			
			#----------------------Checking validity------------------#
			la $s0, hexNo   # save hexNo in $s0
			checkValidity:
				lb $t0, 0($s0)
				beq $t0, '\0', exitValidity
				
				slti $t7, $t0, 103
				bne $t7, 1, invalid
				
				addi $s0, $s0, 1
				j checkValidity
				
			exitValidity:
				j continue
				
			invalid:
				la $a0, invalidHexNo
				li $v0, 4
				syscall
				j input
			
		continue:
			la $a0, hexNo            # To save beginning address of string hexNo
			addi $t9, $zero, 0	  # Saving the sum
		
			jal ConvertToDec
			
			move $a0, $t9
			li $v0, 1
			syscall
			
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			
	
	# stopping execution
	li $v0, 10
	syscall
		
	ConvertToDec:
		# Checking if reading string is finished or not
		beq $t1, 0, exitConvertToDec
		lb $t0, 0($a0)
		# Keeps track of how many times to multiply with 16 in order to convert hexno to decimal
		addi $t4, $t2, -1
		# Checking if the register $t0 is number or letter
		slti $t3, $t0, 58
		# $t0 keeps assci code of hexno, so decreasing by 48 gives us the hexno itself
		beq $t3, 0, letter
		addi $t0, $t0, -48
		j oparateForNumber
		# $t0 keeps assci code of hexno, so decreasing by 87 gives us the hexno itself represented by letter
		letter:
			addi $t0, $t0, -87
			j operateForLetter
		
		oparateForNumber:
			beq $t4, 0, exitOparateForNumber
			mul $t0, $t0, 16
			
			addi $t4, $t4, -1
			j oparateForNumber
			
		exitOparateForNumber:
			j repeat
		
		operateForLetter:
			beq $t4, 0, exitOparateForLetter
			mul $t0, $t0, 16
			
			addi $t4, $t4, -1
			j operateForLetter
			
		exitOparateForLetter:
			j repeat
			
		repeat:
			addi $a0, $a0, 1   # Increasing 1 byte, to take next element of string hexNo
			addi $t1, $t1, -1
			add $t9, $t9, $t0  # Keeping the sum by adding $t0 to $t9
			addi $t2, $t2, -1  # Decreasing the size after each iteration on the string 
			j ConvertToDec
		
	exitConvertToDec:
		jr $ra
