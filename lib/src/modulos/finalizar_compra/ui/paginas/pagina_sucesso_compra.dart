import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lottie/lottie.dart';

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
            Lottie.asset(
              'assets/lotties/sucesso.json',
              width: 135,
              height: 135,
              fit: BoxFit.fill,
              repeat: false,
            ),
            const Text(
              'Código PIX gerado!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            QrImageView(
              data: '123iop12j93ij12890h89whe8912gh98312890389012h38912h938123',
              size: 250,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 224, 224, 224)),
                  foregroundColor: const MaterialStatePropertyAll<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                child: const Text('COPIAR CÓDIGO PIX'),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'O pagamento deve ser realizado em até',
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: ' 30 minutos', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '. Ápos isso, o pedido será'),
                    TextSpan(text: ' cancelado automaticamente', style: TextStyle(color: Colors.red)),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll<Color>(Colors.red),
                    foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Verificar Pagamento'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll<Color>(Colors.red),
                    foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return const PaginaInicio();
                      },
                    ), (Route<dynamic> route) => false);
                  },
                  child: const Text('Inicio'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
