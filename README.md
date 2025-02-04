Fazer no Aplicativo

- Movimentações duplicou (não permitir duplicar pelo id_mov)
- Vincular_parceiros duplicou (não permitir duplicar pelo id_venda ou outra coisa)
- Caso laço em dupla, 3 tambores, laço individual for Pendente no cadastro do cliente, aparecer para selecionar a modalide na tela de home

  - Arrumar loading ao cancelar login do google
  - Usuário não pode comprar prova que ele não pode correr (3 tambores, laço individual, laço em dupla)
  - Ao segurar o card da prova, aparecer a súmula em uma modal
  - Aparecer um TabBar contendo as categorias (3 tambores, laço em dupla, laço individual, etc..) na página de evento (onde contem as provas)
    
  - Cadastros de cliente
- Ao cadastrar aparecer "Selecione as Modalidades que deseja competir" e fazer cards para selecionar as modalidades (Simular checkbox)
- Laço em dupla (CADASTRO DO CLIENTE) - aparecer do jeito que tá
- 3 Tambores (CADASTRO DO CLIENTE) - Data de Nascimento, Select de opção do profissional (sim ou não), Genêro/sexo (opcional, selecionar na tela de home depois caso pule)
- Laço Individual (CADASTRO DO CLIENTE) - Handicap laço individual (1, 2, 3, 4)


Cadastro de prova

- 3 Tambores - Venda Avulsa padrão como Sim
- 3 Tambores - Apenas deixar esses campos: Descrição e Quant. Max. Inscrições Pacote Fechado
- 3 Tambores - Campo de selecionar a idade máxima da prova
- 3 Tambores - Campo de selecionar Genêro/Sexo da prova
- 3 Tambores - Campo de selecionar opção de profissional da prova
- 
- Laço em dupla - Venda Avulsa padrão como Sim
- Laço em dupla - Aparecer Quant. Max. Inscrições Pacote Fechado como 1
- 
- Laço Individual - Criar campo de HC Máximo (é outro campo, não pode usar o que já esta criado)
- Laço Individual  - Apenas deixar esses campos: Descrição e Quant. Max. de Inscrições



Na Página de Provas

- 3 Tambores selecionar o animal para mostrar as provas (ou mostrar o animal que está como Padrão)
- 3 Tambores aparecer somente as provas que o animal e o competidor pode correr
- 3 Tambores embaixo do tabbar vai ter um input de selecionar o animal
- 
- Laço Individual só clicar no card e comprar
- 
- Permissão Compra Ordenada -> Só pode comprar as provas se comprou a prova anterior, ex: Eu só posso comprar a prova 2 se eu comprar a prova 1 primeiro (1 ou 2, pegar pela sequencia)
- Permissão de Selecionar animal de outra pessoa









======================================= ATUALIZAÇÕES ==================================================

