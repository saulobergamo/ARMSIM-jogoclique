.equ	mascara4bit, 	0x0f						@mascara para obter os 4 últimos bits do tick(0-F)
.equ	exit, 			0x11						@termina o programa
.equ	getTicks,		0x6d						@acessa o tempo atual o clock
.equ	setseg8, 		0x200						@acende o display 8 segmentos 
.equ	checkBlack, 	0x202						@verifica se um dos botöes preto foi selecionado
.equ	checkBlue, 		0x203						@verifica se um dos botöes azuis foi selecionado
.equ	drawstring, 	0x204						@desenha um string no display lcd
.equ 	drawint, 		0x205						@desenha um int no display lcd
.equ	cleardisplay, 	0x206						@limpa todo o display lcd
.equ	clearline, 		0x208						@limpa uma linha específica

.equ	botao00, 		0x01						@define o botão azul 00
.equ	botao01, 		0x02						@define o botáo azul 01
.equ	botao02, 		0x04						@define o botáo azul 02
.equ	botao03, 		0x08						@define o botáo azul 03
.equ	botao04, 		0x10						@define o botáo azul 04
.equ	botao05, 		0x20						@define o botáo azul 05
.equ	botao06, 		0x40						@define o botáo azul 06
.equ	botao07, 		0x80						@define o botáo azul 07
.equ	botao08, 		1<<8						@define o botáo azul 08
.equ	botao09, 		1<<9						@define o botáo azul 09
.equ	botao10A, 		1<<10						@define o botáo azul 10/A
.equ	botao11B, 		1<<11						@define o botáo azul 11/B
.equ	botao12C, 		1<<12						@define o botáo azul 12/C
.equ	botao13D, 		1<<13						@define o botáo azul 13/D
.equ	botao14E, 		1<<14						@define o botáo azul 14/E
.equ	botao15F, 		1<<15						@define o botáo azul 15/F

