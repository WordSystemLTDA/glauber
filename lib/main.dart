import 'package:flutter/material.dart';
import 'package:glauber/src/app_widget.dart';
import 'package:glauber/src/compartilhado/theme/theme_controller.dart';
import 'package:glauber/src/essencial/network/dio_cliente.dart';
import 'package:glauber/src/essencial/network/http_cliente.dart';
import 'package:glauber/src/essencial/usuario_provider.dart';
import 'package:glauber/src/modulos/autenticacao/data/servicos/autenticacao_servico_impl.dart';
import 'package:glauber/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:glauber/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:glauber/src/modulos/compras/data/servicos/compras_servico_impl.dart';
import 'package:glauber/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:glauber/src/modulos/compras/interator/stores/compras_store.dart';
import 'package:glauber/src/modulos/finalizar_compra/data/servicos/finalizar_compra_servico_impl.dart';
import 'package:glauber/src/modulos/finalizar_compra/data/servicos/listar_informacoes_servico_impl.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/servicos/listar_informacoes_servico.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/stores/finalizar_compra_store.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/stores/listar_informacoes_store.dart';
import 'package:glauber/src/modulos/home/data/servicos/home_servico_impl.dart';
import 'package:glauber/src/modulos/home/interator/servicos/home_servico.dart';
import 'package:glauber/src/modulos/home/interator/stores/home_store.dart';
import 'package:glauber/src/modulos/provas/data/servicos/prova_sevico_impl.dart';
import 'package:glauber/src/modulos/provas/interator/servicos/prova_servico.dart';
import 'package:glauber/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UsuarioProvider.init();

  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeController()),
      Provider<IHttpClient>(create: (context) => DioClient()),
      // Autenticação
      Provider<AutenticacaoServico>(create: (context) => AutenticacaoServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => AutenticacaoStore(context.read())),
      // Home
      Provider<HomeServico>(create: (context) => HomeServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => HomeStore(context.read())),
      // Provas
      Provider<ProvaServico>(create: (context) => ProvaServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => ProvasStore(context.read())),
      // Finalizar Compra
      Provider<FinalizarCompraServico>(create: (context) => FinalizarCompraServicoImpl(context.read())),
      Provider<ListarInformacoesServico>(create: (context) => ListarInformacoesServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => FinalizarCompraStore(context.read())),
      ChangeNotifierProvider(create: (context) => ListarInformacoesStore(context.read())),
      // Compras
      Provider<ComprasServico>(create: (context) => ComprasServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => ComprasStore(context.read())),
    ],
    child: const AppWidget(),
  );

  runApp(app);
}
