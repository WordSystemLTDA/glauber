// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/data/services/compras_servico.dart';
import 'package:provadelaco/data/services/home_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/domain/models/compras/compras.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/features/competidores/widgets/pagina_selecionar_competidor.dart';
import 'package:provadelaco/ui/features/compras/widgets/modal_compras.dart';
import 'package:provadelaco/ui/features/compras/widgets/modal_parceiros.dart';
import 'package:provadelaco/utils/whatsapp.dart';
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
      return Colors.grey;
    } else {
      return Colors.green;
    }
  }

  Future<bool> verificarConfirmarParceiros() async {
    var usuario = context.read<UsuarioProvider>().usuario;

    if (usuario == null) return false;

    var servico = context.read<HomeServico>();
    var usuarioProvider = context.read<UsuarioProvider>();

    var dados = await servico.listarConfirmarParceiros(usuarioProvider.usuario?.id ?? '0');

    if (mounted) {
      if (dados.lacarcabeca.isNotEmpty || dados.lacarpe.isNotEmpty) {
        Navigator.pushNamed(context, AppRotas.confirmarParceiros);
        return true;
      }
    }

    return false;
  }

  String _mensagemBloqueioCompetidor(ComprasModelo item, CompetidoresModelo competidor) {
    if (item.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty && competidor.id != '0') {
      return 'Esse competidor já foi selecionado.';
    }

    if (competidor.ativo == 'Não') {
      return 'Competidor já fez todas as inscrições.';
    }

    if (competidor.ativo == 'Somatoria') {
      return 'HandiCap do competidor estoura a somatória.';
    }

    if (competidor.ativo == 'HCMinMax') {
      return 'HandiCap do competidor não é compatível com a prova.';
    }

    return 'Esse competidor não pode ser selecionado.';
  }

  Future<void> _abrirSelecaoParceiro(ComprasModelo item) async {
    final competidor = await Navigator.of(context).push<CompetidoresModelo>(
      MaterialPageRoute(
        builder: (_) => PaginaSelecionarCompetidor(
          idCabeceira: widget.item.idCabeceira,
          idProva: widget.item.provas[0].id,
          destacarCardsStatus: true,
          jaSelecionado: (competidor) => item.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty,
          podeSelecionar: (competidor) {
            return ((competidor.ativo == 'Sim' && (item.parceiros.where((element) => element.idParceiro == competidor.id).isEmpty)) || competidor.id == '0');
          },
          mensagemBloqueio: (competidor) => _mensagemBloqueioCompetidor(item, competidor),
        ),
      ),
    );

    if (competidor == null || !mounted) {
      return;
    }

    final comprasServico = context.read<ComprasServico>();

    showDialog<String>(
      context: context,
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          title: const Text('Substituir'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja realmente substituir esse parceiro?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(contextDialog).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                await comprasServico.editarParceiro(item.parceiros[0].id, item.parceiros[0].idParceiro, competidor.id, item.parceiros[0].nomeModalidade).then((value) {
                  var (sucesso, mensagem) = value;

                  if (sucesso) {
                    if (mounted) {
                      if (context.mounted) {
                        if (widget.atualizarLista != null) {
                          widget.atualizarLista!();
                        }
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(mensagem),
                        backgroundColor: Colors.black87,
                      ));
                    }
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoCard = 125;
    var item = widget.item;
    final bool ehFiliacao = item.tipodevenda == 'Filiação';

    return SizedBox(
      height: ((item.provas.isNotEmpty && item.provas[0].idmodalidade == '4') || item.status == 'Cancelado' || item.parceiros.isEmpty) ? 130 : 170,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: ehFiliacao
              ? const BorderSide(color: Colors.orange, width: 2)
              : widget.comprasTransferencia.contains(item) || widget.comprasPagamentos.contains(item)
                  ? const BorderSide(color: Colors.green, width: 2)
                  : BorderSide.none,
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
              if (ehFiliacao) ...[
                Positioned(
                  right: 65,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Filiação',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
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
                            bottomLeft: (item.provas.isNotEmpty && item.provas[0].idmodalidade == '4') ? Radius.circular(5) : Radius.zero,
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
                            mainAxisAlignment: item.provas.isNotEmpty && item.provas[0].liberarReembolso == 'Sim' && item.reembolso == 'Não' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Whatsapp.abrir(item.numeroCelular);
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              ),
                              if (item.provas.isNotEmpty && item.provas[0].liberarReembolso == 'Sim' && item.reembolso == 'Não') ...[
                                IconButton(
                                  onPressed: () {
                                    // FuncoesGlobais.abrirWhatsapp(item.numeroCelular);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Deseja realmente cancelar venda?'),
                                          content: const Text(
                                            'Caso você queira trocar o seu parceiro, não é necessário o cancelamento, você pode alterar em "Ver meus Parceiros" ou "(Nome do parceiro)"',
                                          ),
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
                                                      content: const Text('ATENÇÃO, SE VOCÊ CANCELAR, NÃO PODERÁ FAZER INSCRIÇÃO NOVAMENTE NESTA PROVA E PERDERÁ AS VINCULAÇÕES COM SEUS PARCEIROS. TEM CERTEZA QUE DESEJA CONTINUAR?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text('Voltar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await context
                                                                .read<ComprasServico>()
                                                                .editarReembolsoVenda(
                                                                  item.id,
                                                                  item.idCliente,
                                                                  item.idCabeceira ?? '0',
                                                                )
                                                                .then((value) async {
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
                                                          child: const Text('Quero Cancelar', style: TextStyle(color: Colors.black87)),
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
                                  icon: const Icon(Icons.block_outlined, color: Colors.black87, size: 30),
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
              if (item.provas.isNotEmpty && item.provas[0].idmodalidade != '4' && item.status != 'Cancelado' && item.parceiros.isNotEmpty)
                Positioned(
                  bottom: -5,
                  left: 0,
                  right: 0,
                  child: ElevatedButton(
                    onPressed: () async {
                      var temQueConfirmarParceiros = await verificarConfirmarParceiros();
                      if (temQueConfirmarParceiros) {
                        return;
                      }

                      if (item.provas.isNotEmpty && item.provas[0].idmodalidade == '3') {
                        return;
                      }

                      if (item.provas.isNotEmpty && item.provas[0].avulsa == 'Não') {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ModalParceiros(
                                idCompra: item.id,
                                idProva: item.provas[0].id,
                                idEvento: item.idEvento,
                              );
                            },
                          );
                        }
                        return;
                      }

                      if (item.provas.isNotEmpty && item.provas[0].permitirEditarParceiros == 'Sim') {
                        await _abrirSelecaoParceiro(item);
                      }
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll((item.parceiros.isEmpty || (item.provas.isNotEmpty && item.provas[0].avulsa == 'Não'))
                          ? Theme.of(context).colorScheme.surfaceContainerHighest
                          : (item.parceiros[0].parceiroTemCompra == 'Pendente'
                              ? Colors.grey[400]
                              : item.parceiros[0].parceiroTemCompra == 'Confirmado'
                                  ? Colors.green[200]
                                  : Theme.of(context).colorScheme.surfaceContainerHighest)),
                      foregroundColor: WidgetStatePropertyAll(
                        (item.parceiros.isEmpty || (item.provas.isNotEmpty && item.provas[0].avulsa == 'Não')) ? Theme.of(context).colorScheme.onSurface : (item.parceiros[0].parceiroTemCompra == 'Sem Parceiro' ? Theme.of(context).colorScheme.onSurface : Colors.white),
                      ),
                    ),
                    child: item.provas.isNotEmpty && item.provas[0].idmodalidade == '3'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Animal: ', style: TextStyle(fontSize: 14)),
                              Text(item.provas[0].animalSelecionado?.nomedoanimal ?? '0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          )
                        : (item.provas.isNotEmpty && item.provas[0].avulsa == 'Sim')
                            ? Text(
                                (item.parceiros.isEmpty
                                    ? 'Sorteio'
                                    : item.parceiros[0].nomeParceiro == 'Sem Competidor'
                                        ? 'Sorteio'
                                        : item.parceiros[0].nomeParceiro),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            : Text('Ver seus Parceiros (${item.parceiros.length})', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
