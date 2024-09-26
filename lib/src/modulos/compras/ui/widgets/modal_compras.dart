import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/card_parceiros_compra.dart';
import 'package:provider/provider.dart';

class ModalCompras extends StatefulWidget {
  final String idCompra;
  final String idProva;
  final String idEvento;
  const ModalCompras({super.key, required this.idCompra, required this.idProva, required this.idEvento});

  @override
  State<ModalCompras> createState() => _ModalComprasState();
}

class _ModalComprasState extends State<ModalCompras> {
  ComprasModelo? item;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    listarCompra();
  }

  void listarCompra() async {
    if (carregando == false) {
      setState(() {
        carregando = true;
      });
    }

    var comprasServico = context.read<ComprasServico>();

    await comprasServico.listarPorId(widget.idCompra, widget.idProva, widget.idEvento).then((value) {
      item = value;
    });

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (item == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      surfaceTintColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width * 0.9,
          maxHeight: height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Detalhes da sua Inscrição', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Detalhes do evento', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            item!.nomeEvento,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(item!.dataEvento))),
                        Text(item!.horaInicioF),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Valores da venda', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Valor ingresso'),
                            Text(
                              Utils.coverterEmReal.format(double.parse(item!.valorIngresso)),
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
                              Utils.coverterEmReal.format(double.parse(item!.valorTaxa)),
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
                              Utils.coverterEmReal.format(double.parse(item!.valorDesconto)),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        if (double.tryParse(item!.valorFiliacao) != null && double.parse(item!.valorFiliacao) > 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Valor filiação'),
                              Text(
                                Utils.coverterEmReal.format(double.parse(item!.valorFiliacao)),
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Valor total'),
                            Text(
                              Utils.coverterEmReal.format(double.parse(item!.valorTotal)),
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
                          item!.pago == 'Não' ? "Não Pago" : "Pago",
                          style: TextStyle(color: item!.pago == 'Não' ? Colors.red : Colors.green),
                        ),
                        Text(item!.formaPagamento),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item!.status),
                        Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(item!.dataCompra))),
                        Text(item!.horaCompra),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Provas Vinculadas', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 5),
                        itemCount: item!.provas.length,
                        itemBuilder: (context, index) {
                          var provas = item!.provas[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(provas.nomeCabeceira!),
                                  const SizedBox(height: 5),
                                  Text(provas.nomeProva),
                                  const SizedBox(height: 5),
                                  Text(
                                    Utils.coverterEmReal.format(double.parse(provas.valor)),
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (item!.parceiros.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text('Seus Parceiros', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 5),
                          itemCount: item!.parceiros.length,
                          itemBuilder: (context, index) {
                            var parceiro = item!.parceiros[index];

                            return CardParceirosCompra(
                              item: item!,
                              parceiro: parceiro,
                              parceiros: item!.parceiros,
                              aoSalvar: () {
                                listarCompra();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                    if (item!.pago == 'Não' && item!.status != 'Cancelado') const SizedBox(height: 70),
                  ],
                ),
              ),
              // if (item!.pago == 'Não' && item!.status != 'Cancelado') ...[
              //   Positioned(
              //     bottom: 10,
              //     left: 0,
              //     right: 0,
              //     child: Align(
              //       alignment: Alignment.center,
              //       child: ElevatedButton(
              //         onPressed: () {
              //           Navigator.pop(context);
              //           Navigator.pushNamed(
              //             context,
              //             AppRotas.finalizarCompra,
              //             arguments: PaginaFinalizarCompraArgumentos(
              //               editarVenda: true,
              //               dadosEdicaoVendaModelo: DadosEdicaoVendaModelo(idVenda: item!.id, metodoPagamento: item!.idFormaPagamento),
              //               provas: item!.provas,
              //               idEvento: item!.idEvento,
              //             ),
              //           ).then((value) {
              //             if (widget.atualizarLista != null) {
              //               widget.atualizarLista!();
              //             }
              //           });
              //         },
              //         child: const Text('Editar forma de Pagamento'),
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
