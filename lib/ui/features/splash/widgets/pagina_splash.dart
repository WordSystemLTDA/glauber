import 'package:flutter/material.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/data/servicos/usuario_servico.dart';
import 'package:provadelaco/data/servicos/autenticacao_servico.dart';
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
      // initializeFirebaseMessaging();
      // checkForNotifications();
    });
  }

  // initializeFirebaseMessaging() async {
  //   await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  // }

  // checkForNotifications() async {
  //   await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  // }

  void verificarLogin() async {
    if (mounted) {
      var usuario = await UsuarioServico.getUsuario(context);

      if (usuario == null) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRotas.inicio,
            (Route<dynamic> route) => false,
          );
        }
        return;
      } else {
        if (mounted) {
          final autenticacaoServico = context.read<AutenticacaoServico>();
          // final firebaseMessagingService = context.read<FirebaseMessagingService>();

          // String? tokenNotificacao = kIsWeb ? '' : await firebaseMessagingService.getDeviceFirebaseToken();

          autenticacaoServico.verificar(usuario, '').then((resposta) async {
            var (sucesso, _, usuarioRetorno) = resposta;

            if (sucesso) {
              if (mounted) {
                UsuarioServico.salvarUsuario(context, usuarioRetorno!);
              }
            } else {
              if (mounted) {
                UsuarioServico.sair(context);
              }
            }

            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(context, AppRotas.inicio, (Route<dynamic> route) => false);
            }
          });
        }
      }
    }
  }
}
