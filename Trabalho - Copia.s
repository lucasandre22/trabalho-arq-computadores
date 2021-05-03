	.equ SWI_CLEAR_DISPLAY,0x206 		@clear LCD
	.equ SWI_DRAW_INT, 0x205 		@display an int on LCD	
	.equ SWI_DRAW_STRING, 0x204 @display a string on LCD
	.equ SWI_EXIT, 0x11 			@terminate program
	.equ SWI_CheckBlue, 0x203 		@check press Blue button
	.equ RIGHT_LED, 0x01			@right led lights
	.equ BLUE_KEY_00, 0x01 @button(0)
	.equ BLUE_KEY_01, 0x02 @button(1)
	.equ BLUE_KEY_02, 0x04 @button(2)
	.equ BLUE_KEY_03, 0x08 @button(3)
	.equ BLUE_KEY_04, 0x10 @button(4)
	.equ BLUE_KEY_05, 0x20 @button(5)
	.equ BLUE_KEY_06, 0x40 @button(6)
	.equ BLUE_KEY_07, 0x80 @button(7)
	.equ BLUE_KEY_08, 1<<8 @button(8) - different way to set
	.equ BLUE_KEY_09, 1<<9 @button(9)
	.equ BLUE_KEY_10, 1<<10 @button(10)
	.equ BLUE_KEY_11, 1<<11 @button(11)
	.equ BLUE_KEY_12, 1<<12 @button(12)
	.equ BLUE_KEY_13, 1<<13 @button(13)
	.equ BLUE_KEY_14, 1<<14 @button(14)
	.equ BLUE_KEY_15, 1<<15 @button(15)

memspace: .space 24

start:
	mov r0, #0
	mov r3, #0
	mov r4, #4
	mov r5, #4
	mov r6, #4 @sera o valor total da entrada do usuario
	mov r7, #10 

	mov r8, #4 @controla o array
	mov r9, #0 @index
	mov r11, #1 @incrementa index

	mov r9, #0
	mov r11, #4
	mov r12, #5
	mov r13, #6
	mov r14, #7
	mov r1, #0
	ldr r10,=memspace

	@ldrb  r2, [r10], #1      @ r2 = *r1++
up:			@teste
	str r9, [r10] @ store the value found in R2 (0x03) to the memory address found in R1
	add r10, r8, r10
	str r11, [r10] @ store the value found in R2 (0x03) to the memory address found in R1
	add r10, r8, r10
	str r12, [r10] @ store the value found in R2 (0x03) to the memory address found in R1
	add r10, r8, r10
	str r13, [r10] @ store the value found in R2 (0x03) to the memory address found in R1
	add r10, r8, r10
	str r14, [r10] @ store the value found in R2 (0x03) to the memory address found in R1
	add r10, r8, r10
	str r3, [r10] @ store the value found in R2 (0x03) to the memory address found in R1

	@str r11, [r10] @ load address of destination
	@ldrb r2, [r10], #1      @ r2 = *r1++
	@str r12, [r10] @ load address of destination
	@ldrb r2, [r10], #1      @ r2 = *r1++
	@str r13, [r10] @ load address of destination
	@ldrb r2, [r10], #1      @ r2 = *r1++
	@str r14, [r10] @ load address of destination
	@ldrb r2, [r10], #1      @ r2 = *r1++
	@str r1, [r10] @ load address of destination

testee:
	ldr r3,=memspace
	ldr r2, [r3]
	@mov r2, r0
	swi 0x206	@limpa tela
	swi SWI_DRAW_INT	@mostra mensagem
	add r3, r5, r3
	@ldr r3,=memspace+4

	ldr r2, [r3]
	ldr r2, [r3]
	swi 0x206	@limpa tela
	swi SWI_DRAW_INT	@mostra mensagem
	add r3, r5, r3

	@ldr r3,=memspace+8
	ldr r2, [r3]
	swi 0x206	@limpa tela
	swi SWI_DRAW_INT	@mostra mensagem
	add r3, r5, r3

	@ldr r3,=memspace+12
	ldr r2, [r3] 	
	swi 0x206	@limpa tela
	swi SWI_DRAW_INT	@mostra mensagem
	add r3, r5, r3

	@ldr r3,=memspace+16
	ldr r2, [r3]
	swi 0x206	@limpa tela
	swi SWI_DRAW_INT	@mostra mensagem
	add r3, r5, r3

	@ldr r3,=memspace+20
	ldr r2, [r3]
	swi 0x206	@limpa tela
	swi SWI_DRAW_INT	@mostra mensagem

	@ldr r9, [r10] @ load address of destination r10 in r9

	
	swi SWI_CheckBlue	@retorna em R0 a tecla pressionada
	swi 0x206	@limpa tela

	ldrb  r3, [r6], #1
