.data
	hexNo: .asciiz "14"
	invalidHexNo: .asciiz "You have entered invalid hexadecimal number."

.text
	main:
		#li $s0, 0x10010000
		la $a0, hexNo            # To save beginning address of string hexNo
		addi $t2, $zero, 0	  # Beginning length of string hexNo
		size:
			lb $t0, 0($a0)
			beq $t0, '\0', exitSize
			addi $t2, $t2, 1
			addi $a0, $a0, 1
			j  size
		exitSize:
		
		la $a0, hexNo
		addi $t9, $zero, 0	  # Saving the sum
		
		jal ConvertToDec
			
		move $a0, $t9
		li $v0, 1
		syscall
			
	stopExecution:
		li $v0, 10
		syscall
		
	ConvertToDec:
		lb $t0, 0($a0)
		# Checking if reading string is finished or not
		beq $t0, '\0', exitConvertToDec
		# Checking if input is valid hexNo
		slti $t3, $t0, 103
		bne $t3, 1, invalid
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
			add $t9, $t9, $t0  # Keeping the sum by adding $t0 to $t9
			addi $t2, $t2, -1  # Decreasing the size after each iteration on the string 
			j ConvertToDec
		
		invalid:
			la $a0, invalidHexNo
			li $v0, 4
			syscall
			j stopExecution
		
	exitConvertToDec:
		jr $ra
