##
## LAB1 Preleminary Work 1. Swap 
##  ?dil Atmaca 22002491 CS224-3

##	creates an array of maximum size of 20 elements
##	asks the user the number of elements and then enters the elements one by one
##	 Displays array contents
##	 Swap and displays agaim


	.text		
	.globl __start	

__start:
	la $a0,prompt	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall

	li $v0, 5	# syscall 5 reads an integer
	syscall

	sw $v0, customSize #get the inputed value and store it in customSize variable
	jal readArrayValues  #jump to the function readArrayValues
	jal printArray  #jump to the function printArray
	la $a0, 0($t0)
	jal reverseElements
	
	la $a0,reversedMsg	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall
	jal printArray
	
	li $v0,10		# system call to exit
	syscall		#    bye bye
	
	#reads inputted values from the user one by one
	readArrayValues:
		lw $t1, customSize #get the array size identified by the user and load to t1
		la $t0, origArray #get the address of the array and put it into t0 (now $t0 points to beginning of the array)
		
		beq $zero,$t1,return #checks for array size 0		
		
		readValue:
		
			la $a0,prompt1	# output prompt message for getting each item in the array
			li $v0,4	# syscall 4 prints the string
			syscall
			
			li $v0,5 #read the value at current index
			syscall
			sb $v0,0($t0) #get the read value and put it to current addres of the array
			addi $t0, $t0, 4 #update the addres of the array
			subi $t1,$t1,1 #update counter
			bgt $t1, $zero, readValue #go through the readValue function until all the elements are finalized
		jr $ra
	
	printArray:
		la $t0, origArray #get the array pointers' addres
		lw $t1, customSize #get the array size identified by the user and load to t1
		la $a0,printMsg	# output prompt message for getting each item in the array
		li $v0,4	# syscall 4 prints the string
		syscall
		printElement:
			lw $a0,0($t0)	# get the value of the current index
			li $v0, 1 # print the current element
			syscall
			addi $t0,$t0,4
			subi $t1,$t1,1
			
			
			#add space between the elements
			space:
			la $a0,space0	# output prompt message on terminal
			li $v0,4	# syscall 4 prints the string
			syscall
			
			bgt $t1, $zero, printElement
			
			
		subi $t0,$t0,4 #t0 points to the last element on the array
		
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall
		
		jr $ra	
	reverseElements:
		la $t1, origArray #get the array pointers' addres	
		reverse:
			lw $t2, 0($t1) #element from the beginning of the array
			lw $t3, 0($t0) #element from the end of the array
			
			#swap
			sw $t2, 0($t0)
			sw $t3, 0($t1)
			
			#update adress
			addi $t1,$t1,4
			subi $t0,$t0,4
			
			bgt $t0,$t1,reverse #continue to reverse items until we reach to middle
		jr $ra	
	return:
			li $v0,10	# system call to exit
			syscall		#    bye bye	
		jr $ra		
			
			
			
			
			
	

	


#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
prompt:	.asciiz "Enter the size of the array: "
prompt1:.asciiz "Enter the next value in the array: "
printMsg: .asciiz "Array items are: "
reversedMsg: .asciiz "(reversed) "
origArray: .space 80 #creates an array of maximum size of 20 elements
customSize: .word 0 #size of the array
endl:	.asciiz "\n"
space0: .asciiz " "


##
## end of file Program2.asm

