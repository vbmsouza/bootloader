;; Equipe - Projeto Bootloader
;; Mateus Viégas Martins Farias (mvmf)
;; Victor Bruno de Moura Souza (vbms) 
;; Luan de Oliveira Romancini Leite (lorl)

org 0x7e00
jmp 0x0000:start

palavras0 db "SAGAZ", 13, 0
palavras1 db "EXITO", 13, 0
palavras2 db "AFETO", 13, 0
palavras3 db "VIGOR", 13, 0
palavras4 db "FAZER", 13, 0
palavras5 db "SANAR", 13, 0
palavras6 db "ETICO", 13, 0
palavras7 db "TEMPO", 13, 0
palavras8 db "CAUSA", 13, 0
palavras9 db "COMUM", 13, 0

dica0 db "      HABILIDADE  ", 13, 0 
dica1 db "      SUCESSO    ", 13, 0 
dica2 db "      CARINHO     ", 13, 0 
dica3 db "      ENERGIA        ", 13, 0 
dica4 db "      REALIZAR       ", 13, 0 
dica5 db "      RESOLVER, CURAR      ", 13, 0 
dica6 db "      MORAL, JUSTO  ", 13, 0 
dica7 db "      RELOGIO       ", 13, 0 
dica8 db "      MOTIVO        ", 13, 0 
dica9 db "      NORMAL        ", 13, 0 

underlines db "  _ _ _ _ _  ", 13, 0

dica_texto db "DICA : ", 13, 0 
msg_ultima_letra db "Letra digitada :", 13, 0 
msg_vidas db "Vidas restantes : ", 13, 0 

qtd_de_vidas db "5", 13

ultima_letra db 0
INDEX_PALAVRA db 0

flag db 0
qtd_de_caracteres db 0
cont db 0
numero_de_letras db 0

tem_a db 0
tem_b db 0
tem_c db 0
tem_d db 0
tem_e db 0
tem_f db 0
tem_g db 0
tem_h db 0
tem_i db 0
tem_j db 0
tem_k db 0
tem_l db 0
tem_m db 0
tem_n db 0
tem_o db 0
tem_p db 0
tem_q db 0
tem_r db 0
tem_s db 0
tem_t db 0
tem_u db 0
tem_v db 0
tem_w db 0
tem_x db 0
tem_y db 0
tem_z db 0

barra0	db  "______",13,0
barra1	db  "|  ___>---V |",13,0
barra6	db  "| |     (-_-)",13,0
barra8	db  "| |    ---|---",13,0	
barra10	db  "| |      / \",13,0	
barra5	db "_| |_",13,0
	 
barra2  db"| |",13,0	 
barra3  db"| |",13,0		
barra4  db"| |",13,0
barra7  db"| |    ---|---",13,0
barra9  db"| |      /",13,0		
	

start:
    xor ax, ax ; ZERA O REG
    mov ds, ax

    mov byte[qtd_de_vidas], '5' ; DEFINE 5 COMO O QTD_VIDAS
    mov byte[cont], 0

    ;; Modo de vídeo.
    mov ah, 0x0
    mov al, 12h
    int 10h

    mov ah, 0xb
    mov bh, 0
    mov bl, 1
    int 10h

    ;; Seleciona um número de 0-9, referente a palavra a ser escolhida
    call sorteia_random

    ;; Chama as strings de dicas e da palavra escolhida pro jogo
    ;; Printa dica, underlines, texto padrão da dica
    call post_jogo
    
    ;; Mostra a última letra digitada pelo usuário na tela
    call post_letra

    ;; Verifica numero de vidas restantes, e printa para o usuário visualizar
    call post_vidas

    ;; Verifica numero de vidas restantes, e printa a forca no estágio correto
    ;; Estágio da forca depende de quantas vezes o usuario errou
    call printa_forca

    ;; Pega input do usuário. Se repete até o jogo acabar...
    call esperar_entrada

jmp exit

; escolhe uma palavra
sorteia_random:
    random_start:
        mov ah, 0x0  ; interrepção que chama o time       
        int 1AH      ; conta o numero de clocks desde o 00:00
      

        mov  ax, dx
        xor  dx, dx
        mov  cx, 10    
        div  cx       ; pega o resto da div do cx que esta entre 0 e 9

        mov byte[INDEX_PALAVRA], dl
ret

