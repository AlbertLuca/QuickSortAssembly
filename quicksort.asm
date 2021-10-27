# CODE CREATED BY ALBERT LUCAS
# DATE: 10/26/2021

.data  # Defines Variable section of an assembky routine
array: .word 10, 2, 17, 9, 6, 4, 8
comma: .asciiz ", " 
.text  # Defines the start of the code section 

.globl main

main:

la $a0, array  # moves address of array into register $t0
la $a1, 0($a0)  # low index address
la $a2, 24($a0)  # high index address

jal quicksort		# quicksort(arrray[], int low, int high)
la $t0, 0($a0)
la $t1, 0($a2)  # Restores array and high index address

# Prints Array
while:

bgt $t0, $t1, exitWhile

lw $t2, 0($t0)
li $v0, 1		# Prints current number
move $a0, $t2
syscall

la $a0, comma 		# Prints comma
li $v0, 4
syscall

addi $t0, $t0, 4  # Next number

j while  # jumps back to while loop

exitWhile:

li $v0, 10 	# Tells system this is end of the program
syscall


swap:

subi $sp, $sp, 12 # Allocate Memory
sw $a0, 0($sp)	# array address
sw $a1, 4($sp)	# int low address
sw $a2, 8($sp)	# int high address

# s1 = address of array[i]

# $s2 = address of array[j]

lw $t1, 0($s1)
lw $t2, 0($s2)
		# Swaps array[i] array[j]
sw $t1, 0($s2)
sw $t2, 0($s1)

addi $sp, $sp, 12	# Restores stack
jr $ra	# exit swap


quicksort:

subi $sp,$sp, 16 # Allocate memory

sw $a0, 0($sp)	# array address
sw $a1, 4($sp)	# int low address
sw $a2, 8($sp)	# int high address
sw $ra, 12($sp)  # return address

# Initialize low and high address to temp registers
lw $t0, 0($a1)	# int low address
lw $t2, 0($a2)	# int high address

slt $t3, $a1, $a2	# Saves 1 to t3 if low < high
beq $t3, $zero, exitq	# Exits quicksort if t3 = 0 

jal partition	# Partition(array[], int low, int high)
move $a3, $v0	# pivot, s0 = v0
subi $a3, $a3, 4	# pivot index - 1 

la $a2, 0($a3)	# high = pivot - 1

jal quicksort		# quicksort(array[], int low, pivot - 1)

addi $a3, $a3, 8	# pivot index + 1
la $a1, 0($a3)		#low = pivot + 1
la $a2, 24($a0)		# Restore high
jal quicksort		# quicksort(array[],pivot + 1, high)

exitq:
lw $a0, 0($sp)	# array address
lw $a1, 4($sp)	# int low address
lw $a2, 8($sp)	# int high address
lw $ra, 12($sp)	# return address
addi $sp, $sp, 16	# Restore stack
jr $ra	# return to main

partition:
# Allocate Memory
subi $sp, $sp, 16

# Store memory
sw $a0, 0($sp)	# array address
sw $a1, 4($sp)	# int low address
sw $a2, 8($sp)	# int high address
sw $ra, 12($sp)	# return address

# Pivot variable
lw $s0, 0($a2)

# i = low - 1 address
subi $s1, $a1, 4

# j = low address
move $s2, $a1

# t3 = high - 1
move $s3, $a2	# copies high = s3
subi $s3, $s3, 4	# s3 = high - 1

forLoop:

# for(j = low; j <= high - 1; j++)
bgt $s2, $s3, exitFor

# retrievce value at array[]
lw $s4, 0($s2)

# if (array[j] < pivot)
bge $s4, $s0, exitIf
# Then
addi $s1, $s1, 4	# i++
jal swap	# swap(array[j] and pivot)

exitIf:
# j++
addi $s2, $s2, 4

j forLoop

exitFor:

addi $s1, $s1, 4	# s1 = i + 1

jal swap	# swap(array[i+1], array[j])

lw $ra, 12($sp)	# return address
addi $sp, $sp, 16 # restore stack
la $v0, 0($s1)	# i + 1 = v0

jr $ra		# returns pivot to quicksort
