import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/theme/theme_controller.dart';
import 'package:glauber/src/essencial/network/dio_cliente.dart';
import 'package:glauber/src/essencial/network/http_cliente.dart';
import 'package:glauber/src/modulos/autenticacao/data/servicos/autenticacao_servico_impl.dart';
import 'package:glauber/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:glauber/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provider/provider.dart';

void main() {
  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeController()),
      Provider<IHttpClient>(create: (context) => DioClient()),
      // Autenticação
      Provider<AutenticacaoServico>(create: (context) => AutenticacaoServicoImpl(context.read())),
      ChangeNotifierProvider(create: (context) => AutenticacaoStore(context.read())),
    ],
  );

  runApp(app);
}
