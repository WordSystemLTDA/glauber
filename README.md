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
- [ ] Arrumar ordem de entrada repetida
- [ ] Fazer logs de transfêrencia no banco de dados

- [ ] Botão de mudar várias inscrições ao mesmo tempo (Pagamento)
- [ ] Limite de handicap nos parceiros (na hora de escolher)

======================================= PARA FAZER (AVANÇADO) =========================================
[ ] Fazer com que ao clicar na notificação em foreground poder ir para Inscrições, ordem de entrada, perfil e inicio. (somente é possivel em modo background)

======================================= IDEIAS ========================================================
Fazer uma configuração no banco de dados, caso a pessoa queria que a foto do evento ou propaganda seja

- Cobrir (pode cortar imagem ou não)
- Esticar imagem para preencher o espaço disponível
- Ajustar para a largura (pode cortar imagem ou não)
- Ajustar para a altura (pode sobrar nas horizontais)
- Aparecer imagem toda (sem se preocupar com largura ou altura, dependendo pode sobrar nas laterais)
