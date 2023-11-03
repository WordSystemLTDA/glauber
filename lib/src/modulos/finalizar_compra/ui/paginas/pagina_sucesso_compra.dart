import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/inicio/ui/paginas/pagina_inicio.dart';

class PaginaSucessoCompra extends StatefulWidget {
  const PaginaSucessoCompra({super.key});

  @override
  State<PaginaSucessoCompra> createState() => _PaginaSucessoCompraState();
}

class _PaginaSucessoCompraState extends State<PaginaSucessoCompra> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sucesso ao Comprar'),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return const PaginaInicio();
                  },
                ));
              },
              child: const Text('Voltar para página de Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
