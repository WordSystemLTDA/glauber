import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/verificar_pagamento_estado.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/retorno_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/verificar_pagamento_servico.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/stores/verificar_pagamento_store.dart';
import 'package:provadelaco/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lottie/lottie.dart';

class PaginaSucessoCompra extends StatefulWidget {
  final DadosRetornoCompraModelo dados;
  final String metodoPagamento;
  const PaginaSucessoCompra({super.key, required this.dados, required this.metodoPagamento});

  @override
  State<PaginaSucessoCompra> createState() => _PaginaSucessoCompraState();
}

class _PaginaSucessoCompraState extends State<PaginaSucessoCompra> {
  bool sucessoAoVerificarPagamento = false;

  @override
  void initState() {
    super.initState();
    iniciarVerificacaoPagamento();
  }

  void iniciarVerificacaoPagamento() {
    if (widget.dados.tipoRetorno == 'verificacao') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          var verificarPagamentoServico = context.read<VerificarPagamentoServico>();

          Timer.periodic(const Duration(seconds: 5), (timer) {
            verificarPagamentoServico.verificarPagamento(widget.dados.idVenda!, widget.metodoPagamento).then((sucesso) {
              if (sucesso) {
                setState(() {
                  sucessoAoVerificarPagamento = true;
                });
                timer.cancel();
              }
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dados = widget.dados;
    var verificarPagamentoStore = context.read<VerificarPagamentoStore>();

    if (sucessoAoVerificarPagamento) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lotties/sucesso.json',
                width: 145,
                height: 145,
                fit: BoxFit.fill,
                repeat: false,
              ),
              Text(
                dados.tituloSucessoAoVerificarPagamento!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 50),
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
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/sucesso.json',
              width: 145,
              height: 145,
              fit: BoxFit.fill,
              repeat: false,
            ),
            Text(
              dados.tituloRetorno!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (dados.tipoRetorno == 'normal') ...[
              const SizedBox(height: 50),
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
            if (dados.tipoRetorno == 'verificacao') ...[
              const SizedBox(height: 25),
              QrImageView(
                data: dados.codigoPix!,
                size: 250,
                backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.transparent : Colors.white,
              ),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      showCloseIcon: true,
                      backgroundColor: Colors.green,
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
                  text: TextSpan(
                    text: 'O pagamento deve ser realizado em até',
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                    children: <TextSpan>[
                      TextSpan(text: " ${dados.tempoCancel} minutos", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: '. Ápos isso, o pedido será'),
                      const TextSpan(text: ' cancelado automaticamente', style: TextStyle(color: Colors.red)),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<VerificarPagamentoEstado>(
                      valueListenable: verificarPagamentoStore,
                      builder: (context, state, _) {
                        return SizedBox(
                          width: 200,
                          child: ElevatedButton(
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
                              verificarPagamentoStore.verificarPagamento(dados.idVenda!, widget.metodoPagamento);
                            },
                            child: state is Verificando
                                ? const SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1,
                                    ),
                                  )
                                : const Text('Verificar Pagamento'),
                          ),
                        );
                      }),
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
          ],
        ),
      ),
    );
  }
}
