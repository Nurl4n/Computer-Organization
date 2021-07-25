##
##	Program3.asm is a loop implementation
##	of the Fibonacci function
##        

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
.globl __start
 
__start:			# execution starts here
	li $a0,7		# to calculate fib(7)
	jal fib		# call fib
	
	# li $v0, 1  # $v1 gets 1 here, and it was moved to $a0 so the result was 1 always, but insted $t1 should have been moved to $a0 as a sum of nth term of fib
	move $a0,$v0 #t1	# print result 
	li $v0, 1
	syscall
	
	li $v0,4
	la $a0,endl		# print newline
	syscall

	li $v0,10
	syscall		# bye bye

#------------------------------------------------


fib:	move $v0,$a0	# initialize last element v0 = 7
	blt $a0,2,done	# fib(0)=0, fib(1)=1

	li $t0,0		# second last element
	li $v0,1		# last element

loop:	add $t1,$t0,$v0	# get next value
	move $t0,$v0	# update second last
	move $v0,$t1	# update last element
	sub $a0,$a0,1	# decrement count
	bgt $a0,1,loop	# exit loop when count=0 // should exit the loop when count is 1 not 0
done:	jr $ra

#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
endl:	.asciiz "\n"

##
## end of Program3.asm
