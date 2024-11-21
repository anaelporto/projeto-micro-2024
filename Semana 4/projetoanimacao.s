# Animação usando temporizador sem interrupção
# Funcionando, isolado e melhorado - Semana 4

/*
Registradores utilizados e funcionalidades:

r16 - armazena ponteiro que recebe o endereço dos switches
r17 - armazena ponteiro que recebe o endereço dos leds vermelhos
r18 - variável auxiliar de leitura do estado do switch SW0
r19 - variável auxiliar para testar estado do switch SW0
r20 - variável que recebe o valor inicial do bit que será deslocado na animação
r21 - contador utilizado para produzir o atraso de 200ms
r22 - variável auxiliar para testar os limites inferior e superior

 */

# Endereços base dos LEDs vermelhos e dos Switches
.equ RED_LEDS, 0x10000000         # Endereço dos LEDs vermelhos
.equ SWITCHES, 0x10000040         # Endereço dos switches

# Constantes para temporizador
.equ FREQUENCY, 27000000          # Frequência do sistema em Hz
.equ DELAY_MS, 60                 # Atraso em milissegundos (testado na placa, gera aprox 200 ms de delay)
.equ TICKS, (FREQUENCY / 1000) * DELAY_MS # Ticks para 200ms

.global ANIMALEDS

ANIMALEDS:
    movia r16, SWITCHES			  # Inicializando Switches
    movia r17, RED_LEDS			  # Inicializando LEDs

    movi r5, 1
loop:
    beq r4, r5, end               # Representa implementação de r5 em memória caso receba sinal de parada

    ldwio r18, 0(r16)             # Lê o estado dos switches
    
    # Verifica se o switch sw0 está abaixado
    andi r19, r18, 0x1 			  # Testa o estado do Switch SW0
    beq r19, r0, move_left        # Se sw0 estiver abaixado, move para a esquerda    
    br move_right                 # Se sw0 estiver levantado, move para a direita

# Animação para a esquerda
move_left:
    movi r20, 0x1				  # Valor inicial do LED 0 para começar
    stwio r20, 0(r17)             # Atualiza LEDs
    br delay                      # Chama a função de atraso
move_left_main:
    movia r22, 0x20000			  # Valor do 18º LED
    and r19, r20, r22             # Testando se chegou no 18º LED
    bne r19, r0, end_move_left	  # Se chegou, recomeça
	
    slli r20, r20, 1              # Desloca o bit para a esquerda
    stwio r20, 0(r17)             # Atualiza LEDs
    
    br delay                      # Chama a função de atraso
end_move_left:
	movi r20, 0x1				  # Valor inicial do LED 0 para recomeçar
    stwio r20, 0(r17)             # Atualiza LEDs
	br loop						  # Retorna para o loop inicial
	
# Animação para a direita
move_right:
    movia r20, 0x20000			  # Valor inicial do LED 17 para começar
    stwio r20, 0(r17)             # Atualiza LEDs
    br delay                      # Chama a função de atraso
move_right_main:
	movi r22, 0x1				  # Valor do 1º LED 
    beq r20, r22, end_move_right  # Se chegou no 1º LED, recomeça
	
    srli r20, r20, 1              # Desloca o bit para a direita
    stwio r20, 0(r17)             # Atualiza LEDs
   
    br delay                      # Chama a função de atraso
end_move_right:
	movia r20, 0x20000			  # Valor inicial do led 17 para recomeçar
    stwio r20, 0(r17)			  # Atualiza LEDs
	br loop						  # Retorna para o loop inicial
	
# Função de atraso de 200 ms
delay:
    movia r21, TICKS              # Carrega o número de ticks
delay_loop:
    subi r21, r21, 1              # Decrementa o contador
    bne r21, r0, delay_loop       # Continua até que r1 seja zero
	
	ldwio r18, 0(r16)             # Lê o estado dos switches
	andi r19, r18, 0x1 			  # Testa o estado do Switch SW0
    
	beq r19, r0, move_left_main   # Retorna da função de atraso para animação à esquerda
    br move_right_main            # Retorna da função de atraso para animação à direita

end:
    br end                        # Retorna da chamada