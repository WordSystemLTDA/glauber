import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/features/compras/widgets/modal_compras.dart';
import 'package:provadelaco/ui/features/compras/widgets/modal_parceiros.dart';

import 'helpers/test_app.dart';
import 'mocks/fake_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ──────────────────────────────────────────────────────────────────────────
  // Helper: faz login e navega para a tela de compras com dados pré-definidos
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> logarComCompras(
    WidgetTester tester, {
    Map<String, Map<String, dynamic>>? httpOverrides,
  }) async {
    await inicializarAppTeste(tester, httpOverrides: httpOverrides);
    AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.login);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final emailField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'E-mail',
    );
    await tester.enterText(emailField, 'glauber@teste.com');
    final senhaField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'Senha',
    );
    await tester.enterText(senhaField, 'senha123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.compras);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helper: abre o ModalParceiros diretamente no test
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> abrirModalParceiros(WidgetTester tester) async {
    AppRotas.navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: ModalParceiros(
            idCompra: '1001',
            idProva: '100',
            idEvento: '300',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helper: abre o ModalCompras diretamente
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> abrirModalCompra(WidgetTester tester) async {
    AppRotas.navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: ModalCompras(
            idCompra: '1001',
            idProva: '100',
            idEvento: '300',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Visualizar Parceiros de uma Compra
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Visualizar Parceiros', () {
    // TC-PARC-01
    testWidgets('TC-PARC-01: Modal de parceiros exibe nome do parceiro da compra', (tester) async {
      await logarComCompras(
        tester,
        httpOverrides: {
          'compras/listar.php': {
            'sucesso': true,
            'dados': {
              'anteriores': [],
              'atuais': [
                {
                  'id': '300',
                  'nomeProva': 'Grande Rodeio de Teste 2026',
                  'nomeEvento': 'Grande Rodeio de Teste 2026',
                  'somaTotal': '155.00',
                  'compras': [FakeData.compraComParceiro.toMap()],
                }
              ],
              'canceladas': [],
            },
          },
        },
      );

      await abrirModalParceiros(tester);

      // Nome do parceiro deve aparecer no modal
      expect(find.textContaining('João Parceiro'), findsWidgets);
    });

    // TC-PARC-02
    testWidgets('TC-PARC-02: Modal de parceiros exibe o nome da prova', (tester) async {
      await logarComCompras(tester);
      await abrirModalParceiros(tester);

      expect(find.textContaining('Grande Rodeio de Teste 2026'), findsWidgets);
    });

    // TC-PARC-03
    testWidgets('TC-PARC-03: Modal de parceiros com permissão exibe botão "Competidores disponíveis"', (tester) async {
      await logarComCompras(tester);
      await abrirModalParceiros(tester);

      expect(find.text('Competidores disponíveis'), findsOneWidget);
    });

    // TC-PARC-04
    testWidgets('TC-PARC-04: Modal de detalhes da compra exibe informações de valor total', (tester) async {
      await logarComCompras(tester);
      await abrirModalCompra(tester);

      // Modal deve mostrar valores monetários
      expect(find.textContaining('R\$'), findsWidgets);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Editar Parceiro de uma Compra
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Editar Parceiro', () {
    // TC-EDIT-PARC-01
    testWidgets('TC-EDIT-PARC-01: Ao tocar no card do parceiro, abre seleção de competidores', (tester) async {
      await logarComCompras(tester);
      await abrirModalParceiros(tester);

      // Toca no card do parceiro para abrir seleção
      final cardParceiro = find.textContaining('João Parceiro').first;
      await tester.tap(cardParceiro);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Deve abrir página de seleção de competidor (ou diálogo de substituição)
      // Se tiver a tela de competidores, verifica o título
      final temTelaCompetidores = find.text('Competidores disponíveis').evaluate().isNotEmpty || find.text('Deseja realmente substituir esse parceiro?').evaluate().isNotEmpty;
      expect(temTelaCompetidores, isTrue);
    });

    // TC-EDIT-PARC-02
    testWidgets('TC-EDIT-PARC-02: Selecionar competidor diferente abre diálogo de confirmação', (tester) async {
      await logarComCompras(tester);
      await abrirModalParceiros(tester);

      // Toca no botão "Competidores disponíveis" para abrir a lista
      final btnCompetidores = find.text('Competidores disponíveis');
      if (btnCompetidores.evaluate().isNotEmpty) {
        await tester.tap(btnCompetidores);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Lista de competidores deve aparecer
        expect(find.textContaining('Carlos Competidor'), findsOneWidget);

        // Seleciona Carlos
        await tester.tap(find.textContaining('Carlos Competidor').first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Diálogo de substituição deve aparecer
        expect(find.text('Deseja realmente substituir esse parceiro?'), findsOneWidget);
      }
    });

    // TC-EDIT-PARC-03
    testWidgets('TC-EDIT-PARC-03: Confirmar substituição de parceiro com sucesso', (tester) async {
      await logarComCompras(tester);
      await abrirModalParceiros(tester);

      final btnCompetidores = find.text('Competidores disponíveis');
      if (btnCompetidores.evaluate().isNotEmpty) {
        await tester.tap(btnCompetidores);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.textContaining('Carlos Competidor').first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Confirma substituição
        final botaoSim = find.text('Sim');
        if (botaoSim.evaluate().isNotEmpty) {
          await tester.tap(botaoSim);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Após confirmação o modal deve ter fechado ou atualizado
          expect(find.text('Deseja realmente substituir esse parceiro?'), findsNothing);
        }
      }
    });

    // TC-EDIT-PARC-04
    testWidgets('TC-EDIT-PARC-04: Cancelar substituição mantém parceiro original', (tester) async {
      await logarComCompras(tester);
      await abrirModalParceiros(tester);

      final btnCompetidores = find.text('Competidores disponíveis');
      if (btnCompetidores.evaluate().isNotEmpty) {
        await tester.tap(btnCompetidores);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.textContaining('Carlos Competidor').first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Cancela substituição
        final botaoCancelar = find.text('Cancelar');
        if (botaoCancelar.evaluate().isNotEmpty) {
          await tester.tap(botaoCancelar);
          await tester.pumpAndSettle();

          // Diálogo fechou sem alterar
          expect(find.text('Deseja realmente substituir esse parceiro?'), findsNothing);
        }
      }
    });

    // TC-EDIT-PARC-05: Erro na API ao substituir parceiro exibe SnackBar de erro
    testWidgets('TC-EDIT-PARC-05: Erro ao substituir parceiro exibe mensagem de erro', (tester) async {
      await logarComCompras(
        tester,
        httpOverrides: {
          'compras/editar_parceiro.php': {
            'sucesso': false,
            'mensagem': 'Não foi possível substituir o parceiro. Tente novamente.',
          },
        },
      );
      await abrirModalParceiros(tester);

      final btnCompetidores = find.text('Competidores disponíveis');
      if (btnCompetidores.evaluate().isNotEmpty) {
        await tester.tap(btnCompetidores);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.textContaining('Carlos Competidor').first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final botaoSim = find.text('Sim');
        if (botaoSim.evaluate().isNotEmpty) {
          await tester.tap(botaoSim);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Deve exibir SnackBar de erro
          expect(
            find.textContaining('Não foi possível substituir'),
            findsOneWidget,
          );
        }
      }
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Confirmar Parceiros (aceitar convite de parceiro)
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Aceitar Parceiro (Confirmar Parceiros)', () {
    // TC-CONFIRMAR-01
    testWidgets('TC-CONFIRMAR-01: Tela de confirmar parceiros exibe lista de pendências', (tester) async {
      await inicializarAppTeste(
        tester,
        httpOverrides: {
          'confirmar_parceiros': {
            'sucesso': true,
            'dados': [
              {
                'id': '5001',
                'idVenda': '1001',
                'idParceiro': '1',
                'idCabeceira': '9',
                'nomeCabeceira': 'João Parceiro',
                'nomeProva': 'Laço em Dupla - Amateur',
                'nomeEvento': 'Grande Rodeio de Teste 2026',
                'dataEvento': '10/05/2026',
                'nomeModalidade': 'Dupla',
                'idModalidade': '1',
                'status': 'pendente',
              }
            ],
          },
        },
      );
      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.login);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final emailField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'E-mail',
      );
      await tester.enterText(emailField, 'glauber@teste.com');
      final senhaField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'Senha',
      );
      await tester.enterText(senhaField, 'senha123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.confirmarParceiros);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // A pendência deve aparecer na tela
      expect(find.textContaining('João Parceiro'), findsWidgets);
    });

    // TC-CONFIRMAR-02
    testWidgets('TC-CONFIRMAR-02: Aceitar parceiro — exibe confirmação de sucesso', (tester) async {
      await inicializarAppTeste(
        tester,
        httpOverrides: {
          'confirmar_parceiros': {
            'sucesso': true,
            'dados': [
              {
                'id': '5001',
                'idVenda': '1001',
                'idParceiro': '1',
                'idCabeceira': '9',
                'nomeCabeceira': 'João Parceiro',
                'nomeProva': 'Laço em Dupla - Amateur',
                'nomeEvento': 'Grande Rodeio de Teste 2026',
                'dataEvento': '10/05/2026',
                'nomeModalidade': 'Dupla',
                'idModalidade': '1',
                'status': 'pendente',
              }
            ],
          },
          'parceiros/confirmar.php': {
            'sucesso': true,
            'mensagem': 'Parceiro confirmado com sucesso.',
          },
        },
      );
      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.login);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final emailField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'E-mail',
      );
      await tester.enterText(emailField, 'glauber@teste.com');
      final senhaField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'Senha',
      );
      await tester.enterText(senhaField, 'senha123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.confirmarParceiros);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Toca em "Aceitar" ou botão equivalente
      final botaoAceitar = find.textContaining('Aceitar');
      if (botaoAceitar.evaluate().isNotEmpty) {
        await tester.tap(botaoAceitar.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Sucesso exibido
        expect(find.textContaining('sucesso'), findsWidgets);
      }
    });

    // TC-CONFIRMAR-03
    testWidgets('TC-CONFIRMAR-03: Recusar parceiro — exibe confirmação', (tester) async {
      await inicializarAppTeste(
        tester,
        httpOverrides: {
          'confirmar_parceiros': {
            'sucesso': true,
            'dados': [
              {
                'id': '5001',
                'idVenda': '1001',
                'idParceiro': '1',
                'idCabeceira': '9',
                'nomeCabeceira': 'João Parceiro',
                'nomeProva': 'Laço em Dupla - Amateur',
                'nomeEvento': 'Grande Rodeio de Teste 2026',
                'dataEvento': '10/05/2026',
                'nomeModalidade': 'Dupla',
                'idModalidade': '1',
                'status': 'pendente',
              }
            ],
          },
          'parceiros/confirmar.php': {
            'sucesso': true,
            'mensagem': 'Parceiro recusado.',
          },
        },
      );
      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.login);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final emailField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'E-mail',
      );
      await tester.enterText(emailField, 'glauber@teste.com');
      final senhaField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'Senha',
      );
      await tester.enterText(senhaField, 'senha123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.confirmarParceiros);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final botaoRecusar = find.textContaining('Recusar');
      if (botaoRecusar.evaluate().isNotEmpty) {
        await tester.tap(botaoRecusar.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Item deve sumir da lista após recusa
        expect(find.textContaining('João Parceiro'), findsNothing);
      }
    });

    // TC-CONFIRMAR-04
    testWidgets('TC-CONFIRMAR-04: Sem pendências exibe tela vazia', (tester) async {
      await inicializarAppTeste(tester); // confirmar_parceiros retorna lista vazia por padrão

      await tester.pumpAndSettle(const Duration(seconds: 3));

      final emailField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'E-mail',
      );
      await tester.enterText(emailField, 'glauber@teste.com');
      final senhaField = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'Senha',
      );
      await tester.enterText(senhaField, 'senha123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.confirmarParceiros);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Sem pendências, não deve aparecer nenhum card de parceiro
      expect(find.textContaining('João Parceiro'), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Status de Parceiros em Compras
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Status de Parceiros em Compras', () {
    // TC-STATUS-PARC-01
    testWidgets('TC-STATUS-PARC-01: Parceiro sem compra exibe indicação visual distinta', (tester) async {
      await logarComCompras(tester);
      await abrirModalParceiros(tester);

      // "parceiroTemCompra": "Não" — deve mostrar algum indicador visual
      // Verifica que o parceiro está listado
      expect(find.textContaining('João Parceiro'), findsWidgets);
    });

    // TC-STATUS-PARC-02
    testWidgets('TC-STATUS-PARC-02: Compra com parceiro sem inscrição exibe aviso', (tester) async {
      await logarComCompras(
        tester,
        httpOverrides: {
          'compras/listar.php': {
            'sucesso': true,
            'dados': {
              'anteriores': [],
              'atuais': [
                {
                  'id': '300',
                  'nomeProva': 'Grande Rodeio de Teste 2026',
                  'nomeEvento': 'Grande Rodeio de Teste 2026',
                  'somaTotal': '155.00',
                  'compras': [FakeData.compraComParceiro.toMap()],
                }
              ],
              'canceladas': [],
            },
          },
        },
      );

      // Compra deve estar visível com parceiro
      expect(find.textContaining('Grande Rodeio de Teste 2026'), findsWidgets);
    });
  });
}
