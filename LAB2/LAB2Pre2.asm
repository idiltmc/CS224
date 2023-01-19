## Idil Atmaca 22002491
## CS224-3 LAB2
## Preleminary Q2
	.text		
	.globl __start	

__start:


	la $a0,prompt	# output prompt message on terminal
	li $v0,4	# syscall 4 prints the string
	syscall
	
	
	## push stack
	addi	$sp, $sp, -24
	sw	$s4, 20($sp)
	sw	$s3, 16($sp)
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	
	
	
	##get the decimal value from the user
	li $v0,5 #read the value at current index
	syscall
	
	
	##move the decimal value to a0 than s0
	move $a0,$v0
	move $s0,$a0
	
	##print new line
	la $a0,endl	
	li $v0,4
	syscall	
	
	
	##print the hex represantation of the input decimal with a msessage
	la $a0,hex1	
	li $v0,4	
	syscall
	
			
	move $a0,$s0
	li $v0,34
	syscall
	
	
	##restore the hex value in $s0		
	move $s0,$a0
	
	
	
	
	
	
	
	#li $a0,0Xa1b2c3d4
	
	
	
	li $s1,0XFF  ##masking	
	li $s4,4  ##how many times we will iterate through the hex
	
	##shift values by two
	## $s3 will be the reversed hex represantation 
	shift:
		
		##get the least significant 2 bits
		subi $s4,$s4,1 ##update counter
		and $s2,$s0,$s1  ##find the least significant bit
		
		
		##add them to the end of the $s3
		sll $s3,$s3,8 ##shift left 2 (reverse register)
		add $s3,$s3,$s2  ##add the least significant bit to the other reg
		
		##update
		srl $s0,$s0,8 ##shift 2 right
		bgt $s4,$zero,shift
	
	
	
	##print the results
	la $a0,endl	
	li $v0,4	
	syscall	
	
	
	la $a0,hex2	
	li $v0,4	
	syscall
	
	move $a0,$s3
	li $v0,34
	syscall
	
	##pop
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)	
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	addi	$sp, $sp, 24
	
			
	
	#bye
	li $v0,10
	syscall









	.data
prompt: .asciiz "Enter a decimal value: "
endl: .asciiz "\n"	
hex1: .asciiz "Hex represantation of the input value: "
hex2: .asciiz "Reversed: "

	