post_jogo:
    ;; Printa as linhas da palavra escolhida
    ;; AH=2 INT10h
    mov si, underlines
    mov ah, 0x2
    mov bh, 0
    mov dl, 30
    mov dh, 20
    int 10h
    call printstring
    xor si, si
    
    ;; Qual palavra será escrita? 
    cmp byte[INDEX_PALAVRA], 0
    je .sub0
    cmp byte[INDEX_PALAVRA], 1
    je .sub1
    cmp byte[INDEX_PALAVRA], 2
    je .sub2
    cmp byte[INDEX_PALAVRA], 3
    je .sub3
    cmp byte[INDEX_PALAVRA], 4
    je .sub4
    cmp byte[INDEX_PALAVRA], 5
    je .sub5
    cmp byte[INDEX_PALAVRA], 6
    je .sub6
    cmp byte[INDEX_PALAVRA], 7
    je .sub7
    cmp byte[INDEX_PALAVRA], 8
    je .sub8
    cmp byte[INDEX_PALAVRA], 9
    je .sub9

    ;; Passa para SI a dica da palavra selecionada
    .sub0:
        mov si, dica0
        jmp .end_post_jogo
    .sub1:
        mov si, dica1
        jmp .end_post_jogo
    .sub2:
        mov si, dica2
        jmp .end_post_jogo
    .sub3:
        mov si, dica3
        jmp .end_post_jogo
    .sub4:
        mov si, dica4
        jmp .end_post_jogo
    .sub5:
        mov si, dica5
        jmp .end_post_jogo
    .sub6:
        mov si, dica6
        jmp .end_post_jogo
    .sub7:
        mov si, dica7
        jmp .end_post_jogo
    .sub8:
        mov si, dica8
        jmp .end_post_jogo
    .sub9:
        mov si, dica9
        jmp .end_post_jogo

    ;; Chama post_texto_padrao_dica
    ;; Função que printa a dica que está em SI
    .end_post_jogo:
        call post_texto_padrao_dica
        ret
ret

post_texto_padrao_dica:
    ;; AH=2 INT 10H
    ;; Setando cursor
    ;; BH=numero da pagina ; DH=linha ; DL=coluna
    mov ah, 0x2
    mov bh, 0
    mov dl, 25
    mov dh, 24
    int 10h
    ;; printando a dica que está no reg si
    call printStr

    ;; Printando o texto padrão da dica
    mov si, dica_texto
    mov ah, 0x2
    mov bh, 0
    mov dl, 21
    int 10h
    call printStr
ret

post_letra:
    ;; AH=2 INT 10H
    ;; Setando cursor
    ;; BH=numero da pagina ; DL=linha ; DH=coluna
    mov ah, 0x2
    mov bh, 00h
    mov dh, 26
    mov dl, 21
    int 10h
    mov si, msg_ultima_letra
    call printStr
ret

post_vidas:
    ;; Se zerou a quantidade de vidas, o jogo recomeça (0 vidas)
    cmp byte[qtd_de_vidas], '0'
    je start

    ;; Setando cursor
    mov ah, 0x2
    mov bh, 0
    mov dh, 28
    mov dl, 21
    int 10h

    ;; printa "Vidas restantes : [qtd_de_vidas]"
    mov si, msg_vidas
    call printStr
    mov si, qtd_de_vidas
    call printStr_qtd_de_vidas
ret