- [X] Selecionar o Handicap pelo select que vem do banco de dados na hora do cadastro
- [X] Quando for login social ele, tem que abrir uma tela para selecionar o handicap dele
- [X] Não pode permitir compra sem o cliente ter Handicap
- [X] Arrumar tela quando a inscrição não está pago
- [X] Competidor com Handicap mínimo e máximo na prova (Handicap não permitido para essa Somatória.)
- [X] Arrumar informações que mostram quando clica na inscrição (Ex. Data do evento formatação).
- [X] Melhorar código para retorno de dados do cliente (entrar.php, verificacao.php) deixar tudo em lugar só
- [X] Fazer data liberação da prova
- [X] Mudar usuário manual na hora de inserir venda no inserir.php em vendas
- [X] Fazer verificação de pagamento do PIX automática tela de venda
- [X] Fazer verificação de pagamento do PIX automática tela de compras
- [X] Fazer ordem de entrada
- [X] Fazer função de excluir conta
- [X] Melhorar Perfil
- [X] Na API retornar somente funções invés de importações
- [X] Quando for login social, pegar a foto da pessoa e não o nome
- [X] Fazer buscar eventos
- [X] Fazer página de editar usuário
- [X] Fazer alguma forma de quando mudar algum dado do usuário, mudar em todo o aplicativo também
- [X] Fazer com que aparece um texto acima de cada textfield na pagina de editar dados
- [X] Fazer botões Termos de Uso e Denunciar nas provas
- [X] Aparecer número de versões no drawer navigator
- [X] Deixar a Ultima versão vir do banco de dados
- [X] Fazer modal de pagamentos
- [X] Fazer quando clicar na foto do evento abrir para melhor visualização
- [X] Melhorar a modal de localização nas provas (ver se colocar latitude e longitude)
- [X] Fazer troca de tema
- [X] Arrumar modo escuro do app
- [X] Colocar "sua somatoria: 5" na ordem de entrada
- [X] Fazer categorias dos eventos na pagina Home
- [X] Fazer propagandas
- [X] Arrumar termos de uso (deixar dados dinâmicos)
- [X] Quando entra no app pela primeira vez, fica carregando infinitamente
- [X] Mudar nome app (nativo)
- [X] Mudar logo app (nativo)
- [X] Fazer com que ao clicar na propaganda, seja carregado tudo de novo (carregar)
- [X] Mudar textos da notificação agendada.
- [X] Fazer verificação caso a data mudou e cancelar notificação caso tenha mudado (zonedSchedule)
- [X] Criar um botão para atualizar calendário
- [X] Fazer com que o botão de salvar na pagina de editar dados do usuario seja fixo
- [X] Verificar nome do cliente se tem espaços ou não
- [X] Deixar fixo o botão de editar forma de pagamento nas inscrições
- [X] Aparecer mensagem de erro quando for excluir a conta e tiver vendas vinculadas.
- [X] Verificar em todo app se existe algum valor que possa vir nulo (compras e ordem de entrada)
- [X] Mudar a forma de mostrar cards compras (vinculados)
- [X] Verificação de e-mail
- [X] (ARRUMAR NO APP) Se ele for 2 ou mais em qqr uma das modalidades, pe ou cabeca, ele nao pode ser menor q 2 na oposta, Por exemplo, Se ele colocar 2 na cabeca, no pe nao pode ser menor q 2 E vice versa
- [X] Ver se quando transferir uma compra que não esteja pago, (caso seja pix) gerar outro pagamento e adicionar o valor da filiação caso o usuário não tenha comprado nenhuma prova daquele evento ainda
- [X] Ver como fazer com o valor da filiação caso tenha comprado duas vendas diferente mas tenha pagado a venda que não tinha o valor da filiação (Ver como obrigar o competidor a pagar a filiação)
- [X] Arrumar botão de atualização
- [X] Ação de Remover prova do carrinho caso for pacote fechado
- [X] Fazer um tabbar em compras (Anteriores, Atuais, Canceladas) <--- Mostrar nessa ordem no tabbar
- [X] Selecionar os inscrições e gerar 1 pagamento para inscrições (pix)
- [X] Colocar mensagem na hora de selecionar parceiros e não ter todos os parceiros selecionados (rever)
- [X] Verificação permitir vincular parceiro na prova (caso perm_vincular_parceiro for igual a Sim, deixar selecionar os parceiros como obrigatorio.)
- [X] Colocar um checkbox de selecionar sorteio na hora de selecionar parceiros e deve ser somente um
- [X] Quantidade máxima de inscrições na PROVA
- [X] Descrição na prova no meio do card
- [X] Listar os parceiros na hora de selecionar, somente se o pagamento da venda dele for como Sim e o Status for como Pendente
- [X] Na hora de selecionar o parceiro não permitir selecionar ele caso já tenha passado o limite de vinculaçoes, se a quantidade vinculações for igual ao de (quant_parceiros -> PACOTE FECHADO OU quant_maxima -> AVULSA) não permitir mais selecionar aquele parceiro.
- [X] Vincular Parceiro não pode listar vendas que está canceladas
- [X] Trocar as ordens do handicap na listagem de parceiros na ordem de entrada
- [X] Arrumar mensagem de erros do app (mensagem virá somente da api)
- [X] Trocar os handicaps na ordem de entrada (somente os parceiros)
- [X] ao clicar na forma de pagamento PIX aparecer um alerta
- [X] permissão de bloquear as vendas, mas quem tem inscrições vinculadas (parceiros) pode comprar
- [X] colocar uma coluna quando a vincular_parceiro for editada
- [X] arrumar competidores no pacote fechado também
- [X] Arrumar ordem de entrada repetida
- [X] Limite de handicap nos parceiros (na hora de escolher)
- [X] Colocar uma permissão de obrigar a cidade quando clicar na prova (OBRIGAR A COLOCAR A CIDADE)
- [X] quando clicar no gerar pagamento aparecer uma modal das inscrições deles para selecionar
- [X] cancelar inscrições indepedente do pagamento (sim ou não)
- [ ] cancelar a inscrição com um bloqueio (exemplo, colocar 0 horas pode cancelar qualquer hora, 2 horas pode cancelar 2 horas antes da prova)
- [X] colocar um carrosel infinito, na pagina_provas, mostrando as fotos que foram vinculadas \*
- [X] fazer para mostrar a inscrição que está agora, pegar por ordem de 1 boi até o ultimo editado + 1, a partir do 2 boi, a ordem vai pegar normal menos a que ta SAT no 1 boi. \*
- [X] quando for transferir os ingressos, transferir também os parceiros vinculados ou ver se é para zerar os parceiros.
- [X] Fazer aparecer em cor amarelo nos parceiros nas compras (caso o parceiro não tenha nenhuma compra)
- [X] Tirar botão de editar forma de pagamento
- [X] quando for transferir os ingressos, transferir também os parceiros vinculados ou ver se é para zerar os parceiros. \*
- [X] Banco de competidores (Botão de ver competidores que já compraram e tem a inscrição como sorteio mostrar na modal de detalhes da prova (somente informação)) colocar o botão no whatsapp para entrar em contato com o competidor \*
- [X] Fazer botão de reembolsar venda \*
- [X] Fazer vinculação de provas na lista_competicacao na hora de mostrar provas ao vivo (que agora não é mais provas é por lista_competicao), juntar as ordem de entradas das provas vinculadas (ORDEM CRESCENTE NÚMERO DA INSCRIÇÃO)
- [X] Fazer automatico uma lista de FINAL ordenada pelo ranking se o ranking não tiver null (MAIOR PARA O MENOR, baseado no ranking) (SEMPRE EM BAIXO DE TODAS AS LISTAS)
- [X] Fazer automatico uma lista de RESULTADO FINAL ordenada pelo classificacao se o classificacao não tiver null (MENOR PARA O MAIOR, baseado na classificacao) (SEMPRE EM BAIXO DE TODAS AS LISTAS)
- [ ] Liberação de Compra EVENTO erro
- [X] Ao editar parceiro mudar data e hora edição
- [ ] Ao cancelar inscrição remover do vincular_parceiros se o seu id_vendas for vinculado sozinho, se não, editar o seu id e id_vendas para 0
- [ ] Arrumar notificações
- [X] Colocar Competidores Disponiveis na modal de detalhes da inscrição em compras (ao editar parceiro)
- [X] fazer quant_max_inscricoes_pezeiro e quant_max_inscricoes_cabeceira

