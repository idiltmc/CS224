## Idil Atmaca 22002491
## CS224-3 LAB1 Q3
## x = (2 *a - b) / (a + b)


## x = ((2 *a - b) /c ) * (a - b)


	.text		
	.globl __start	

__start:
	la $a0,prompt	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall

	li $v0, 5	# syscall 5 reads an integer
	syscall

	sw $v0,a #initialize the number a
	
	
	la $a0,prompt2	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall

	li $v0, 5	# syscall 5 reads an integer
	syscall

	sw $v0,b #initialize the number b
	
	
	la $a0,prompt3	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall

	li $v0, 5	# syscall 5 reads an integer
	syscall

	sw $v0,c #initialize the number c
	
	
	
	
	lw $t0,a
	lw $t1,b
	lw $t2,c
	lw $t3,x
	
	
	jal calculation ##calculate the formula
	
		
	beq $t2,$zero,undefined

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

	
	## x = (2 *a - b) / (a + b)
	calculation:
		li $t5,2  #coeffiecient for a
		mult $t0,$t5   ##2 *a
		mflo $t3  ## x = 2 *a 
		
		mult $t3,$t1
		mflo $t3  ## x = 2 *a * b

		div $t3, $t2
		mflo $t3 ## x = (2 *a * b) / c
		mfhi $t4 ## x = (2 *a * b) mod c
		
		sub $t0,$t0,$t2 ##(a - c)
		
		mult $t3,$t0  ## ((2 *a * b) / c) * (a - c)
		mflo $t3
		
			
		
	jr $ra

	
	undefined:
		la $a0,res	# print string before result
		li $v0,4
		syscall
		
		li $v0,10		# system call to exit
		syscall		#    bye bye
		
		
				
			


#					 	#
#     	 data segment		

	.data
a: .word 0
b: .word 0
c: .word 0
x: .word 0	
prompt:	.asciiz "Enter a value for a: "
prompt2:.asciiz "Enter a value for b: "
prompt3:.asciiz "Enter a value for c: "
res: .asciiz "UNDEFINED "
ans1:	.asciiz "x = "
endl:	.asciiz "\n"

##
## end of file lab1Q3.asm

