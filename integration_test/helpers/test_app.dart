import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provadelaco/app_widget.dart';
import 'package:provadelaco/config/dependencies.dart';
import 'package:provadelaco/config/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../mocks/fake_interceptor.dart';

/// Cria e configura o interceptor fake com todas as rotas necessárias para
/// os testes E2E. O mapa [overrides] permite sobrescrever rotas específicas.
FakeInterceptor buildFakeInterceptor({Map<String, Map<String, dynamic>>? overrides}) {
  final interceptor = FakeInterceptor();

  final defaultRoutes = <String, Map<String, dynamic>>{
    'dados/listar_dados.php': {
      'sucesso': true,
      'dados': {
        'celularSuporte': '(65) 99999-0000',
        'atualizacaoAndroid': '1.5.8',
        'atualizacaoIos': '1.5.8',
        'possuiCadastro1': 'Já tem cadastro? Faça o login.',
        'possuiCadastro2': 'Ainda não tem cadastro? Cadastre-se.',
        'ativoCadastro': 'Sim',
      },
    },
    'autenticacao/entrar.php': {
      'sucesso': true,
      'mensagem': 'Login realizado com sucesso.',
      'resultado': {
        'id': '1',
        'email': 'glauber@teste.com',
        'tipoDePix': 'cpf',
        'chavePix': '000.000.000-00',
        'senha': '',
        'nome': 'Glauber Teste',
        'token': 'fake-token-123',
        'hcCabeceira': '3',
        'hcPezeiro': '3',
        'idHcCabeceira': '10',
        'idHcPezeiro': '10',
        'tipo': 'cliente',
        'primeiroAcesso': 'Não',
        'cpf': '000.000.000-00',
        'dataNascimento': '01/01/1990',
        'sexo': 'M',
        'rg': '0000000',
        'telefone': '',
        'celular': '(65) 99999-9999',
        'cep': '78000-000',
        'endereco': 'Rua Teste',
        'numero': '100',
        'bairro': 'Centro',
        'complemento': '',
        'foto': '',
        'civil': 'Solteiro',
        'apelido': 'Glauber',
        'nomeCidade': 'Cuiabá',
        'idCidade': '1',
        'clienteBloqueado': false,
        'celularSuporte': '(65) 99999-0000',
        'nivel': '1',
        'somaDeHandicaps': '6',
        'atualizacaoAndroid': '1.5.8',
        'atualizacaoIos': '1.5.8',
        'cabeceiroProvas': 'Sim',
        'pezeiroProvas': 'Sim',
        'ativoProva': 'Sim',
        'lacoemdupla': 'Sim',
        'tambores3': 'Não',
        'lacoindividual': 'Não',
        'tipodecategoriaprofissional': 'Amateur',
        'handicaplacoindividual': '3',
        'idhandicaplacoindividual': '10',
      },
    },
    'autenticacao/verificacao.php': {
      'sucesso': false,
      'mensagem': 'Usuário não autenticado.',
      'resultado': null,
    },
    'autenticacao/sair.php': {
      'sucesso': true,
      'mensagem': 'Logout realizado com sucesso.',
    },
    'compras/listar.php': {
      'sucesso': true,
      'dados': {
        'anteriores': [],
        'atuais': [],
        'canceladas': [],
      },
    },
    'compras/listar_por_id.php': {
      'sucesso': true,
      'dados': {
        'id': '1001',
        'valorIngresso': '150.00',
        'valorTaxa': '5.00',
        'valorDesconto': '0.00',
        'valorTotal': '155.00',
        'valorFiliacao': '0.00',
        'status': 'Ativo',
        'codigoQr': 'QR_CODE_FAKE_1001',
        'codigoPIX': 'PIX_CODE_FAKE_1001',
        'idCliente': '1',
        'dataCompra': '29/04/2026',
        'horaCompra': '10:00',
        'pago': 'Não',
        'nomeProva': 'Laço em Dupla - Amateur',
        'nomeEmpresa': 'Rodeio Teste LTDA',
        'idEvento': '300',
        'idEmpresa': '5',
        'nomeEvento': 'Grande Rodeio de Teste 2026',
        'dataEvento': '10/05/2026',
        'horaInicio': '08:00',
        'horaInicioF': '08:00',
        'parcelas': '1',
        'tipodevenda': 'normal',
        'horaTermino': '18:00',
        'numeroCelular': '(65) 99999-9999',
        'formaPagamento': 'PIX',
        'idFormaPagamento': '1',
        'quandoInscricaoNaoPaga': 'cancelar',
        'mensagemQuandoInscricaoNaoPaga': 'Inscrição será cancelada se não paga.',
        'permVincularParceiro': 'Sim',
        'pixVencido': 'Não',
        'provas': [
          {
            'id': '100',
            'nomeProva': 'Laço em Dupla - Amateur',
            'valor': '150.00',
            'hcMinimo': '1',
            'hcMaximo': '6',
            'avulsa': 'Não',
            'quantMinima': '2',
            'quantMaxima': '2',
            'permitirCompra': {'liberado': true, 'mensagem': ''},
            'permitirSorteio': 'Não',
            'habilitarAoVivo': 'Não',
            'idListaCompeticao': '200',
            'liberarReembolso': 'Não',
            'descricao': 'Prova de laço em dupla categoria Amateur',
            'somatoriaHandicaps': '6',
            'sorteio': false,
            'permitirEditarParceiros': 'Sim',
            'animalSelecionado': null,
            'nomeCabeceira': 'Glauber Teste',
            'idCabeceira': '1',
            'competidores': [],
            'idmodalidade': '1',
          }
        ],
        'parceiros': [
          {
            'id': '2001',
            'nomeParceiro': 'João Parceiro',
            'idParceiro': '9',
            'idProva': '100',
            'nomeProva': 'Laço em Dupla - Amateur',
            'nomeModalidade': 'Dupla',
            'idModalidade': '1',
            'nomeCidade': 'Cuiabá',
            'siglaEstado': 'MT',
            'parceiroTemCompra': 'Não',
          }
        ],
        'idCabeceira': '1',
        'reembolso': 'Não',
      },
    },
    'vendas/listar_informacoes.php': {
      'sucesso': true,
      'mensagem': '',
      'dados': {
        'prova': {'valor': '150.00', 'taxaProva': '5.00'},
        'evento': {
          'id': '300',
          'idEmpresa': '5',
          'nomeEvento': 'Grande Rodeio de Teste 2026',
          'dataEvento': '10/05/2026',
          'horaInicio': '08:00',
          'horaTermino': '18:00',
          'foto': '',
          'cep': '78000-000',
          'endereco': 'Rua Evento',
          'descricao1': 'Evento de teste',
          'descricao2': '',
          'numero': '1',
          'bairro': 'Centro',
          'complemento': '',
          'longitude': '0',
          'latitude': '0',
          'nomeCidade': 'Cuiabá',
          'nomeEmpresa': 'Rodeio Teste LTDA',
          'liberacaoDeCompra': 'Sim',
          'bannersCarrossel': [],
        },
        'taxaCartao': '3.50',
        'parcelasDisponiveisCartao': [],
        'pagamentos': [
          {'id': '1', 'nome': 'PIX'},
        ],
        'parcelasFiliacaoDisponiveis': [],
        'valorAdicionalPorParcela': null,
        'valorAdicional': null,
        'valorDescontoPorProva': null,
        'ativoPagamento': 'Sim',
        'pagamentoPix': 'Sim',
        'tempoCancel': '30',
      },
    },
    'vendas/inserir.php': {
      'sucesso': true,
      'mensagem': 'Inscrição realizada com sucesso!',
      'dados': {
        'txid': 'TXID_FAKE_123',
        'codigoPix': 'PIX_CODE_FAKE',
        'idProva': '100',
        'idVenda': '1001',
        'idEmpresa': '5',
        'idCompra': '1001',
        'tipoRetorno': 'pix',
        'tituloRetorno': 'Pagamento via PIX',
        'tituloSucessoAoVerificarPagamento': 'Pagamento confirmado!',
        'tempoCancel': '30',
      },
    },
    'vendas/editar.php': {
      'sucesso': true,
      'mensagem': 'Inscrição atualizada com sucesso!',
      'dados': {
        'txid': null,
        'codigoPix': null,
        'idProva': '100',
        'idVenda': '1001',
        'idEmpresa': '5',
        'idCompra': '1001',
        'tipoRetorno': 'sem_pagamento',
        'tituloRetorno': 'Inscrição atualizada',
        'tituloSucessoAoVerificarPagamento': '',
        'tempoCancel': '0',
      },
    },
    'competidores': {
      'sucesso': true,
      'dados': [
        {
          'id': '9',
          'nome': 'João Parceiro',
          'apelido': 'João',
          'nomeCidade': 'Cuiabá',
          'siglaEstado': 'MT',
          'ativo': 'Sim',
          'idProva': '100',
          'jaExistente': false,
          'podeCorrer': true,
          'hccabeceira': '3',
          'hcpezeiro': '3',
          'idParceiroTrocado': null,
          'idVincularParceiros': null,
          'celular': '(65) 98888-8888',
          'somaDupla': '6',
          'somatoriProva': null,
          'mensagemValidacao': null,
          'motivosBloqueio': [],
        },
        {
          'id': '15',
          'nome': 'Carlos Competidor',
          'apelido': 'Carlão',
          'nomeCidade': 'Rondonópolis',
          'siglaEstado': 'MT',
          'ativo': 'Sim',
          'idProva': '100',
          'jaExistente': false,
          'podeCorrer': true,
          'hccabeceira': '2',
          'hcpezeiro': '2',
          'idParceiroTrocado': null,
          'idVincularParceiros': null,
          'celular': '(66) 97777-7777',
          'somaDupla': '5',
          'somatoriProva': null,
          'mensagemValidacao': null,
          'motivosBloqueio': [],
        },
      ],
    },
    'parceiros/vincular.php': {
      'sucesso': true,
      'mensagem': 'Parceiro atualizado com sucesso.',
    },
    'parceiros/confirmar.php': {
      'sucesso': true,
      'mensagem': 'Parceiro confirmado com sucesso.',
    },
    'compras/gerar_pagamentos.php': {
      'sucesso': true,
      'mensagem': 'Pagamento gerado com sucesso.',
      'dados': {
        'txid': 'TXID_PAGAMENTO_123',
        'codigoPix': 'PIX_PAGAMENTO_CODE',
        'idVendas': ['1001'],
        'valorTotal': '155.00',
      },
    },
    'home/listar.php': {
      'sucesso': true,
      'eventosTopo': [],
      'eventos': [],
      'propagandas': [],
      'categorias': [
        {'id': '0', 'nome': 'Todas'},
      ],
      'dadosConfig': {
        'versaoAppAndroid': '1.5.8',
        'versaoAppIos': '1.5.8',
        'linkAtualizacaoAndroid': '',
        'linkAtualizacaoIos': '',
        'nomeApp': 'GS Equine',
        'anoApp': '2026',
        'logoApp': '',
      },
    },
    'home/listar_parceiros_aguardando_confirmacao.php': {
      'lacarpe': [],
      'lacarcabeca': [],
    },
    'home/aceitar_parceiro.php': {
      'sucesso': true,
      'mensagem': 'Parceiro aceito com sucesso.',
    },
    'home/recusar_parceiro.php': {
      'sucesso': true,
      'mensagem': 'Parceiro recusado com sucesso.',
    },
    'propagandas': {
      'sucesso': true,
      'dados': [],
    },
    'config': {
      'sucesso': true,
      'dados': {
        'tema': 'escuro',
      },
    },
    'confirmar_parceiros': {
      'sucesso': true,
      'dados': [],
    },
  };

  // Rotas de competidores (usarBancoCompetidores=true e false)
  defaultRoutes['compras/listar_competidores.php'] = {
    'sucesso': true,
    'dados': [
      {
        'id': '9',
        'nome': 'João Parceiro',
        'apelido': 'João',
        'nomeCidade': 'Cuiabá',
        'siglaEstado': 'MT',
        'ativo': 'Sim',
        'idProva': '100',
        'jaExistente': false,
        'podeCorrer': true,
        'hccabeceira': '3',
        'hcpezeiro': '3',
        'idParceiroTrocado': null,
        'idVincularParceiros': null,
        'celular': '(65) 98888-8888',
        'somaDupla': '6',
        'somatoriProva': null,
        'mensagemValidacao': null,
        'motivosBloqueio': [],
      },
      {
        'id': '15',
        'nome': 'Carlos Competidor',
        'apelido': 'Carlão',
        'nomeCidade': 'Rondonópolis',
        'siglaEstado': 'MT',
        'ativo': 'Sim',
        'idProva': '100',
        'jaExistente': false,
        'podeCorrer': true,
        'hccabeceira': '2',
        'hcpezeiro': '2',
        'idParceiroTrocado': null,
        'idVincularParceiros': null,
        'celular': '(66) 97777-7777',
        'somaDupla': '5',
        'somatoriProva': null,
        'mensagemValidacao': null,
        'motivosBloqueio': [],
      },
    ],
  };
  defaultRoutes['compras/listar_clientes_sorteio.php'] = defaultRoutes['compras/listar_competidores.php']!;
  defaultRoutes['compras/editar_parceiro.php'] = {
    'sucesso': true,
    'mensagem': 'Parceiro atualizado com sucesso.',
  };
  defaultRoutes['compras/editar_reembolso_venda.php'] = {
    'sucesso': true,
    'mensagem': 'Reembolso solicitado com sucesso.',
  };
  defaultRoutes['verificar_pagamento'] = {
    'sucesso': false,
    'mensagem': 'Aguardando pagamento.',
    'dados': null,
  };

  // Mescla overrides com as rotas padrão
  final mergedRoutes = {...defaultRoutes, ...?overrides};

  // Registra todos os handlers — retorna string JSON para endpoints POST
  // (pois os serviços chamam jsonDecode) e Map para GET sem jsonDecode
  mergedRoutes.forEach((path, body) {
    interceptor.mockRoute(path, (options) {
      final isGetSemDecode = path == 'compras/listar.php';
      return isGetSemDecode ? body : jsonEncode(body);
    });
  });

  return interceptor;
}

