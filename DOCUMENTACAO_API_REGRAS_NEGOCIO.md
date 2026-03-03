# Documentação da API e Regras de Negócio

## 1) Objetivo

Este documento descreve o comportamento da API PHP, as regras de negócio críticas e os principais pontos de rastreabilidade no código.

Escopo coberto:

- Domínios e responsabilidades da API.
- Regras de negócio de compra, parceiros, pagamentos e reembolso.
- Entidades/tabelas centrais e rastreabilidade de implementação.

---

## 2) Visão Geral da API

- Projeto: `api_gsequine/api_glauber`
- Arquitetura: endpoints PHP procedurais por domínio funcional.

Domínios principais:

- `autenticacao`, `home`, `provas`, `vendas`, `compras`, `pagamentos`, `transferencia`, `ordem_de_entrada`, `animais`, `clientes`, `eventos`, `propagandas`, `dados`, `cidade`, `handicaps`, `denuncias`.

---

## 3) Regras de Negócio (Núcleo)

## 3.1 Elegibilidade para compra

Implementação principal:

- `provas/retornar_permitir_compra.php`
- `provas/retornar_ja_comprou.php`

Regras ativas:

- A prova precisa estar ativa (`provas.ativo = 'Sim'`) para liberar venda.
- A compra respeita janela de liberação por data/hora (`data_liberacao_venda`, `hora_liberacao_venda`).
- Pode haver bloqueio global por evento (`eventos.liberacao_de_compra`).
- Pode exigir celular/cidade preenchidos conforme `permissoes_empresa`.
- Handicap do cliente deve respeitar faixa mínima/máxima da prova e regra de somatória.
- Limites por prova:
  - Avulsa: usa `quant_maxima`.
  - Não avulsa: usa `quant_parceiros`.
- Limites por papel/modalidade:
  - `quant_max_inscricoes_cabeceira`
  - `quant_max_inscricoes_pezeiro`
- Limite fechado por prova (quando configurado): `quant_max_inscri_p_fechado`.
- Compras canceladas não contam como ativas para o cálculo de limite.
- Retorno de API inclui auxiliares para UI:
  - `idCabeceiraInvalido`
  - `quantMaximaAvulsa`
  - `quantParceiros`
  - `permVincularParceiro`
  - `competidoresJaSelecionados`

## 3.2 Status de vínculo de parceiros (confirmar parceiros)

Tabela principal: `vincular_parceiros`

Estados usados:

- `Sem Parceiro`
- `Pendente`
- `Confirmado`

Regras:

- Convite aceito pode exigir compra concluída para virar `Confirmado` (dependendo do cenário).
- Se prova/limite não permitir, vínculo é recusado automaticamente para evitar inconsistência.
- Recusa redefine par correspondente para `0` e status `Sem Parceiro`.

Implementação:

- `home/aceitar_parceiro.php`
- `home/recusar_parceiro.php`
- `vendas/funcoes/inserir_provas_nao_avulsas.php`

## 3.3 Antiduplicata e antiestouro (parceiros)

Regra geral de limite:

- Avulsa (`avulsa = 'Sim'`) usa `quant_maxima`.
- Não avulsa (`avulsa = 'Não'`) usa `quant_parceiros`.

Proteções implementadas:

- Não inserir parceiro duplicado na mesma venda/prova/modalidade.
- Não criar vínculos acima do limite da prova para a venda.
- Em edição de parceiro, impedir vínculo já ativo (`status != 'Sem Parceiro'`) com o mesmo par.
- Limpeza recíproca ao trocar/cancelar parceiro zera também IDs de venda do lado oposto quando aplicável.

Arquivos-chave:

- `vendas/funcoes/inserir_provas_nao_avulsas.php`
- `home/aceitar_parceiro.php` (função `inserirNovaVinculacaoParceiro`)
- `compras/editar_parceiro.php`
- `compras/editar_reembolso_venda.php`

## 3.4 Reembolso e cancelamento

Regras:

- Cancelamento de venda marca `vendas.status = 'Cancelado'` e `vendas.reembolso = 'Pendente'`.
- Vínculos do competidor são desmontados para `Sem Parceiro`, incluindo lado recíproco.

Implementação:

- `compras/editar_reembolso_venda.php`

## 3.5 Transferência de inscrições

Regras:

- Troca `vendas.id_cliente` para novo cliente.
- Atualiza também `vincular_parceiros.id_cabeceira` ou `id_pezeiro` conforme modalidade.

Implementação:

- `transferencia/transferir.php`

## 3.6 Pagamentos

Formas suportadas no backend:

- Pix Mercado Pago (`id_forma_pagamento = 1`)
- Cartão Mercado Pago (`3`)
- Pix Inter (`4`)
- Pix Sicredi (`5`)
- Pix Asaas (`6`)
- Pix Sicoob (`7`)

Regras:

- Em Pix, retorna `txid` + código para exibição/verificação.
- Há criação de evento SQL para expirar Pix (`pix_vencido = 'Sim'`) após `tempo_cancel`.
- Verificação de pagamento pode rodar em dois modos (`verificar_pagamento` e `verificar_pagamento_gerado`).

Arquivos:

- `vendas/inserir.php`, `vendas/editar.php`
- `pagamentos/verificar_pagamento.php`, `pagamentos/verificar_pagamento_gerado.php`
- `pagamentos/listar_pagamentos_ativos.php`

## 3.7 Cadastro e restrições de usuário

