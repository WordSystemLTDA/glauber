======================================= ATUALIZAÇÕES ==================================================

- [x] Selecionar o Handicap pelo select que vem do banco de dados na hora do cadastro
- [x] Quando for login social ele, tem que abrir uma tela para selecionar o handicap dele
- [x] Não pode permitir compra sem o cliente ter Handicap
- [x] Arrumar tela quando a inscrição não está pago
- [x] Competidor com Handicap mínimo e máximo na prova (Handicap não permitido para essa Somatória.)
- [x] Arrumar informações que mostram quando clica na inscrição (Ex. Data do evento formatação).
- [x] Melhorar código para retorno de dados do cliente (entrar.php, verificacao.php) deixar tudo em lugar só
- [x] Fazer data liberação da prova
- [x] Mudar usuário manual na hora de inserir venda no inserir.php em vendas
- [x] Fazer verificação de pagamento do PIX automática tela de venda
- [x] Fazer verificação de pagamento do PIX automática tela de compras
- [x] Fazer ordem de entrada
- [x] Fazer função de excluir conta
- [x] Melhorar Perfil
- [x] Na API retornar somente funções invés de importações
- [x] Quando for login social, pegar a foto da pessoa e não o nome
- [x] Fazer buscar eventos
- [x] Fazer página de editar usuário
- [x] Fazer alguma forma de quando mudar algum dado do usuário, mudar em todo o aplicativo também
- [x] Fazer com que aparece um texto acima de cada textfield na pagina de editar dados
- [x] Fazer botões Termos de Uso e Denunciar nas provas
- [x] Aparecer número de versões no drawer navigator
- [x] Deixar a Ultima versão vir do banco de dados
- [x] Fazer modal de pagamentos
- [x] Fazer quando clicar na foto do evento abrir para melhor visualização
- [x] Melhorar a modal de localização nas provas (ver se colocar latitude e longitude)
- [x] Fazer troca de tema
- [x] Arrumar modo escuro do app
- [x] Colocar "sua somatoria: 5" na ordem de entrada
- [x] Fazer categorias dos eventos na pagina Home
- [x] Fazer propagandas
- [x] Arrumar termos de uso (deixar dados dinâmicos)
- [x] Quando entra no app pela primeira vez, fica carregando infinitamente
- [x] Mudar nome app (nativo)
- [x] Mudar logo app (nativo)
- [x] Fazer com que ao clicar na propaganda, seja carregado tudo de novo (carregar)
- [x] Mudar textos da notificação agendada.
- [x] Fazer verificação caso a data mudou e cancelar notificação caso tenha mudado (zonedSchedule)
- [x] Criar um botão para atualizar calendário
- [x] Fazer com que o botão de salvar na pagina de editar dados do usuario seja fixo
- [x] Verificar nome do cliente se tem espaços ou não
- [x] Deixar fixo o botão de editar forma de pagamento nas inscrições
- [x] Aparecer mensagem de erro quando for excluir a conta e tiver vendas vinculadas.
- [x] Verificar em todo app se existe algum valor que possa vir nulo (compras e ordem de entrada)
- [x] Mudar a forma de mostrar cards compras (vinculados)
- [x] Verificação de e-mail
- [x] (ARRUMAR NO APP) Se ele for 2 ou mais em qqr uma das modalidades, pe ou cabeca, ele nao pode ser menor q 2 na oposta, Por exemplo, Se ele colocar 2 na cabeca, no pe nao pode ser menor q 2 E vice versa
- [x] Ver se quando transferir uma compra que não esteja pago, (caso seja pix) gerar outro pagamento e adicionar o valor da filiação caso o usuário não tenha comprado nenhuma prova daquele evento ainda
- [x] Ver como fazer com o valor da filiação caso tenha comprado duas vendas diferente mas tenha pagado a venda que não tinha o valor da filiação (Ver como obrigar o competidor a pagar a filiação)
- [x] Arrumar botão de atualização
- [x] Ação de Remover prova do carrinho caso for pacote fechado
- [x] Fazer um tabbar em compras (Anteriores, Atuais, Canceladas) <--- Mostrar nessa ordem no tabbar
- [x] Selecionar os inscrições e gerar 1 pagamento para inscrições (pix)
- [x] Colocar mensagem na hora de selecionar parceiros e não ter todos os parceiros selecionados (rever)
- [x] Verificação permitir vincular parceiro na prova (caso perm_vincular_parceiro for igual a Sim, deixar selecionar os parceiros como obrigatorio.)
- [x] Colocar um checkbox de selecionar sorteio na hora de selecionar parceiros e deve ser somente um
- [x] Quantidade máxima de inscrições na PROVA
- [x] Descrição na prova no meio do card
- [x] Listar os parceiros na hora de selecionar, somente se o pagamento da venda dele for como Sim e o Status for como Pendente
- [x] Na hora de selecionar o parceiro não permitir selecionar ele caso já tenha passado o limite de vinculaçoes, se a quantidade vinculações for igual ao de (quant_parceiros -> PACOTE FECHADO OU quant_maxima -> AVULSA) não permitir mais selecionar aquele parceiro.
- [x] Vincular Parceiro não pode listar vendas que está canceladas
- [x] Trocar as ordens do handicap na listagem de parceiros na ordem de entrada
- [x] Arrumar mensagem de erros do app (mensagem virá somente da api)
- [x] Trocar os handicaps na ordem de entrada (somente os parceiros)
- [x] ao clicar na forma de pagamento PIX aparecer um alerta
- [x] permissão de bloquear as vendas, mas quem tem inscrições vinculadas (parceiros) pode comprar
- [x] colocar uma coluna quando a vincular_parceiro for editada
- [x] arrumar competidores no pacote fechado também
- [x] Arrumar ordem de entrada repetida
- [x] Limite de handicap nos parceiros (na hora de escolher)
- [x] Colocar uma permissão de obrigar a cidade quando clicar na prova (OBRIGAR A COLOCAR A CIDADE)
- [x] quando clicar no gerar pagamento aparecer uma modal das inscrições deles para selecionar
- [ ] cancelar inscrições indepedente do pagamento (sim ou não)
- [ ] cancelar a inscrição com um bloqueio (exemplo, colocar 0 horas pode cancelar qualquer hora, 2 horas pode cancelar 2 horas antes da prova)
- [x] colocar um carrosel infinito, na pagina_provas, mostrando as fotos que foram vinculadas \*
- [x] fazer para mostrar a inscrição que está agora, pegar por ordem de 1 boi até o ultimo editado + 1, a partir do 2 boi, a ordem vai pegar normal menos a que ta SAT no 1 boi. \*
- [x] quando for transferir os ingressos, transferir também os parceiros vinculados ou ver se é para zerar os parceiros.
- [x] Fazer aparecer em cor amarelo nos parceiros nas compras (caso o parceiro não tenha nenhuma compra)
- [x] Tirar botão de editar forma de pagamento
- [x] quando for transferir os ingressos, transferir também os parceiros vinculados ou ver se é para zerar os parceiros. \*
- [x] Banco de competidores (Botão de ver competidores que já compraram e tem a inscrição como sorteio mostrar na modal de detalhes da prova (somente informação)) colocar o botão no whatsapp para entrar em contato com o competidor \*
- [x] Fazer botão de reembolsar venda \*
- [ ] Fazer vinculação de provas na lista de competicação na hora de mostrar provas ao vivo (que agora não é mais provas é por lista de competição), juntar as ordem de entradas das provas vinculadas
- [ ] Fazer automatico uma lista de FINAL ordenada pelo ranking se o ranking não tiver null (MAIOR PARA O MENOR)

======================================= SISTEMA WEB ===================================================

- [ ] relatorio para filiações prova (colunas -> id (competidor), nome, valor, data)
- [ ] Rever gerar pagamanento provas avulsas se possível gerar uma unica linha ou mostrar uma unica linha (SISTEMA)
- [ ] remover parceiros vinculados ao excluir inscrição
- [ ] nas inscrições na hora de excluir, em vincular_parceiros se for pezeiro editar o id_venda_pezeiro para 0 e o id_pezeiro para 0 ou se for cabeceiro editar id_venda_cabeceira para 0 e o id_cabeceira para 0

======================================= ERROS =========================================================

- [ ] arrumar lista de parceiros nas compras, pegar a quantidade exata que está na prova (REVER)
- [ ] arrumar quando inserir mais de uma vez a mesma prova, ele retirar do carrinho (REVER)
- [ ] Listagem de parceiros nas compras, rever por id_cabeceira e id_pezeiro (está puxando tudo junto)

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
