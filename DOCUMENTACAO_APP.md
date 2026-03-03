# Documentação do App (Flutter)

## 1) Objetivo

Este documento descreve o comportamento do app Flutter, sua arquitetura e os fluxos funcionais implementados no projeto.

Escopo coberto:

- Arquitetura técnica do app.
- Funcionalidades por módulo/tela.
- Mapeamento dos endpoints consumidos.

---

## 2) Visão Geral do App

- Projeto: `glauber`
- Entradas principais:
  - `lib/main.dart`
  - `lib/app_widget.dart`
- Base URL da API:
  - `lib/config/config.dart` (`ConstantesGlobal.apiUrl`)
- Cliente HTTP:
  - `lib/config/dio.dart` (Dio com timeout de 10 minutos)
- Injeção de dependências e estado:
  - `lib/config/dependencies.dart` (Provider/ChangeNotifier)

---

## 3) Arquitetura

### 3.1 Inicialização

- `main.dart`:
  - inicializa locale pt-BR (`initializeDateFormatting`).
  - aplica `HttpOverrides` aceitando certificados (ambiente flexível, inclusive dev).
  - injeta providers via `MultiProvider`.

### 3.2 Roteamento

- Rotas em `lib/routing/routes.dart`.
- Gerador de rotas em `lib/routing/router.dart`.
- Features principais visíveis no roteamento:
  - autenticação, home, buscar, provas, compras, finalizar compra, ordem de entrada, perfil, propaganda, animais, competidores, splash.

### 3.3 Camadas

- `data/services/*`: chama endpoints da API.
- `data/repositories/*`: estado/view models da aplicação.
- `ui/features/*`: telas e interação com usuário.

---

## 4) Funcionalidades do App

## 4.1 Acesso e Sessão

- Login por e-mail/senha, Google ou Apple.
- Verificação de sessão/token no bootstrap.
- Logout e exclusão de conta.
- Persistência local do usuário via `SharedPreferences`.

Arquivos:

- App: `lib/data/services/autenticacao_servico.dart`, `lib/data/services/usuario_servico.dart`

## 4.2 Cadastro e Perfil

- Cadastro tradicional e social.
- Edição de perfil completo (dados pessoais, cidade, handicap, pix, modalidades).
- Alteração de senha.

Arquivos:

- App: `autenticacao_servico.dart`, `editar_usuario_servico.dart`, `mudar_senha_servico.dart`

## 4.3 Home, Eventos e Busca

- Lista eventos em destaque e por categoria.
- Carrega propagandas e configuração remota do app (versões, links de atualização).
- Busca eventos por nome.

Arquivos:

- App: `home_servico.dart`, `buscar_servico.dart`, `listar_dados_servicos.dart`

## 4.4 Provas e Permissão de Compra

- Lista provas por evento/modalidade.
- Avalia se o cliente pode adicionar prova ao carrinho.
- Exibe bloqueios e mensagens de negócio retornadas pela API.

Arquivos:

- App: `prova_sevico.dart`

## 4.5 Finalização de Compra e Pagamento

- Envia lote de provas para compra.
- Suporta fluxo de retorno para Pix e cartão.
- Usa verificação pós-pagamento para meios assíncronos.

Arquivos:

- App: `finalizar_compra_servico.dart`, `verificar_pagamento_servico.dart`, `listar_informacoes_servico.dart`

## 4.6 Compras (Minhas Inscrições)

- Lista compras em 3 grupos: atuais, anteriores e canceladas.
- Exibe provas, parceiros, QR/Pix, reembolso e status.
- Permite:
  - editar parceiro,
  - solicitar reembolso/cancelamento,
  - transferir inscrições,
  - gerar novo pagamento consolidado,
  - baixar/compartilhar PDF de inscrição.

Arquivos:

- App: `compras_servico.dart`

## 4.7 Parceiros (Confirmação e Recusa)

- Lista convites pendentes por prova.
- Permite aceitar/recusar parceiro.
- Pode exigir conclusão de compra antes de confirmar vínculo final.

Arquivos:

- App: `home_servico.dart`

## 4.8 Competidores e Ordem de Entrada

- Lista competidores por busca/sorteio.
- Lista ordem de entrada por cliente, por prova e por lista de competição.
- Tela ao vivo com “quem está correndo agora”, final e classificação final.

Arquivos:

- App: `competidores_servico.dart`, `ordermdeentrada_servico.dart`, `prova_sevico.dart`

## 4.9 Animais, Propagandas e Denúncias

- CRUD de animais do usuário (com upload de imagem).
- Exibição de detalhe de propaganda.
- Registro de denúncia de evento.

Arquivos:

- App: `servico_animais.dart`, `propagandas_servico.dart`, `denunciar_servico.dart`

---

## 5) Endpoints Consumidos pelo App

### 5.1 Autenticação e usuário

- `autenticacao/entrar.php`
- `autenticacao/verificacao.php`
- `autenticacao/sair.php`
- `autenticacao/excluir_conta.php`
- `autenticacao/cadastrar.php`
- `autenticacao/cadastrar_social.php`
- `clientes/editar.php`
- `clientes/mudar_senha.php`

### 5.2 Home/Eventos/Config

- `home/listar.php`
- `eventos/listar_por_nome.php`
- `dados/listar_dados.php`
- `propagandas/listar_por_id.php`

### 5.3 Provas/Compra

- `provas/listar.php`
- `provas/listar_ao_vivo.php`
- `provas/permitir_adicionar_compra.php`
- `vendas/listar_informacoes.php`
- `vendas/inserir.php`
- `vendas/editar.php`

### 5.4 Pagamento

- `pagamentos/verificar_pagamento.php`
- `pagamentos/verificar_pagamento_gerado.php`

### 5.5 Compras e parceiros

- `compras/listar.php`
- `compras/listar_por_id.php`
- `compras/listar_somente_inscricoes.php`
- `compras/listar_clientes_normal.php`
- `compras/editar_parceiro.php`
- `compras/editar_reembolso_venda.php`
- `compras/gerar_pagamentos.php`
- `transferencia/transferir.php`
- `home/listar_parceiros_aguardando_confirmacao.php`
- `home/aceitar_parceiro.php`
- `home/recusar_parceiro.php`

### 5.6 Ordem de entrada/competidores

- `ordem_de_entrada/listar.php`
- `ordem_de_entrada/listar_por_provas.php`
- `ordem_de_entrada/listar_por_lista_competicao.php`
- `compras/listar_competidores.php`
- `compras/listar_clientes_sorteio.php`

### 5.7 Utilitários

- `geracao_pdf/gerar_pdf_inscricao.php`
- `cidade/listar_por_nome.php`
- `handicaps/listar.php`
- `animais/listar.php`, `animais/inserir.php`, `animais/editar.php`, `animais/excluir.php`
- `denuncias/denunciar.php`

---

## 6) Observações de manutenção (App)

- A rota de calendário existe em `routes.dart` e no menu lateral, porém não há case correspondente em `routing/router.dart` no estado atual.
- A URL da API está fixa em `ConstantesGlobal.apiUrl` (produção).
- O app aceita certificados via `HttpOverrides` (avaliar impacto de segurança por ambiente).

---

## 7) Referências principais de código

- `lib/main.dart`
- `lib/app_widget.dart`
- `lib/config/dependencies.dart`
- `lib/routing/routes.dart`
- `lib/routing/router.dart`
- `lib/data/services/*.dart`
