	.equ DOIS_SEGUNDOS, 2000
	.equ SWI_GetTicks, 0x6d
	.equ SWI_LIMPA_TELA,0x206 	@clear LCD
	.equ SWI_ESCREVE_INT, 0x205 		@display an int on LCD	
	.equ SWI_ESCREVE_STRING, 0x204     @display a string on LCD
	.equ SWI_EXIT, 0x11 			@terminate program
	.equ SWI_CHECA_BOTAO_AZUL, 0x203 		@check press Blue button
	.equ LED_DIREITO, 0x01			@right led lights
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
	.equ BOTAO_ESQUERDO, 1 @button(15)
	memspace: .space 24

@--------------------------------------------------------------------------@
@	Trabalho de arquitetura e organização de computadores - 2020/2
@	Lucas André	
@	Vitor Triches
@
@	A calculadora efetua todas as operações entre os dois últimos números da pilha,
@	se a pilha é composta por números 9->3 respectivamente, a cálculo será 9(OPERAÇÃO)3, como
@	por exemplo 9-3 caso seja subtração.
@--------------------------------------------------------------------------@

_start:
	mov r0, #0				@contrle coluna da tela, guarda também o algarismo que o usuário digita
	mov r1, #0				@controla linha da tela
	mov r2, #0				
	mov r3, #0 				
	mov r4, #0
	mov r5, #1			    @controla index, usado para somar 1 nos registradores do programa quando necessário
	mov r6, #0				@JUNTA_ALGARISMOS do usuário
	mov r8, #0
	mov r7, #10 			@multiplicador dos números de JUNTA_ALGARISMOS 
	mov r9, #0 				@sempre valor 0
	ldr r10, =memspace 		@array
	mov r11, #4 			@soma array, para apontar para próxima posição, soma-se 4 bytes
	mov r12, #0 			@index atual da pilha
	mov r13, #0
	mov r14, #0				@auxiliar, irá ser usado nas operações armazenando um dos números da pilha que irá ser submetido a operação
	swi SWI_LIMPA_TELA	@limpa tela

loop:
	swi SWI_CHECA_BOTAO_AZUL 	@guarda botão pressionado no r0
	cmp r0,#BOTAO_AZUL_15 @3.3
	beq DIVISAO
	cmp r0,#BOTAO_AZUL_14 @3.2
	beq RESTO
	cmp r0,#BOTAO_AZUL_13 @3.1
	beq ZERO
	cmp r0,#BOTAO_AZUL_12 @3.0
	beq ENTER
	cmp r0,#BOTAO_AZUL_11 @2.3
	beq MULTIPLICA
	cmp r0,#BOTAO_AZUL_10 @2.2
	beq NOVE
	cmp r0,#BOTAO_AZUL_09 @2.1
	beq OITO
	cmp r0,#BOTAO_AZUL_08 @2.0
	beq SETE
	cmp r0,#BOTAO_AZUL_07 @1.3
	beq SUBTRACAO
	cmp r0,#BOTAO_AZUL_06 @1.2
	beq SEIS
	cmp r0,#BOTAO_AZUL_05 @1.1
	beq CINCO
	cmp r0,#BOTAO_AZUL_04 @1.0
	beq QUATRO
	cmp r0,#BOTAO_AZUL_03 @0.3
	beq SOMA
	cmp r0,#BOTAO_AZUL_02 @0.2
	beq TRES
	cmp r0,#BOTAO_AZUL_01 @0.1
	beq DOIS
	cmp r0,#BOTAO_AZUL_00 @0.0
	beq UM
	cmp r0, #1 
	b CHECA_BOTAO_ESQUERDO

CHECA_BOTAO_ESQUERDO:		@esvazia a pilha caso botão esquerdo foi pressionado
	swi 0x202		    	@coloca em r0 o valor do botão apertado
	cmp r0, #1	        	@checa se o botao esquerdo foi apertado
	beq ESVAZIA_PILHA  	
	b loop 			    	@se não foi, volta pro loop principal
	
