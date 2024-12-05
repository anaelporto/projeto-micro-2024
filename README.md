# projeto-micro-2024
Projeto final da disciplina de Microprocessadores

Grupo: Anael Porto, Daniel Requena e Eric Perdigão

Relatório do Projeto:

Proposta: 
    Ao longo do semestre, foram desenvolvidas várias atividades ao fim de cada dia letivo. Com posse desse conhecimento, temos a proposta atual do projeto, que é a de usar tudo que já foi aprendido com cada atividade, em um só “programa”, para implementar um prompt de comando que interage com a placa através de comandos pela UART, que permite acender e apagar LEDs, fazer uma animação de deslocamento para ambos os lados e iniciar e parar um cronômetro que é exibido no display de 7 segmentos.

Cronograma:
    Semana 1 - Estruturar LEDs
    Semana 2 - Criar animação
    Semana 3 - Implementar a ordem/direção da animação
    Semana 4 - Implementar o cronômetro
    Semana 5 - Implementar chamadas pela UART
    Semana 6 - Estruturar o prompt na UART

Metodologia: 
    O projeto será implementado em Assembly e testado no simulador https://cpulator.01xz.net/?sys=nios-de2-115 remotamente, além de ser testado presencialmente durante o horário das aulas e fora do horário quando necessário e possível para algum dos membros.

Desenvolvimento:
    Semanas 1 e 2: Durante as duas primeiras semanas, houve o foco na animação dos leds da placa, pois já havíamos trabalhado com a ativação dos LEDs antes e embora a animação fosse uma dificuldade a mais, ainda era a parte mais simples do projeto. Aproveitamos também para dar início a estruturação do arquivo principal, responsável pelo chamado de todas as funções que serão usadas neste projeto.

        Fazer o LED funcionar não foi trabalhoso, mas acabamos levando mais tempo do que o previsto inicialmente pois sua animação acabou sendo mais trabalhosa do que esperado, temos a previsão de finalizá-la durante a próxima semana, mas como está envolvida com várias partes do projeto pode ser que seja necessário mais tempo.

        Fizemos também a maior parte da Uart, já que seu código estava praticamente pronto devido a sua implementação em aula, só precisamos deixar parte de sua implementação no aguardo.

    Semana 3: Durante essa semana foram atualizados os códigos para a animação dos LEDs e do arquivo main, como nessa semana o grupo no geral teve dificuldades com o tempo, preferimos refinar o que já havia sido feito até então, ao invés de iniciar outra parte do projeto.

    Semana 4: Nesta semana continuamos a atualização do arquivo main, já que a cada nova chamada, temos uma nova função para o main, atualizamos também o arquivo de animação. Em específico, começamos a trabalhar no cronômetro e a mudança dos LEDs através de comandos pela UART, montamos a maior parte de ambos os programas, porém, houve certa dificuldade em fazê-los funcionar de forma apropriada, já que inicialmente não se apaga ou liga a LED correta quando passamos a informação pelo UART, já com o cronômetro que estamos usando como auxílio, seu tempo parece não estar sendo o que estipulamos.

    Semana 5: Mantemos atualização a respeito da main e mexemos na animação do LED e também com a mudança de estados do LED (liga/desliga), pois encontramos abordagens mais apropriadas para o funcionamento das funcionalidades. Estamos também finalizando acertos com respeito ao cronômetro que está quase calibrado.

    Semana 6: O prompt, o acender e apagar de LEDs e a animação se mostraram perfeitamente funcionais, entretanto, o cronômetro apresentou maior dificuldade do que o esperado durante a integração, rendendo uma implementação minimalista adaptada ao sistema sem o uso de interrupções.

Conclusão: 
    Foi possível implementar boa parte do projeto de forma simples e direta, entretanto, devido a alguns problemas de horário e confusão de conceitos, optamos por revisar os códigos implementados durante o andamento do projeto e isso acabou dificultando um pouco o término do desenvolvimento. O código contém todas as funcionalidades requisitadas, mas não foi possível implementar no modelo de interrupção adequadamente até o tempo limite. Diante disso, pretendemos seguir melhorando o projeto quando possível para que ele atinja o nível ideal.