## Idil Atmaca 22002491
## CS224-3 LAB6
## Preleminary Q5

## Program will execute until the quit option is selected
	.text		
	.globl __start	

__start:

	jal firstMenu



	
createMatrix:


	##push stack

	addi	$sp, $sp, -36
	sw	$s0, 32($sp)
	sw	$s1, 28($sp)
	sw	$s2, 24($sp)
	sw	$s3, 20($sp)
	sw	$s4, 16($sp)
	sw 	$s5, 12($sp)
	sw 	$s6, 8($sp)
	sw 	$s7, 4($sp)
	
	sw	$ra, 0($sp)
	
	
	ask:
	la $a0,rowDimPrompt	
	li $v0,4	
	syscall
	
	li $v0,5
	syscall
	
	move $s0,$v0 ## s0 holds row size 
	bgt $s0,$zero,b1 ##check if the input value is valid
		
	la $a0,errorPrompt	
	li $v0,4	
	syscall
	
	j ask
	
	
	b1:
	la $a0,colDimPrompt	
	li $v0,4	
	syscall
	
	li $v0,5
	syscall
	
	move $s1,$v0  ## s1 holds col size
	
	bgt $s1,$zero,b2 ##check if the input value is valid
		
	la $a0,errorPrompt	
	li $v0,4	
	syscall
	
	j b1
	
	b2:
	#create matrix with the given size
	mul $a0, $s0,$s1 ##a0 contains the size of the array
	li $v0,9
	syscall
	
	
	
	move $s4,$v0 #s4 contains the adress of the new array
	
	move $s2,$v0 #s2 contains the adress of the new array
	
	li $s3,1 ##count
	
	
	
	##initialize values of the matrix
	continue:	
		bgt $s3,$a0,done
		sh $s3,0($s4)
		addi $s4,$s4,2
		addi $s3,$s3,1
		j continue
	
	done:	
		##print the size of the matrix
		la $a0,sizePrompt	
		li $v0,4	
		syscall
		
		addi $s3,$s3,-1
		move $a0,$s3
		li $v0,1
		syscall
		
		la $a0,newLine	
		li $v0,4
		syscall
		
		
		j menu  #s0 = rowSize, $s1 = colSize , $s2 = adress
		

findElement:

		addi $s3,$a0,-1 ##s3 = row index
		addi $s4,$a1,-1 ## s4 = col index
		
		#from row and col index, find corresponding index in the array
		mul $a0,$s3,$s1  
		add $a0,$a0,$s4
		
		li $a1,0
		move $s4,$s2
		
		cont:	
		
			beq $a1,$a0,found
			addi $s4,$s4,2
			addi $a1,$a1,1
			j cont
	
		found:
			lh $s4,0($s4)
			move $v0,$s4 ##found element returns in v0
			
			jr $ra

displayMatrixElement:

		asking:
		##ask for a row number from the user
		la $a0,rowElementDisplayPrompt	
		li $v0,4	
		syscall
	
		li $v0,5
		syscall
		
		move $s3,$v0
		ble $s3,$zero,er1 ##check if the input value is valid
		ble $s3,$s0,b3
		
		er1:
		
		la $a0,errorPrompt	
		li $v0,4	
		syscall
	
		j asking
		
		b3:
	
		##ask for a column number from the user
		la $a0,columnElementDisplayPrompt	
		li $v0,4
		syscall
		
		li $v0,5
		syscall
		
		ble $v0,$zero,er ##check if the input value is valid
		ble $v0,$s1,b4
		
		er:
		la $a0,errorPrompt	
		li $v0,4	
		syscall
	
		
		j b3
		
		b4:
		
		##find the element in the given numbers
		move $a1,$v0
		move $a0,$s3
		jal findElement
		move $s4,$v0
		
		
		##print found element	
		la $a0,newLine	
		li $v0,4	
		syscall
			
		la $a0,elementPrompt	
		li $v0,4	
		syscall
		
		la $a0,newLine	
		li $v0,4	
		syscall
			
			
		move $a0,$s4
		li $v0,1			
		syscall	
		
		la $a0,newLine	
		li $v0,4	
		syscall
			

		j menu
		
rowMajor:

		la $a0,rowSumPrompt	
		li $v0,4	
		syscall


		la $a0,newLine	
		li $v0,4	
		syscall
		
		li $s6,1 #row index
		
		li $a2,0 #total sum
		
		
		loop:
		
		
			bgt $s6,$s0,return ##continue until all the rows are iterated
			la $a0,rowPrompt	
			li $v0,4	
			syscall
			
			move $a0,$s6
			li $v0,1
			syscall	
			
			la $a0,outPrompt	
			li $v0,4	
			syscall
			
			li $s7,1
			li $s5,0 #sum
			
			
			summ:
				bgt $s7,$s1,displaySum ##go through the row until all its columns are finished
				move $a0,$s6
				move $a1,$s7
				jal findElement
				
				add $s5,$s5,$v0
				addi $s7,$s7,1 ##update col index
				j summ
		
			displaySum:
				##print out the sum of that row
				move $a0,$s5
				li $v0,1
				syscall
				la $a0,newLine	
				li $v0,4	
				syscall
				addi $s6,$s6,1
				add $a2,$a2,$s5
				j loop
				
		return:
		
		la $a0,totalSumPrompt	
		li $v0,4	
		syscall
		
		move $a0,$a2
		li $v0,1
		syscall
		
		la $a0,newLine	
		li $v0,4	
		syscall
		
		
		
		j menu
colMajor:

		la $a0,colSumPrompt	
		li $v0,4	
		syscall


		la $a0,newLine	
		li $v0,4	
		syscall
		
		li $s6,1 #col index
		li $a2,0
		
		
		loopCol:
		
			bgt $s6,$s1,return ##continue until all the columns are iterated
			la $a0,colPrompt	
			li $v0,4	
			syscall
			
			move $a0,$s6
			li $v0,1
			syscall	
			
			la $a0,outPrompt	
			li $v0,4	
			syscall
			
			li $s7,1
			li $s5,0 #sum
			
			
			summCol:
				bgt $s7,$s0,displaySumCol ##go through the column until all its rows in tha index are finished
				move $a0,$s7
				move $a1,$s6
				jal findElement
				
				add $s5,$s5,$v0
				addi $s7,$s7,1 ##update row index
				j summCol
		
			displaySumCol:
				##print out the sum of that column
				move $a0,$s5
				add $a2,$a2,$s5
				li $v0,1
				syscall
				la $a0,newLine
				li $v0,4	
				syscall
				addi $s6,$s6,1
				j loopCol
				
		
quit:

	#pop stack
		
	lw	$s0, 32($sp)
	lw	$s1, 28($sp)
	lw	$s2, 24($sp)
	lw	$s3, 20($sp)
	lw	$s4, 16($sp)
	lw 	$s5, 12($sp)
	lw 	$s6, 8($sp)
	lw 	$s7, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 36
	
		##finish execution
		li	$v0, 10
		syscall



firstMenu:

	##display menu to the user at the start of the program

	la $a0,menuPrompt	
	li $v0,4	
	syscall
	
	la $a0,choice0	
	li $v0,4	
	syscall
	
	la $a0,choice1	
	li $v0,4	
	syscall
	
	
	##get the choice
	la $a0,enterPrompt	
	li $v0,4	
	syscall
	
	
	li $v0,5
	syscall
	
	move $a0,$v0 ##get the input value
	
	li $a1,1
	
	##decide where to go based on the choice , quit or form a matrix
	beq  $a0,$zero, quit
	beq  $a0,$a1, createMatrix
	
	la $a0,errorPrompt	
	li $v0,4	
	syscall
	
	j firstMenu
	
  
  
menu:	
	##display menu to the user for the rest of the program

	la $a0,menuPrompt	
	li $v0,4	
	syscall
	
	
	la $a0,choice1	
	li $v0,4	
	syscall
	
	la $a0,choice2	
	li $v0,4	
	syscall
	la $a0,choice3	
	li $v0,4	
	syscall
	la $a0,choice4	
	li $v0,4	
	syscall
	la $a0,choice5	
	li $v0,4	
	syscall
	
	la $a0,enterPrompt	
	li $v0,4	
	syscall
	
	
	li $v0,5
	syscall
	
	move $a0,$v0 ##get the input value
	
	
	##decide where to go based on user choice
	li $a1,1
	
	beq  $a0,$a1, createMatrix
	
	li $a1,2
	beq  $a0,$a1, displayMatrixElement
	
	li $a1,3
	beq  $a0,$a1, rowMajor
	
	
	li $a1,4
	beq  $a0,$a1, colMajor
	
	li $a1,5
	beq  $a0,$a1, quit
	
	la $a0,errorPrompt	
	li $v0,4	
	syscall
	
	j menu
	
	
#     	 data segment		#

	.data
	
menuPrompt: .asciiz "MENU\n"			
rowDimPrompt: .asciiz "Enter row dimension (N): "
colDimPrompt: .asciiz "Enter column dimension (N): "
sizePrompt: .asciiz "Size of the matrix: "
choice0: .asciiz "Press 0 to quit \n"
choice1: .asciiz "Press 1 to create a new matrix\n"
choice2: .asciiz "Press 2 to display desired element in the matrix\n"
choice3: .asciiz "Press 3 to obtain summation of matrix (row-major)\n "
choice4: .asciiz "Press 4 to obtain summation of matrix (column-major)\n "
choice5: .asciiz "Press 5 to quit\n "
enterPrompt: .asciiz " Enter your choice: " 

elementPrompt: .asciiz "Element in stored in wanted location: "
rowElementDisplayPrompt: .asciiz "Please enter row index you want to access: "
columnElementDisplayPrompt: .asciiz "Please enter column index you want to access: "

totalSumPrompt: .asciiz "Total Sum: "
outPrompt: .asciiz ": "
rowSumPrompt: .asciiz "ROW MAJOR SUMMATION"
rowPrompt: .asciiz "Row "

colSumPrompt: .asciiz "COLUMN MAJOR SUMMATION"
colPrompt: .asciiz "Column "

errorPrompt :.asciiz "INVALID, please try again: "


newLine : .ascii "\n"
.align 2
