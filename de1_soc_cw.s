.global _start
_start:		LDR R0, =BUTTONBASE
			LDR R1, =HEXBASE
			BL init
			@MOV R3, #0b1
			@LSL	R3, R3, #BUTTON_NO
			
			
loop0:		NOP
			LDR R2, [R0]		@ assign state of button to R2
			CMP R2, #1 @R3			@ compare to check whether the first button is pressed
			BLEQ incr_c1		@ call incr_c1 to increment the first two hex displays
			CMP R2, #2			@compare R2 with 2 to check whether the second button is pressed
			BLEQ incr_c3		@call incr_c3 to increment the last two hex displays 
			
			B loop0

incr_c1:	PUSH {R4-R7, LR}
			LDR R4, =c1			@ assign address of first counter to R4
			LDR R5, [R4]		@ assign value at R4 (FIRST COUNTER) to R5
			CMP R5, #9			@ check the value is 9, skip otherwise
			BLEQ incr_c2		@ assign R8 to 1 to be used to map to second hex
			@else do the next lines
			
			ADD R5, #1			@ increment value at counter by one
			STR R5, [R4]		@ update counter value in counter
			BL chks				@ branch to checker to compare with digits	
			
			POP {R4-R7, LR}
			BX LR
			

			
incr_c2:	PUSH {R4, R6, R7, LR} @push registers 4,6, 7 and link register unto stack to be used in this subroutine 
			@register 5 is retained so that the it can be retained and modified 
			@MOV R5, -1			  @set R5 to -1 as it will be incremented later	
			LDR R4, =c2
			LDR R6, [R4]			@assign value at c2 into R6
			ADD R6, #1				@increment value at c2
			STR R6, [R4]			@update value back into address c2
			MOV R5, R6			
			@BL	pt_to_h2
			MOV R8, #1
			BL	chks
			MOV R5, #0
			LDR	R4, =c1					@load c1 into r4
			SUB R8, #1
			STR R8, [R4]				@update value at c1
			BL show_zero
			MOV R5, #-1
			POP	{R4, R6, R7,  LR}
			BX LR
			
incr_c3:	PUSH {R4-R7, LR}
			LDR R4, =c3			@ assign address of first counter to R4
			LDR R5, [R4]		@ assign value at R4 (FIRST COUNTER) to R5
			CMP R5, #9			@ check the value is 9, skip otherwise
			BLEQ incr_c4		@ assign R8 to 1 to be used to map to second hex
			@else do the next lines
			
			ADD R5, #1			@ increment value at counter by one
			STR R5, [R4]
			MOV R8, #2
			BL chks				@ branch to checker to compare with digits	
			MOV R8, #0
			POP {R4-R7, LR}
			BX LR

incr_c4:	PUSH {R4, R6, R7, LR} @push registers 4,6, 7 and link register unto stack to be used in this subroutine 
			@register 5 is retained so that the it can be retained and modified 
			@MOV R5, -1			  @set R5 to -1 as it will be incremented later	
			LDR R4, =c4
			LDR R6, [R4]			@assign value at c2 into R6
			ADD R6, #1				@increment value at c2
			STR R6, [R4]			@update value back into address c2
			MOV R5, R6
			@BL	pt_to_h2
			MOV R8, #3
			BL	chks
			MOV R5, #0
			LDR	R4, =c3					@load c1 into r4
			SUB R8, #1
			STR R8, [R4]				@update value at c1
			BL show_zero
			MOV R5, #-1
			POP	{R4, R6, R7,  LR}
			BX LR
			
			
chks:		PUSH {LR}
			CMP R5, #9
			BLEQ show_nine
			CMP R5, #8
			BLEQ show_eight
			CMP R5, #7
			BLEQ show_seven
			CMP R5, #6
			BLEQ show_six
			CMP R5, #5
			BLEQ show_five
			CMP R5, #4
			BLEQ show_four
			CMP R5, #3
			BLEQ show_three
			CMP R5, #2
			BLEQ show_two
			CMP R5, #1
			BLEQ show_one
			@CMP R5, #0
			@BLEQ show_zero
			POP {LR}
			BX LR		

@pt_to_h2:
@			PUSH {LR}
@			MOV R8, #1		@assign R8 to 1, to be used in later comparison
@			POP {LR}
@			BX LR	
			
init:		PUSH {R4-R7, LR}	@ push these registers to the stack to be used as local variables
			LDR R4, =0x3f3f3f3f @ assigns the value of 0 in every hex segment up to 32 bits
			STR R4, [R1] 		@ stores the value in R4 in the address stored int R1

			
			POP {R4-R7, LR} 	@ restore the original values at these registers by poping them back from the stack
			BX LR				@ exits the branch
			

