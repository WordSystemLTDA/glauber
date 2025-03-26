// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/core/constantes/funcoes_global.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_compras.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_parceiros.dart';
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
    double tamanhoCard = 125;
    var item = widget.item;

    return SizedBox(
      height: (item.provas[0].idmodalidade == '4') ? 130 : 170,
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
          child: Stack(
            children: [
              SizedBox(
                height: tamanhoCard,
                child: Row(
                  children: [
                    Skeleton.shade(
                      child: Container(
                        width: 5,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: (item.provas[0].idmodalidade == '4') ? Radius.circular(5) : Radius.zero,
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
                                Flexible(child: Text(item.nomeEvento)),
                                if (widget.aparecerNomeProva == true) ...[
                                  // SizedBox(width: 10),
                                  // Flexible(child: Text(item.nomeProva)),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (item.provas[0].idmodalidade != '4')
                Positioned(
                  bottom: -5,
                  left: 0,
                  right: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (item.provas[0].idmodalidade == '3') {
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return ModalParceiros(idCompra: item.id, idProva: item.provas[0].id, idEvento: item.idEvento);
                        },
                      );
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 237, 237, 237)),
                      foregroundColor: WidgetStatePropertyAll(Colors.black87),
                    ),
                    child: item.provas[0].idmodalidade == '3'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Animal: ", style: TextStyle(fontSize: 14)),
                              Text(item.provas[0].animalSelecionado?.nomedoanimal ?? '0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              // Text(item.provas[0].animalSelecionado?.racadoanimal ?? '0', style: TextStyle(fontSize: 12)),
                            ],
                          )
                        : Text("Ver meus Parceiros"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
