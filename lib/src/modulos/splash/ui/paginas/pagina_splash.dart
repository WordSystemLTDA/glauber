import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:glauber/src/compartilhado/firebase/notification_service.dart';
import 'package:glauber/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
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

    autenticacaoServico.verificar().then((logado) async {
      if (logado) {
        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        Navigator.pushReplacementNamed(context, '/autenticacao/login');
      }
    });
  }
}
