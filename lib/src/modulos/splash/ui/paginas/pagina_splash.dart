import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/compartilhado/firebase/notification_service.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provider/provider.dart';

class PaginaSplash extends StatefulWidget {
  const PaginaSplash({super.key});

  @override
  State<PaginaSplash> createState() => _PaginaSplashState();
}

class _PaginaSplashState extends State<PaginaSplash> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // InformacoesApp.getLogoApp(context, widthClara: 200, widthEscura: 140),
            SizedBox(height: 25),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verificarLogin();
      initializeFirebaseMessaging();
      checkForNotifications();
    });
  }

  initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  }

  checkForNotifications() async {
    await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  }

  void verificarLogin() async {
    final autenticacaoServico = context.read<AutenticacaoServico>();
    final firebaseMessagingService = context.read<FirebaseMessagingService>();
    String? tokenNotificacao = await firebaseMessagingService.getDeviceFirebaseToken();

    autenticacaoServico.verificar(tokenNotificacao).then((logado) async {
      var usuario = UsuarioProvider.getUsuario();

      if (logado && usuario != null) {
        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        Navigator.pushReplacementNamed(context, '/inicio');
      }
    });
  }
}
