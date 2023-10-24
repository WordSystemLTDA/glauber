import 'package:flutter/material.dart';

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
    });
  }

  void verificarLogin() async {
    Navigator.pushReplacementNamed(context, '/inicio');
    // Navigator.pushReplacementNamed(context, '/autenticacao/login');
  }
}