printa_forca:
    ;; A forca muda de estágio toda vez que o usuário erra
    ;; Logo, ela depende da qtd_de_vidas restantes
    cmp byte[qtd_de_vidas], '5'
    je d5
    cmp byte[qtd_de_vidas], '4'
    je d4
    cmp byte[qtd_de_vidas], '3'
    je d3
    cmp byte[qtd_de_vidas], '2'
    je d2
    cmp byte[qtd_de_vidas], '1'
    je d1
    cmp byte[qtd_de_vidas], '0'
    je d0

    d5:
        mov ah, 0x2;
        mov bh, 0
        mov dh, 7
        mov dl, 25
        int 10h
        mov si, barra0
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 8
        mov dl, 25
        int 10h
        mov si, barra1
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 9
        mov dl, 25
        int 10h
        mov si, barra2
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 10
        mov dl, 25
        int 10h
        mov si, barra3
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 11
        mov dl, 25
        int 10h
        mov si, barra4
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 12
        mov dl, 23
        int 10h
        mov si, barra5
        call printStr
    ret

    d4:
        mov ah, 0x2;
        mov bh, 0
        mov dh, 7
        mov dl, 25
        int 10h
        mov si, barra0
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 8
        mov dl, 25
        int 10h
        mov si, barra1
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 9
        mov dl, 25
        int 10h
        mov si, barra6
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 10
        mov dl, 25
        int 10h
        mov si, barra3
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 11
        mov dl, 25
        int 10h
        mov si, barra4
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 12
        mov dl, 23
        int 10h
        mov si, barra5
        call printStr
    ret

    d3:
        mov ah, 0x2;
        mov bh, 0
        mov dh, 7
        mov dl, 25
        int 10h
        mov si, barra0
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 8
        mov dl, 25
        int 10h
        mov si, barra1
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 9
        mov dl, 25
        int 10h
        mov si, barra6
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 10
        mov dl, 25
        int 10h
        mov si, barra7
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 11
        mov dl, 25
        int 10h
        mov si, barra4
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 12
        mov dl, 23
        int 10h
        mov si, barra5
        call printStr
    ret

    d2:
        mov ah, 0x2;
        mov bh, 0
        mov dh, 7
        mov dl, 25
        int 10h
        mov si, barra0
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 8
        mov dl, 25
        int 10h
        mov si, barra1
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 9
        mov dl, 25
        int 10h
        mov si, barra6
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 10
        mov dl, 25
        int 10h
        mov si, barra8
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 11
        mov dl, 25
        int 10h
        mov si, barra9
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 12
        mov dl, 23
        int 10h
        mov si, barra5
        call printStr
    ret

    d1:
        mov ah, 0x2;
        mov bh, 0
        mov dh, 7
        mov dl, 25
        int 10h
        mov si, barra0
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 8
        mov dl, 25
        int 10h
        mov si, barra1
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 9
        mov dl, 25
        int 10h
        mov si, barra6
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 10
        mov dl, 25
        int 10h
        mov si, barra8
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 11
        mov dl, 25
        int 10h
        mov si, barra10
        call printStr
        mov ah, 0x2;
        mov bh, 0
        mov dh, 12
        mov dl, 23
        int 10h
        mov si, barra5
        call printStr
    ret

    d0:
    ret
ret

esperar_entrada:
    ;; Pega input
    call getchar
    ;; Se o input for um newline/enter, reinicia jogo
    cmp al, 0x0d
    je start

	;; Se for minusculo, transforma em maiusculo
	cmp al, 'a'
	jge .torna_maiusculo

	call printar_Caracteres

    jmp esperar_entrada

	.torna_maiusculo:
        ;; Para transformar um numero em maiusculo, subtrai 32 dele (Space=32)
		sub al, ' '
		call printar_Caracteres
	
	;; Tentativa de encerrar o jogo quando o usuário vencer (sem apertar ENTER)
	xor dx, dx
	mov dl, byte[numero_de_letras]
	cmp byte[cont], dl
	jge start 

    ;; Vai pegar input até o jogo acabar...
	jmp esperar_entrada
ret

printar_Caracteres:
    ;; reg AL tem o ASCII da letra teclada
    ;; Atualiza ultima_letra
    mov byte[ultima_letra], al

    ;; Aqui vai ser printada a última letra digitada em local de destaque
    mov ah, 0x2
    mov bh, 0
    mov dh, 26
    mov dl, 57
    int 10h
    call putchar_destaque

    ;; carrega a palavra no reg SI
    call load_palavra
    mov ah, 0x2
    mov bh, 00h
    mov dh, 19
    mov dl, 30
	int 10h
    
    ;; Compara ultima_letra com a palavra carregada em load_palavra
	call printstringforca

    ;; Se flag=1, subtrai 1 de qtd_de_vidas
	cmp byte[flag], 1
	jne .subtrair

	mov byte[flag], 0

ret	

.subtrair:
    mov byte[flag], 0
	sub byte[qtd_de_vidas], 1
    call printa_forca
   	call post_vidas
ret

