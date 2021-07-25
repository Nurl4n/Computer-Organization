##
## Program1.asm - prints out "hello world"
##
##	a0 - points to the string
##




#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	str:	.asciiz "Hello, "
	#n:	.word	10
	name: .asciiz "Please enter your name: "
	userInput: .space 20
	#newLine: .asciiz "\n"

##
## end of file Program1.asm


#################################
#					 	#
#		text segment		#
#						#
#################################

.text		
.globl __start
	__start:
		li $v0, 4
		la $a0, name
		syscall
		
		li $v0,8
		la $a0, userInput
		li $a1, 21  # User can enter at max length of 10 string
		syscall
	
		li $v0,4	# system call to print
		la $a0,str	# put string address into a0
		syscall	#   out a string
		
		li $v0, 4
		la $a0, userInput
		syscall
	
	
	li $v0,10  # system call to exit
	syscall	#    bye bye


