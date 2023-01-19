##
## LAB2 
##  Idil Atmaca 22002491 CS224-3

##	get array size and elements from the user,sorts them using bubble sort algorithm and finds min and max items
## 	and displays them
		


	.text		
	.globl __start	

__start:
	
	jal main
	
	
	
	la $a0,endl	# system call to print
	li $v0,4		# out a newline
	syscall	

	finish:
	
	##pop
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)	
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw 	$s5, 24($sp)
	addi	$sp, $sp, 28
	
	li $v0,10
	syscall
				
	#reads inputted values from the user one by one
	readArrayValues:
		
		
		##ask the array size
		la $a0,prompt	
		li $v0,4	
		syscall

		li $v0, 5	
		syscall

		sw $v0, size #get the inputed value and store it in customSize variable
		
		lw $s0,size
		la $s1,array
		
		blt $s0,$zero,errorMessagePrint   ## if size is a negative number, display error message and ask again
		
		beq $zero,$s0,finish #checks for array size 0		
		
		readValue:
		
			##ask for the next array element
			la $a0,prompt1	
			li $v0,4	
			syscall
			
			li $v0,5
			syscall
			
			sw $v0,0($s1) #get the read value and put it to current addres of the array
			addi $s1, $s1, 4 #update the addres of the array
			subi $s0,$s0,1 #update counter
			bgt $s0, $zero, readValue #go through the readValue function until all the elements are finalized
		j breakPoint
	
	


	main:
		##push stack
		addi	$sp, $sp, -28
		sw	$s5, 24($sp)
		sw	$s4, 20($sp)
		sw	$s3, 16($sp)
		sw	$s2, 12($sp)
		sw	$s1, 8($sp)
		sw	$s0, 4($sp)
		sw	$ra, 0($sp)
		
		
		
		jal monitor

	monitor:
		
		
		##display options (input array or exit)
		la $a0,menuPrompt	
		li $v0,4	
		syscall
		
		la $a0,endl	
		li $v0,4		
		syscall			


		#options
		li $s1,'1'
		li $s2,'2'
		
		
		li $v0, 12	#reads the option as char
		syscall
		
		
		beq $v0,$s1,readArrayValues ##if the first choice is choosen
		beq $v0,$s2,finish  ####if the second choice is choosen
		
		
		##if the user inputs an invalid option, print the error message and ask again
		
		la $a0,errorMessage	
		li $v0,4	
		syscall
		
		la $a0,endl	
		li $v0,4	
		syscall
		
		j monitor
		
		
		
		breakPoint:
		
			##print input array
			la $a0,printMsg	
			li $v0,4	
			syscall
			
			jal printArray
			la $a0,endl	
			li $v0,4		
			syscall	
			
			jal bubbleSort ##sort array
		
		breakPoint4:
		
			jal printArray  ##print sorted array
			jal minMax ##find min and max of the array
		
		
		breakPoint6:
		
			j monitor ## go back to cohices		
		
		
	
		

	bubbleSort:
	
		#display sorted array
		la $a0,sortedMsg	
		li $v0,4	
		syscall
		
		lw $s0,size
		la $s1,array
		
		
		##if there is only one item in the array, it is already sorted
		li $s4,1
		beq $s0,$s4,finish
		
		
		sorting:
			lw $s0,size
			la $s1,array
			li $s5,0 ## variable to decide if the array is sorted
			bubble:
				lw $s2,0($s1)
				lw $s3,4($s1)
				bgt $s3,$s2,swap
				breakPoint3:
				subi $s0,$s0,1
				addi $s1,$s1,4
			
				li $s4,1
				bgt $s0,$s4,bubble
			bne $s5,$zero,sorting	##if the array was not sorted, go through it again
				
			
			
		j breakPoint4
		swap:
			sw $s2,4($s1)
			sw $s3,0($s1)
			addi $s5,$s5,1
			j breakPoint3
			
	
		

				
	minMax:
		la $s1, array #get the array pointers' addres
		lw $s0, size #get the array size identified by the user and load to t1
		
		lw $s2,0($s1) ##min value of the sorted array
		li $s4,0  ##max value
		
		findLast:
			addi $s1,$s1,4
			subi $s0,$s0,1
			bgt $s0,$zero,findLast
		
		subi $s1,$s1,4 ##point to the last element
		lw $s4,0($s1)	 ##load max value
		
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
		##print min
		la $a0,maxMsg	# output prompt message for getting each item in the array
		li $v0,4	# syscall 4 prints the string
		syscall
		
		move $a0,$s2	# get the value of the current index
		li $v0, 1 # print the current element
		syscall
		
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
		
		##print max
		la $a0,minMsg	# output prompt message for getting each item in the array
		li $v0,4	# syscall 4 prints the string
		syscall
		
		move $a0,$s4	# get the value of the current index
		li $v0, 1 # print the current element
		syscall
		
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
		
		j breakPoint6
		
	
		
	printArray:
		la $s1, array #get the array pointers' addres
		lw $s0, size #get the array size identified by the user and load to t1
		
		printElement:
			lw $a0,0($s1)	# get the value of the current index
			li $v0, 1 # print the current element
			syscall
			addi $s1,$s1,4
			subi $s0,$s0,1
			
			
			#add space between the elements
			space:
			la $a0,space0	# output prompt message on terminal
			li $v0,4	# syscall 4 prints the string
			syscall
			
			bgt $s0, $zero, printElement
			
			
		subi $s0,$s0,4 #t0 points to the last element on the array
	
	
		
		jr $ra
		
		errorMessagePrint:
			la $a0,errorMessage	# output prompt message on terminal
			li $v0,4	# syscall 4 prints the string
			syscall
			la $a0,endl	# output prompt message on terminal
			li $v0,4	# syscall 4 prints the string
			syscall
			
			j readArrayValues
				
		
	.data
	
	.align 2
	array: .space 400	
	endl: .asciiz "\n"
	
	menuPrompt: .asciiz "Choose an option (1 to input an array, 2 to exit)"
	prompt: .asciiz "Enter the size of the array:"	
	prompt1:.asciiz "Enter the next value in the array: "	
	printMsg:.asciiz "input array: "
	sortedMsg: .asciiz "Sorted array is: "
	maxMsg: .asciiz "Max value of the array is: "
	minMsg: .asciiz "Min value of the array is: "
	errorMessage: .asciiz "INVALID, try again"
	size: .word 0	
	space0: .asciiz " "
																							
	
