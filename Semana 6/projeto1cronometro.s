/*
Cronômetro que é exibido no display de 7 segmentos
Como é callee, aqui deve-se usar os registradores r16-r23
Se atuar como caller, deve-se salvar os valores de r16-r23

Funcionando, isolada e melhorada - Semana 6

Registradores utilizados e funcionalidades:

r16 - Representa as unidades do cronômetro
r17 - Representa as dezenas do cronômetro
r18 - Representa as centenas do cronômetro
r19 - Representa os milhares do cronômetro
r20 - Representa o limite de 10 para cada componente do cronômetro
r21 - Armazena endereço do Display de 7 Segmentos
r22 - Auxiliar para contador e exibição no display
r23 - Auxiliar para gerenciamento e exibição no display

*/

.equ    DISPLAY_BASE,       0x10000020    # Endereço base do display de 7 segmentos

.org    0x2000

.global _start

_start:

    # Inicializa os registradores do cronômetro e o stack pointer
    movia   r16, 0          # Unidades
    movia   r17, 0          # Dezenas
    movia   r18, 0          # Centenas
    movia   r19, 0          # Milhares

    movi    r20, 10         # Limite para cada dígito
    
    movia   r21, DISPLAY_BASE  # Endereço base do display
    
    movia   sp, 0x3000       # Inicializa o stack pointer na RAM
	
	stbio   r0, 0(r21)      # Atualiza o display (unidades)
	stbio   r0, 1(r21)      # Atualiza o display (unidades)
	stbio   r0, 2(r21)      # Atualiza o display (unidades)
	stbio   r0, 3(r21)      # Atualiza o display (unidades)

    subi    sp, sp, 4       # Reserva espaço na pilha
    stw     ra, 0(sp)       # Salva o registrador ra

main_loop:
    # Representa interrupção caso receba sinal de parada
    bne r4, r0, CRONOMETRO_END         

    # Espera aproximadamente 1 segundo
    call    delay_1s       

muda_unidades:    
    # Incrementa as unidades
    addi    r16, r16, 1      
    beq     r16, r20, muda_dezenas  # Vai para dezenas se unidades == 10

    call    unidades_fim

    br      main_loop
unidades_fim:
    subi    sp, sp, 16      # Reserva espaço na pilha
    stw     ra, 0(sp)       # Salva o registrador ra
	stw		r21, 4(sp)		# Salva o callee-saved r21
	stw		r22, 8(sp)		# Salva o callee-saved r22
	stw		r23, 12(sp)		# Salva o callee-saved r23
	
	
    mov     r23, r16         
    call    convert_to_7seg  # Converte o valor para 7 segmentos
    movia   r21, DISPLAY_BASE  # Endereço base do display
    stbio   r2, 0(r21)      # Atualiza o display (unidades)
	
    ldw 	r23, 12(sp)		# Restaura o callee-saved r23
	ldw 	r22, 8(sp)		# Restaura o callee-saved r22
	ldw 	r21, 4(sp)		# Restaura o callee-saved r21
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 16      # Libera espaço na pilha
	
    ret

muda_dezenas:
    # Incrementa as dezenas e reinicia as unidades
    mov     r16, r0         
    addi    r17, r17, 1      
    beq     r17, r20, muda_centenas  # Vai para centenas se dezenas == 10

    call    dezenas_fim

    br      main_loop
dezenas_fim:
    subi    sp, sp, 16      # Reserva espaço na pilha
    stw     ra, 0(sp)       # Salva o registrador ra
	stw		r21, 4(sp)		# Salva o callee-saved r21
	stw		r22, 8(sp)		# Salva o callee-saved r22
	stw		r23, 12(sp)		# Salva o callee-saved r23

    call      unidades_fim

    mov     r23, r17         
    call    convert_to_7seg  
    movia   r21, DISPLAY_BASE  # Endereço base do display
    addi    r21, r21, 1
    stbio   r2, 0(r21)     # Atualiza o display (dezenas)
    
	ldw 	r23, 12(sp)		# Restaura o callee-saved r23
	ldw 	r22, 8(sp)		# Restaura o callee-saved r22
	ldw 	r21, 4(sp)		# Restaura o callee-saved r21
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 16      # Libera espaço na pilha
	
    ret

muda_centenas:
    # Incrementa as centenas e reinicia as dezenas
    mov     r17, r0         
    addi    r18, r18, 1      
    beq     r18, r20, muda_milhares  # Vai para milhares se centenas == 10

    call    centenas_fim

    br      main_loop