PUSH:  	
	cmp r12, #6		    	@se r12 igual a 6 a pilha está cheia
	beq PILHA_CHEIA  	
	str r6, [r10]       	@armazena o numero na posição da memoria apontado por r10
	add r10, r11, r10   	@passa para o próximo endereço
	add r12, r5, r12    	@i++
	mov r6, #0		    	@r6 recebe 0 para a proxima leitura
	mov r4, #0				@r4 representa a coluna e vai variando digita os números, quando der push volta pra 0
	b PREPARA_IMPRIMIR	
	b loop	

PREPARA_IMPRIMIR:   		@seta os registradores com os valores necessários para imprimir
	swi SWI_LIMPA_TELA
	mov r0, #0 				@coluna 0
	mov r1, #0 				@linha 0
	mov r14, #0				@vai contar o index até ele ser igual ao index atual armazenado em r12
	ldr r10,=memspace 		@pilha aponta para o começo

IMPRIME: 					@imprime pilha
	ldr r2, [r10]			@carrega o conteúdo da memória para r2
	swi SWI_ESCREVE_INT		@imprime o número
	add r1, r5, r1			@incrementa a linha em que será impresso
	add r10, r11, r10		@passa para o próximo endereço na pilha
	add r14, r5, r14		@i++
	cmp r12, r14			@r14 contém o index atual e r12 o index em que o ultimo número está armazenado na pilha
	beq loop				@se r12 igual a r14 acabou
	b IMPRIME

PILHA_CHEIA:				
	ldr r2,=mpilhacheia
	mov r14, #0				@vai contar o index até ele ser igual ao index atual armazenado em r12
	ldr r10,=memspace 		@pilha aponta para o começo
	mov r4, #0				@r4 que controla a coluna tem que ser retado (é retado normalmente na branch PUSH, mas como ele não é chamado caso a pilha esteja cheia, é retado aqui também)
	mov r6, #0				@reseto o valor que o usuário digitou e não foi inserido porque a pilha estava cheia
	swi SWI_ESCREVE_STRING
	b PREPARA_IMPRIMIR

ESVAZIA_PILHA: 				@branch é executada caso aperte o botão azul esquerdo
	cmp r12, #0				@a cada iteração verifico se o index é 0, para poder sair da branch
	beq PILHA_ESVAZIADA
	str r9, [r10]			@vai iterando pela pilha zerando os valores antigos
	sub r12, r12, r5		@
	sub r10, r10, r11   	
	b ESVAZIA_PILHA

PILHA_ESVAZIADA:
	swi SWI_LIMPA_TELA		
	ldr r2,=mPILHA_ESVAZIADA	@aparece message pilha vazia na tela
	mov r0, #0				@coluna 0
	mov r1, #0				@linha 0
	swi SWI_ESCREVE_STRING
	mov r0, #0				@coluna 0
	mov r1, #1				@linha 1
	b loop

OPERACAO_POR_ZERO:
	add r10, r11, r10   	@arruma a pilha, pois ela está 2 posições para trás
	add r10, r11, r10   	@adicionando 8 bytes na posição atual
	mov r0, #LED_DIREITO
	swi SWI_SETLED
	mov r13, r2
    bl PAUSA

PAUSA:
	mov r2, #DOIS_SEGUNDOS	@seta dois segundos de pausa
	swi SWI_GetTicks
	mov r3, r0 				@r3 tempo inicial

LOOP_PAUSA:
	swi SWI_GetTicks
	subs r0, r0, r3 		@r3 tempo atual
	cmp r0, r2				
	blt LOOP_PAUSA

TERMINA_WAIT:
	mov r0,#0
	swi SWI_SETLED
	@add r10, r11, r10 		@arruma pilha
	mov r2, r13
	b loop

JUNTA_ALGARISMOS: 			@junta os algarismos digitados, ele é multiplicado por 10 cada vez que um novo algarismo é inserido		
	mul r6, r7, r6 			@multiplica o número armazenado por 10
	cmp r2, r6				@
	addgt r6, r2, r6 
	bgt loop					
	add r6, r6, r2  
	b loop

