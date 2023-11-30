import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/compartilhado/firebase/notification_service.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
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
    if (mounted) {
      final autenticacaoServico = context.read<AutenticacaoServico>();
      final firebaseMessagingService = context.read<FirebaseMessagingService>();
      var usuario = await UsuarioServico.getUsuario(context);

      String? tokenNotificacao = await firebaseMessagingService.getDeviceFirebaseToken();

      autenticacaoServico.verificar(usuario, tokenNotificacao).then((resposta) async {
        var (sucesso, usuarioRetorno) = resposta;

        if (sucesso) {
          UsuarioServico.salvarUsuario(context, usuarioRetorno!);
        }

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return const PaginaInicio();
          },
        ), (Route<dynamic> route) => false);
      });
    }
  }
}
