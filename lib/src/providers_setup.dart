import 'package:provadelaco/src/core/theme/theme_controller.dart';
import 'package:provadelaco/src/essencial/network/dio_cliente.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/config/config_provider.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/data/servicos/listar_dados_servicos.dart';
import 'package:provadelaco/src/data/repositories/provedor_animal.dart';
import 'package:provadelaco/src/data/servicos/servico_animais.dart';
import 'package:provadelaco/src/data/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/data/servicos/handicap_servico.dart';
import 'package:provadelaco/src/data/repositories/autenticacao_store.dart';
import 'package:provadelaco/src/data/repositories/handicap_store.dart';
import 'package:provadelaco/src/data/servicos/buscar_servico.dart';
import 'package:provadelaco/src/data/repositories/buscar_store.dart';
import 'package:provadelaco/src/data/servicos/compras_servico.dart';
import 'package:provadelaco/src/data/repositories/compras_provedor.dart';
import 'package:provadelaco/src/data/repositories/transferencia_provedor.dart';
import 'package:provadelaco/src/data/servicos/finalizar_compra_servico.dart';
import 'package:provadelaco/src/data/servicos/listar_cartoes_servico.dart';
import 'package:provadelaco/src/data/servicos/listar_informacoes_servico.dart';
import 'package:provadelaco/src/data/servicos/verificar_pagamento_servico.dart';
import 'package:provadelaco/src/data/repositories/finalizar_compra_store.dart';
import 'package:provadelaco/src/data/repositories/listar_cartoes_store.dart';
import 'package:provadelaco/src/data/repositories/listar_informacoes_store.dart';
import 'package:provadelaco/src/data/repositories/verificar_pagamento_store.dart';
import 'package:provadelaco/src/data/repositories/verificar_permitir_compra_provedor.dart';
import 'package:provadelaco/src/data/servicos/home_servico.dart';
import 'package:provadelaco/src/data/repositories/home_store.dart';
import 'package:provadelaco/src/data/servicos/mudar_senha_servico.dart';
import 'package:provadelaco/src/data/servicos/ordermdeentrada_servico.dart';
import 'package:provadelaco/src/data/repositories/ordemdeentrada_prova_store.dart';
import 'package:provadelaco/src/data/repositories/ordemdeentrada_store.dart';
import 'package:provadelaco/src/data/servicos/cidade_servico.dart';
import 'package:provadelaco/src/data/servicos/editar_usuario_servico.dart';
import 'package:provadelaco/src/data/servicos/propagandas_servico.dart';
import 'package:provadelaco/src/data/repositories/propagandas_store.dart';
import 'package:provadelaco/src/data/servicos/competidores_servico.dart';
import 'package:provadelaco/src/data/servicos/denunciar_servico.dart';
import 'package:provadelaco/src/data/servicos/prova_sevico.dart';
import 'package:provadelaco/src/data/repositories/provas_aovivo_store.dart';
import 'package:provadelaco/src/data/repositories/provas_provedor.dart';
import 'package:provadelaco/src/data/repositories/provas_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers => [
      // Provider<NotificationService>(create: (context) => NotificationService()),
      // Provider<FirebaseMessagingService>(create: (context) => FirebaseMessagingService(context.read())),
      ChangeNotifierProvider(create: (context) => ThemeController()),
      Provider<IHttpClient>(create: (context) => DioClient()),
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
      ChangeNotifierProvider(create: (context) => ProvasStore(context.read())),
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
      Provider<ComprasServico>(create: (context) => ComprasServico(context.read<IHttpClient>(), context.read<UsuarioProvider>())),
      ChangeNotifierProvider(create: (context) => ComprasProvedor(context.read())),
      ChangeNotifierProvider(create: (context) => TransferenciaProvedor(context.read())),
      // Ordem de Entrada
      Provider<OrdemDeEntradaServico>(create: (context) => OrdemDeEntradaServico(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaStore(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaProvaStore(context.read())),
      // Calendário
      // Provider<AgendaServico>(create: (context) => AgendaServico(context.read())),
      // Provider<AgendaDataSource>(create: (context) => AgendaDataSource([], context.read())),
      // ChangeNotifierProvider(create: (context) => AgendaStore(context.read<AgendaServico>(), context.read<AgendaDataSource>())),
      // ChangeNotifierProvider(create: (context) => AgendaInfoStore(context.read<AgendaServico>())),

      Provider(create: (context) => ServicoAnimais(context.read(), context.read())),
      ChangeNotifierProvider(create: (context) => ProvedorAnimal(context.read<ServicoAnimais>())),
      ChangeNotifierProvider(create: (context) => ProvasProvedor()),
    ];
