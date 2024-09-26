// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/constantes/funcoes_global.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_compras.dart';
import 'package:provider/provider.dart';
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
                      return ModalCompras(idCompra: item.id, idProva: item.provas[0].id, idEvento: item.idEvento);
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
                          Text(item.pago == 'Não' ? 'Pendente' : 'Pago'),
                          Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(item.dataCompra))),
                          Text(item.horaCompra),
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
                      mainAxisAlignment: item.provas[0].liberarReembolso == 'Sim' && item.reembolso == 'Não' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
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
                        if (item.provas[0].liberarReembolso == 'Sim' && item.reembolso == 'Não') ...[
                          IconButton(
                            onPressed: () {
                              // FuncoesGlobais.abrirWhatsapp(item.numeroCelular);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Deseja realmente cancelar venda?'),
                                    content: const Text('Cancelar venda'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Não'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Cuidado!'),
                                                content: const Text('Essa inscrição será Cancelada.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Voltar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await context.read<ComprasServico>().editarReembolsoVenda(item.id).then((value) {
                                                        if (context.mounted) {
                                                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text(value.$2)),
                                                          );
                                                        }

                                                        if (value.$1 == true) {
                                                          if (context.mounted) {
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          }

                                                          if (widget.atualizarLista != null) {
                                                            widget.atualizarLista!();
                                                          }
                                                        }
                                                      });
                                                    },
                                                    child: const Text('Quero Cancelar', style: TextStyle(color: Colors.red)),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('Sim'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.block_outlined, color: Colors.red, size: 30),
                          ),
                        ],
                        // IconButton(
                        //   onPressed: () {
                        //     if (item.pago == 'Sim') {
                        //       showDialog(
                        //         context: context,
                        //         builder: (context) {
                        //           return ModalCompraPaga(item: item);
                        //         },
                        //       );
                        //     } else {
                        //       if (item.status == 'Cancelado') {
                        //         ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //           content: const Text('Esse ingresso foi cancelado.'),
                        //           action: SnackBarAction(
                        //             label: 'OK',
                        //             onPressed: () {},
                        //           ),
                        //         ));
                        //         return;
                        //       }

                        //       if (item.quandoInscricaoNaoPaga == 'nao_mostrar_qrcode_pix') {
                        //         ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //           content: Text(item.mensagemQuandoInscricaoNaoPaga),
                        //           action: SnackBarAction(
                        //             label: 'OK',
                        //             onPressed: () {},
                        //           ),
                        //         ));
                        //         return;
                        //       }

                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return ModalCompraNaoPaga(
                        //       item: item,
                        //       aoVerificarPagamento: (item) {
                        //         setState(() {
                        //           item.pago = 'Sim';
                        //         });
                        //       },
                        //     );
                        //   },
                        // );
                        //     }
                        //   },
                        //   icon: const Icon(Icons.qr_code_scanner, size: 30),
                        // ),
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
