##
## LAB1 Question 4
##  Idil Atmaca 22002491 CS224-3

##	implementing a program with a simple menu that involve loop 


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
	
	
	jal displayMenu
	
	la $a0,endl	# system call to print
	li $v0,4		# out a newline
	syscall	
			
	li $v0,10		# system call to exit
	syscall		#    bye bye
	
	
	
	displayMenu:
	
		
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
	
		la $a0,menu1	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
		
		la $a0,menu2	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
		
		
		la $a0,menu3	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
		
		la $a0,menu4	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
		
		
		
		## choices for the user
		li $t0, 'a'
		li $t1,'b'
		li $t2,'c'
		li $t3, 'd'
		
		li $v0, 12 # v0 contains char
		syscall
		
		## make the given instruction
		beq $v0,$t0,greaterSummation
		beq $v0,$t1,oddAndEvenSums
		beq $v0,$t2,numberOfOccurrences
		beq $v0,$t3,return	
		
			
		##print an error message if none of the above instructions are choosen
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall		
			
		la $a0,errorMsg	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall
		
		jal displayMenu
						
		
		
				
	#reads inputted values from the user one by one
	readArrayValues:
		lw $t1, customSize #get the array size identified by the user and load to t1
		la $t0, arr #get the address of the array and put it into t0 (now $t0 points to beginning of the array)
		
		beq $zero,$t1,return #checks for array size 0		
		
		readValue:
		
			la $a0,prompt1	# output prompt message for getting each item in the array
			li $v0,4	# syscall 4 prints the string
			syscall
			
			li $v0,5 #read the value at current index
			syscall
			sw $v0,0($t0) #get the read value and put it to current addres of the array
			addi $t0, $t0, 4 #update the addres of the array
			subi $t1,$t1,1 #update counter
			bgt $t1, $zero, readValue #go through the readValue function until all the elements are finalized
		jr $ra
	
	
	
	# $t2 return to the sumamtion of all numbers in the array
	summation:
		la $t0, arr
		lw $t1, customSize
		li $t2,0
		
		next:
			lw $t3,0($t0)
			add $t2,$t2,$t3
			addi $t0, $t0, 4 #update the addres of the array
			subi $t1,$t1,1 #update counter
			bgt $t1, $zero, next #go through the readValue function until all the elements are finalized
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
		j position
		
	
	oddAndEvenSums:
	
		#calculate the sum of all numbers to use later on
		jal summation
		
		position:
		
		#store the sum in the register for even summation
		li $t6,0
		add $t6,$t6,$t2
		
		
		##find the odd summation
		jal oddSummation
		returnPlace:
		
		##find even summation
		sub $t6,$t6,$t2
		
		
		##print odd sum result
		la $a0,oddSumMsg	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall
	
		move $a0,$t2	# get the value of the current index
		li $v0, 1 # print the current element
		syscall


		##print even sum result
		la $a0,endl	# system call to print
		li $v0,4		# out a newline
		syscall	
				
		la $a0,evenSumMsg	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall
		
		
		move $a0,$t6	# get the even number sum
		li $v0, 1 # print the current element
		syscall	
		
	jal displayMenu  ##go back to the menu
	
	#returns with $t2
	oddSummation:
		la $t0, arr
		lw $t1, customSize
		li $t2,0
		
		
		nxt:
			lw $t3,0($t0)
			li $t4,2
			div $t3,$t4
			mfhi $t4  #checking if the current number is a even or odd num
			
			addi $t0, $t0, 4 #update the addres of the array
			subi $t1,$t1,1 #update counter
			
			beq $t4, 1, addItem  ##if the current number is odd, add it to the sum
			beq $t4, -1, addItem  ##if the current number is odd, add it to the sum
			returnPos:
			
			bgt $t1, $zero, nxt #go through the readValue function until all the elements are finalized
			
		
		
		j returnPlace	
		addItem:
			add $t2,$t2,$t3
			j returnPos
				
		
	
	##find the sum of numbers that are greater than the input number
	greaterSummation:
	
		la $t0, arr
		lw $t1, customSize
		li $t2,0
		
		la $a0,inputMsg	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall

		li $v0, 5	# syscall 5 reads an integer
		syscall
		
		
		##store ethe input number
		sw $v0,inputNum
		lw $t4,inputNum
		
		greaterNext:
			lw $t3,0($t0)
			
			addi $t0, $t0, 4 #update the addres of the array
			subi $t1,$t1,1 #update counter
			bgt $t3, $t4, addItem2  ##add the current to the sum if it is greater than the input number
			position2:
			bgt $t1, $zero, greaterNext #go through the function until all the elements are finalized
			
			
			##print result	
			la $a0,endl	# system call to print
			li $v0,4		# out a newline
			syscall	
			
			
			la $a0,greaterSumMsg	# output prompt message on terminal
			li $v0,4	# syscall 4 prints the string
			syscall
		
			move $a0,$t2	# get the even number sum
			li $v0, 1 # print the current element
			syscall	
		
			jal displayMenu	 ##go back to menu
			
			
			addItem2:
			add $t2,$t2,$t3 ##update sum
			j position2	
				
	##find the total number of occurrences that are divsible by the input number	
	numberOfOccurrences:
	
		la $t0, arr
		lw $t1, customSize
		li $t2,0
		
		la $a0,inputMsg	# output prompt message on terminal
		li $v0,4	# syscall 4 prints the string
		syscall

		li $v0, 5	# syscall 5 reads an integer
		syscall
		
		
		#initialize the input value
		sw $v0,inputNum
		lw $t4,inputNum
		
		
		occurNext:
			lw $t3,0($t0)
			
			addi $t0, $t0, 4 #update the addres of the array
			subi $t1,$t1,1 #update counter
			
			div $t3,$t4
			mfhi $t3
			
			beq $t3,$zero,increase  ##if the current is divisible by the input, increase the num of occurences
			
			position3:
			bgt $t1, $zero, occurNext #go through the function until all the elements are finalized
			
			
			
			##print result
			la $a0,endl	# system call to print
			li $v0,4		# out a newline
			syscall	
				
			la $a0,occurMsg	# output prompt message on terminal
			li $v0,4	# syscall 4 prints the string
			syscall
		
			move $a0,$t2	# get the even number sum
			li $v0, 1 # print the current element
			syscall	
		
			jal displayMenu	 ##go back to the menu
			
			
			increase:
			addi $t2,$t2,1
			j position3	
	
	
	
	printArray:
		la $t0, arr #get the array pointers' addres
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
		
		
		
		jr $ra	
	
		
	## quit the program			
	return:
			li $v0,10	# system call to exit
			syscall		#    bye bye	
		jr $ra		
			
			
			
			
			
	

	


#################################
#     	 data segment		#

	.data
prompt:	.asciiz "Enter the size of the array: "
prompt1:.asciiz "Enter the next value in the array: "
printMsg: .asciiz "Array items are: "
reversedMsg: .asciiz "(reversed) "
inputMsg: .asciiz "Please enter a number: "
errorMsg:  .asciiz "INVALID, please try again: "
sumMsg: .asciiz "Sum of all array items are: "
oddSumMsg: .asciiz "Sum of all odd numbers in array: "
evenSumMsg: .asciiz "Sum of all even numbers in array: "
greaterSumMsg:  .asciiz "Sum of numbers greater than an input number: "
occurMsg: .asciiz "Number of occurrences divisible by the input: "
menu1: .asciiz "a. Find summation of numbers stored in the array which is greater than an input number."
menu2: .asciiz "b. Find summation of even and odd numbers and display them."
menu3: .asciiz "c. Display the number of occurrences of the array elements divisible by a certain input number"
menu4: .asciiz "d. Quit."

.align 2
arr: .space 400 #creates an array of maximum size of 20 elements
sum: .word 0
inputNum: .word 0
customSize: .word 0 #size of the array
endl:	.asciiz "\n"
space0: .asciiz " "


##
## end of file lab1Q4.asm