display4:	PUSH {R4, R5, R6, R7, LR}
			@R5 is the current value of the count
			@free registers, R4 ,R6 and R7
			LDR R5, [R1] 		@extract value in hexbase and store in R4
			LDR R6, [R4]			@extract value at R4
			
			AND	R5, #0x00ffffff	@takes off value at hexdisplay 1
			ORR R5, R6,	LSL #24
			STR R5, [R1]		@ should display value at R4
			
			POP {R4, R5, R6, R7, LR}
			BX LR

display3:	PUSH {R5,R6, LR}
			@R5 is the current value of the count
			@free registers, R4 ,R6 and R7
			LDR R5, [R1] 		@extract value in hexbase and store in R4
			LDR R6, [R4]			@extract value at R4
			AND	R5, #0xff00ffff	@takes off value at hexdisplay 1
			ORR R5, R6, LSL #16
			STR R5, [R1]		@ should display value at R4
			
			POP {R5, R6,LR}
			BX LR


display2:	PUSH {R4, R5, R6, R7, LR}
			@R5 is the current value of the count
			@free registers, R4 ,R6 and R7
			LDR R5, [R1] 		@extract value in hexbase and store in R4
			LDR R6, [R4]			@extract value at R4
			
			AND	R5, #0xffff00ff	@takes off value at hexdisplay 1
			ORR R5, R6,	LSL #8
			STR R5, [R1]		@ should display value at R4
			
			POP {R4, R5, R6, R7, LR}
			BX LR





display1:	PUSH {R5,R6, LR}
			@R5 is the current value of the count
			@free registers, R4 ,R6 and R7
			LDR R5, [R1] 		@extract value in hexbase and store in R4
			LDR R6, [R4]			@extract value at R4
			AND	R5, #0xffffff00	@takes off value at hexdisplay 1
			ORR R5, R6
			STR R5, [R1]		@ should display value at R4
			
			POP {R5, R6,LR}
			BX LR


show_zero:	NOP
			PUSH {R4-R7,LR}
			LDR R4, =zero 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #2			@ check value at R8 to know which display to point to
			BLEQ display3		@branch to display 3
			
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}
			BX LR			
show_one: 	NOP
			PUSH {R4-R7,LR}
			LDR R4, =one 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #3
			BLEQ display4		@branch to display 4
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}
			BX LR			
show_two: 	NOP
			PUSH {R4-R7,LR}
			LDR R4, =two 		@assign R6 to the value at address one, which should be hexcode to display '1'
			CMP R8, #3
			BLEQ display4		@branch to display 4
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1		
			POP {R4-R7,LR}
			BX LR		
show_three: NOP
			PUSH {R4-R7,LR}
			LDR R4, =three 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #3
			BLEQ display4		@branch to display 4
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}
			BX LR		
show_four: 	NOP
			PUSH {R4-R7,LR}
			LDR R4, =four 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #3
			BLEQ display4		@branch to display 4
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}
			BX LR		
show_five: 	NOP
			PUSH {R4-R7,LR}
			LDR R4, =five 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #3
			BLEQ display4		@branch to display 4
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}
			BX LR		
show_six: 	NOP
			PUSH {R4-R7,LR}
			LDR R4, =six 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #3
			BLEQ display4		@branch to display 4
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}
			BX LR		
show_seven: NOP
			PUSH {R4-R7,LR}
			LDR R4, =seven 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #3
			BLEQ display4		@branch to display 4
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}
			BX LR		
show_eight: NOP
			PUSH {R4-R7,LR}
			LDR R4, =eight 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #3
			BLEQ display4		@branch to display 3
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}	
			BX LR		
show_nine: 	NOP
			PUSH {R4-R7,LR}
			LDR R4, =nine 		@assign R6 to the value at address one, which should be hexcode to display '1'
			
			CMP R8, #3
			BLEQ display4		@branch to display 4
			
			CMP R8, #2
			BLEQ display3		@branch to display 3
			
			CMP R8, #1			@ check value at R8 to know which display to point to
			BLEQ display2		@branch to display 2
			CMP R8, #0
			BLEQ display1		@branch to display 1
			POP {R4-R7,LR}
			BX LR		
.data

.equ BUTTONBASE,	0xFF200050
.equ HEXBASE,	0xFF200020
.equ BUTTON_NO, 0	

.equ COUNTERS, 2
	
.align 4
counters:
c1:	.word  0
c2:	.word  0
c3:	.word  0
c4:	.word  0

.align 4
button_masks:
	.byte  0b00000001
	.byte  0b00000010
	.byte  0b00000100

.align 4	
digits:				@ table with the bit patterns for all number
zero:	.word	0b0111111	@ 0
one:	.word	0b0000110	@ 1
two:	.word	0b1011011	@ 2
three:	.word 	0b1001111 	@3
four:	.word	0b1100110 	@4
five:	.word	0b1101101 	@5
six:	.word	0b1111101 	@6
seven:	.word	0b0000111 	@7
eight:	.word	0b1111111 	@8
nine:	.word	0b1101111 	@9


