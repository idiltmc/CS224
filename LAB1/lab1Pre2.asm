##
## LAB1 Preleminary Work 2. ArithmeticExpression 
##  ?dil Atmaca 22002491 CS224-3

#					 	#
#		find A = (B / C + D*B -C) Mod B		#
#						#
#################################

	.text		
	.globl __start	

__start:
	la $a0,prompt	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall

	li $v0, 5	# syscall 5 reads an integer
	syscall

	sw $v0,B #initialize the number B
	
	
	la $a0,prompt2	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall

	li $v0, 5	# syscall 5 reads an integer
	syscall

	sw $v0,C #initialize the number C
	
	
	la $a0,prompt3	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall

	li $v0, 5	# syscall 5 reads an integer
	syscall

	sw $v0,D #initialize the number D
	
	
	lw $t0,B
	lw $t1,C
	lw $t2,D
	lw $t3,A
	
	
	jal division # B / C
	
	move $t3,$t6  #put the divisions' answer back to the A's register
	
	mul $t4,$t2,$t0   #D * B 
	
	add $t3,$t3,$t4 # A = B/C + D*B
	sub $t3,$t3,$t1 # A = B/C + D*B - C 
	
	
	move $t1,$t0 
	move $t0, $t3
	jal division
	
	move $t3,$t4 #put the mod result to the A's register
	

	la $a0,ans1	# print string before result
	li $v0,4
	syscall
	
	move $a0,$t3	# get the value of the current index
	li $v0, 1 # print the current element
	syscall


	la $a0,endl	# system call to print
	li $v0,4		# out a newline
	syscall

	li $v0,10		# system call to exit
	syscall		#    bye bye
	
	
	#in the return value, $t6 is the division result, $t4 is remainder
	division:
		move $t4, $t0 #load B
		move $t5, $t1 #load C
		lw $t6, A
		
		#decide whether B > C
		sub $t7,$t4,$t5
		bgt $t7,$zero,op
		jr $ra	
		op:
			sub $t4,$t4,$t5
			addi $t6,$t6,1
			bge $t4,$t5,op
			
		jr $ra		
			
			


#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
B: .word 0
C: .word 0
D: .word 0
A: .word 0	
prompt:	.asciiz "Enter a value for B: "
prompt2:.asciiz "Enter a value for C: "
prompt3:.asciiz "Enter a value for D: "
ans1:	.asciiz "A = "
endl:	.asciiz "\n"


