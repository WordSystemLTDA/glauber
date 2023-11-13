import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glauber/src/compartilhado/constantes/funcoes_global.dart';
import 'package:glauber/src/compartilhado/uteis.dart';
import 'package:glauber/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:glauber/src/modulos/compras/ui/widgets/dashed_line.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class CardCompras extends StatefulWidget {
  final ComprasModelo item;
  const CardCompras({super.key, required this.item});

  @override
  State<CardCompras> createState() => _CardComprasState();
}

class _CardComprasState extends State<CardCompras> {
  double tamanhoCard = 120;

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
    var item = widget.item;

    var dataInicioFiltrado = DateTime.parse(
      DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateFormat('yyyy-MM-dd HH:mm:ss').parse("${item.dataEvento} ${item.horaInicio}"),
      ),
    );

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  backgroundColor: Colors.white,
                  shadowColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Detalhes do seu Ingresso'),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nome'),
                            Text('10/07/2023'),
                            Text('14:22 PM'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Valor ingresso'),
                                Text(
                                  Utils.coverterEmReal.format(double.parse(item.valorIngresso)),
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Valor taxa'),
                                Text(
                                  Utils.coverterEmReal.format(double.parse(item.valorTaxa)),
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Valor desconto'),
                                Text(
                                  Utils.coverterEmReal.format(double.parse(item.valorDesconto)),
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Valor total'),
                                Text(
                                  Utils.coverterEmReal.format(double.parse(item.valorTotal)),
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.nomeProva),
                            const Text('Online'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.dataCompra),
                            Text(item.horaCompra),
                            Text(item.status),
                          ],
                        ),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 20),
                            itemCount: item.provas.length,
                            itemBuilder: (context, index) {
                              var provas = item.provas[index];

                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(provas.nomeCabeceira),
                                      Text(provas.nomeProva),
                                      Text(
                                        Utils.coverterEmReal.format(double.parse(provas.total)),
                                        style: const TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Row(
            children: [
              Container(
                width: 5,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: const VerticalDivider(
                  color: Colors.red,
                  thickness: 5,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("#${item.id} - Nome Empresa"),
                      const SizedBox(height: 10),
                      Text(item.nomeProva),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('11/10/2023'),
                          const Text('14:48 PM'),
                          Text(item.status),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: tamanhoCard,
                width: 60,
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            FuncoesGlobais.abrirWhatsapp(item.numeroCelular);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
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
                                          const SizedBox(height: 15),
                                          QrImageView(
                                            data: item.codigoQr,
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
                                          Text(item.nomeProva),
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
                                                  item.nomeProva,
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
                                                      setStateDialog(() {
                                                        baixandoPDF = true;
                                                      });

                                                      var tempDir = await getTemporaryDirectory();
                                                      var savePath = '${tempDir.path}/inscricao.pdf';

                                                      Response response = await Dio().get(
                                                        'http://192.168.2.114/sistema/api_glauber/geracao_pdf/gerar_pdf.php',
                                                        onReceiveProgress: updateProgress,
                                                        options: Options(
                                                          responseType: ResponseType.bytes,
                                                          followRedirects: false,
                                                          validateStatus: (status) {
                                                            return status! < 500;
                                                          },
                                                        ),
                                                      );

                                                      var file = File(savePath).openSync(mode: FileMode.write);
                                                      file.writeFromSync(response.data);
                                                      await file.close();

                                                      final result = await Share.shareXFiles([XFile(file.path)], text: 'PDF Inscrição');

                                                      print(result.status);
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
                                                    child: baixandoPDF
                                                        ? const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: CircularProgressIndicator(
                                                              color: Colors.white,
                                                              strokeWidth: 1,
                                                            ),
                                                          )
                                                        : const Text('Baixar Ingresso'),
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
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.qr_code_scanner,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
