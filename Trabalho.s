	.equ SWI_CLEAR_DISPLAY,0x206 	@clear LCD
	.equ SWI_DRAW_INT, 0x205 		@display an int on LCD	
	.equ SWI_DRAW_STRING, 0x204     @display a string on LCD
	.equ SWI_EXIT, 0x11 			@terminate program
	.equ SWI_CheckBlue, 0x203 		@check press Blue button
	.equ RIGHT_LED, 0x01			@right led lights
	.equ BUTTON, 0x202			
	.equ SWI_SETLED, 0x201 @LEDs on/off
	.equ BOTAO_AZUL_00, 0x01 @button(0)
	.equ BOTAO_AZUL_01, 0x02 @button(1)
	.equ BOTAO_AZUL_02, 0x04 @button(2)
	.equ BOTAO_AZUL_03, 0x08 @button(3)
	.equ BOTAO_AZUL_04, 0x10 @button(4)
	.equ BOTAO_AZUL_05, 0x20 @button(5)
	.equ BOTAO_AZUL_06, 0x40 @button(6)
	.equ BOTAO_AZUL_07, 0x80 @button(7)
	.equ BOTAO_AZUL_08, 1<<8 @button(8)
	.equ BOTAO_AZUL_09, 1<<9 @button(9)
	.equ BOTAO_AZUL_10, 1<<10 @button(10)
	.equ BOTAO_AZUL_11, 1<<11 @button(11)
	.equ BOTAO_AZUL_12, 1<<12 @button(12)
	.equ BOTAO_AZUL_13, 1<<13 @button(13)
	.equ BOTAO_AZUL_14, 1<<14 @button(14)
	.equ BOTAO_AZUL_15, 1<<15 @button(15)
	.equ Sec1, 1000 @ 1 seconds interval pagina 39 do guide

memspace: .space 24

start:
	mov r0, #0
	mov r2, #0
	mov r3, #0
	mov r4, #0
	mov r5, #1 @controla index
	mov r6, #0 @sera o valor total da entrada do usuario
	mov r7, #10 

	mov r9, #0 @sempre valor 0
	ldr r10,=memspace @array
	mov r11, #4 @soma array
	mov r12, #0 @index atual
	@mov r5, #1 
	
	
up:			@testes
	ldr r2,=Message
	swi 0x204	@mostra mensagem
	swi SWI_CLEAR_DISPLAY	@limpa tela
	b loop

loop:
	swi SWI_CheckBlue 	@guarda botão pressionado no r0
	
	@cmp r0,#0
	@beq loop
	cmp r0,#BOTAO_AZUL_15
	beq DIVISAO
	cmp r0,#BOTAO_AZUL_14
	beq RESTO
	cmp r0,#BOTAO_AZUL_13
	beq ZERO
	cmp r0,#BOTAO_AZUL_12
	beq ENTER
	cmp r0,#BOTAO_AZUL_11
	beq MULTIPLICA
	cmp r0,#BOTAO_AZUL_10
	beq NOVE
	cmp r0,#BOTAO_AZUL_09
	beq OITO
	cmp r0,#BOTAO_AZUL_08
	beq SETE
	cmp r0,#BOTAO_AZUL_07
	beq SUBTRACAO
	cmp r0,#BOTAO_AZUL_06
	beq SEIS
	cmp r0,#BOTAO_AZUL_05
	beq CINCO
	cmp r0,#BOTAO_AZUL_04
	beq QUATRO
	cmp r0,#BOTAO_AZUL_03
	beq SOMA
	cmp r0,#BOTAO_AZUL_02
	beq TRES
	cmp r0,#BOTAO_AZUL_01
	beq DOIS
	cmp r0,#BOTAO_AZUL_00
	beq UM
	b ChecaBotaoEsquerdo

ChecaBotaoEsquerdo:
	swi 0x202
	cmp r0,#1			@checa se o botao esquerdo foi apertado
	beq ESVAZIAPILHA
	b loop 		@ if zero, no button pressed

EMPURRAPILHA:
	@verifica se está cheia antes, if index == 5 cheia : nao cheia
	cmp r12, #6
	beq PILHACHEIA
	str r6, [r10]     @armazena o numero na posição da memoria apontado por r10
	add r10, r11, r10 @incrementa +4 na memoria do array
	add r12, r5, r12 @incrementa index atual array
	mov r6, #0		  @r6 recebe 0 para a proxima leitura

	b MOSTRAPILHA
	b loop

