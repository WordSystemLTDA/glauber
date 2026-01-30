import 'package:provadelaco/config/dio.dart';
import 'package:provadelaco/data/repositories/animal_repository.dart';
import 'package:provadelaco/data/repositories/autenticacao_repository.dart';
import 'package:provadelaco/data/repositories/buscar_repository.dart';
import 'package:provadelaco/data/repositories/compras_repository.dart';
import 'package:provadelaco/data/repositories/config_repository.dart';
import 'package:provadelaco/data/repositories/finalizar_compra_repository.dart';
import 'package:provadelaco/data/repositories/handicap_repository.dart';
import 'package:provadelaco/data/repositories/home_repository.dart';
import 'package:provadelaco/data/repositories/listar_cartoes_repository.dart';
import 'package:provadelaco/data/repositories/listar_informacoes_repository.dart';
import 'package:provadelaco/data/repositories/ordemdeentrada_prova_repository.dart';
import 'package:provadelaco/data/repositories/ordemdeentrada_repository.dart';
import 'package:provadelaco/data/repositories/propagandas_repository.dart';
import 'package:provadelaco/data/repositories/provas_aovivo_repository.dart';
import 'package:provadelaco/data/repositories/provas_repository.dart';
import 'package:provadelaco/data/repositories/transferencia_repository.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/data/repositories/verificar_pagamento_repository.dart';
import 'package:provadelaco/data/repositories/verificar_permitir_compra_repository.dart';
import 'package:provadelaco/data/services/autenticacao_servico.dart';
import 'package:provadelaco/data/services/buscar_servico.dart';
import 'package:provadelaco/data/services/cidade_servico.dart';
import 'package:provadelaco/data/services/competidores_servico.dart';
import 'package:provadelaco/data/services/compras_servico.dart';
import 'package:provadelaco/data/services/denunciar_servico.dart';
import 'package:provadelaco/data/services/editar_usuario_servico.dart';
import 'package:provadelaco/data/services/finalizar_compra_servico.dart';
import 'package:provadelaco/data/services/handicap_servico.dart';
import 'package:provadelaco/data/services/home_servico.dart';
import 'package:provadelaco/data/services/listar_cartoes_servico.dart';
import 'package:provadelaco/data/services/listar_dados_servicos.dart';
import 'package:provadelaco/data/services/listar_informacoes_servico.dart';
import 'package:provadelaco/data/services/mudar_senha_servico.dart';
import 'package:provadelaco/data/services/ordermdeentrada_servico.dart';
import 'package:provadelaco/data/services/propagandas_servico.dart';
import 'package:provadelaco/data/services/prova_sevico.dart';
import 'package:provadelaco/data/services/servico_animais.dart';
import 'package:provadelaco/data/services/verificar_pagamento_servico.dart';
import 'package:provadelaco/ui/core/themes/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers => [
      ChangeNotifierProvider(create: (context) => ThemeController()),
      Provider(create: (context) => DioClient()),
      ChangeNotifierProvider(create: (context) => UsuarioProvider()),
      ChangeNotifierProvider(create: (context) => ConfigProvider()),
      // Inicio
      Provider<MudarSenhaServico>(create: (context) => MudarSenhaServico(context.read())),
      // Autenticação
      Provider<HandiCapServico>(create: (context) => HandiCapServico(context.read())),
      Provider<AutenticacaoServico>(create: (context) => AutenticacaoServico(context.read())),
      Provider(create: (context) => ListarDadosServicos(context.read())),
      ChangeNotifierProvider(create: (context) => AutenticacaoStore(context.read())),
      ChangeNotifierProvider(create: (context) => HandiCapStore(context.read())),
      // Home
      Provider<HomeServico>(create: (context) => HomeServico(context.read())),
      ChangeNotifierProvider(create: (context) => HomeStore(context.read())),
      // Editar Usuario
      Provider<CidadeServico>(create: (context) => CidadeServico(context.read())),
      Provider<EditarUsuarioServico>(create: (context) => EditarUsuarioServico(context.read())),
      // Buscar
      Provider<BuscarServico>(create: (context) => BuscarServico(context.read())),
      ChangeNotifierProvider(create: (context) => BuscarStore(context.read())),
      // Provas
      Provider<CompetidoresServico>(create: (context) => CompetidoresServico(context.read())),
      Provider<DenunciarServico>(create: (context) => DenunciarServico(context.read())),
      Provider<ProvaServico>(create: (context) => ProvaServico(context.read())),
      ChangeNotifierProvider(create: (context) => ProvasProvedor(context.read())),
      ChangeNotifierProvider(create: (context) => ProvasAoVivoStore(context.read())),
      ChangeNotifierProvider(create: (context) => VerificarPermitirCompraProvedor(context.read())),
      // Propagandas
      Provider<PropagandasServico>(create: (context) => PropagandasServico(context.read())),
      ChangeNotifierProvider(create: (context) => PropagandasStore(context.read())),
      // Finalizar Compra
      Provider<FinalizarCompraServico>(create: (context) => FinalizarCompraServico(context.read())),
      Provider<VerificarPagamentoServico>(create: (context) => VerificarPagamentoServico(context.read())),
      Provider<ListarInformacoesServico>(create: (context) => ListarInformacoesServico(context.read())),
      Provider<ListarCartoesServico>(create: (context) => ListarCartoesServico(context.read())),
      ChangeNotifierProvider(create: (context) => FinalizarCompraStore(context.read())),
      ChangeNotifierProvider(create: (context) => VerificarPagamentoStore(context.read())),
      ChangeNotifierProvider(create: (context) => ListarInformacoesStore(context.read())),

      ChangeNotifierProvider(create: (context) => ListarCartoesStore(context.read())),
      // Compras
      Provider<ComprasServico>(create: (context) => ComprasServico(context.read(), context.read<UsuarioProvider>())),
      ChangeNotifierProvider(create: (context) => ComprasProvedor(context.read())),
      ChangeNotifierProvider(create: (context) => TransferenciaProvedor(context.read())),
      // Ordem de Entrada
      Provider<OrdemDeEntradaServico>(create: (context) => OrdemDeEntradaServico(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaStore(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaProvaStore(context.read())),

      Provider(create: (context) => ServicoAnimais(context.read(), context.read())),
      ChangeNotifierProvider(create: (context) => ProvedorAnimal(context.read<ServicoAnimais>())),
    ];
