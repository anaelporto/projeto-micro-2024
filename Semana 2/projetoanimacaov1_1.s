# Animação usando temporizador com interrupção 
# Código revisado na semana 2, mas ainda não está totalmente funcional

.equ RED_LEDS, 0x10000000      # Endereço dos LEDs vermelhos (base do mapeamento de memória)
.equ SWITCHES, 0x10000040      # Endereço dos switches (base do mapeamento de memória)
.equ TIMER, 0x10002000         # Endereço do temporizador (base do mapeamento de memória)
.equ INT_CTRL, 0x10002020      # Endereço do controlador de interrupções (base do mapeamento de memória)
.equ FREQUENCY, 50000000      # Frequência do sistema (50 MHz)
.equ DELAY_MS, 200            # Atraso de 200ms
.equ TICKS, (FREQUENCY / 1000) * DELAY_MS  # Ticks para 200ms

.global _start

_start:
    # Inicializa os registradores com os endereços necessários
    movia r7, RED_LEDS         # r7: endereço dos LEDs
    movia r8, TIMER            # r8: endereço do temporizador
    movia r9, INT_CTRL         # r9: endereço do controlador de interrupções
    movia r10, SWITCHES        # r10: endereço dos switches
    movia r11, 0x10002000


    # Configura o temporizador para gerar interrupções a cada 200ms
    movia r2, TICKS            # Carrega o número de ticks (200ms)
    stwio r2, 0(r8)            # Carrega o número de ticks no temporizador
    movi r3, 0x7              # Configura o temporizador para auto-reload e habilita interrupção
    stwio r3, 4(r8)            # Escreve a configuração no registrador de controle do temporizador

    # Configura o controlador de interrupções para o temporizador
    movi r4, 0x1              # Habilita a interrupção do temporizador
    stwio r4, 0(r9)            # Habilita interrupções do temporizador

    # Habilita interrupções globais no processador (CTL3 - IENABLE)
    movi r5, 0x1              # Habilita interrupções globais (bit 0 = 1)
    stwio r5, 0(r11)       # Escreve 1 no endereço de controle de interrupção (configuração do processador)

    # Inicializa os LEDs com o valor inicial (primeiro LED aceso)
    movi r6, 1                # Primeiro LED aceso (1)
    stwio r6, 0(r7)            # Atualiza o estado dos LEDs

    # Loop principal (espera pela interrupção)
loop:
    # Verifica se há interrupções pendentes
    ldwio r6, 10(r11)       # Lê as interrupções pendentes do endereço de IPENDING
    andi r6, r6, 0x1           # Verifica se a interrupção do temporizador (bit 0) está pendente
    beq r6, r0, loop           # Se não houver interrupção pendente, continua no loop

    # Chama a rotina de interrupção
    br interrupt_handler

# Rotina de Interrupção
interrupt_handler:
    # Limpa a interrupção pendente (registrador de IPENDING)
    movi r8, 0x1
    stwio r8, 14(r11)       # Limpa a interrupção do temporizador

    # Lê o valor atual dos LEDs
    ldwio r6, 0(r7)           # Lê o valor atual dos LEDs

    # Lê o estado do switch SW0 (verifica se está levantado ou abaixado)
    ldwio r5, 0(r10)          # Lê o valor dos switches
    andi r5, r5, 0x1          # Verifica o estado de SW0 (bit 0)

    # Se SW0 estiver abaixado (bit 0 = 0), move para a esquerda
    beq r5, r0, move_left

    # Caso contrário, move para a direita
    br move_right

move_left:
    # Desloca o bit para a esquerda (move LEDs para a esquerda)
    slli r6, r6, 1            # Desloca os LEDs para a esquerda
    andi r6, r6, 0x1FF        # Garante que apenas os 9 LEDs sejam usados
    # Se o valor de r6 ultrapassar 9 LEDs (0x100), reseta para o primeiro LED
    beq r6, r0, reset_leds
    br update_leds

move_right:
    # Desloca o bit para a direita (move LEDs para a direita)
    srli r6, r6, 1            # Desloca os LEDs para a direita
    andi r6, r6, 0x1FF        # Garante que apenas os 9 LEDs sejam usados
    # Se o valor de r6 for 0 (todos os LEDs apagados), reseta para o primeiro LED
    beq r6, r0, reset_leds
    br update_leds


reset_leds:
    # Reseta o LED para o primeiro (bit 0 aceso)
    movi r6, 1                # Reseta para o primeiro LED
    br update_leds

update_leds:
    # Atualiza os LEDs com o novo valor
    stwio r6, 0(r7)           # Escreve o valor de volta para os LEDs

    # Retorna da interrupção
    eret                      # Retorna da interrupção e restaura o contexto