.text
	
	mov r6, #1										@regstrador 6 é utilizado como contador das jogadas	
	swi cleardisplay								@limpar a tela lcd antes do início do jogo
	mov r0, #0
	swi setseg8										@apaga o display 8 segmentos caso tenha sido usado anteriormente 
	ldr r5, =mascara4bit							@reserva o registrador 5 para a máscara dos 4 úlitmos bits do clock
	
	ldr r2, =comece0								@carrega no registrador 2 string/frase com o Nome do jogo
	mov r0, #13										@registrador 0 e registrador 1 definem a coluna e linha a ser impressa a string na tela lcd
	mov r1, #1										
	swi drawstring									@imprime a string armazenada em r2 anteriormente

	ldr r2, =comece 								@carrega no registrador 2 a instrução para que o jogador consiga iniciar o jogo
	mov r0, #3										@registrador 0 e registrador 1 definem a coluna e linha a ser impressa a string na tela lcd
	mov r1, #3
	swi drawstring									@imprime a string armazenada em r2 anteriormente

	ldr r2, =rodada1								@carrega o registrador dois com a string correspondente ao início da rodada 1
	mov r0, #14										@move para r0 e r1 a coluna e linha a ser impressa a string
	mov r1, #5
	swi drawstring									@imprime a string armazenada em r2 na tela lcd

	botaopreto:	
		swi checkBlack								@verificar se um dos botões pretos foi selecionado para iniciar o jogo e armazena em r0 o valor correspondente
		cmp r0, #1									@caso contrário fica repetindo a verificação até encontrar r0=1(direito) ou r0=2(esquerdo)
		beq apagalinhas								@quando um dos botões é selecionado faz um salto para apagar as linhas
		cmp r0, #2
		beq apagalinhas
		bal botaopreto

	apagalinhas:
		mov r0, #1									@registrador 0 define as linhas que seráo apagadas e o comando clearline apaga a linha definida
		swi clearline

		mov r0, #3
		swi clearline
		bal inicio

	inicio:

		swi getTicks								@acessa o tempo atual do clock e guarda em r0
		mov r2, r0 									@faz uma cópia em r2 do tempo guardado em r0
		and r2, r2, r5 								@faz a máscara com r5 e reserva apenas os últimos 4 bits(0-F)
		mov r3, r2

			cmp r2, #0
			bne um
			mov r0, #0xED							@move para o registrador 0, a combinação necessária para mostrar
			swi setseg8								@o número ou letra(0-F) desejada no display 8 segmentos
			cmp r6, #1								@para a primeira rodada inicia no rótulo botaoazul que vai novamente pegar o tick do clock para contar o tempo
			beq botaoazul							@para as próximas rodadas passa direto para o rótulo relógio que está "dentro" do rótulo botaoazul
			bal relogio
		um:
			cmp r2, #1
			bne dois
			mov r0, #0x60
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
		dois:
			cmp r2, #2
			bne tres
			mov r0, #0xCE
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
			
		tres:
			cmp r2, #3
			bne quatro
			mov r0, #0xEA
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio

		quatro:											
			cmp r2, #4									
			bne cinco
			mov r0, #0x63
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio

		cinco:
			cmp r2, #5
			bne seis
			mov r0, #0xAB
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio

		seis:
			cmp r2, #6
			bne sete
			mov r0, #0xAF
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio

		sete:
			cmp r2, #7
			bne oito
			mov r0, #0xE0
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
	
		oito:
			cmp r2, #8
			bne nove		
			mov r0, #0xEF
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
	
		nove:
			cmp r2, #9
			bne dez
			mov r0, #0xE3
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
		
		dez:
			cmp r2, #10
			bne onze
			mov r0, #0xE7
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
		
		onze:
			cmp r2, #11
			bne doze
			mov r0, #0x2F
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
		
		doze:
			cmp r2, #12
			bne treze
			mov r0, #0x8D
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
	
		treze:
			cmp r2, #13
			bne quatorze
			mov r0, #0x6E
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
	
		quatorze:
			cmp r2, #14
			bne quinze
			mov r0, #0x8F
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio
		
		quinze:
			cmp r2, #15
			bne inicio
			mov r0, #0x87
			swi setseg8
			cmp r6, #1										
			beq botaoazul									
			bal relogio		


	botaoazul:
		swi getTicks									@acessa o tempo atual do tick do clock e faz cópia utilizada posteriormente para contar o intervalo de tempo decorrido
		mov r4, r0
		sub r2, r4, r0									@r2=r4-r0 -> r2=0 para iniciar o relógio em 00.000 s
		
		relogio:
			swi getTicks								@acessa o tempo atual do tick do clock e verifica o intervalo de tempo decorrido em milissegundos
			sub r2, r0, r4	
			mov r7, r2
			mov r8, #0

			divisao:									@esse rótulo é utilizado para "transformar" os milissegundos em segundos através da "divisão"  por mil
				add r8, r8, #1							@utilizados posteriormente para a impressão correta na tela lcd no formato 00.000 s
				sub r7, r7, #1000
				cmp r7, #0
				bgt divisao
				beq resultado
				sub r8, r8, #1							@dregistrador 8 armazena a parte inteira da divisão para ser impresso no formato de segundos (00.)
				add r9, r7, #1000						@registrador 9 armazena o "resto" da divisão, que será impresso no formato de milissegundo (.000 s)

				resultado:
					mov r2, r8
					cmp r2, #9							@verifica se o tempo a ser impresso for maior que 9 altera a coluna a ser impressa, sempre para manter o formato 00.000 s
					bgt imprime
					mov r0, #25
					mov r1, #5
					swi drawint
					mov r0, #27
					mov r2, r9							@r2 recebe o valor de r9 que será impresso no formato .000 s (milissegeundos)
					swi drawint
					mov r0, #24
					mov r2, #0
					swi drawint
					bal fimrelogio
				
				imprime:
					cmp r2, #99							@define que o máximo de tempo possível são 99 segundos, se o tempo for maior que 99s o jogador perdeu
					bgt perdeu
					mov r0, #24
					mov r1, #5		
					swi drawint
					mov r0, #27
					mov r2, r9
					swi drawint
						
			fimrelogio:
				mov r2, r3
				swi checkBlue								@verifica qual botão azul foi selecionado, compara e verifica se o jogador avança de fase
				cmp r0, #botao00							@caso tenha clicado no botão correto ou perde o jogo caso tenha clicado no botão errado
				bne num1
				
				num0:
					cmp r2, #0
					bne	perdeu
					addeq r6, r6, #1						@se o botão selecionado foi correto, incrementa a rodada
					bal rodada

				num1:
					cmp r0, #botao01
					bne num2
					cmp r2, #1
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num2:
					cmp r0, #botao02
					bne num3		
					cmp r2, #2
					bne	perdeu
					addeq r6, r6, #1
					bal rodada
	
				num3:
					cmp r0, #botao03
					bne num4
					cmp r2, #3
					bne	perdeu
					addeq r6, r6, #1
					bal rodada
			
				num4:
					cmp r0, #botao04
					bne num5
					cmp r2, #4
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num5:
					cmp r0, #botao05
					bne num6
					cmp r2, #5
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num6:
					cmp r0, #botao06
					bne num7
					cmp r2, #6
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num7:
					cmp r0, #botao07
					bne num8
					cmp r2, #7
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num8:
					cmp r0, #botao08
					bne num9
					cmp r2, #8
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num9:
					cmp r0, #botao09
					bne num10
					cmp r2, #9
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num10:
					cmp r0, #botao10A
					bne num11
					cmp r2, #10
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num11:
					cmp r0, #botao11B
					bne num12
					cmp r2, #11
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num12:
					cmp r0, #botao12C
					bne num13
					cmp r2, #12
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num13:
					cmp r0, #botao13D
					bne num14
					cmp r2, #13
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num14:
					cmp r0, #botao14E
					bne num15
					cmp r2, #14
					bne	perdeu
					addeq r6, r6, #1
					bal rodada

				num15:
					cmp r0, #botao15F
					bne relogio 
					cmp r2, #15
					bne	perdeu
					addeq r6, r6, #1
					bal rodada
			
				bal relogio
	
	rodada:													@verifica em qual rodada o jogador se encontra fazendo a impressão correta na tela lcd
		cmp r6, #2
		bgt rodada03
		
		rodada02:											@carrega a frase da rodada correspondente (alterando apenas o número da rodada e reimprime) direcionando para o inicio novamente		
			ldr r2, =rodada2
			mov r0, #14
			mov r1, #5										
			swi drawstring									@r0 e r1 definem a coluna e linha de impressão da string
			bal inicio	

		rodada03:
			cmp r6, #3
			bgt rodada04	
			ldr r2, =rodada3
			mov r0, #14
			mov r1, #5
			swi drawstring
			bal inicio

		rodada04:
			cmp r6, #4
			bgt rodada05
			ldr r2, =rodada4
			mov r0, #14
			mov r1, #5
			swi drawstring
			bal inicio

		rodada05:
			cmp r6, #5
			bgt rodada06
			ldr r2, =rodada5
			mov r0, #14
			mov r1, #5
			swi drawstring
			bal inicio

		rodada06:
			cmp r6, #6
			bgt fimdojogo									@se o número de rodadas for superior a 6 quer dizer que o jogador chegou ao final e ganhou o jogo, direciona para o fim do jogo
			ldr r2, =rodada6
			mov r0, #14
			mov r1, #5
			swi drawstring
			bal inicio
		
		fimdojogo:											@carrega a frase "VOCE VENCEU!!!!" para o registrador e imprime na tela
			ldr r2, =venceuojogo									
			mov r0, #14
			mov r1, #7	
			swi drawstring
			swi exit

	perdeu:
		ldr r2, =perdeuojogo								@carrega a frase "VOCE PERDEU!!!!" para o registrador e imprime na tela						
		mov r0, #14
		mov r1, #7
		swi drawstring
		swi exit											@encerra o programa

.data

venceuojogo:							.asciz						"VOCE GANHOU!!!!!!!"
perdeuojogo:							.asciz						"VOCE PERDEU!!!!!!!"
rodada1:								.asciz						"Rodada 1: 00.000 s"
rodada2:								.asciz						"Rodada 2:   .    s"
rodada3:								.asciz						"Rodada 3:   .    s"
rodada4:								.asciz						"Rodada 4:   .    s"
rodada5:								.asciz						"Rodada 5:   .    s"
rodada6:								.asciz						"Rodada 6:   .    s"
comece0:								.asciz						"JOGO CLIQUE RAPIDO"
comece:									.asciz						"Clique em um botao preto para iniciar"

.end