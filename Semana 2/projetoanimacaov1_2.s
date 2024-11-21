# Animação usando temporizador sem interrupção
# Funcionando e melhorado - semana 2

/*
Registradores:

r8 = armazena ponteiro que recebe o endereço dos switches
r9 = armazena ponteiro que recebe o endereço dos leds vermelhos
r10 = variável auxiliar de leitura do estado do switch SW0
r11 = variável auxiliar para testar estado do switch SW0
r12 = variável que recebe o valor inicial do bit que será deslocado na animação
r13 = contador utilizado para produzir o atraso de 200ms
r14 = variável auxiliar para testar os limites inferior e superior

 */

# Endereços
.equ RED_LEDS, 0x10000000         # Endereço dos LEDs vermelhos
.equ SWITCHES, 0x10000040         # Endereço dos switches

# Constantes para temporizador
.equ FREQUENCY, 27000000          # Frequência do sistema em Hz
.equ DELAY_MS, 60                 # Atraso em milissegundos (testado na placa, gera aprox 200 ms de delay)
.equ TICKS, (FREQUENCY / 1000) * DELAY_MS # Ticks para 200ms

.global _start

_start:
    movia r8, SWITCHES			  # Inicializando Switches
    movia r9, RED_LEDS			  # Inicializando LEDs

loop:
    ldwio r10, 0(r8)              # Lê o estado dos switches
    
    # Verifica se o switch sw0 está abaixado
    andi r11, r10, 0x1 			  # Testa o estado do Switch SW0
    beq r11, r0, move_left        # Se sw0 estiver abaixado, move para a esquerda    
    br move_right                 # Se sw0 estiver levantado, move para a direita

# Animação para a esquerda
move_left:
    movi r12, 0x1				  # Valor inicial do LED 0 para começar
    stwio r12, 0(r9)              # Atualiza LEDs
    br delay                      # Chama a função de atraso
move_left_main:
    movia r14, 0x20000			  # Valor do 18º LED
    and r11, r12, r14             # Testando se chegou no 18º LED
    bne r11, r0, end_move_left	  # Se chegou, recomeça
	
    slli r12, r12, 1              # Desloca o bit para a esquerda
    stwio r12, 0(r9)              # Atualiza LEDs
    
    br delay                      # Chama a função de atraso
end_move_left:
	movi r12, 0x1				  # Valor inicial do LED 0 para recomeçar
    stwio r12, 0(r9)              # Atualiza LEDs
	br loop						  # Retorna para o loop inicial
	
# Animação para a direita
move_right:
    movia r12, 0x20000			  # Valor inicial do LED 17 para começar
    stwio r12, 0(r9)              # Atualiza LEDs
    br delay                      # Chama a função de atraso
move_right_main:
	movi r14, 0x1				  # Valor do 1º LED 
    beq r12, r14, end_move_right  # Se chegou no 1º LED, recomeça
	
    srli r12, r12, 1              # Desloca o bit para a direita
    stwio r12, 0(r9)              # Atualiza LEDs
   
    br delay                      # Chama a função de atraso
end_move_right:
	movia r12, 0x20000			  # Valor inicial do led 17 para recomeçar
    stwio r12, 0(r9)			  # Atualiza LEDs
	br loop						  # Retorna para o loop inicial
	
# Função de atraso de 200 ms
delay:
    movia r13, TICKS              # Carrega o número de ticks
delay_loop:
    subi r13, r13, 1              # Decrementa o contador
    bne r13, r0, delay_loop       # Continua até que r1 seja zero
	
	ldwio r10, 0(r8)              # Lê o estado dos switches
	andi r11, r10, 0x1 			  # Testa o estado do Switch SW0
    
	beq r11, r0, move_left_main   # Retorna da função de atraso para animação à esquerda
    br move_right_main            # Retorna da função de atraso para animação à direita

end:
    br end                        # Volta para o início do loop