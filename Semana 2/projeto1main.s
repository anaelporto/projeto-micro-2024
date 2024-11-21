# Processamento principal do programa com a JTAG UART
# Precisa incluir e ajustar as chamadas de funções

.global _start

# Endereço base da JTAG UART
.equ JTAG_UART_BASE, 0x10001000

_start:
    # Inicializa o ponteiro para o endereço da JTAG UART
    movia   r8, JTAG_UART_BASE

	movi r9, 0x30
	movi r10, 0x31
	movi r11, 0x32
	movi r12, 0x33
	movi r13, 0x34
	movi r14, 0x35
	
loop:
    # Lê o próximo byte de dados da JTAG UART
    ldw    r6, 0(r8)  
	andi r6, r6, 0xFF
    # Comparar os valores
    beq     r6, r9, code_00   # Se for '00' (hexadecimal 0x30)
    beq     r6, r10, code_01   # Se for '01' (hexadecimal 0x31)
    beq     r6, r11, code_10   # Se for '10' (hexadecimal 0x32)
    beq     r6, r12, code_11   # Se for '11' (hexadecimal 0x33)
    beq     r6, r13, code_20   # Se for '20' (hexadecimal 0x34)
    beq     r6, r14, code_21   # Se for '21' (hexadecimal 0x35)
    
    # Se nenhum código for reconhecido, fica em loop esperando nova entrada
    br       loop

# Subrotina para o código 00
# Acende i-ésimo LED
code_00:
    ldwio r6, 0(r4)
	andi r6, r6, 0xFF
    # Execute ações para o código 00
	mov r15, r0
    call ANIMALED
	mov r6, r0
    br       loop

# Subrotina para o código 01
# Apaga i-ésimo LED
code_01:
    ldwio r6, 0(r4)
	andi r6, r6, 0xFF
    # Execute ações para o código 01
    movi r15, 1
	call ANIMALED
	mov r6, r0
    br       loop

# Subrotina para o código 10
# Começa animação dos LEDs
code_10:
    # Execute ações para o código 10
    movia   r13, 0x0003
	mov r6, r0
    br       loop

# Subrotina para o código 11
# Para a animação dos LEDs (congela ou encerra?)
code_11:
    # Execute ações para o código 11
    movia   r13, 0x0004
	mov r6, r0
    br    loop

# Subrotina para o código 20
# Inicia cronômetro (key1 gerencia pausa)
code_20:
    # Execute ações para o código 20
    movia   r13, 0x0005
	mov r6, r0
    br       loop

# Subrotina para o código 21
# Cancela cronômetro (encerra)
code_21:
    # Execute ações para o código 21
    movia   r13, 0x0006
	mov r6, r0
    br       loop

FIM_ANIMA1:
    movi r15, 2
	ret
	
FIM_ANIMA2:
    movi r15, 3
	ret
	
ANIMALED:
    beq r15, r0, FIM_ANIMA1
	br FIM_ANIMA2
	