MOSTRAPILHAA:
	ldr r2, [r10]
	swi SWI_DRAW_INT
	add r1, r5, r1
	add r10, r11, r10
	add r12, r5, r12
	cmp r12, r14
	beq loop
	mov r8, #0
	b MOSTRAPILHAA

MOSTRAPILHA:
	mov r0, #0 @coluna 0
	mov r1, #0 @linha 0
	mov r14, r12 @provisorio
	mov r12, #0 @provisorio
	sub r10, r11, r10
	ldr r10,=memspace @provisorio
	b MOSTRAPILHAA

PILHACHEIA:
	ldr r2,=mpilhacheia
	add r1, r5, r1		@incrementa linha
	swi SWI_DRAW_STRING
	b MOSTRAPILHA

ESVAZIAPILHA: @se clicar no botao esquerda (left) esvazia pilha
	cmp r12, #0
	beq PILHAESVAZIADA
	str r9, [r10]		@armazena 0
	sub r12, r12, r5
	sub r10, r10, r11   @sub é diferente do add!!!
	b ESVAZIAPILHA

PILHAESVAZIADA:
	swi SWI_CLEAR_DISPLAY
	ldr r2,=mpilhaesvaziada
	mov r0, #0			@coluna 0
	mov r1, #0			@linha 0
	swi SWI_DRAW_STRING
	mov r1, #1			@linha 1
	b loop

OPERACAOPORZERO:
	mov r0,#RIGHT_LED
	swi SWI_SETLED
	@wait
	mov r0,#0
	swi SWI_SETLED
	add r10, r11, r10 @arruma pilha
	mov r0, #0
	b loop

fim: @provisorio
	add r8, r5, r8
	cmp r8, #1000
	bgt loop
	b fim

ENTRADA: @junta os algarismos
	mul r6, r7, r6 	@multiplica o número armazenado por 10
	cmp r2, r6		@
	addgt r6, r2, r6 
	bgt loop				
	add r6, r6, r2  
	b loop

ZERO:		@0
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #0	
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

UM:			@1
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #1
	swi SWI_DRAW_INT	
	mov r0, #0
	b ENTRADA

DOIS:			@2
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #2
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

TRES:			@3
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #3
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

QUATRO:			@4
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #4	
	swi SWI_DRAW_INT
	mov r0, #0	
	b ENTRADA

CINCO:			@5
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #5	
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

SEIS:			@6
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #6	
	swi SWI_DRAW_INT
	mov r0, #0	
	b ENTRADA

SETE:			@7
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #7	
	swi SWI_DRAW_INT
	mov r0, #0	
	b ENTRADA

OITO:			@8
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #8	
	swi SWI_DRAW_INT
	mov r0, #0
	b ENTRADA

NOVE:			@9
	mov r0, r4		@r0 representa a coluna
	add r4, r4, r5		@incrementa a coluna que vai ser printada
	mov r2, #9	
	swi SWI_DRAW_INT
	mov r0, #0	
	b ENTRADA

ENTER:
	@add r4, r4, r5		@incrementa a coluna que vai ser printada
	@mov r0, r4		@r0 representa a coluna
	@ldr r2,=menter	@mostra mensagem enter
	@swi SWI_DRAW_STRING
	@mov r0, #0
	mov r4, #0
	mov r0, r4 		@reseta coluna
	swi SWI_CLEAR_DISPLAY
	b EMPURRAPILHA

DIVISAO:		@divisao
	cmp r12, #2		@se index < 2 entao não possuo dois numeros na pilha
	blt loop
	ldr r13, [r10]   @armazeno posicao atual
	sub r10, r10, r11 @diminuo 4 bytes da memoria para apontar para o numero anterior
	ldr r14, [r10]
	cmp r13, #0
	beq OPERACAOPORZERO
	cmp r14, #0
	beq OPERACAOPORZERO
	sub r12, r12, r5  @diminuo um index
	mov r8, #0

CalculaDivisao:
	@calcula divisao
	@r13 dividido por r14
	@armazena valor em r8, guarda em r10

RESTO:		@resto
	cmp r12, #2		@se index < 2 entao não possuo dois numeros na pilha
	blt loop
	ldr r13, [r10]   @armazeno posicao atual
	sub r10, r10, r11 @diminuo 4 bytes da memoria para apontar para o numero anterior
	ldr r14, [r10]
	cmp r13, #0
	beq OPERACAOPORZERO
	cmp r14, #0
	beq OPERACAOPORZERO
	sub r12, r12, r5  @diminuo um index
	mov r8, #0

CalculaResto:
	@calcula resto
	@r13 resto de r14
	@armazena valor em r8, guarda em r10


	mov r0, #0
	b MOSTRAPILHA
	
