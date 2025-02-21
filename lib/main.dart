import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_widget.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/compartilhado/firebase/notification_service.dart';
import 'package:provadelaco/src/compartilhado/theme/theme_controller.dart';
import 'package:provadelaco/src/essencial/network/dio_cliente.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/providers/config/config_provider.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/essencial/servicos/listar_dados_servicos_impl.dart';
import 'package:provadelaco/src/modulos/animais/provedores/provedor_animal.dart';
import 'package:provadelaco/src/modulos/animais/servicos/servico_animais.dart';
import 'package:provadelaco/src/modulos/autenticacao/data/servicos/autenticacao_servico_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/data/servicos/handicap_servico_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/handicap_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/handicap_store.dart';
import 'package:provadelaco/src/modulos/buscar/data/servicos/buscar_servico_impl.dart';
import 'package:provadelaco/src/modulos/buscar/interator/servicos/buscar_servico.dart';
import 'package:provadelaco/src/modulos/buscar/interator/stores/buscar_store.dart';
import 'package:provadelaco/src/modulos/calendario/data/servicos/agenda_servico_impl.dart';
import 'package:provadelaco/src/modulos/calendario/interator/servicos/agenda_servico.dart';
import 'package:provadelaco/src/modulos/calendario/interator/stores/agenda_info_store.dart';
import 'package:provadelaco/src/modulos/calendario/interator/stores/agenda_store.dart';
import 'package:provadelaco/src/modulos/calendario/ui/widgets/agenda_datasource.dart';
import 'package:provadelaco/src/modulos/compras/data/servicos/compras_servico_impl.dart';
import 'package:provadelaco/src/modulos/compras/interator/provedor/compras_provedor.dart';
import 'package:provadelaco/src/modulos/compras/interator/provedor/transferencia_provedor.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/data/servicos/finalizar_compra_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/data/servicos/listar_cartoes_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/data/servicos/listar_informacoes_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/data/servicos/verificar_pagamento_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/listar_cartoes_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/listar_informacoes_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/verificar_pagamento_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/finalizar_compra_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/listar_cartoes_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/listar_informacoes_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/verificar_pagamento_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/verificar_permitir_compra_provedor.dart';
import 'package:provadelaco/src/modulos/home/data/servicos/home_servico_impl.dart';
import 'package:provadelaco/src/modulos/home/interator/servicos/home_servico.dart';
import 'package:provadelaco/src/modulos/home/interator/stores/home_store.dart';
import 'package:provadelaco/src/modulos/inicio/data/servicos/mudar_senha_servico_impl.dart';
import 'package:provadelaco/src/modulos/inicio/interator/servicos/mudar_senha_servico.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/data/servicos/ordermdeentrada_servico_impl.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/servicos/ordemdeentrada_servico.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/stores/ordemdeentrada_prova_store.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/stores/ordemdeentrada_store.dart';
import 'package:provadelaco/src/modulos/perfil/data/servicos/cidade_servico_impl.dart';
import 'package:provadelaco/src/modulos/perfil/data/servicos/editar_usuario_servico_impl.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/cidade_servico.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/editar_usuario_servico.dart';
import 'package:provadelaco/src/modulos/propaganda/data/servicos/propagandas_servico_impl.dart';
import 'package:provadelaco/src/modulos/propaganda/interator/servicos/propagandas_servico.dart';
import 'package:provadelaco/src/modulos/propaganda/interator/stores/propagandas_store.dart';
import 'package:provadelaco/src/modulos/provas/data/servicos/competidores_servico_impl.dart';
import 'package:provadelaco/src/modulos/provas/data/servicos/denunciar_servico_impl.dart';
import 'package:provadelaco/src/modulos/provas/data/servicos/prova_sevico_impl.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/competidores_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/denunciar_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/prova_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_aovivo_store.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDZ6lea3HfYNHHk56a6XjfyklgXNmKi1EU",
      appId: '1:558343760209:web:40cdf70d0e292a66800b70',
      messagingSenderId: "558343760209",
      projectId: "provasdelaco",
    ),
  );

  HttpOverrides.global = MyHttpOverrides();

  final app = MultiProvider(
    providers: [
      Provider<NotificationService>(create: (context) => NotificationService()),
      Provider<FirebaseMessagingService>(create: (context) => FirebaseMessagingService(context.read())),
      ChangeNotifierProvider(create: (context) => ThemeController()),
      Provider<IHttpClient>(create: (context) => DioClient()),
      ChangeNotifierProvider(create: (context) => UsuarioProvider()),
      ChangeNotifierProvider(create: (context) => ConfigProvider()),
      // Inicio
      Provider<MudarSenhaServico>(create: (context) => MudarSenhaServicoImpl(context.read())),
      // Autenticação
      Provider<HandiCapServico>(create: (context) => HandiCapServicoImpl(context.read())),
      Provider<AutenticacaoServico>(create: (context) => AutenticacaoServicoImpl(context.read())),
      Provider(create: (context) => ListarDadosServicosImpl(context.read())),
      ChangeNotifierProvider(create: (context) => AutenticacaoStore(context.read())),
      ChangeNotifierProvider(create: (context) => HandiCapStore(context.read())),
      // Home
      Provider<HomeServico>(create: (context) => HomeServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => HomeStore(context.read())),
      // Editar Usuario
      Provider<CidadeServico>(create: (context) => CidadeServicoImpl(context.read())),
      Provider<EditarUsuarioServico>(create: (context) => EditarUsuarioServicoImpl(context.read())),
      // Buscar
      Provider<BuscarServico>(create: (context) => BuscarServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => BuscarStore(context.read())),
      // Provas
      Provider<CompetidoresServico>(create: (context) => CompetidoresServicoImpl(context.read())),
      Provider<DenunciarServico>(create: (context) => DenunciarServicoImpl(context.read())),
      Provider<ProvaServico>(create: (context) => ProvaServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => ProvasStore(context.read())),
      ChangeNotifierProvider(create: (context) => ProvasAoVivoStore(context.read())),
      ChangeNotifierProvider(create: (context) => VerificarPermitirCompraProvedor(context.read())),
      // Propagandas
      Provider<PropagandasServico>(create: (context) => PropagandasServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => PropagandasStore(context.read())),
      // Finalizar Compra
      Provider<FinalizarCompraServico>(create: (context) => FinalizarCompraServicoImpl(context.read())),
      Provider<VerificarPagamentoServico>(create: (context) => VerificarPagamentoServicoImpl(context.read())),
      Provider<ListarInformacoesServico>(create: (context) => ListarInformacoesServicoImpl(context.read())),
      Provider<ListarCartoesServico>(create: (context) => ListarCartoesServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => FinalizarCompraStore(context.read())),
      ChangeNotifierProvider(create: (context) => VerificarPagamentoStore(context.read())),
      ChangeNotifierProvider(create: (context) => ListarInformacoesStore(context.read())),

      ChangeNotifierProvider(create: (context) => ListarCartoesStore(context.read())),
      // Compras
      Provider<ComprasServico>(create: (context) => ComprasServicoImpl(context.read<IHttpClient>(), context.read<UsuarioProvider>())),
      ChangeNotifierProvider(create: (context) => ComprasProvedor(context.read())),
      ChangeNotifierProvider(create: (context) => TransferenciaProvedor(context.read())),
      // Ordem de Entrada
      Provider<OrdemDeEntradaServico>(create: (context) => OrdemDeEntradaServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaStore(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaProvaStore(context.read())),
      // Calendário
      Provider<AgendaServico>(create: (context) => AgendaServicoImpl(context.read())),
      Provider<AgendaDataSource>(create: (context) => AgendaDataSource([], context.read())),
      ChangeNotifierProvider(create: (context) => AgendaStore(context.read<AgendaServico>(), context.read<AgendaDataSource>())),
      ChangeNotifierProvider(create: (context) => AgendaInfoStore(context.read<AgendaServico>())),

      Provider(create: (context) => ServicoAnimais(context.read(), context.read())),
      ChangeNotifierProvider(create: (context) => ProvedorAnimal(context.read<ServicoAnimais>())),
    ],
    child: const AppWidget(),
  );

  runApp(app);
}
