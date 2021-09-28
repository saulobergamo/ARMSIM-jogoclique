mov r2, 0						@inicializa o registrador 2 com zero
mov r4, r1						@copia o total de números para o r4

begin:
	ld r3, [r0], 4				@lê o valor indicado pelo endereço de r0 e copia em r3
	add r0, 4					@incremente o endereço apontado por r0 em 4 bytes
	add r2, r3					@soma cada número que será indicado pelo enreço de r0m lido e armazenado anteriormente em r3
	sub r1, 1					@diminui a quantidade de números que serão contados/somados
	bmz begin					@se ainda há números para serem lidos, se ainda houver números na "pilha", continua o processo

								@r2 armazena o total da soma de todos os números disponíveis
media:							
	add r5, 1					@contador para gerar a parte inteira da média
	sub r2, r4					@subtrai r4 de r2 n vezes até chegar a zero ou menor que zero, simulando a divisão de r2 por r4
	bmz media
	bz resultado				@salta para o resultado final caso a média seja inteira/exata
	sub r5, 1					@subtrai um do contador caso tenha passado do número necessários de subtrações no processo, quando a média não seria inteira

resultado:
	mov r2, r5					@move a média final para o registrador 2

fim:
	sub r3, r3					@encerra o programa 
	bz fim