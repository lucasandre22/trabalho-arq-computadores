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

start:
	mov r0, #0
	mov r2, #0
	mov r3, #0
	mov r4, #0
	mov r5, #1
	mov r6, #0 @sera o valor total da entrada do usuario
	mov r7, #10 
	
up:			@testes
	ldr r2,=Message
	swi 0x204	@mostra mensagem
	swi SWI_CheckBlue	@retorna em R0 a tecla pressionada
	swi 0x206	@limpa tela
	b loop
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
ZERO:		@0
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #0	
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6		@r6 = r7*r6
	cmp r2, r6		
	addgt r6, r2, r6	@ if (r2 > r6) { r6 += r2 }
	bgt loop		@ se r2 > r6 volta pro loop principal
	add r6, r6, r2		@r6 += r2
	b loop
	
ENTER:
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=menter	@enter
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
NOVE:			@9
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #9	
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6 	
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop				
	add r6, r6, r2		
	b loop	
OITO:			@8
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #8	
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop			 		
	add r6, r6, r2		
	b loop
SETE:			@7
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #7	
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6 	
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop				
	add r6, r6, r2		
	b loop
SUBTRACAO:			@subtracao
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=msubtracao	
	swi SWI_DRAW_STRING
	mov r0, #0
	b loop	
SEIS:			@6
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #6	
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6 
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop				
	add r6, r6, r2		
	b loop
CINCO:			@5
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #5	
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6 
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop				
	add r6, r6, r2	
	b loop
QUATRO:			@4
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #4	
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6 
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop					
	add r6, r6, r2	
	b loop	
SOMA:			@soma
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	ldr r2,=madicao	
	swi SWI_DRAW_STRING
	mov r0, #0
	b loop
TRES:			@3
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #3
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop			 		
	add r6, r6, r2	
	b loop
DOIS:			@2
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #2
	swi SWI_DRAW_INT
	mov r0, #0
	mul r6, r7, r6 
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop					
	add r6, r6, r2	
	b loop
UM:			@1
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r0, r4		@r0 representa a coluna
	mov r2, #1
	swi SWI_DRAW_INT
	mul r6, r7, r6 	
	cmp r2, r6		
	addgt r6, r2, r6
	bgt loop				
	add r6, r6, r2	
	b loop

madicao: .asciz "+"
msubtracao: .asciz "-"
mresto: .asciz "%"
mmultiplicacao: .asciz "*"
menter: .asciz "enter"
mdivisao: .asciz "/"

