###
# r8 - ponteiro para a jtag uart
# r9 - ponteiro para os leds vermelhos
# r16 - aux / soma dos dig n
# r17 - aux / dig 1
# r18 - aux / dig 2
###

.global _start

# Endereço base da JTAG UART e dos LEDs
.equ JTAG_UART_BASE, 0x10001000
.equ RED_LEDS, 0x10000000  # Endereço para controlar os LEDs (18 LEDs)

_start:
    # Inicializa o ponteiro para o endereço da JTAG UART
    movia   r8, JTAG_UART_BASE
    movia   r9, RED_LEDS

    movi    r10, 0x30      # Caractere '0'
    movi    r11, 0x31      # Caractere '1'
    movi    r12, 0x32      # Caractere '2'
  
loop:
    # Lê o primeiro caractere (comando principal)
    ldwio   r13, 0(r8)          # Lê o primeiro caractere (comando)
    andi    r13, r13, 0xFF        # Máscara para manter os 8 bits
    mov     r14, r13              # Armazena o primeiro dígito do comando em r7

    # Lê o segundo caractere (comando específico)
    ldwio   r13, 0(r8)          # Lê o segundo caractere (comando específico)
    andi    r13, r13, 0xFF
    mov     r15, r13              # Armazena o segundo dígito do comando em r8

    # Verifica o valor do primeiro caractere (seção)
    beq     r14, r10, secao_0      # Se r7 == 0, redireciona para a seção 0
    beq     r14, r11, secao_1      # Se r7 == 1, redireciona para a seção 1
    beq     r14, r12, secao_2      # Se r7 == 2, redireciona para a seção 2

    # Se o comando não for reconhecido, continua aguardando
    br loop

# Seção 1: Comandos de controle de LEDs (Entrada 0)

secao_0:
    # Verifica o segundo caractere e redireciona para a função correta
    beq     r15, r10, comando_00   # Se r8 == 0, acende o LED
    beq     r15, r11, comando_01   # Se r8 == 1, apaga o LED
    br loop                       # Se r8 não for 0 ou 1, aguarda novamente

comando_00:  # Se o comando for '00', acende o LED
    # Lê o número do LED (dois caracteres seguintes)
    ldwio   r16, 0(r8)         # Lê o terceiro caractere (número do LED) em r16
    andi    r16, r16, 0xFF      # Pega apenas os 8 bits necessários
    subi    r16, r16, 0x30      # Converte de ASCII para valor numérico
    mov     r17, r16            # Armazena o primeiro dígito do número do LED em r17

    ldwio   r16, 0(r8)         # Lê o quarto caractere (número do LED) em r16
    andi    r16, r16, 0xFF      # Pega apenas os 8 bits necessários
    subi    r16, r16, 0x30      # Converte de ASCII para valor numérico
    mov     r18, r16            # Armazena o segundo dígito do número do LED em r18

    # Junta os dois dígitos para formar o número completo do LED
    muli    r16, r17, 10       # Multiplica o primeiro dígito por 10 e salva em r16
    add     r16, r16, r18       # Soma o segundo dígito para formar o número do LED (1-18)

    # Verifica se o número do LED é válido (de 1 a 18)
    # Verifica se o número do LED é menor que 1
    subi    r17, r16, 1         # Subtrai 1 de r16 e salva em r17
    blt     r17, r0, loop       # Testa r17 e se for menor que 1 não faz nada

    # Verifica se o número do LED é maior que 18
    subi    r17, r16, 18        # Subtrai 18 de r16 e salva em r17
    bgt     r17, r0, loop       # Testa r17 e se for maior que 18 não faz nada

    # Ajusta o número para o índice de 0 a 17 (para LEDs de 1 a 18)
    subi    r16, r16, 1         # Ajusta r16 para manter o número do LED de 0 a 17

    # Desloca o bit para a posição correta (1 a 18) em r12
    movi    r17, 1              # Carrega 1 em r17
    sll     r17, r17, r16        # Desloca 1 para a posição do LED correspondente

    # Lê o valor atual dos LEDs
    ldwio   r16, 0(r9)          # Lê o valor atual dos LEDs (r16)

    # Acende o LED (fazendo um bit OR com 1)
    or      r16, r16, r17       # Acende o LED correspondente ao bit
    stwio   r16, 0(r9)          # Escreve no endereço dos LEDs (acende o LED)

    br loop

comando_01:  # Se o comando for '01', apaga o LED
    # Lê o número do LED (dois caracteres seguintes)
    ldwio   r16, 0(r8)         # Lê o terceiro caractere (número do LED) em r16
    andi    r16, r16, 0xFF      # Pega apenas os 8 bits necessários
    subi    r16, r16, 0x30      # Converte de ASCII para valor numérico
    mov     r17, r16            # Armazena o primeiro dígito do número do LED em r17

    ldwio   r16, 0(r8)         # Lê o quarto caractere (número do LED) em r16
    andi    r16, r16, 0xFF      # Pega apenas os 8 bits necessários
    subi    r16, r16, 0x30      # Converte de ASCII para valor numérico
    mov     r18, r16            # Armazena o segundo dígito do número do LED em r18

    # Junta os dois dígitos para formar o número completo do LED
    muli    r16, r17, 10       # Multiplica o primeiro dígito por 10 e salva em r16
    add     r16, r16, r18       # Soma o segundo dígito para formar o número do LED (1-18)

    # Verifica se o número do LED é válido (de 1 a 18)
    # Verifica se o número do LED é menor que 1
    subi    r17, r16, 1         # Subtrai 1 de r16 e salva em r17
    blt     r17, r0, loop       # Testa r17 e se for menor que 1 não faz nada

    # Verifica se o número do LED é maior que 18
    subi    r17, r16, 18        # Subtrai 18 de r16 e salva em r17
    bgt     r17, r0, loop       # Testa r17 e se for maior que 18 não faz nada

    # Ajusta o número para o índice de 0 a 17 (para LEDs de 1 a 18)
    subi    r16, r16, 1         # Ajusta r16 para manter o número do LED de 0 a 17

    # Desloca o bit para a posição correta (1 a 18) em r12
    movi    r17, 1              # Carrega 1 em r17
    nor     r17, r17, r17       # Inverte r17
    rol     r17, r17, r16        # Desloca 0 para a posição do LED correspondente

    # Lê o valor atual dos LEDs
    ldwio   r16, 0(r9)          # Lê o valor atual dos LEDs (r16)

    # Acende o LED (fazendo um bit OR com 1)
    and     r16, r16, r17       # Apaga o LED correspondente ao bit
    stwio   r16, 0(r9)          # Escreve no endereço dos LEDs (acende o LED)

    br loop

# Seção 2: Comandos de animação (Entrada 1)

secao_1:
    # Lógica para animação (não implementada, exemplo genérico)
    br loop

# Seção 3: Comandos de status (Entrada 2)
secao_2:
    # Lógica para exibir status ou outra operação (não implementada)
    br loop