MULTIPLICA:
	cmp r12, #2			@se index < 2 entao não possuo dois numeros na pilha
	blt loop
	subs r10, r10, r11
	ldr r13, [r10]   	@armazeno posicao atual
	sub r12, r12, r5 	@diminuo um index
	sub r10, r10, r11
	ldr r14, [r10]
	mul r13, r14, r13 	@operacao
	str r13, [r10]
	add r10, r11, r10	@aumento um na memoria preparando para proxima entrada, ponteiro pra memoria sempre aponta pra posição vazia, da proxima entrada
	swi SWI_CLEAR_DISPLAY

	@ldr r2,=mmultiplicacao	@multiplicacao
	@swi SWI_DRAW_STRING
	mov r0, #0
	b MOSTRAPILHA	

SUBTRACAO:			@subtracao
	cmp r12, #2		@se index < 2 entao não possuo dois numeros na pilha
	blt loop
	subs r10, r10, r11
	ldr r13, [r10]   @armazeno posicao atual
	sub r12, r12, r5 @diminuo um index
	sub r10, r10, r11
	ldr r14, [r10]
	sub r13, r14, r13	@operação
	str r13, [r10]
	add r10, r11, r10	@aumento um na memoria preparando para proxima entrada, ponteiro pra memoria sempre aponta pra posição vazia, da proxima entrada
	swi SWI_CLEAR_DISPLAY

	mov r0, #0
	b MOSTRAPILHA	
	
SOMA:
	cmp r12, #2		   @se index < 2 entao não possuo dois numeros na pilha
	blt loop
	subs r10, r10, r11 @vou pra posição anterior do array
	ldr r13, [r10]     @armazeno posicao atual
	subs r12, r12, r5  @diminuo um index
	subs r10, r10, r11
	ldr r14, [r10]
	add r13, r14, r13
	str r13, [r10]
	add r10, r11, r10
	swi SWI_CLEAR_DISPLAY

	@ldr r2,=madicao	
	@swi SWI_DRAW_STRING
	mov r0, #0
	b MOSTRAPILHA

Message: .asciz "Calculadora\n"
madicao: .asciz "+"
msubtracao: .asciz "-"
mresto: .asciz "%"
mmultiplicacao: .asciz "*"
menter: .asciz "enter"
mdivisao: .asciz "/"
marmazenou: .asciz "armazenou"
mpilhacheia: .asciz "Pilha cheia!"
mpilhaesvaziada: .asciz "Pilha esvaziada"

@11.4  Example: Subroutine to implement a wait cycle with the 32‐bit timer
@ Wait(Delay:r2) wait for r2 milliseconds
@Wait:
@stmfdsp!, {r0-r1,lr}
@swi SWI_GetTicks
@mov r1, r0 @ R1: start time
@WaitLoop:
@swi SWI_GetTicks
@subs r0, r0, r1 @ R0: time since start
@rsbltr0, r0, #0 @ fix unsigned subtract
@cmp r0, r2
@blt WaitLoop
@WaitDone:
@ldmfdsp!, {r0-r1,pc}

@se divisao por 0
@mov r0,#LEFT_LED
@swi SWI_SETLED

@	.equ Sec1, 1000 @ 1 seconds interval
@	.equ Point1Sec, 100 @ 0.1 seconds interval
@	.equ EmbestTimerMask, 0x7fff @ 15 bit mask for timer values
@	.equ Top15bitRange,0x0000ffff @(2^15) -1 = 32,767
@	.text
@_start:
@	mov r6,#0 @ counting the loops (not necessary)
@	ldr r8,=Top15bitRange
@	ldr r7,=EmbestTimerMask
@	ldr r10,=Point1Sec
@	SWI SWI_GetTicks @Get current time T1
@	mov r1,r0 @ R1 is T1
@	and r1,r1,r7 @ T1 in 15 bits
@RepeatTillTime:
@	add r6,r6,#1 @ count number of loops (not necessary)
@	SWI SWI_GetTicks @Get current time T2
@	mov r2,r0 @ R2 is T2
@	and r2,r2,r7 @ T2 in 15 bits
@	cmp r2,r1 @ is T2>T1?
@bgesimpletime:
@	sub r9,r8,r1 @ TIME= 32,676 - T1
@	add r9,r9,r2 @ + T2
@	bal CheckInt
@simpletime:
@	sub r9,r2,r1 @ TIME = T2-T1
@CheckInt:
@	cmp r9,r10 @is TIME < interval?
@ 	blt RepeatTillTime
@	swi	SWI_EXIT
@.end