fim:	b fim

Message: .asciz "Calculadora\n"
loop:
	swi SWI_CheckBlue 	@get button press into R0
	@swi SWI_CLEAR_DISPLAY
	cmp r0,#0
	beq loop 		@ if zero, no button pressed
	cmp r0,#BLUE_KEY_15
	beq DIVISAO
	cmp r0,#BLUE_KEY_14
	beq RESTO
	cmp r0,#BLUE_KEY_13
	beq ZERO
	cmp r0,#BLUE_KEY_12
	beq ENTER
	cmp r0,#BLUE_KEY_11
	beq MULTIPLICA
	cmp r0,#BLUE_KEY_10
	beq NOVE
	cmp r0,#BLUE_KEY_09
	beq OITO
	cmp r0,#BLUE_KEY_08
	beq SETE
	cmp r0,#BLUE_KEY_07
	beq SUBTRACAO
	cmp r0,#BLUE_KEY_06
	beq SEIS
	cmp r0,#BLUE_KEY_05
	beq CINCO
	cmp r0,#BLUE_KEY_04
	beq QUATRO
	cmp r0,#BLUE_KEY_03
	beq SOMA
	cmp r0,#BLUE_KEY_02
	beq TRES
	cmp r0,#BLUE_KEY_01
	beq DOIS
	cmp r0,#BLUE_KEY_00
	beq ZERO
	@mov r0,#5 	@clear previous line 
	@swi SWI_CLEAR_LINE
	@mov r1,#0
	@mov r0,#0
	@BL Display8Segment
	@bal CKBLUELOOP

ENTRADA: @junta os algarismos
	mul r6, r7, r6 	
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop				
	add r6, r6, r2
	b loop

ZERO:		@0
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #0	
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

UM:			@1
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #1
	swi SWI_DRAW_INT	
	b ENTRADA

DOIS:			@2
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #2
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

TRES:			@3
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #3
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

QUATRO:			@4
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #4	
	swi SWI_DRAW_INT
	mov r0, #0	
	b ENTRADA

CINCO:			@5
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #5	
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

SEIS:			@6
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #6	
	swi SWI_DRAW_INT
	mov r0, #0	
	b ENTRADA

SETE:			@7
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #7	
	swi SWI_DRAW_INT
	mov r0, #0	
	b ENTRADA

OITO:			@8
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #8	
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

NOVE:			@9
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #9	
	swi SWI_DRAW_INT
	mov r0, #0	
	b ENTRADA

ENTER:
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=menter	@enter
	swi SWI_DRAW_STRING
	mov r0, #0
	b loop

DIVISAO:		@divisao
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=mdivisao	@divisao
	swi SWI_DRAW_STRING
	mov r0, #0
	b loop
RESTO:		@resto
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=mresto	
	swi SWI_DRAW_STRING
	mov r0, #0
	b loop
	
MULTIPLICA:
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=mmultiplicacao	@multiplicacao
	swi SWI_DRAW_STRING
	mov r0, #0
	b loop	

SUBTRACAO:			@subtracao
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=msubtracao	
	swi SWI_DRAW_STRING
	mov r0, #0
	b loop	
	
SOMA:			@soma
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=madicao	
	swi SWI_DRAW_STRING
	mov r0, #0
	b loop


madicao: .asciz "+"
msubtracao: .asciz "-"
mresto: .asciz "%"
mmultiplicacao: .asciz "*"
menter: .asciz "enter"
mdivisao: .asciz "/"

