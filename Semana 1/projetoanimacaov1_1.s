# Animação usando temporizador com interrupção 
# Precisa testar e corrigir possíveis erros

# Endereços
.equ RED_LEDS, 0x10000000     # Endereço dos LEDs vermelhos
.equ SWITCHES, 0x10000040     # Endereço dos switches
.equ TIMER, 0x10002000   # Endereço do temporizador
.equ INT_CTRL, 0x10002020 # Endereço do controlador de interrupções

# Constantes para temporizador
.equ FREQUENCY, 50000000      # Frequência do sistema em Hz
.equ DELAY_MS, 200            # Atraso em milissegundos
.equ TICKS, (FREQUENCY / 1000) * DELAY_MS # Ticks para 200 ms

.global _start

_start:
    # Inicializa os LEDs com um valor inicial
    movia r7, SWITCHES
    movia r8, RED_LEDS
	movia r9, TIMER
	movia r10, INT_CTRL

    # Configura o temporizador
    movia r2, TICKS              # Número de ticks
    stwio r2, 0(r9) # Carrega o timer
    movi r3, 0x7                # Configura o timer (auto-reload, habilita)
    stwio r3, 4(r9) # Escreve configuração no registrador de controle

    # Habilitar interrupções do temporizador
    movi r4, 0x1                # Habilita interrupção do timer
    stwio r4, 0(r10)      # Configura o controlador de interrupções

loop:
    # Lê o estado dos switches
    ldwio r4, 0(r7)             # Lê o valor dos switches
    
    # Verifica se o switch sw0 está abaixado
    andi r5, r4, 0x1            # sw0 é o bit 0
    beq r5, r0, move_left       # Se sw0 estiver abaixado, move para a esquerda    
    br move_right               # Se sw0 estiver levantado, move para a direita

    # Atualiza os LEDs
    br loop                     # Volta para o início do loop

move_left:
    movi r2, 1
    stwio r2, 0(r8)
move_left_loop:
    # Desloca o bit para a esquerda
    slli r2, r2, 1              # Desloca para a esquerda
    stwio r2, 0(r8)             # Atualiza LEDs
    
    # Termina se ultrapassar 9 LEDs (0x100)
    andi r6, r2, 0x100          # Mantém os 9 bits
    bne r6, r0, end_move_left   # Se for 1, reseta
    call delay                   # Chama a função de atraso
    br move_left_loop           # Volta para o início do loop

end_move_left:
    mov r2, r0
    stwio r2, 0(r8)             # Atualiza LEDs
    call delay                   # Chama a função de atraso
    br loop

move_right:
    movi r2, 256
    stwio r2, 0(r8)
move_right_loop:
    # Desloca o bit para a direita
    srli r2, r2, 1              # Desloca para a direita
    stwio r2, 0(r8)             # Atualiza LEDs
    
    # Termina se chegar a 0
    beq r2, r0, end_move_right  # Se já chegou a 0, reseta
    call delay                   # Chama a função de atraso
    br move_right_loop          # Volta para o início do loop

end_move_right:
    mov r2, r0
    stwio r2, 0(r8)             # Atualiza LEDs
    call delay                   # Chama a função de atraso
    br loop

# Função de atraso usando o temporizador
delay:
    wait_for_timer:
        ldwio r5, 12(r9)  # Lê o status do temporizador
        andi r5, r5, 0x1              # Verifica se a interrupção foi acionada
        beq r5, r0, wait_for_timer    # Continua esperando

    # Limpa o status do temporizador
    movi r6, 0x1
    stwio r6, 12(r9)      # Limpa a interrupção

    ret                                # Retorna da função de atraso

end:
    br end                            # Volta para o início do loop