centenas_fim:
    subi    sp, sp, 16      # Reserva espaço na pilha
    stw     ra, 0(sp)       # Salva o registrador ra
	stw		r21, 4(sp)		# Salva o callee-saved r21
	stw		r22, 8(sp)		# Salva o callee-saved r22
	stw		r23, 12(sp)		# Salva o callee-saved r23
    
    call      dezenas_fim

    mov     r23, r18         
    call    convert_to_7seg  
    movia   r21, DISPLAY_BASE  # Endereço base do display
    addi    r21, r21, 2
    stbio   r2, 0(r21)      # Atualiza o display (centenas)

    ldw 	r23, 12(sp)		# Restaura o callee-saved r23
	ldw 	r22, 8(sp)		# Restaura o callee-saved r22
	ldw 	r21, 4(sp)		# Restaura o callee-saved r21
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 16      # Libera espaço na pilha
	
    ret

muda_milhares:
    # Incrementa os milhares e reinicia as centenas
    mov     r18, r0         
    addi    r19, r19, 1      
    beq     r19, r20, reinicia_contador  # Reinicia o cronômetro se milhares == 10

    call    milhares_fim

    br      main_loop
milhares_fim:
    subi    sp, sp, 16      # Reserva espaço na pilha
    stw     ra, 0(sp)       # Salva o registrador ra
	stw		r21, 4(sp)		# Salva o callee-saved r21
	stw		r22, 8(sp)		# Salva o callee-saved r22
	stw		r23, 12(sp)		# Salva o callee-saved r23
    
    call      centenas_fim

    mov     r23, r19         
    call    convert_to_7seg
    movia   r21, DISPLAY_BASE  # Endereço base do display
    addi    r21, r21, 3
    stbio   r2, 0(r21)     # Atualiza o display (milhares)

    ldw 	r23, 12(sp)		# Restaura o callee-saved r23
	ldw 	r22, 8(sp)		# Restaura o callee-saved r22
	ldw 	r21, 4(sp)		# Restaura o callee-saved r21
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 16      # Libera espaço na pilha
    
    ret

reinicia_contador:
    # Reinicia todos os valores
    #mov     r19, r0
    #stw     r0, 0(r21)

    br      main_loop

# Função para esperar 1 segundo
delay_1s:
    subi    sp, sp, 8       # Reserva espaço na pilha
    stw     ra, 0(sp)       # Salva o registrador ra
	stw 	r23, 4(sp)		# Salva o callee-saved r23 
	
    movia   r23, 2850000   # Configura o número de iterações do loop (ajustável)
delay_loop:
    subi    r23, r23, 1       # Decrementa o contador
    bne     r23, r0, delay_loop  
	
	ldw		r23, 4(sp)
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 8       # Libera espaço na pilha
    ret                     # Retorna para o chamador

# Função para converter um valor para o código de 7 segmentos
convert_to_7seg:
    subi    sp, sp, 12      # Reserva espaço na pilha
    stw     ra, 0(sp)       # Salva o registrador ra
	stw		r22, 4(sp)		# Salva o callee-saved r22
	stw		r23, 8(sp)		# Salva o callee-saved r23 
		
    andi    r22, r23, 0x0F   # Isola os 4 bits menos significativos
    beq     r22, r0, DISP7_0
    movi    r23, 1
    beq     r22, r23, DISP7_1
    movi    r23, 2
    beq     r22, r23, DISP7_2
    movi    r23, 3
    beq     r22, r23, DISP7_3
    movi    r23, 4
    beq     r22, r23, DISP7_4
    movi    r23, 5
    beq     r22, r23, DISP7_5
    movi    r23, 6
    beq     r22, r23, DISP7_6
    movi    r23, 7
    beq     r22, r23, DISP7_7
    movi    r23, 8
    beq     r22, r23, DISP7_8
    movi    r23, 9
    beq     r22, r23, DISP7_9 
	
	ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha
	
    ret

# Valores para o display de 7 segmentos
DISP7_0:
    movi    r2, 0x3F        # Código para '0'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha       
    ret

DISP7_1:
    movi    r2, 0x06        # Código para '1'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha    
    ret

DISP7_2:
    movi    r2, 0x5B        # Código para '2'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha     
    ret

DISP7_3:
    movi    r2, 0x4F        # Código para '3'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha   
    ret

DISP7_4:
    movi    r2, 0x66        # Código para '4'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha      
    ret

DISP7_5:
    movi    r2, 0x6D        # Código para '5'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha       
    ret

DISP7_6:
    movi    r2, 0x7D        # Código para '6'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha       
    ret

DISP7_7:
    movi    r2, 0x07        # Código para '7'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha       
    ret

DISP7_8:
    movi    r2, 0x7F        # Código para '8'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha       
    ret

DISP7_9:
    movi    r2, 0x6F        # Código para '9'
    ldw 	r23, 8(sp)		# Restaura o callee-saved r23
	ldw 	r22, 4(sp)		# Restaura o callee-saved r22
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 12      # Libera espaço na pilha      
    ret

CRONOMETRO_END:
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 4       # Libera espaço na pilha

    ret
