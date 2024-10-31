# Endereços
.equ RED_LEDS, 0x10000000     # Endereço dos LEDs vermelhos
.equ SWITCHES, 0x10000040     # Endereço dos switches
.equ TIMER, 0x10002000        # Endereço do temporizador

# Constantes para temporizador
.equ FREQUENCY, 50000000      # Frequência do sistema em Hz
.equ DELAY_MS, 2            # Atraso em milissegundos
.equ TICKS, (FREQUENCY / 1000) * DELAY_MS # Ticks para 200 ms

.global _start

_start:
    # Inicializa os LEDs com um valor inicial
    movia r7, SWITCHES
    movia r8, RED_LEDS

loop:
    # Lê o estado dos switches
    ldwio r4, 0(r7)              # Lê o valor dos switches
    
    # Verifica se o switch sw0 está abaixado
    andi r5, r4, 0x1             # sw0 é o bit 0
    beq r5, r0, move_left        # Se sw0 estiver abaixado, move para a esquerda    
    br move_right                # Se sw0 estiver levantado, move para a direita

move_left:
    movi r2, 1
    stwio r2, 0(r8)
	call delay  
move_left_loop:
    # Desloca o bit para a esquerda
    slli r2, r2, 1               # Desloca para a esquerda
    stwio r2, 0(r8)              # Atualiza LEDs
    
    # Termina se ultrapassar 9 LEDs (0x100)
    andi r6, r2, 0x100           # Mantém os 9 bits
    bne r6, r0, end_move_left    # Se for 1, reseta
    call delay                   # Chama a função de atraso
    br move_left_loop            # Volta para o início do loop

end_move_left:
    mov r2, r0
    stwio r2, 0(r8)              # Atualiza LEDs
    call delay                   # Chama a função de atraso
    br loop

move_right:
    movi r2, 256
    stwio r2, 0(r8)
	call delay  
move_right_loop:
    # Desloca o bit para a direita
    srli r2, r2, 1               # Desloca para a direita
    stwio r2, 0(r8)              # Atualiza LEDs
    
    # Termina se chegar a 0
    beq r2, r0, end_move_right   # Se já chegou a 0, reseta
    call delay                   # Chama a função de atraso
    br move_right_loop           # Volta para o início do loop

end_move_right:
    mov r2, r0
    stwio r2, 0(r8)              # Atualiza LEDs
    call delay                   # Chama a função de atraso
    br loop

# Função de atraso de 200 ms
delay:
    movia r11, TICKS               # Carrega o número de ticks
delay_loop:
    nop                          # Faz uma operação nula para consumir tempo
    nop                          # Adicione mais nops se necessário para ajustar o tempo
    nop                          # Adicione mais nops se necessário para ajustar o tempo
    nop                          # Adicione mais nops se necessário para ajustar o tempo
    nop                          # Adicione mais nops se necessário para ajustar o tempo
    subi r11, r11, 1               # Decrementa o contador
    bne r11, r0, delay_loop       # Continua até que r1 seja zero
    ret                           # Retorna da função de atraso

end:
    br end                        # Volta para o início do loop