load_palavra:
    ;; Hora de checar se o caracter está na palavra! Antes carregamos a palavra
    ;; a letra pressionado está no reg AL

    ;; Qual a palavra sendo utilizada?
    cmp byte[INDEX_PALAVRA], 0
    je .carrega0
    cmp byte[INDEX_PALAVRA], 1
    je .carrega1
    cmp byte[INDEX_PALAVRA], 2
    je .carrega2
    cmp byte[INDEX_PALAVRA], 3
    je .carrega3
    cmp byte[INDEX_PALAVRA], 4
    je .carrega4
    cmp byte[INDEX_PALAVRA], 5
    je .carrega5
    cmp byte[INDEX_PALAVRA], 6
    je .carrega6
    cmp byte[INDEX_PALAVRA], 7
    je .carrega7
    cmp byte[INDEX_PALAVRA], 8
    je .carrega8
    cmp byte[INDEX_PALAVRA], 9
    je .carrega9

    ret

	.carrega0: ;;sagaz
		xor si, si
		mov si, palavras0
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 4
		ret

	.carrega1:;;exito
		xor si, si
		mov si, palavras1
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 5
		ret

	.carrega2:;;afeto
		xor si, si
		mov si, palavras2
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 5
		ret

	.carrega3:;;vigor
		xor si, si
		mov si, palavras3
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 5
		ret

	.carrega4:;;fazer
		xor si, si
		mov si, palavras4
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 5
		ret

	.carrega5:;;sanar
		xor si, si
		mov si, palavras5
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 4
		ret  

	.carrega6:;;etico
		xor si, si
		mov si, palavras6
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 5
		ret

	.carrega7:;;tempo
		xor si, si
		mov si, palavras7
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 5
		ret

	.carrega8:;;causa
		xor si, si
		mov si, palavras8
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 4
		ret

	.carrega9:;;comum
		xor si, si
		mov si, palavras9
		mov byte[qtd_de_caracteres], 5
        mov byte[numero_de_letras], 5
		ret
ret

printstring:
    .loop:
        ;; bota o próximo caracter de SI em AL
        lodsb

        ;; Se achar 0, é porque a string acabou
        cmp al, 0
        je .endloop

        ;; AH=0Eh -> teletype output
        mov ah, 0xe
        ;; Cor da strings
        ;; Cor = 7 -> cinza
        mov bx, 7
        int 10h
        jmp .loop
    .endloop:
        ret
ret

printstringforca:
    .loop:
        ;; bota o próximo caracter de SI em AL
        lodsb
        
        mov ah, 0x2
		mov bh, 0
		mov dh, 19
		add dl, 2
		int 10h
		
		;; Se achar o 0, é porque a string acabou
		cmp al, 0
        je .endloop

		;; Se achou a ulima_letra na palavra, printa ela!
		cmp al, byte[ultima_letra]
        je .printar
		
		jmp .loop
		.printar:
			call putchar_verde
			mov byte[flag], 1
			add byte[cont], 1
            cmp al, 'A'
            je .certezaa
            cmp al, 'B'
            je .certezab
            cmp al, 'C'
            je .certezac
            cmp al, 'D'
            je .certezad
            cmp al, 'E'
            je .certezae
            cmp al, 'F'
            je .certezaf
            cmp al, 'G'
            je .certezag
            cmp al, 'H'
            je .certezah
            cmp al, 'I'
            je .certezai
            cmp al, 'J'
            je .certezaj
            cmp al, 'K'
            je .certezao
            cmp al, 'P'
            je .certezap
            cmp al, 'Q'
            je .certezaq
            cmp al, 'R'
            je .certezar
            cmp al, 'S'
            je .certezas
            cmp al, 'T'
            je .certezat
            cmp al, 'U'
            je .certezau
            cmp al, 'V'
            je .certezav
            cmp al, 'W'
            je .certezaw
            cmp al, 'X'
            je .certezax
            cmp al, 'Y'
            je .certezay
            cmp al, 'Z'
            je .certezaz
            jmp .terminar;

        ;; Inicialmente tem_a, tem_b, etc... = 0
	    ;; Se for setado pra 1 é porque esta letra já foi encontrada antes
	    ;; Letras repetidas não precisam ser contadas novamente, por isso dec cont
        .certezaa:
            cmp byte[tem_a], 1
            je .diminuas
            mov byte[tem_a], 1
            jmp .terminar
        .certezab:
            cmp byte[tem_b], 1
            je .diminuas
            mov byte[tem_b], 1
            jmp .terminar
        .certezac:
            cmp byte[tem_c], 1
            je .diminuas
            mov byte[tem_c], 1
            jmp .terminar
        .certezad:
            cmp byte[tem_d], 1
            je .diminuas
            mov byte[tem_d], 1
            jmp .terminar
        .certezae:
            cmp byte[tem_e], 1
            je .diminuas
            mov byte[tem_e], 1
            jmp .terminar
        .certezaf:
            cmp byte[tem_f], 1
            je .diminuas
            mov byte[tem_f], 1
            jmp .terminar
        .certezag:
            cmp byte[tem_g], 1
            je .diminuas
            mov byte[tem_g], 1
            jmp .terminar
        .certezah:
            cmp byte[tem_h], 1
            je .diminuas
            mov byte[tem_h], 1
            jmp .terminar
        .certezai:
            cmp byte[tem_i], 1
            je .diminuas
            mov byte[tem_i], 1
            jmp .terminar
        .certezaj:
            cmp byte[tem_j], 1
            je .diminuas
            mov byte[tem_j], 1
            jmp .terminar
        .certezak:
            cmp byte[tem_k], 1
            je .diminuas
            mov byte[tem_k], 1
            jmp .terminar
        .certezal:
            cmp byte[tem_l], 1
            je .diminuas
            mov byte[tem_l], 1
            jmp .terminar
        .certezam:
            cmp byte[tem_m], 1
            je .diminuas
            mov byte[tem_m], 1
            jmp .terminar
        .certezan:
            cmp byte[tem_n], 1
            je .diminuas
            mov byte[tem_n], 1
            jmp .terminar
        .certezao:
            cmp byte[tem_o], 1
            je .diminuas
            mov byte[tem_o], 1
            jmp .terminar
        .certezap:
            cmp byte[tem_p], 1
            je .diminuas
            mov byte[tem_p], 1
            jmp .terminar
        .certezaq:
            cmp byte[tem_q], 1
            je .diminuas
            mov byte[tem_q], 1
            jmp .terminar
        .certezar:
            cmp byte[tem_r], 1
            je .diminuas
            mov byte[tem_r], 1
            jmp .terminar
        .certezas:
            cmp byte[tem_s], 1
            je .diminuas
            mov byte[tem_s], 1
            jmp .terminar
        .certezat:
            cmp byte[tem_t], 1
            je .diminuas
            mov byte[tem_t], 1
            jmp .terminar
        .certezau:
            cmp byte[tem_u], 1
            je .diminuas
            mov byte[tem_u], 1
            jmp .terminar
        .certezav:
            cmp byte[tem_v], 1
            je .diminuas
            mov byte[tem_v], 1
            jmp .terminar
        .certezaw:
            cmp byte[tem_w], 1
            je .diminuas
            mov byte[tem_w], 1
            jmp .terminar
        .certezax:
            cmp byte[tem_x], 1
            je .diminuas
            mov byte[tem_x], 1
            jmp .terminar
        .certezay:
            cmp byte[tem_y], 1
            je .diminuas
            mov byte[tem_y], 1
            jmp .terminar
        .certezaz:
            cmp byte[tem_z], 1
            je .diminuas
            mov byte[tem_z], 1
	        jmp .terminar

        .diminuas:
            dec byte[cont];
            jmp .terminar;
        .terminar:
        jmp .loop
    .endloop:
