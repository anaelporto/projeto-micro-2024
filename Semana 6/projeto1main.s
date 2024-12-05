/*
Função principal que exibe o prompt na UART e chama as outras funções
Deve solicitar uma entrada e armazenar no buffer
Como é caller, aqui deve-se usar os registradores r8-r15

Funcionando e melhorada - Semana 6

Registradores utilizados e funcionalidades:

r8 - ponteiro para a jtag uart
r9 - auxiliar para testar valores de entrada
r10 - aux / teste do caractere 0
r11 - aux / teste do caractere 1
r12 - aux / teste do caractere 2
r13 - leitura de caracteres
r14 - armazena o primeiro dígito lido
r15 - armazena o segundo dígito lido

*/

.global _start

# Endereço base da JTAG UART e dos LEDs
.equ JTAG_UART_BASE, 0x10001000

_start:
    # Inicializa o ponteiro para o endereço da JTAG UART
    movia   r8, JTAG_UART_BASE

    movi    r10, 0x30      # Caractere '0'
    movi    r11, 0x31      # Caractere '1'
    movi    r12, 0x32      # Caractere '2'
  
    br menu
loop:
    # Lê o primeiro caractere (comando principal)
    ldwio   r13, 0(r8)          # Lê o primeiro caractere (comando)
    andi    r13, r13, 0xFF        # Máscara para manter os 8 bits
    mov     r14, r13              # Armazena o primeiro dígito do comando em r14

    # Lê o segundo caractere (comando específico)
    ldwio   r13, 0(r8)          # Lê o segundo caractere (comando específico)
    andi    r13, r13, 0xFF
    mov     r15, r13              # Armazena o segundo dígito do comando em r15

    # Verifica se a segunda entrada é menor que 0 ou maior que 1
    subi    r9, r15, 1         # Subtrai 1 de r15 e salva em r9
    blt     r9, r0, menu       # Testa r9 e se for menor que 0 não faz nada
    bgt     r9, r0, menu       # Testa r9 e se for maior que 0 não faz nada

    # Armazena o segundo valor para determinar a ação
    subi r4, r15, 0x30

    # Verifica o valor do primeiro caractere (seção)
    beq     r14, r10, comando_0X      # Se r14 == 0, redireciona para a seção 0
    beq     r14, r11, comando_1X      # Se r14 == 1, redireciona para a seção 1
    beq     r14, r12, comando_2X      # Se r14 == 2, redireciona para a seção 2

    # Se o comando não for reconhecido, continua aguardando
    br menu

# Seção 1: Comandos de controle de LEDs (Entrada 0)

comando_0X:  # Se o comando for '0X', acende ou apaga o LED
    call MUDALEDS

    br loop

# Seção 2: Comandos de animação (Entrada 1)

comando_1X:  
    call ANIMALEDS

    br loop

# Seção 3: Comandos de cronômetro (Entrada 2)

comando_2X:  # Se o comando for '20', acende o LED
    call CRONOMETRO

    br loop

menu:

    br loop
