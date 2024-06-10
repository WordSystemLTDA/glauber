import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/dashed_line.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_compra_paga.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/verificar_pagamento_servico.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ModalCompraNaoPaga extends StatefulWidget {
  final ComprasModelo item;
  final Function(ComprasModelo item) aoVerificarPagamento;
  const ModalCompraNaoPaga({super.key, required this.item, required this.aoVerificarPagamento});

  @override
  State<ModalCompraNaoPaga> createState() => _ModalCompraNaoPagaState();
}

class _ModalCompraNaoPagaState extends State<ModalCompraNaoPaga> {
  // ignore: unused_field
  late StateSetter _setState;
  bool sucessoAoVerificarPagamento = false;
  bool aparecerModalPaga = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    iniciarVerificacaoPagamento();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void iniciarVerificacaoPagamento() {
    if (widget.item.quandoInscricaoNaoPaga == 'mostrar_qrcode_pix' && widget.item.idFormaPagamento != '6') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          var verificarPagamentoServico = context.read<VerificarPagamentoServico>();

          _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
            verificarPagamentoServico.verificarPagamento(widget.item.id, widget.item.idFormaPagamento).then((sucesso) {
              if (sucesso) {
                widget.aoVerificarPagamento(widget.item);
                _setState(() {
                  sucessoAoVerificarPagamento = true;
                });
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  setState(() {
                    aparecerModalPaga = true;
                  });
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
    var height = MediaQuery.of(context).size.height;
    var item = widget.item;

    if (aparecerModalPaga) {
      return ModalCompraPaga(item: item);
    }

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      surfaceTintColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width * 0.9,
          maxHeight: height * 0.9,
        ),
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            _setState = setStateDialog;

            if (sucessoAoVerificarPagamento) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/lotties/sucesso.json',
                        width: 145,
                        height: 145,
                        fit: BoxFit.fill,
                        repeat: false,
                      ),
                      const Text(
                        'Sua compra foi verificada com sucesso.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: const Text('Fechar'),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  if (item.pixVencido == 'Sim') ...[
                    const Text('Esse pix está Vencido, gere outro para pagar.'),
                  ],
                  if (item.pixVencido == 'Não') ...[
                    QrImageView(
                      data: item.codigoPIX,
                      size: width / 2,
                      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.transparent : Colors.white,
                    ),
                  ],
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 5),
                          Text(item.idCliente),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          const Icon(Icons.airplane_ticket, size: 20),
                          const SizedBox(width: 5),
                          Text(item.id),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(item.nomeEvento),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: CustomPaint(
                      painter: DashedPathPainter(
                        originalPath: Path()..lineTo(width - 40, 0),
                        pathColor: Colors.grey,
                        strokeWidth: 2.0,
                        dashGapLength: 10.0,
                        dashLength: 10.0,
                      ),
                      size: Size(width - 40, 2.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: SizedBox(
                      width: width - 50,
                      child: const Text(
                        'Para concluir sua inscrição, realize o pagamento através do PIX, copiando e colando o código no seu aplicativo do BANCO.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).colorScheme.onSurface),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            child: const Text('Fechar'),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          fit: FlexFit.tight,
                          child: ElevatedButton(
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                showCloseIcon: true,
                                backgroundColor: Colors.green,
                                content: Center(
                                  child: Text('Código PIX copiado', textAlign: TextAlign.center),
                                ),
                              ));
                              Clipboard.setData(ClipboardData(text: item.codigoPIX));
                            },
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll<Color>(Colors.red),
                              foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            child: const Text('Copiar PIX'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
