import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/firebase_options.dart';
import 'package:provadelaco/src/app_widget.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/compartilhado/firebase/notification_service.dart';
import 'package:provadelaco/src/compartilhado/theme/theme_controller.dart';
import 'package:provadelaco/src/essencial/network/dio_cliente.dart';
import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/data/servicos/autenticacao_servico_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/data/servicos/handicap_servico_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/handicap_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/handicap_store.dart';
import 'package:provadelaco/src/modulos/buscar/data/servicos/buscar_servico_impl.dart';
import 'package:provadelaco/src/modulos/buscar/interator/servicos/buscar_servico.dart';
import 'package:provadelaco/src/modulos/buscar/interator/stores/buscar_store.dart';
import 'package:provadelaco/src/modulos/compras/data/servicos/compras_servico_impl.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/compras/interator/stores/compras_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/data/servicos/finalizar_compra_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/data/servicos/listar_informacoes_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/data/servicos/verificar_pagamento_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/listar_informacoes_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/verificar_pagamento_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/finalizar_compra_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/listar_informacoes_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/verificar_pagamento_store.dart';
import 'package:provadelaco/src/modulos/home/data/servicos/home_servico_impl.dart';
import 'package:provadelaco/src/modulos/home/interator/servicos/home_servico.dart';
import 'package:provadelaco/src/modulos/home/interator/stores/home_store.dart';
import 'package:provadelaco/src/modulos/inicio/data/servicos/mudar_senha_servico_impl.dart';
import 'package:provadelaco/src/modulos/inicio/interator/servicos/mudar_senha_servico.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/data/servicos/ordermdeentrada_servico_impl.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/servicos/ordemdeentrada_servico.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/stores/ordemdeentrada_store.dart';
import 'package:provadelaco/src/modulos/perfil/data/editar_usuario_servico_impl.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/editar_usuario_servico.dart';
import 'package:provadelaco/src/modulos/provas/data/servicos/prova_sevico_impl.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/prova_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final app = MultiProvider(
    providers: [
      Provider<NotificationService>(create: (context) => NotificationService()),
      Provider<FirebaseMessagingService>(create: (context) => FirebaseMessagingService(context.read())),
      ChangeNotifierProvider(create: (context) => ThemeController()),
      Provider<IHttpClient>(create: (context) => DioClient()),
      ChangeNotifierProvider(create: (context) => UsuarioProvider()),
      // Inicio
      Provider<MudarSenhaServico>(create: (context) => MudarSenhaServicoImpl(context.read())),
      // Autenticação
      Provider<HandiCapServico>(create: (context) => HandiCapServicoImpl(context.read())),
      Provider<AutenticacaoServico>(create: (context) => AutenticacaoServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => AutenticacaoStore(context.read())),
      ChangeNotifierProvider(create: (context) => HandiCapStore(context.read())),
      // Home
      Provider<HomeServico>(create: (context) => HomeServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => HomeStore(context.read())),
      // Editar Usuario
      Provider<EditarUsuarioServico>(create: (context) => EditarUsuarioServicoImpl(context.read())),
      // Buscar
      Provider<BuscarServico>(create: (context) => BuscarServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => BuscarStore(context.read())),
      // Provas
      Provider<ProvaServico>(create: (context) => ProvaServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => ProvasStore(context.read())),
      // Finalizar Compra
      Provider<FinalizarCompraServico>(create: (context) => FinalizarCompraServicoImpl(context.read())),
      Provider<VerificarPagamentoServico>(create: (context) => VerificarPagamentoServicoImpl(context.read())),
      Provider<ListarInformacoesServico>(create: (context) => ListarInformacoesServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => FinalizarCompraStore(context.read())),
      ChangeNotifierProvider(create: (context) => VerificarPagamentoStore(context.read())),
      ChangeNotifierProvider(create: (context) => ListarInformacoesStore(context.read())),
      // Compras
      Provider<ComprasServico>(create: (context) => ComprasServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => ComprasStore(context.read())),
      // Ordem de Entrada
      Provider<OrdemDeEntradaServico>(create: (context) => OrdemDeEntradaServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => OrdemDeEntradaStore(context.read())),
    ],
    child: const AppWidget(),
  );

  runApp(app);
}
