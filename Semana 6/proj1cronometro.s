/************************************************************************** 
Endereços importantes:
7-seg: 0x10000020
***************************************************************************/
.global _start

.equ    DISPLAY_BASE,       0x10000020    # Endereço base do display de 7 segmentos

.org    0x1000
_start:
    # Inicializa os registradores do contador e o stack pointer
    movia   r2, 0          # Unidades
    movia   r3, 0          # Dezenas
    movia   r4, 0          # Centenas
    movia   r5, 0          # Milhares
    movi    r6, 10         # Limite para cada dígito
    movia   r7, DISPLAY_BASE  # Endereço base do display
    movia   sp, 0x2000       # Inicializa o stack pointer na RAM

main_loop:
    # Espera aproximadamente 1 segundo
    call    delay_1s       

muda_unidades:    
    # Incrementa as unidades
    addi    r2, r2, 1      
    beq     r2, r6, muda_dezenas  # Vai para dezenas se unidades == 10
unidades_fim:
    mov     r11, r2         
    call    convert_to_7seg  # Converte o valor para 7 segmentos
    stwio   r8, 0(r7)      # Atualiza o display (unidades)
    br      main_loop

muda_dezenas:
    # Incrementa as dezenas e reinicia as unidades
    mov     r2, r0         
    addi    r3, r3, 1      
    beq     r3, r6, muda_centenas  # Vai para centenas se dezenas == 10
dezenas_fim:
    mov     r11, r3         
    call    convert_to_7seg  
    stwio   r8, 4(r7)      # Atualiza o display (dezenas)
    br      unidades_fim

muda_centenas:
    # Incrementa as centenas e reinicia as dezenas
    mov     r3, r0         
    addi    r4, r4, 1      
    beq     r4, r6, muda_milhares  # Vai para milhares se centenas == 10
centenas_fim:
    mov     r11, r4         
    call    convert_to_7seg  
    stwio   r8, 8(r7)      # Atualiza o display (centenas)
    br      dezenas_fim

muda_milhares:
    # Incrementa os milhares e reinicia as centenas
    mov     r4, r0         
    addi    r5, r5, 1      
    beq     r5, r6, reinicia_contador  # Reinicia o contador se milhares == 10
milhares_fim:
    mov     r11, r5         
    call    convert_to_7seg  
    stwio   r8, 12(r7)     # Atualiza o display (milhares)
    br      centenas_fim

reinicia_contador:
    # Reinicia todos os valores
    mov     r5, r0         
    br      main_loop

# Função para esperar 1 segundo
delay_1s:
    subi    sp, sp, 4       # Reserva espaço na pilha
    stw     ra, 0(sp)       # Salva o registrador ra
    movia   r9, 3           # Configura o número de iterações do loop (ajustável)
delay_loop:
    subi    r9, r9, 1       # Decrementa o contador
    bne     r9, r0, delay_loop  
    ldw     ra, 0(sp)       # Restaura o registrador ra
    addi    sp, sp, 4       # Libera espaço na pilha
    ret                     # Retorna para o chamador

# Função para converter um valor para o código de 7 segmentos
convert_to_7seg:
    subi    sp, sp, 4       # Reserva espaço na pilha
    stw     ra, 0(sp)       
    andi    r8, r11, 0x0F   # Isola os 4 bits menos significativos
    beq     r8, r0, DISP7_0
    movi    r10, 1
    beq     r8, r10, DISP7_1
    movi    r10, 2
    beq     r8, r10, DISP7_2
    movi    r10, 3
    beq     r8, r10, DISP7_3
    movi    r10, 4
    beq     r8, r10, DISP7_4
    movi    r10, 5
    beq     r8, r10, DISP7_5
    movi    r10, 6
    beq     r8, r10, DISP7_6
    movi    r10, 7
    beq     r8, r10, DISP7_7
    movi    r10, 8
    beq     r8, r10, DISP7_8
    movi    r10, 9
    beq     r8, r10, DISP7_9
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

# Valores para o display de 7 segmentos
DISP7_0:
    movi    r8, 0x3F        # Código para '0'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_1:
    movi    r8, 0x06        # Código para '1'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_2:
    movi    r8, 0x5B        # Código para '2'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_3:
    movi    r8, 0x4F        # Código para '3'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_4:
    movi    r8, 0x66        # Código para '4'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_5:
    movi    r8, 0x6D        # Código para '5'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_6:
    movi    r8, 0x7D        # Código para '6'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_7:
    movi    r8, 0x07        # Código para '7'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_8:
    movi    r8, 0x7F        # Código para '8'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

DISP7_9:
    movi    r8, 0x6F        # Código para '9'
    ldw     ra, 0(sp)       
    addi    sp, sp, 4       
    ret

CRONOMETRO_END:
    ret