403 RG3 SOMA 6 -> São Assaí, Getúlio peba, João Ciliao - Passou do limite e duplicou

401 RG3 SOMA 10 -> tito - DUPLICOU

406 RG3 SOMA 5 -> darci barreto - passou do limite

======================================= SISTEMA WEB ===================================================

- [X] relatorio para filiações prova (colunas -> id (competidor), nome, valor, data)
- [X] Rever gerar pagamanento provas avulsas se possível gerar uma unica linha ou mostrar uma unica linha (SISTEMA)
- [X] remover parceiros vinculados ao excluir inscrição
- [X] nas inscrições na hora de excluir, em vincular_parceiros se for pezeiro editar o id_venda_pezeiro para 0 e o id_pezeiro para 0 ou se for cabeceiro editar id_venda_cabeceira para 0 e o id_cabeceira para 0

======================================= ERROS =========================================================

- [X] arrumar lista de parceiros nas compras, pegar a quantidade exata que está na prova (REVER)
- [X] arrumar quando inserir mais de uma vez a mesma prova, ele retirar do carrinho (REVER)
- [X] Listagem de parceiros nas compras, rever por id_cabeceira e id_pezeiro (está puxando tudo junto)

======================================= PARA FAZER (AVANÇADO) =========================================

[ ] Fazer com que ao clicar na notificação em foreground poder ir para Inscrições, ordem de entrada, perfil e inicio. (somente é possivel em modo background)

======================================= IDEIAS ========================================================

Fazer uma configuração no banco de dados, caso a pessoa queria que a foto do evento ou propaganda seja

- Cobrir (pode cortar imagem ou não)
- Esticar imagem para preencher o espaço disponível
- Ajustar para a largura (pode cortar imagem ou não)
- Ajustar para a altura (pode sobrar nas horizontais)
- Aparecer imagem toda (sem se preocupar com largura ou altura, dependendo pode sobrar nas laterais)

===================================== DESENVOLVIMENTO PARA PROVA DE 3 TAMBORES ===================================

(BOTES OPÇÕES) LAÇO EM DUPLA - 3 TAMBORES - LAÇO INDIVIDUAL

Perguntas
VOCÊ É COMPETIDOR LAÇO EM DUPLA
VOCÊ É COMPETIDOR DE 3 TAMBORES
VOCÊ PARTICIPA DE LAÇO INDIVIDUAL

Menu categorias
Laço em dupla, 3 tambores

no evento criar coluna, qual tipo de evento (prova de laço (padrão), ou 3 tambores, aparecer pergunta se é pra você ou para outra pessoa)

criar cadastro de cavalos (cliente pode ter mais de um cavalo) campos - nome, nascimento, registro, sexo, raça, propietario, cidade

1 -
Deseja confirmar sua inscrição laçando a cabeça?

2 -
Tem certeza que deseja fazer o pagamento via PIX?
