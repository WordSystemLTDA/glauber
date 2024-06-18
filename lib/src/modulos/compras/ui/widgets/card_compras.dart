// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/constantes/funcoes_global.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/card_parceiros_compra.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_compra_nao_paga.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_compra_paga.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class CardCompras extends StatefulWidget {
  final ComprasModelo item;
  final bool modoTransferencia;
  final bool modoGerarPagamento;
  final List<ComprasModelo> comprasTransferencia;
  final List<ComprasModelo> comprasPagamentos;
  final Function(ComprasModelo compra) aoClicarParaTransferir;
  final Function(ComprasModelo compra) aoClicarParaGerarPagamento;
  bool? aparecerNomeProva;
  Function()? atualizarLista;

  CardCompras({
    super.key,
    required this.item,
    required this.modoTransferencia,
    required this.modoGerarPagamento,
    required this.comprasTransferencia,
    required this.comprasPagamentos,
    required this.aoClicarParaTransferir,
    required this.aoClicarParaGerarPagamento,
    this.aparecerNomeProva = false,
    this.atualizarLista,
  });

  @override
  State<CardCompras> createState() => _CardComprasState();
}

class _CardComprasState extends State<CardCompras> {
  double tamanhoCard = 120;

  Color corCompra(ComprasModelo item) {
    if (item.status == 'Cancelado') {
      return Colors.yellow;
    } else if (item.pago == 'Não') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var item = widget.item;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: widget.comprasTransferencia.contains(item) || widget.comprasPagamentos.contains(item) ? const BorderSide(color: Colors.green, width: 2) : BorderSide.none,
        ),
        child: InkWell(
          onTap: (widget.modoTransferencia || widget.modoGerarPagamento) && (item.status == 'Cancelado')
              ? null
              : () {
                  if (widget.modoTransferencia) {
                    widget.aoClicarParaTransferir(item);
                    return;
                  }

                  if (widget.modoGerarPagamento) {
                    widget.aoClicarParaGerarPagamento(item);
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (context) {
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
                                              item.nomeEvento,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(item.dataEvento))),
                                          Text(item.horaInicioF),
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
                                          if (double.tryParse(item.valorFiliacao) != null && double.parse(item.valorFiliacao) > 0) ...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text('Valor filiação'),
                                                Text(
                                                  Utils.coverterEmReal.format(double.parse(item.valorFiliacao)),
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
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.only(top: 5),
                                          itemCount: item.provas.length,
                                          itemBuilder: (context, index) {
                                            var provas = item.provas[index];

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
                                      if (item.parceiros.isNotEmpty) ...[
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Seus Parceiros',
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 5),
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.only(top: 5),
                                            itemCount: item.parceiros.length,
                                            itemBuilder: (context, index) {
                                              var parceiro = item.parceiros[index];

                                              return CardParceirosCompra(
                                                item: item,
                                                parceiro: parceiro,
                                                parceiros: item.parceiros,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                      if (item.pago == 'Não' && item.status != 'Cancelado') const SizedBox(height: 70),
                                    ],
                                  ),
                                ),
                                // if (item.pago == 'Não' && item.status != 'Cancelado') ...[
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
                                //               dadosEdicaoVendaModelo: DadosEdicaoVendaModelo(idVenda: item.id, metodoPagamento: item.idFormaPagamento),
                                //               provas: item.provas,
                                //               idEvento: item.idEvento,
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
                    },
                  );
                },
          child: Row(
            children: [
              Skeleton.shade(
                child: Container(
                  width: 5,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                  child: VerticalDivider(color: corCompra(item), thickness: 5),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("#${item.id} - ${item.nomeEmpresa}"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(item.nomeEvento),
                          if (widget.aparecerNomeProva == true) ...[
                            const Text(' - '),
                            Text(item.nomeProva),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(item.dataCompra))),
                          Text(item.horaCompra),
                          Text(item.pago == 'Não' ? 'Pendente' : 'Pago'),
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
                            if (item.pago == 'Sim') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ModalCompraPaga(item: item);
                                },
                              );
                            } else {
                              if (item.status == 'Cancelado') {
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text('Esse ingresso foi cancelado.'),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {},
                                  ),
                                ));
                                return;
                              }

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
                          icon: const Icon(Icons.qr_code_scanner, size: 30),
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
