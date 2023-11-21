import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/dashed_line.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ModalCompraNaoPaga extends StatefulWidget {
  final ComprasModelo item;
  const ModalCompraNaoPaga({super.key, required this.item});

  @override
  State<ModalCompraNaoPaga> createState() => _ModalCompraNaoPagaState();
}

class _ModalCompraNaoPagaState extends State<ModalCompraNaoPaga> {
  // ignore: unused_field
  late StateSetter _setState;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var item = widget.item;

    var dataInicioFiltrado = DateTime.parse(
      DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateFormat('yyyy-MM-dd HH:mm:ss').parse("${item.dataEvento} ${item.horaInicio}"),
      ),
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: StatefulBuilder(
        builder: (context, setStateDialog) {
          _setState = setStateDialog;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),
              QrImageView(
                data: item.codigoPIX,
                size: 220.0,
                gapless: false,
              ),
              const SizedBox(height: 20),
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
                        Text(
                          '18:00:00',
                          style: TextStyle(color: Colors.grey),
                        ),
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
                    SizedBox(
                      width: 140,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 219, 219, 219)),
                          foregroundColor: const MaterialStatePropertyAll<Color>(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Text('Fechar'),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            showCloseIcon: true,
                            content: Center(
                              child: Text(
                                'Código PIX copiado',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ));
                          Clipboard.setData(ClipboardData(text: item.codigoPIX));
                        },
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.red),
                          foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
          );
        },
      ),
    );
  }
}
