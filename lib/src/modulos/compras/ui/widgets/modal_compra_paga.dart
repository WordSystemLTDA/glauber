import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/widgets/mostrar_hora_atual.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/dashed_line.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ModalCompraPaga extends StatefulWidget {
  final dynamic item;
  const ModalCompraPaga({super.key, required this.item});

  @override
  State<ModalCompraPaga> createState() => _ModalCompraPagaState();
}

class _ModalCompraPagaState extends State<ModalCompraPaga> {
  late StateSetter _setState;

  // Track the progress of a downloaded file here.
  double progress = 0;

  // Track if the PDF was downloaded here.
  bool baixandoPDF = false;

  void updateProgress(done, total) {
    progress = done / total;
    _setState(() {
      if (progress >= 1) {
        baixandoPDF = false;
      } else {
        // progressString = 'Download progress: ' + (progress * 100).toStringAsFixed(0) + '% done.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var item = widget.item;

    var dataInicioFiltrado = DateTime.parse(
      DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateFormat('yyyy-MM-dd HH:mm:ss').parse("${item.dataEvento} ${item.horaInicio}"),
      ),
    );

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

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  QrImageView(
                    data: item.codigoQr,
                    size: width / 2,
                    backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.transparent : Colors.white,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(item.idCliente),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.airplane_ticket,
                            size: 20,
                          ),
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
                    child: Row(
                      children: [
                        Text(
                          item.nomeEvento,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Data'),
                            SizedBox(
                              width: 200,
                              child: Text(
                                DateFormat.yMMMMEEEEd('pt_BR').format(DateTime.parse(item.dataEvento)),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Hora Inicio'),
                            Text(
                              DateFormat.jm('pt_BR').format(dataInicioFiltrado),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            MostrarHoraAtual(),
                          ],
                        ),
                        Text(
                          item.status,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
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
                              setStateDialog(() {
                                baixandoPDF = true;
                              });

                              var comprasServico = context.read<ComprasServico>();

                              comprasServico.baixarPDF(item.id).then((sucesso) {
                                if (sucesso) {
                                  setStateDialog(() {
                                    baixandoPDF = false;
                                  });
                                }
                              });
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
                            child: baixandoPDF
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1,
                                    ),
                                  )
                                : const FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text('Baixar Ingresso'),
                                  ),
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
