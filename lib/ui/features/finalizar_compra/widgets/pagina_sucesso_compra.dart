import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provadelaco/config/assets.dart';
import 'package:provadelaco/data/repositories/compras_repository.dart';
import 'package:provadelaco/data/repositories/verificar_pagamento_repository.dart';
import 'package:provadelaco/data/services/verificar_pagamento_servico.dart';
import 'package:provadelaco/domain/models/retorno_compra_modelo.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/features/inicio/widgets/pagina_inicio.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaginaSucessoCompraArgumentos {
  final DadosRetornoCompraModelo dados;
  final String metodoPagamento;

  PaginaSucessoCompraArgumentos({required this.dados, required this.metodoPagamento});
}

class PaginaSucessoCompra extends StatefulWidget {
  final PaginaSucessoCompraArgumentos argumentos;
  const PaginaSucessoCompra({super.key, required this.argumentos});

  @override
  State<PaginaSucessoCompra> createState() => _PaginaSucessoCompraState();
}

class _PaginaSucessoCompraState extends State<PaginaSucessoCompra> {
  bool sucessoAoVerificarPagamento = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    iniciarVerificacaoPagamento();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<ComprasProvedor>().resetarCompras();
      }
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void iniciarVerificacaoPagamento() {
    if (widget.argumentos.dados.tipoRetorno == 'verificacao') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          var verificarPagamentoServico = context.read<VerificarPagamentoServico>();

          _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
            verificarPagamentoServico.verificarPagamento(widget.argumentos.dados.txid!, widget.argumentos.metodoPagamento).then((resposta) {
              if (resposta.sucesso) {
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
    var width = MediaQuery.of(context).size.width;
    var dados = widget.argumentos.dados;
    var verificarPagamentoStore = context.read<VerificarPagamentoStore>();

    if (sucessoAoVerificarPagamento) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  Assets.sucesso,
                  width: 145,
                  height: 145,
                  fit: BoxFit.fill,
                  repeat: false,
                ),
                Text(
                  dados.tituloSucessoAoVerificarPagamento!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.red),
                    foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, AppRotas.inicio, arguments: PaginaInicioArgumentos(rota: AppRotas.compras), (Route<dynamic> route) => false);
                  },
                  child: const Text('Suas inscrições'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  Assets.sucesso,
                  width: 145,
                  height: 145,
                  fit: BoxFit.fill,
                  repeat: false,
                ),
                Text(
                  dados.tituloRetorno!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                if (dados.tipoRetorno == 'normal') ...[
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll<Color>(Colors.red),
                      foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, AppRotas.inicio, arguments: PaginaInicioArgumentos(rota: AppRotas.compras), (Route<dynamic> route) => false);
                    },
                    child: const Text('Suas inscrições'),
                  ),
                ],
                if (dados.tipoRetorno == 'verificacao' || dados.tipoRetorno == 'naoverificar') ...[
                  const SizedBox(height: 25),
                  QrImageView(
                    data: dados.codigoPix!,
                    size: width / 2,
                    backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.transparent : Colors.white,
                  ),
                  SizedBox(
                    width: width / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.green,
                          content: Center(
                            child: Text('Código PIX copiado', textAlign: TextAlign.center),
                          ),
                        ));
                        Clipboard.setData(ClipboardData(text: dados.codigoPix!));
                      },
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll<Color>(Color.fromARGB(255, 224, 224, 224)),
                        foregroundColor: const WidgetStatePropertyAll<Color>(Colors.black),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: const Text('COPIAR CÓDIGO PIX'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    width: 300,
                    child: Text('Suas Inscrições estão confirmadas', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    // child: RichText(
                    //   textAlign: TextAlign.center,
                    //   text: TextSpan(
                    //     text: 'O pagamento deve ser realizado em até',
                    //     style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                    //     children: <TextSpan>[
                    //       TextSpan(text: " ${dados.tempoCancel} minutos", style: const TextStyle(fontWeight: FontWeight.bold)),
                    //       const TextSpan(text: '. Ápos isso, o pedido será'),
                    //       const TextSpan(text: ' cancelado automaticamente', style: TextStyle(color: Colors.red)),
                    //       const TextSpan(text: '.'),
                    //     ],
                    //   ),
                    // ),
                  ),
                  SafeArea(
                    child: SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (dados.tipoRetorno == 'verificacao') ...[
                            ListenableBuilder(
                              listenable: verificarPagamentoStore,
                              builder: (context, _) {
                                return ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.red),
                                    foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    verificarPagamentoStore.verificarPagamento(dados.idVenda!, widget.argumentos.metodoPagamento);
                                  },
                                  child: verificarPagamentoStore.carregando
                                      ? const SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1),
                                        )
                                      : const Text('Verificar Pagamento'),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                          ],
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll<Color>(Colors.red),
                              foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRotas.inicio,
                                arguments: PaginaInicioArgumentos(rota: AppRotas.compras),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: const Text('Suas inscrições'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