Regras identificadas:

- Pode obrigar celular e cidade conforme config.
- Impede cadastro com e-mail duplicado.
- Impede celular duplicado (mensagem com contato de suporte).
- Validação de combinação de handicap cabeça/pé (consistência mínima).
- Cliente bloqueado é identificado em `verificar_cliente.php`.

Arquivos:

- `autenticacao/cadastrar.php`
- `autenticacao/cadastrar_social.php`
- `autenticacao/funcoes/verificar_cliente.php`

---

## 4) Endpoints por domínio (consumo principal do app)

### 4.1 Autenticação e usuário

- `autenticacao/entrar.php`
- `autenticacao/verificacao.php`
- `autenticacao/sair.php`
- `autenticacao/excluir_conta.php`
- `autenticacao/cadastrar.php`
- `autenticacao/cadastrar_social.php`
- `clientes/editar.php`
- `clientes/mudar_senha.php`

### 4.2 Home/Eventos/Config

- `home/listar.php`
- `home/listar_parceiros_aguardando_confirmacao.php`
- `home/aceitar_parceiro.php`
- `home/recusar_parceiro.php`
- `eventos/listar.php`
- `eventos/listar_por_nome.php`
- `dados/listar_dados.php`
- `propagandas/listar_por_id.php`

### 4.3 Provas/Compra

- `provas/listar.php`
- `provas/listar_ao_vivo.php`
- `provas/permitir_adicionar_compra.php`
- `provas/retornar_permitir_compra.php`
- `provas/retornar_ja_comprou.php`
- `vendas/listar_informacoes.php`
- `vendas/inserir.php`
- `vendas/editar.php`

### 4.4 Pagamento

- `pagamentos/verificar_pagamento.php`
- `pagamentos/verificar_pagamento_gerado.php`
- `pagamentos/listar_pagamentos_ativos.php`

### 4.5 Compras e parceiros

- `compras/listar.php`
- `compras/listar_por_id.php`
- `compras/listar_somente_inscricoes.php`
- `compras/listar_clientes_normal.php`
- `compras/editar_parceiro.php`
- `compras/editar_reembolso_venda.php`
- `compras/gerar_pagamentos.php`
- `transferencia/transferir.php`

### 4.6 Ordem de entrada e competidores

- `ordem_de_entrada/listar.php`
- `ordem_de_entrada/listar_por_provas.php`
- `ordem_de_entrada/listar_por_lista_competicao.php`
- `compras/listar_competidores.php`
- `compras/listar_clientes_sorteio.php`

---

## 5) Entidades/Tabelas Mais Relevantes

- `clientes`: identidade, contato, handicap, modalidade, dados de perfil.
- `eventos`: dados do evento, status, regras de compra e vínculo.
- `provas`: parâmetros de elegibilidade e limite (`avulsa`, `quant_parceiros`, `quant_maxima`, handicap etc.).
- `vendas`: compra principal (status, pagamento, valores, reembolso).
- `itens_venda`: itens por prova/modalidade dentro da venda.
- `vincular_parceiros`: relacionamento entre competidores e status de vínculo.
- `ordem_de_entrada`: performance/listagem ao vivo.
- `permissoes_empresa`: regras operacionais da empresa (pagamentos, obrigatoriedade de campos, tempo de cancelamento etc.).
- `tokens_notificacao`: registro de tokens para push.

---

## 6) Domínios da API (Inventário Funcional)

Domínios presentes em `api_glauber`:

- `animais`, `autenticacao`, `banco_de_dados`, `calendario`, `cidade`, `clientes`, `compras`, `dados`, `denuncias`, `eventos`, `geracao_pdf`, `handicaps`, `home`, `jwt`, `logs_view`, `movimentacoes`, `notificacoes`, `ordem_de_entrada`, `pagamentos`, `propagandas`, `provas`, `termos_de_uso`, `transferencia`, `vendas`, `testes`.

Observação:

- O app consome principalmente os domínios de autenticação, home, provas, vendas, compras, pagamentos, transferência, ordem de entrada e utilitários.
- `testes/` e bibliotecas de terceiros (`vendor/`) não fazem parte das regras de negócio do app.

---

## 7) Rastreabilidade rápida (Regra -> Arquivo)

- Elegibilidade de compra -> `provas/retornar_permitir_compra.php`
- Cálculo "já comprou" -> `provas/retornar_ja_comprou.php`
- Inserção de vendas + pagamento -> `vendas/inserir.php`
- Inserção de itens/parceiros -> `vendas/funcoes/inserir_provas_nao_avulsas.php`
- Aceite/recusa de parceiro -> `home/aceitar_parceiro.php`, `home/recusar_parceiro.php`
- Edição de parceiro em compras -> `compras/editar_parceiro.php`
- Reembolso/cancelamento com desvínculo -> `compras/editar_reembolso_venda.php`
- Transferência de inscrição -> `transferencia/transferir.php`
- Verificação de pagamento -> `pagamentos/verificar_pagamento.php`, `pagamentos/verificar_pagamento_gerado.php`
- Listagem consolidada de compras -> `compras/listar.php`

---

## 8) Referências principais de código (API)

- `api_glauber/provas/*`
- `api_glauber/vendas/*`
- `api_glauber/compras/*`
- `api_glauber/home/*`
- `api_glauber/pagamentos/*`
- `api_glauber/transferencia/*`
- `api_glauber/autenticacao/*`
- `api_glauber/ordem_de_entrada/*`
