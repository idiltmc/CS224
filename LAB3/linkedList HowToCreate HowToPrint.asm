	.text
# CS224, Program to be used in Lab3
# October 22, 2021

	##li	$a0, 10 	#create a linked list with 10 nodes
	j	main
	
	
	
	
# Linked list is pointed by $v0
	##move	$a0, $v0	# Pass the linked list address in $a0
	##jal 	printLinkedList
	
	
	
	
# Stop. 
	stop:
	
	li	$v0, 10
	syscall



main:

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
	
	
	
	li $s1,0 ##first list size
	jal  createList
	jal printLinkedList
	move $a1,$v0 ##a1 holds the head pointer of the first list
		
	
	li $s1,0 ##second list size
	
	
	jal createList
	jal printLinkedList
	move $a2,$v0 ##a2 holds the head pointer of the first list
	
	
	jal mergeSortedLists
	jal printLinkedList
	j stop
	
	
	

				
mergeSortedLists:

	li $s5 , 0 ##size of the merged list
	move $s0,$a1 ## s0 points to the beginning of the first list
	move $s1,$a2 ## s1 points to the beginning of the second list
	
	## ADD ZERO CASES
	
	continue:
	
		beq $s0,$zero,firstFinished
		beq $s1,$zero,secondFinished
		
		lw $s6,4($s0)
		lw $s7,4($s1)
		blt $s6,$s7,getFirst
		bgt $s6,$s7,getSecond
		beq $s6,$s7,getValue
	
		getFirst:
			move $s4,$s6
			lw $s0, 0($s0) ##s0 now points to the next node of the first list
			j cont
		
		getSecond:
			move $s4,$s7
			lw $s1, 0($s1) ##s1 now points to the next node of the second list
			j cont
		getValue:
			move $s4,$s6
			lw $s0, 0($s0) ##s0 now points to the next node of the first list
			lw $s1, 0($s1) ##s1 now points to the next node of the second list
			j cont
		cont:	
		beq $s5,$zero,createLinkedList
	
		j addNode2

		firstFinished:
			beq $s1,$zero,return
			j getSecond
		secondFinished:
			j getFirst
			

	return:
	move $s1,$s5
	j allDone
	
createLinkedList:

	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	addi	$s5, $s5, 1
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	
	j continue
	
addNode2:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	##beq	$s1, $s0, allDone
	addi	$s5, $s5, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	##sll	$s4, $s1, 2	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	j	continue			
createList:

	la $a0,finishOrContinue
	li $v0,4
	syscall
	
	li $v0, 12	#reads the option as char
	syscall
	
	
	li $s0,'s'
	beq $s0,$v0,allDone  ## if the user is finished inputing values, finish the first linked list
	
	li $s0,'c'
	bne $s0,$v0,errorPrint
	
	errorCont:

	la $a0,firstListPrompt
	li $v0,4
	syscall

	
	##li $v0, 12	#reads the option as char
	li $v0,5
	syscall
	
	move $s4,$v0 ##get the input value
	
	beq $s1,$zero,createLinkedList2  ##if the list is empty, create one
	
	j addNode ##if the list contains elements, add that to the list
		

			
createLinkedList2:
	# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	sw	$s4, 4($s2)	# Store the data value.
	addi	$s1,$s1,1
	j createList
			

addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	##beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	##sll	$s4, $s1, 2	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	j	createList
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.

	la $a0,sizeMessage
	li $v0,4
	syscall
	
	move $a0,$s1
	li $v0,1
	syscall
	
	beq $s1,$zero,breakPoint
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	j breakPoint2
# Restore the register values
	
	breakPoint:
		li $v0,0
	
	breakPoint2:
	
	
	jr $ra
	
	##add break point to continue with list2
	
	
	
	
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------



# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $v0	# $s0: points to the current node.
	move $s4, $s0	# $s4: head pointer
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode

errorPrint:
	la $a0,errorMessage
	li $v0,4
	syscall
	
	j errorCont
	
	
printedAll:
# Restore the register values

	move $v0,$s4
	
	
	
	jr $ra
#=========================================================		
	.data
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
	
finishOrContinue:
	.asciiz "\n Enter c to add a value to the linked list, s to stop "	
firstListPrompt:
	.asciiz "\n Enter a value to add to the linked list: "	
	
errorMessage:
	.asciiz "\n INVALID, please try again "	
sizeMessage:
	.asciiz "\n Size of the list is "	
	