/// Cria um [DioClient] com o interceptor fake injetado.
DioClient buildFakeDioClient({Map<String, Map<String, dynamic>>? overrides}) {
  final client = DioClient();
  final interceptor = buildFakeInterceptor(overrides: overrides);
  // Insere o interceptor antes dos demais para interceptar as requisições
  client.dio.interceptors.insert(0, interceptor);
  return client;
}

/// Widget raiz do app de teste com providers substituídos pelo DioClient fake.
class TestApp extends StatelessWidget {
  final DioClient fakeDioClient;

  const TestApp({super.key, required this.fakeDioClient});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _buildTestProviders(fakeDioClient),
      child: const AppWidget(),
    );
  }

  List<SingleChildWidget> _buildTestProviders(DioClient fakeDio) {
    // Gera os providers usando as dependências da app, mas substituindo DioClient
    return providers.map((provider) {
      // Substituir apenas o Provider<DioClient>
      if (provider is Provider<DioClient>) {
        return Provider<DioClient>(create: (_) => fakeDio);
      }
      return provider;
    }).toList();
  }
}

/// Inicializa o app de teste com o WidgetTester.
Future<void> inicializarAppTeste(
  WidgetTester tester, {
  Map<String, Map<String, dynamic>>? httpOverrides,
}) async {
  await initializeDateFormatting('pt_BR', null);
  final fakeDioClient = buildFakeDioClient(overrides: httpOverrides);
  await tester.pumpWidget(TestApp(fakeDioClient: fakeDioClient));
  await tester.pumpAndSettle();
}