ZERO:		
	mov r0, r4				@coluna que o algarismo vai ser imprimido
	add r4, r4, r5			@r4 controla em que coluna o próximo algarismo será imprimido
	mov r2, #0				@r2 representa o próprio algarismo digitado
	swi SWI_ESCREVE_INT		@imprime o algarismo
	mov r0, #0				@reseta coluna
	b JUNTA_ALGARISMOS	

UM:				
	mov r0, r4				@coluna que o algarismo vai ser printada
	add r4, r4, r5			@r4 controla em que coluna o próximo algarismo será imprimido
	mov r2, #1				@r2 representa o próprio algarismo digitado
	swi SWI_ESCREVE_INT		@imprime o algarismo
	mov r0, #0				@reseta coluna
	b JUNTA_ALGARISMOS	

DOIS:				
	mov r0, r4				@...
	add r4, r4, r5			@...
	mov r2, #2				@r2 representa o próprio algarismo digitado
	swi SWI_ESCREVE_INT		@imprime o algarismo
	mov r0, #0				@reseta coluna
	b JUNTA_ALGARISMOS	

TRES:			
	mov r0, r4			
	add r4, r4, r5		
	mov r2, #3
	swi SWI_ESCREVE_INT
	mov r0, #0
	b JUNTA_ALGARISMOS

QUATRO:			
	mov r0, r4			
	add r4, r4, r5		
	mov r2, #4	
	swi SWI_ESCREVE_INT
	mov r0, #0	
	b JUNTA_ALGARISMOS

CINCO:		
	mov r0, r4			
	add r4, r4, r5		
	mov r2, #5	
	swi SWI_ESCREVE_INT
	mov r0, #0
	b JUNTA_ALGARISMOS

SEIS:		
	mov r0, r4			
	add r4, r4, r5		
	mov r2, #6	
	swi SWI_ESCREVE_INT
	mov r0, #0	
	b JUNTA_ALGARISMOS

SETE:			
	mov r0, r4			
	add r4, r4, r5		
	mov r2, #7	
	swi SWI_ESCREVE_INT
	mov r0, #0	
	b JUNTA_ALGARISMOS

OITO:			
	mov r0, r4			
	add r4, r4, r5		
	mov r2, #8	
	swi SWI_ESCREVE_INT
	mov r0, #0
	b JUNTA_ALGARISMOS

NOVE:			
	mov r0, r4			
	add r4, r4, r5		
	mov r2, #9	
	swi SWI_ESCREVE_INT
	mov r0, #0	
	b JUNTA_ALGARISMOS

ENTER:
	mov r0, #0 				@reseta coluna
	swi SWI_LIMPA_TELA
	b PUSH
							@---Comentários que valem nas branches MULTIPLICA, SUBTRAÇÃO e SOMA. Mesma sequencia de comandos, muda somente a operação efetuada---
MULTIPLICA:					@
	cmp r12, #2				@se index < 2 entao não possuo dois numeros na pilha, operação cancelada
	blt loop	
	subs r10, r10, r11  	@diminuo 4 bytes no r10 que controla a pilha, para pegar o último número que foi digitado
	ldr r13, [r10]   		@armazeno em r13 o último número digitado atual
	sub r12, r12, r5 		@diminuo um index da pilha
	sub r10, r10, r11		@r10 aponta para penúltimo número digitado
	ldr r14, [r10]			@armazeno em r14 o penúltimo número digitado
	mul r13, r14, r13 		@faz operacao
	str r13, [r10]			@armazena o resultado na pilha
	add r10, r11, r10		@aumento um na memoria preparando para proxima JUNTA_ALGARISMOS, ponteiro pra memoria sempre aponta pra posição vazia, da proxima JUNTA_ALGARISMOS
	swi SWI_LIMPA_TELA	
	b PREPARA_IMPRIMIR		

