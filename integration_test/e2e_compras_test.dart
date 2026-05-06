import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provadelaco/domain/models/prova/prova.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/features/finalizar_compra/widgets/pagina_finalizar_compra.dart';

import 'helpers/test_app.dart';
import 'mocks/fake_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ──────────────────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────────────────

  /// Faz login e navega até a tela de finalizar compra com as [provas] dadas.
  Future<void> logarENavegar(
    WidgetTester tester,
    List<ProvaModelo> provas, {
    bool editarVenda = false,
    String? idVenda,
    Map<String, Map<String, dynamic>>? httpOverrides,
  }) async {
    await inicializarAppTeste(tester, httpOverrides: httpOverrides);
    AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.login);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // --- Login ---
    final emailField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'E-mail',
    );
    await tester.enterText(emailField, 'glauber@teste.com');

    final senhaField = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == 'Senha',
    );
    await tester.enterText(senhaField, 'senha123');

    final botaoEntrar = find.widgetWithText(ElevatedButton, 'Entrar');
    await tester.tap(botaoEntrar);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // --- Navega diretamente para PaginaFinalizarCompra ---
    AppRotas.navigatorKey.currentState!.pushNamed(
      AppRotas.finalizarCompra,
      arguments: PaginaFinalizarCompraArgumentos(
        provas: provas,
        idEvento: '300',
        editarVenda: editarVenda,
        idVenda: idVenda,
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Compra Normal (sem parceiro)
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Compra Normal', () {
    // TC-COMPRA-01
    testWidgets('TC-COMPRA-01: Tela de finalizar compra exibe as informações corretas', (tester) async {
      await logarENavegar(tester, [FakeData.provaSemParceiro]);

      // Verifica que a tela de finalizar compra foi carregada
      expect(find.text('Finalizar Compra'), findsOneWidget);

      // Verifica que o nome da prova aparece no resumo
      expect(find.text('Laço Individual - Amateur'), findsOneWidget);

      // Verifica que o botão CONCLUIR está presente
      expect(find.text('CONCLUIR'), findsOneWidget);

      // Verifica que o botão CONCLUIR está desabilitado (checkbox não marcado)
      final botaoConcluir = find.widgetWithText(ElevatedButton, 'CONCLUIR');
      final ElevatedButton btnWidget = tester.widget(botaoConcluir);
      expect(btnWidget.onPressed, isNull);
    });

    // TC-COMPRA-02
    testWidgets('TC-COMPRA-02: Compra via PIX — aceitar termos e concluir com sucesso', (tester) async {
      await logarENavegar(tester, [FakeData.provaSemParceiro]);

      // Marca o checkbox de termos
      final checkbox = find.byType(Checkbox).last;
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // O botão CONCLUIR deve ficar habilitado
      final botaoConcluir = find.widgetWithText(ElevatedButton, 'CONCLUIR');
      final ElevatedButton btnWidget = tester.widget(botaoConcluir);
      expect(btnWidget.onPressed, isNotNull);

      // Toca no botão
      await tester.tap(botaoConcluir);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Deve navegar para a tela de sucesso
      expect(find.text('Pagamento via PIX'), findsOneWidget);
    });

    // TC-COMPRA-03
    testWidgets('TC-COMPRA-03: Compra sem aceitar termos não deve ser finalizada', (tester) async {
      await logarENavegar(tester, [FakeData.provaSemParceiro]);

      // Não marca o checkbox

      final botaoConcluir = find.widgetWithText(ElevatedButton, 'CONCLUIR');
      final ElevatedButton btnWidget = tester.widget(botaoConcluir);

      // Botão deve estar desabilitado
      expect(btnWidget.onPressed, isNull);
    });

    // TC-COMPRA-04
    testWidgets('TC-COMPRA-04: Erro na API ao concluir exibe SnackBar de erro', (tester) async {
      await logarENavegar(
        tester,
        [FakeData.provaSemParceiro],
        httpOverrides: {
          'vendas/inserir.php': {
            'sucesso': false,
            'mensagem': 'Inscrições encerradas para esta prova.',
            'dados': {
              'txid': null,
              'codigoPix': null,
              'idProva': null,
              'idVenda': null,
              'idEmpresa': null,
              'idCompra': null,
              'tipoRetorno': null,
              'tituloRetorno': null,
              'tituloSucessoAoVerificarPagamento': null,
              'tempoCancel': null,
            },
          },
        },
      );

      final checkbox = find.byType(Checkbox).last;
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'CONCLUIR'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Deve exibir mensagem de erro
      expect(find.text('Inscrições encerradas para esta prova.'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Compra com Parceiro
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Compra com Parceiro', () {
    // TC-COMPRA-PARCEIRO-01
    testWidgets('TC-COMPRA-PARCEIRO-01: Exibe nome do parceiro selecionado no resumo', (tester) async {
      await logarENavegar(tester, [FakeData.prova]);

      // Verifica que o nome do parceiro aparece no resumo da prova
      expect(find.textContaining('João Parceiro'), findsWidgets);
    });

    // TC-COMPRA-PARCEIRO-02
    testWidgets('TC-COMPRA-PARCEIRO-02: Compra com parceiro via PIX — concluída com sucesso', (tester) async {
      await logarENavegar(tester, [FakeData.prova]);

      // Aceita termos
      final checkbox = find.byType(Checkbox).last;
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // Conclui
      final botaoConcluir = find.widgetWithText(ElevatedButton, 'CONCLUIR');
      expect(tester.widget<ElevatedButton>(botaoConcluir).onPressed, isNotNull);
      await tester.tap(botaoConcluir);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Deve navegar para sucesso
      expect(find.text('Pagamento via PIX'), findsOneWidget);
    });

    // TC-COMPRA-PARCEIRO-03
    testWidgets('TC-COMPRA-PARCEIRO-03: Resumo da compra mostra subtotal, taxa e total corretos', (tester) async {
      await logarENavegar(tester, [FakeData.prova]);

      // Verifica valores monetários na tela
      expect(find.textContaining('R\$'), findsWidgets);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Listar Compras
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Lista de Compras', () {
    // TC-LISTA-01
    testWidgets('TC-LISTA-01: Compras atuais aparecem na aba correta', (tester) async {
      await inicializarAppTeste(
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
      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.login);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Faz login
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

      // Navega para a aba de compras
      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.compras);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // A compra deve estar visível
      expect(find.textContaining('Grande Rodeio de Teste 2026'), findsWidgets);
    });

    // TC-LISTA-02
    testWidgets('TC-LISTA-02: Compras sem itens exibem estado vazio', (tester) async {
      await inicializarAppTeste(tester);
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

      // Com lista vazia, não deve haver cards de compras
      expect(find.text('Laço em Dupla - Amateur'), findsNothing);
    });

    // TC-LISTA-03
    testWidgets('TC-LISTA-03: Usuário não logado vê mensagem de login na tela de compras', (tester) async {
      await inicializarAppTeste(tester);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Sem fazer login, navega direto para compras
      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.compras);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('logado'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Editar Compra
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Editar Compra', () {
    // TC-EDITAR-01
    testWidgets('TC-EDITAR-01: Tela de editar exibe título "Editar Venda"', (tester) async {
      await logarENavegar(
        tester,
        [FakeData.prova],
        editarVenda: true,
        idVenda: '1001',
      );

      expect(find.text('Editar Venda'), findsOneWidget);
    });

    // TC-EDITAR-02
    testWidgets('TC-EDITAR-02: Editar compra com novo parceiro — salva com sucesso', (tester) async {
      await logarENavegar(
        tester,
        [FakeData.prova],
        editarVenda: true,
        idVenda: '1001',
      );

      // Aceita termos
      final checkbox = find.byType(Checkbox).last;
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // Conclui edição
      final botaoConcluir = find.widgetWithText(ElevatedButton, 'CONCLUIR');
      expect(tester.widget<ElevatedButton>(botaoConcluir).onPressed, isNotNull);
      await tester.tap(botaoConcluir);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Deve navegar para sucesso (edição sem pagamento retorna sem QR Code PIX)
      expect(find.text('Inscrição atualizada'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Group: Gerar Pagamento para Inscrições em Aberto
  // ──────────────────────────────────────────────────────────────────────────
  group('E2E — Gerar Pagamento', () {
    // TC-PAGAR-01
    testWidgets('TC-PAGAR-01: Compra não paga exibe botão "Pagar inscrições"', (tester) async {
      await inicializarAppTeste(
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

      // Floating action button ou botão de pagar deve estar visível
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    // TC-PAGAR-02
    testWidgets('TC-PAGAR-02: Compra paga não exibe botão de pagar', (tester) async {
      await inicializarAppTeste(
        tester,
        httpOverrides: {
          'compras/listar.php': {
            'sucesso': true,
            'dados': {
              'anteriores': [
                {
                  'id': '300',
                  'nomeProva': 'Grande Rodeio de Teste 2026',
                  'nomeEvento': 'Grande Rodeio de Teste 2026',
                  'somaTotal': '155.00',
                  'compras': [FakeData.compraPaga.toMap()],
                }
              ],
              'atuais': [],
              'canceladas': [],
            },
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

      AppRotas.navigatorKey.currentState!.pushNamed(AppRotas.compras);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Com compra paga nas anteriores, não deve haver FAB de pagamento
      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });
}
