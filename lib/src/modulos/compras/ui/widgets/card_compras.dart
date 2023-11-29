import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/constantes/funcoes_global.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_compra_nao_paga.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_compra_paga.dart';

class CardCompras extends StatefulWidget {
  final ComprasModelo item;
  const CardCompras({super.key, required this.item});

  @override
  State<CardCompras> createState() => _CardComprasState();
}

class _CardComprasState extends State<CardCompras> {
  double tamanhoCard = 120;

  @override
  Widget build(BuildContext context) {
    var item = widget.item;

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
                        const Text(
                          'Detalhes do seu Ingresso',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Detalhes do evento',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.nomeEvento),
                            Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(item.dataEvento))),
                            Text(item.horaInicio),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Valores da venda',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5),
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
                        const Text(
                          'Detalhes da compra',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.pago == 'Não' ? "Não Pago" : "Pago",
                              style: TextStyle(color: item.pago == 'Não' ? Colors.red : Colors.green),
                            ),
                            Text(item.formaPagamento),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.status),
                            Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(item.dataCompra))),
                            Text(item.horaCompra),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Provas Vinculadas',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 5),
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
                child: VerticalDivider(
                  color: item.pago == 'Sim' ? Colors.green : Colors.red,
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
                      Text(item.nomeEvento),
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
                            if (item.quandoInscricaoNaoPaga == 'nao_mostrar_qrcode_pix') {
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(item.mensagemQuandoInscricaoNaoPaga),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {},
                                ),
                              ));
                              return;
                            }

                            if (item.pago == 'Sim') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ModalCompraPaga(item: item);
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ModalCompraNaoPaga(
                                    item: item,
                                    aoVerificarPagamento: (item) {
                                      setState(() {
                                        item.pago = 'Sim';
                                      });
                                    },
                                  );
                                },
                              );
                            }
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