SUBTRACAO:					@Ver comentários da branch MULTIPLICA, são as mesmas instruções
	cmp r12, #2				@**
	blt loop				
	subs r10, r10, r11		@**
	ldr r13, [r10]   		@**
	sub r12, r12, r5    	@**
	sub r10, r10, r11		@**
	ldr r14, [r10]			@**
	sub r13, r14, r13		@faz operacao de subtração
	str r13, [r10]			@**
	add r10, r11, r10		@**
	swi SWI_LIMPA_TELA
	b PREPARA_IMPRIMIR	
	
SOMA:						@Ver comentários da branch MULTIPLICA, são as mesmas instruções
	cmp r12, #2		   		@**
	blt loop		
	subs r10, r10, r11 		@**
	ldr r13, [r10]     		@**
	subs r12, r12, r5  		@**
	subs r10, r10, r11 		@**
	ldr r14, [r10]	   		@**
	add r13, r14, r13  		@faz operação de soma
	str r13, [r10]     		@**
	add r10, r11, r10  		@**
	swi SWI_LIMPA_TELA
	b PREPARA_IMPRIMIR

DIVISAO:			    	
	cmp r12, #2		    	@se index < 2 entao não possuo dois numeros na pilha, operação cancelada
	blt loop	
	sub r10, r10, r11 		@diminuo 4 bytes para pegar o último número que foi digitado
	ldr r13, [r10]  		@armazeno o número em r13
	sub r10, r10, r11   	@diminuo mais 4 bytes da memoria para apontar para o numero anterior ao digitado
	ldr r14, [r10]			@armazeno o número em r14
	cmp r13, #0				@se r13 ou r14 forem zero, acende led vermelho
	beq OPERACAO_POR_ZERO	
	cmp r14, #0	
	beq OPERACAO_POR_ZERO	
	b CALCULA_DIVISAO		@se não, faço o calculo da divisão: r14/r13

CALCULA_DIVISAO:
	cmp r13, r14 
	sublt r14, r14, r13		@subtraio r13 ate r14 ser menor ou igual a r13
	subeq r14, r14, r13		
	addlt r6, r6, r5		@r6 armazena a quantidade de vezes que foi subtraido
	addeq r6, r6, r5
	blt CALCULA_DIVISAO		@se r14 maior que r13 continua
	beq CALCULA_DIVISAO		@se forem iguais também
	str r6, [r10]			@gravo r6
	mov r6, #0				@reseto para próxima JUNTA_ALGARISMOS
	subs r12, r12, r5  		@diminuo um index total
	b PREPARA_IMPRIMIR

RESTO:					
	cmp r12, #2		    	@se index < 2 entao não possuo dois numeros na pilha, operação cancelada
	blt loop	
	sub r10, r10, r11 		@diminuo 4 bytes no r10 que controla a pilha, para pegar o último número que foi digitado
	ldr r13, [r10]  		@armazeno o número em r13
	sub r10, r10, r11   	@diminuo mais 4 bytes da memoria para apontar para o numero anterior ao digitado
	ldr r14, [r10]			@armazeno o número em r14
	cmp r13, #0				@se r13 ou r14 forem zero, acende led vermelho
	beq OPERACAO_POR_ZERO	
	cmp r14, #0	
	beq OPERACAO_POR_ZERO	
	b CALCULA_RESTO			@se não, faço o calculo da divisão: r14/r13
	
CALCULA_RESTO: 
	cmp r13, r14 
	sublt r14, r14, r13		@subtraio r13 ate r14 ser menor ou igual a r13	
	subeq r14, r14, r13	
	blt CALCULA_RESTO
	mov r6, r14
	str r6, [r10]			@gravo r6
	mov r6, #0				@reseto para próxima JUNTA_ALGARISMOS
	subs r12, r12, r5  		@diminuo um index total
	b PREPARA_IMPRIMIR

mpilhacheia: .asciz "Pilha cheia!"
mPILHA_ESVAZIADA: .asciz "Pilha esvaziada"
