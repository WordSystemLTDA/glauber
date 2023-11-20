import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/retorno_compra_modelo.dart';
import 'package:provadelaco/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lottie/lottie.dart';

class PaginaSucessoCompra extends StatefulWidget {
  final DadosRetornoCompraModelo dados;
  const PaginaSucessoCompra({super.key, required this.dados});

  @override
  State<PaginaSucessoCompra> createState() => _PaginaSucessoCompraState();
}

class _PaginaSucessoCompraState extends State<PaginaSucessoCompra> {
  @override
  Widget build(BuildContext context) {
    var dados = widget.dados;

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
              data: dados.codigoPix!,
              size: 250,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 280,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    showCloseIcon: true,
                    content: Center(
                      child: Text(
                        'Código PIX copiado',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ));
                  Clipboard.setData(ClipboardData(text: dados.codigoPix!));
                },
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
