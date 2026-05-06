# Testes E2E — GS Equine (Prova de Laço)

Suite de testes de integração end-to-end para o app Flutter.

## Estrutura

```
integration_test/
├── mocks/
│   ├── fake_interceptor.dart   # Interceptor Dio que simula respostas da API
│   └── fake_data.dart          # Fábrica de objetos de domínio para testes
├── helpers/
│   └── test_app.dart           # Configuração do app com DioClient fake
├── e2e_auth_test.dart          # Testes de autenticação (login/logout)
├── e2e_compras_test.dart       # Testes de compras (com e sem parceiro, editar)
└── e2e_parceiros_test.dart     # Testes de gerenciamento de parceiros
```

## Como executar

```bash
# Todos os testes (requer dispositivo conectado ou emulador)
flutter test integration_test/ -d <device-id>

# Grupo específico
flutter test integration_test/e2e_auth_test.dart -d <device-id>
flutter test integration_test/e2e_compras_test.dart -d <device-id>
flutter test integration_test/e2e_parceiros_test.dart -d <device-id>

# Listar dispositivos disponíveis
flutter devices
```

## Cenários cobertos

### Autenticação

- TC-AUTH-01: Login com credenciais válidas navega para tela inicial
- TC-AUTH-02: Login com senha incorreta exibe SnackBar de erro
- TC-AUTH-03: Campos vazios exibem aviso de preenchimento obrigatório
- TC-AUTH-04: Email em formato inválido exibe aviso
- TC-AUTH-05: Campo de senha tem obscureText ativo por padrão

### Compra Normal

- TC-COMPRA-01: Tela de finalizar compra exibe informações corretas
- TC-COMPRA-02: Compra via PIX com termos aceitos — concluída com sucesso
- TC-COMPRA-03: Concluir sem aceitar termos mantém botão desabilitado
- TC-COMPRA-04: Erro na API ao concluir exibe SnackBar de erro

### Compra com Parceiro

- TC-COMPRA-PARCEIRO-01: Nome do parceiro aparece no resumo
- TC-COMPRA-PARCEIRO-02: Compra com parceiro via PIX concluída com sucesso
- TC-COMPRA-PARCEIRO-03: Valores monetários corretos no resumo

### Lista de Compras

- TC-LISTA-01: Compras atuais aparecem na aba correta
- TC-LISTA-02: Lista vazia exibe estado vazio
- TC-LISTA-03: Usuário não logado vê mensagem de login

### Editar Compra

- TC-EDITAR-01: Tela exibe título "Editar Venda"
- TC-EDITAR-02: Editar compra com novo parceiro salva com sucesso

### Gerar Pagamento

- TC-PAGAR-01: Compra não paga exibe FAB de pagamento
- TC-PAGAR-02: Compra paga não exibe FAB de pagamento

### Parceiros — Visualizar

- TC-PARC-01: Modal exibe nome do parceiro
- TC-PARC-02: Modal exibe nome da prova
- TC-PARC-03: Modal com permissão exibe botão de competidores disponíveis
- TC-PARC-04: Modal de compra exibe valores monetários

### Parceiros — Editar

- TC-EDIT-PARC-01: Tocar no card abre seleção de competidores
- TC-EDIT-PARC-02: Selecionar competidor diferente abre diálogo de confirmação
- TC-EDIT-PARC-03: Confirmar substituição com sucesso
- TC-EDIT-PARC-04: Cancelar substituição mantém parceiro original
- TC-EDIT-PARC-05: Erro na API exibe SnackBar de erro

### Parceiros — Confirmar / Aceitar

- TC-CONFIRMAR-01: Lista de pendências exibe convite do parceiro
- TC-CONFIRMAR-02: Aceitar parceiro exibe confirmação de sucesso
- TC-CONFIRMAR-03: Recusar parceiro remove item da lista
- TC-CONFIRMAR-04: Sem pendências exibe tela vazia

### Status de Parceiros

- TC-STATUS-PARC-01: Parceiro sem compra exibe indicação visual distinta
- TC-STATUS-PARC-02: Compra com parceiro sem inscrição exibe aviso
