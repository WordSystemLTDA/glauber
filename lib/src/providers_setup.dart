import 'package:provadelaco/src/core/theme/theme_controller.dart';
import 'package:provadelaco/src/essencial/network/dio_cliente.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/config/config_provider.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/essencial/servicos/listar_dados_servicos_impl.dart';
import 'package:provadelaco/src/data/repositories/provedor_animal.dart';
import 'package:provadelaco/src/data/servicos/servico_animais.dart';
import 'package:provadelaco/src/data/servicos/autenticacao_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/handicap_servico_impl.dart';
import 'package:provadelaco/src/data/repositories/autenticacao_store.dart';
import 'package:provadelaco/src/data/repositories/handicap_store.dart';
import 'package:provadelaco/src/data/servicos/buscar_servico_impl.dart';
import 'package:provadelaco/src/data/repositories/buscar_store.dart';
import 'package:provadelaco/src/data/servicos/compras_servico_impl.dart';
import 'package:provadelaco/src/data/repositories/compras_provedor.dart';
import 'package:provadelaco/src/data/repositories/transferencia_provedor.dart';
import 'package:provadelaco/src/data/servicos/finalizar_compra_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/listar_cartoes_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/listar_informacoes_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/verificar_pagamento_servico_impl.dart';
import 'package:provadelaco/src/data/repositories/finalizar_compra_store.dart';
import 'package:provadelaco/src/data/repositories/listar_cartoes_store.dart';
import 'package:provadelaco/src/data/repositories/listar_informacoes_store.dart';
import 'package:provadelaco/src/data/repositories/verificar_pagamento_store.dart';
import 'package:provadelaco/src/data/repositories/verificar_permitir_compra_provedor.dart';
import 'package:provadelaco/src/data/servicos/home_servico_impl.dart';
import 'package:provadelaco/src/data/repositories/home_store.dart';
import 'package:provadelaco/src/data/servicos/mudar_senha_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/ordermdeentrada_servico_impl.dart';
import 'package:provadelaco/src/data/repositories/ordemdeentrada_prova_store.dart';
import 'package:provadelaco/src/data/repositories/ordemdeentrada_store.dart';
import 'package:provadelaco/src/data/servicos/cidade_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/editar_usuario_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/propagandas_servico_impl.dart';
import 'package:provadelaco/src/data/repositories/propagandas_store.dart';
import 'package:provadelaco/src/data/servicos/competidores_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/denunciar_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/prova_sevico_impl.dart';
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
      Provider<MudarSenhaServicoImpl>(create: (context) => MudarSenhaServicoImpl(context.read())),
      // Autenticação
      Provider<HandiCapServicoImpl>(create: (context) => HandiCapServicoImpl(context.read())),
      Provider<AutenticacaoServicoImpl>(create: (context) => AutenticacaoServicoImpl(context.read())),
      Provider(create: (context) => ListarDadosServicosImpl(context.read())),
      ChangeNotifierProvider(create: (context) => AutenticacaoStore(context.read())),
      ChangeNotifierProvider(create: (context) => HandiCapStore(context.read())),
      // Home
      Provider<HomeServicoImpl>(create: (context) => HomeServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => HomeStore(context.read())),
      // Editar Usuario
      Provider<CidadeServicoImpl>(create: (context) => CidadeServicoImpl(context.read())),
      Provider<EditarUsuarioServicoImpl>(create: (context) => EditarUsuarioServicoImpl(context.read())),
      // Buscar
      Provider<BuscarServicoImpl>(create: (context) => BuscarServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => BuscarStore(context.read())),
      // Provas
      Provider<CompetidoresServico>(create: (context) => CompetidoresServico(context.read())),
      Provider<DenunciarServico>(create: (context) => DenunciarServico(context.read())),
      Provider<ProvaServico>(create: (context) => ProvaServico(context.read())),
      ChangeNotifierProvider(create: (context) => ProvasStore(context.read())),
      ChangeNotifierProvider(create: (context) => ProvasAoVivoStore(context.read())),
      ChangeNotifierProvider(create: (context) => VerificarPermitirCompraProvedor(context.read())),
      // Propagandas
      Provider<PropagandasServicoImpl>(create: (context) => PropagandasServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => PropagandasStore(context.read())),
      // Finalizar Compra
      Provider<FinalizarCompraServicoImpl>(create: (context) => FinalizarCompraServicoImpl(context.read())),
      Provider<VerificarPagamentoServicoImpl>(create: (context) => VerificarPagamentoServicoImpl(context.read())),
      Provider<ListarInformacoesServicoImpl>(create: (context) => ListarInformacoesServicoImpl(context.read())),
      Provider<ListarCartoesServicoImpl>(create: (context) => ListarCartoesServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => FinalizarCompraStore(context.read())),
      ChangeNotifierProvider(create: (context) => VerificarPagamentoStore(context.read())),
      ChangeNotifierProvider(create: (context) => ListarInformacoesStore(context.read())),

      ChangeNotifierProvider(create: (context) => ListarCartoesStore(context.read())),
      // Compras
      Provider<ComprasServicoImpl>(create: (context) => ComprasServicoImpl(context.read<IHttpClient>(), context.read<UsuarioProvider>())),
      ChangeNotifierProvider(create: (context) => ComprasProvedor(context.read())),
      ChangeNotifierProvider(create: (context) => TransferenciaProvedor(context.read())),
      // Ordem de Entrada
      Provider<OrdemDeEntradaServicoImpl>(create: (context) => OrdemDeEntradaServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaStore(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaProvaStore(context.read())),
      // Calendário
      // Provider<AgendaServico>(create: (context) => AgendaServicoImpl(context.read())),
      // Provider<AgendaDataSource>(create: (context) => AgendaDataSource([], context.read())),
      // ChangeNotifierProvider(create: (context) => AgendaStore(context.read<AgendaServico>(), context.read<AgendaDataSource>())),
      // ChangeNotifierProvider(create: (context) => AgendaInfoStore(context.read<AgendaServico>())),

      Provider(create: (context) => ServicoAnimais(context.read(), context.read())),
      ChangeNotifierProvider(create: (context) => ProvedorAnimal(context.read<ServicoAnimais>())),
      ChangeNotifierProvider(create: (context) => ProvasProvedor()),
    ];
