# projeto-micro-2024
<h1>Relatório do Projeto: Prompt de Comandos em Assembly</h1>
<h2>Grupo: Anael Porto, Daniel Requena e Eric Perdigão</h2>
<h3>Proposta:</h3>
<p>Ao longo do semestre, foram desenvolvidas várias atividades ao fim de cada dia letivo. Com posse desse conhecimento, temos a proposta atual do projeto, que é a de usar tudo que já foi aprendido com cada atividade, em um só “programa”, para implementar um prompt de comando que interage com a placa através de comandos pela UART, que permite acender e apagar LEDs, fazer uma animação de deslocamento para ambos os lados e iniciar e parar um cronômetro que é exibido no display de 7 segmentos.</p>
<h3>Cronograma:</h3>
<p>Semana 1 - Estruturar LEDs <br/>
Semana 2 - Criar animação <br/>
Semana 3 - Implementar a ordem/direção da animação <br/>
Semana 4 - Implementar o cronômetro <br/>
Semana 5 - Implementar chamadas pela UART <br/> 
Semana 6 - Estruturar o prompt na UART</p>
<h3>Metodologia:</h3>
<p>O projeto será implementado em Assembly e testado no simulador https://cpulator.01xz.net/?sys=nios-de2-115 remotamente, além de ser testado presencialmente durante o horário das aulas e fora do horário quando necessário e possível para algum dos membros.</p>
<h3>Desenvolvimento:</h3>
<p>Semana 1: Durante a primeira semana, houve o foco na estruturação dos LEDs e na criação de um modelo simples de animação dos LEDs da placa, pois já havíamos trabalhado com essa parte nas primeiras aulas e seu nível de dificuldade foi um dos mais simples, embora a implementação da animação fosse um adicional na dificuldade, ainda acreditamos que é a parte mais simples do projeto. Aproveitamos também para dar início a estruturação do arquivo principal, que conterá o prompt responsável pela chamada de todas as funções que serão usadas neste projeto.<br/> <br/>
Semana 2: Fazer o LED funcionar não foi trabalhoso, mas acabamos levando mais tempo do que o previsto inicialmente pois sua animação acabou sendo mais trabalhosa do que esperado. Esperávamos concluir essa etapa até a semana 2, mas como está envolvida com várias partes do projeto pode ser que seja necessário mais tempo. Fizemos também a maior parte da UART, já que seu código estava praticamente pronto devido a sua implementação em aula, só precisamos ajustar para nosso modelo de projeto.<br/> <br/>
Semana 3: Durante essa semana foram atualizados os códigos para a animação dos LEDs e do arquivo main, como nessa semana o grupo no geral teve dificuldades com o tempo, preferimos refinar o que já havia sido feito até então, ao invés de iniciar outra parte do projeto.<br/> <br/>
Semana 4: Nesta semana continuamos a atualização do arquivo main, tendo em vista que iniciaremos a ultima funcionalidade restante, atualizamos também o arquivo de animação. Em específico, começamos a trabalhar no cronômetro e a mudança dos LEDs através de comandos pela UART. Montamos a maior parte de ambos os programas, porém, houve certa dificuldade em fazê-los funcionar de forma apropriada, já que inicialmente não se apagava ou ligava o LED correto quando passamos a informação pelo UART, o próprio UART não estava funcionando corretamente, mas o acertamos sem maiores dificuldades, já com o cronômetro, seu tempo parece não estar sendo o que estipulamos.<br/> <br/>
Semana 5: Continuamos tentando a atualização a respeito da main para o modelo de interrupções, mexemos na animação do LED e também na mudança de estados do LED (liga/desliga), pois encontramos abordagens mais apropriadas para o funcionamento do código. Estamos também finalizando acertos com respeito ao cronômetro, que se mostrou um verdadeiro desafio.<br/> <br/>
Semana 6: Ao término dessa semana, conseguimos que o prompt, o acender e apagar de LEDs e a animação se mostrem perfeitamente funcionais, entretanto, o cronômetro acabou por apresentar maior dificuldade do que o esperado durante a integração, rendendo uma implementação minimalista adaptada ao sistema sem o uso de interrupções.</p>
<h3>Conclusão:</h3>
<p>Foi possível implementar boa parte do projeto de forma simples e direta, entretanto, devido a alguns problemas de horário e confusão de conceitos, optamos por revisar os códigos implementados durante o andamento do projeto e isso acabou dificultando um pouco o término do desenvolvimento. O código contém todas as funcionalidades requisitadas, mas não foi possível implementar no modelo de interrupção adequadamente até o tempo limite. Diante disso, pretendemos seguir melhorando o projeto quando possível para que ele atinja o nível ideal.</p>