ret

printStr:
    lodsb
    ;; Se ele encontrar o 13 (ascii para \n) pode terminar o print
    cmp al, 13
    je .endprint

    call putchar_comum
    mov al, ' '  ;; cada letra terá um espaço entre elas
    call putchar_comum

    jmp printStr

    .endprint:
        ret
ret

getchar:
    ;; AH=0 INT 16H
    ;; Read key press
    mov ah, 0x0
    int 16h
ret

putchar_comum:
    ;; AH=0Eh, INT 10H
    ;; Teletype Output interruption
    ;; AL=caracter ; BH=numero da pagina ; BL=cor (7 = cinza)
    mov ah, 0xe
    mov bx, 7
    mov bh, 0
    int 10h
ret

putchar_destaque:
    ;; bl = cor 14 = amarelo
    ;; Para ficar destacada a ultima_letra
    mov ah, 0xe
    mov bx, 7
    mov bl, 14
    mov bh, 0
    int 10h
ret

putchar_verde:
    ;; bl = cor 10 = verde
    ;; Para ficar destacada as letras digitadas na forca
    mov ah, 0xe
    mov bx, 7
    mov bl, 10
    mov bh, 0
    int 10h
ret

printStr_qtd_de_vidas:
    lodsb
    ;; Se ele encontrar o 13 (ascii para \n) pode terminar o print
    cmp al, 13
    je .endprint

    call putchar_red
    mov al, ' '  ;; cada letra terá um espaço entre elas
    call putchar_red

    jmp printStr_qtd_de_vidas

    .endprint:
        ret
ret

putchar_red:
    ;; AH=0Eh, INT 10H
    ;; Teletype Output interruption
    ;; AL=caracter ; BH=numero da pagina ; BL=cor (12 = vermelho claro)
    mov ah, 0xe
    mov bx, 7
    mov bl, 12
    mov bh, 0
    int 10h
ret

exit:
