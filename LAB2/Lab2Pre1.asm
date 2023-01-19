## Idil Atmaca 22002491
## CS224-3 LAB2
## Preleminary Q1
	.text		
	.globl __start	

__start:

	la $a0,prompt	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall
	
							
													
	li $a1, 10 ##read 8 hex max
	la $a0, adress
	
	li $v0,8
	sw $a0,adress
	syscall
	
	la $a0, adress
	
	jal convert
	
	jal calcHex
	
	
	
	
	
	la $a0,res	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall
	
	move $v0,$s5	
	
	##pop stack		
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)	
	lw	$s3, 16($sp)	
	lw	$s4, 20($sp)	
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)		
	addi	$sp, $sp, 32
	
	move $a0,$v0
	li $v0, 1 # print the current element
	syscall
	
	li $v0,10		# system call to exit
	syscall		#    bye bye
		
	
	
	convert:
		
		addi	$sp, $sp, -32
		
		##push stack
		sw	$s6, 28($sp)
		sw	$s5, 24($sp)
		sw	$s4, 20($sp)
		sw	$s3,16($sp)
		sw	$s2, 12($sp)
		sw	$s1, 8($sp)
		sw	$s0, 4($sp)
		sw	$ra, 0($sp)
	
	
		move $s0,$a0
		move $s1,$a1
		
	
		##go to the last char of the given string
		reachEnd:
			lbu $s2,0($s0)  ##current hex
			addi $s0,$s0,1 ## update pointer with next char
			beq $s2,10,end  ## finish when encounter enter
			
			
			isValid:
			
				## say that the current value of the char is c
				##check for 0 <= c <= 9
				li $s5,47
				slt $s3,$s5,$s2  ## $s3 = 1 if $s2 >= 0
				slti $s4,$s2, 58 ## $s3 = 1 if $s2 <=9
				and $s3,$s4,$s3 ## $s3 = 1 if ( 0 <= $s2 <= 9)
				beq $s3,1,reachEnd ## continue if it is satisfied
				
				##check for A <= c <= F
				li $s5,64
				slt $s3,$s5,$s2  ## $s3 = 1 if $s2 >= A
				slti $s4,$s2, 71 ## $s3 = 1 if $s2 <= F
				and $s3,$s4,$s3 ## $s3 = 1 if ( A <= $s2 <= F)
				beq $s3,1,reachEnd ## continue if it is satisfied
				
				
				##check for a <= c <= f
				li $s5,96
				slt $s3,$s5,$s2  ## $s3 = 1 if $s2 >= a
				slti $s4,$s2, 103 ## $s3 = 1 if $s2 <= f
				and $s3,$s4,$s3 ## $s3 = 1 if ( a <= $s2 <= f)
				beq $s3,1,reachEnd ## continue if it is satisfied
				
				
				## if none of the above conditions are satified fot the currrent char -> it is not valid
				notValid:
					la $a0,notValidPrompt	#print error message
					li $v0,4	# syscall 4 prints the string
					syscall							
		
		
		
		end:
			subi $s0,$s0,2	##do not include enter
		
		jr $ra		
		
		
		##calculate the hex value for the input decimal
		calcHex:
			
			li $s6, 1  ## coefficient for the current index
			li $s5,0
			next:
			
				lbu $s2,0($s0)  ##current hex
				
				
			
				li $s3,47
				slt $s3,$s3,$s2  ## $s3 = 1 if $s2 >= 0
				slti $s4,$s2, 58 ## $s3 = 1 if $s2 <=9
				and $s3,$s4,$s3 ## $s3 = 1 if ( 0 <= $s2 <= 9)
				beq $s3,1,isDigit ## continue if it is satisfied
						
				li $s3,64
				slt $s3,$s3,$s2  ## $s3 = 1 if $s2 >= A
				slti $s4,$s2, 71 ## $s3 = 1 if $s2 <= F
				and $s3,$s4,$s3 ## $s3 = 1 if ( A <= $s2 <= F)
				beq $s3,1,isBigLetter ## continue if it is satisfied
				
				li $s3,96
				slt $s3,$s3,$s2  ## $s3 = 1 if $s2 >= a
				slti $s4,$s2, 103 ## $s3 = 1 if $s2 <= f
				and $s3,$s4,$s3 ## $s3 = 1 if ( A <= $s2 <= F)
				beq $s3,1,isSmallLetter ## continue if it is satisfied
				
				
				## get the value by applying needed calculations												
				isDigit:
					subi $s2,$s2,48
					j cont
			
				
				isBigLetter:
					subi $s2,$s2,55
					j cont
			
			
				isSmallLetter:
					subi $s2,$s2,87
					j cont
		
				cont:
				
					
					mult $s2,$s6  ##multiply the corresponding coefficient
					mflo $s2
					
					add $s5,$s5,$s2 ##add the current index value to sum
					
					li $s2,16
					mult $s6,$s2 ##update coeffiecient
					mflo $s6
					
					subi $s0,$s0,1 ## prev char
					
					bge $s0,$a0, next ##continue until the initial index is reached
					
				
				
				jr $ra	
					
			
			
	
 	







#     	 data segment		#

	.data
	
prompt: .ascii "Enter: "
.align 2
adress: .space 8	
sum: .word 0

notValidPrompt: .ascii "Not a valid hex"
res: .ascii "Decimal represantation of the input is: "


