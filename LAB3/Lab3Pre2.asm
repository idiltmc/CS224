

.text	

start:

	##push stack
	addi	$sp, $sp, -40
	sw 	$s7, 36($sp)
	sw 	$s6, 32($sp)
	sw 	$s5, 28($sp)
	sw 	$s4, 24($sp)
	sw 	$s3, 20($sp)
	sw 	$s2, 16($sp)
	sw 	$s1, 8($sp)
	sw 	$s0, 4($sp)
	sw	$ra, 0($sp)
	
	
	##initilize pointers to fetch machine code
	la	$s3, main
	la	$s4, stop


	
	
main:
	
	continue:
	
		li $s7,0   ## register counter
		la	$s3, main
		la	$s4, stop

		##ask user to enter a reg number
		la $a0,prompt
		li $v0,4
		syscall
		
		li $v0,5
		syscall
		
		move $s0,$v0  ## get the register number
		
		li $s1,31
		li $s2,1
		
		
		##determine if the input value is a register number, if it is not -> finish running
		bgt $s0,$s1,stop
		blt $s0,$s2,stop
		
		##print register count message
		la $a0,regCount
		li $v0,4
		syscall
		
		
		##testing with t registers
		
		##test R type
		
		li $t0,4
		add $t1,$t1,$t0	
		sub $t1,$t1,$t0
		or $t0,$t2,$t4
		
		##test I type
		
		addi $t1,$t1,7	
		subi $t2,$t5,4
		ori $t5,$t5,1
		
	
	next:
	bgt	$s3, $s4, prnt  ##go to print register number if the subprograms' machine code is finished
	
	
	
	lw $s5,0($s3) ##get current machine code
	srl $s5,$s5,26  ##get op code of the current machine instruction
	
	
	li $s6,3
	beq $s5,$zero,R  ##if opCode = 0 -> R type
	bgt $s5,$s6,I   ##if opCode > 3 -> I Type
	
	#else it is J type
	
	J:
		##there is no register in a J type instruction
		j cont
	
	I:
		
			
		lw $s5,0($s3)  ##get machine code
		
		
		## get rt
		srl $s5,$s5,16    ##shift 16 bits (right most 5 bits will give reg
		andi $s5,$s5,0x01F  ##masking
		
		
		beq $s5,$s0,add1  ##if rt = regNum , increment counter
			
		point1:
		
			lw $s5,0($s3)  ##get machine code
			
			 ## get rs
			srl $s5,$s5,21  
			andi $s5,$s5,0x01F 
			
			beq $s5,$s0,add2  ##if rs = regNum , increment counter
		
		point2:	
			
		j cont	
		
	
	R:
	
		lw $s5,0($s3)   ##get machine code
		
		##get rd
		srl $s5,$s5,11
		andi $s5,$s5,0x01F  
		
		
		beq $s5,$s0,increment1   ##if rd = regNum , increment counter
		
		
		cont1:
		
			lw $s5,0($s3)
			
			 ## get rt
			srl $s5,$s5,16   
			andi $s5,$s5,0x01F 
			
			beq $s5,$s0,increment2   ##if rt = regNum , increment counter
			
		cont2:
			lw $s5,0($s3)
			 ## get rs
			srl $s5,$s5,21  
			andi $s5,$s5,0x01F 
			beq $s5,$s0,increment3  ##if rs = regNum , increment counter
		cont3:	
		
	
		j cont
	
	
	cont:		
	
	
	# Advance program pointer.
	addi	$s3, $s3, 4
	j	next	
	
		
			
	stop:
	
	##pop stack
	addi	$sp, $sp, 40
	lw 	$s7, 36($sp)
	lw 	$s6, 32($sp)
	lw 	$s5, 28($sp)
	lw 	$s4, 24($sp)
	lw 	$s3, 20($sp)
	lw 	$s2, 16($sp)
	lw 	$s1, 8($sp)
	lw 	$s0, 4($sp)
	lw	$ra, 0($sp)
	
	
	##bye
	li	$v0, 10
	syscall	
	
	
	
	##add functions
	increment1:
		addi $s7,$s7,1
		j cont1
	
	increment2:
		addi $s7,$s7,1
		j cont2
	
	increment3:
		addi $s7,$s7,1
		j cont3	
			
	add1:
		addi $s7,$s7,1
		j point1
	
	add2:	
		addi $s7,$s7,1
		j point2
		
	
		
	##print the regCount			
	prnt:
		##print the register count
		move	$a0, $s7
		li	$v0, 1
		syscall
		
		j continue					



.data
newLine:
	.asciiz	"\n"
prompt:
		.asciiz "\n Enter Register Number: "		
regCount:
		.asciiz "\n Register Count: "		
mes:
		.asciiz "\n R TYPE "				
								
