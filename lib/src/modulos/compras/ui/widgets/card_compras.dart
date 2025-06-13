// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/core/constantes/constantes_global.dart';
import 'package:provadelaco/src/core/constantes/funcoes_global.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_compras.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/modal_parceiros.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/competidores_servico.dart';
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
  SearchController searchController = SearchController();

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
    var competidoresServico = context.read<CompetidoresServico>();
    var comprasServico = context.read<ComprasServico>();
    double tamanhoCard = 125;
    var item = widget.item;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                                                      content: const Text(
                                                          'ATENÇÃO, SE VOCÊ CANCELAR, NÃO PODERÁ FAZER INSCRIÇÃO NOVAMENTE NESTA PROVA. TEM CERTEZA QUE DESEJA CONTINUAR?'),
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
                  child: SearchAnchor(
                    viewBuilder: (suggestions) {
                      return ListView.builder(
                        itemCount: suggestions.length,
                        padding: EdgeInsets.only(bottom: ConstantesGlobal.alturaTeclado),
                        itemBuilder: (context, index) {
                          var itemN = suggestions.elementAt(index);

                          return itemN;
                        },
                      );
                    },
                    isFullScreen: true,
                    searchController: searchController,
                    builder: (BuildContext context, SearchController controller) {
                      return ElevatedButton(
                        onPressed: () {
                          if (item.provas[0].idmodalidade == '3') {
                            return;
                          }

                          if (item.provas[0].avulsa == 'Não') {
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
                            return;
                          }

                          if (item.provas[0].permitirEditarParceiros == 'Sim') {
                            controller.openView();
                          }
                        },
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll((item.parceiros.isEmpty || item.provas[0].avulsa == 'Não')
                              ? const Color.fromARGB(255, 237, 237, 237)
                              : (item.parceiros[0].parceiroTemCompra == 'Pendente'
                                  ? Colors.red[200]
                                  : item.parceiros[0].parceiroTemCompra == 'Confirmado'
                                      ? Colors.green[200]
                                      : const Color.fromARGB(255, 237, 237, 237))),
                          foregroundColor: WidgetStatePropertyAll(
                            (item.parceiros.isEmpty || item.provas[0].avulsa == 'Não')
                                ? Colors.black
                                : (item.parceiros[0].parceiroTemCompra == 'Sem Parceiro' ? Colors.black87 : Colors.white),
                          ),
                        ),
                        child: item.provas[0].idmodalidade == '3'
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Animal: ", style: TextStyle(fontSize: 14)),
                                  Text(item.provas[0].animalSelecionado?.nomedoanimal ?? '0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              )
                            : item.provas[0].avulsa == 'Sim'
                                ? Text(
                                    (item.parceiros.isEmpty
                                        ? "Sorteio"
                                        : item.parceiros[0].nomeParceiro == 'Sem Competidor'
                                            ? 'Sorteio'
                                            : item.parceiros[0].nomeParceiro),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  )
                                : Text('Ver seus Parceiros (${item.parceiros.length})', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      );
                    },
                    suggestionsBuilder: (BuildContext context, SearchController controller) async {
                      final keyword = controller.value.text;
                      var usuarioProvider = context.read<UsuarioProvider>();
                      List<CompetidoresModelo>? competidores =
                          await competidoresServico.listarCompetidores(widget.item.idCabeceira, usuarioProvider.usuario, keyword, widget.item.provas[0].id);

                      Iterable<Widget> widgets = competidores.map((competidor) {
                        return Card(
                          elevation: 3.0,
                          color: (competidor.ativo == 'Não' || item.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty) && competidor.id != '0'
                              ? const Color(0xFFfbe5ea)
                              : (competidor.ativo == 'Somatoria' || competidor.ativo == 'HCMinMax')
                                  ? Colors.blue[50]
                                  : null,
                          shape: (competidor.ativo == 'Não' || item.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty) && competidor.id != '0'
                              ? RoundedRectangleBorder(side: const BorderSide(width: 1, color: Colors.red), borderRadius: BorderRadius.circular(5))
                              : (competidor.ativo == 'Somatoria' || competidor.ativo == 'HCMinMax')
                                  ? RoundedRectangleBorder(side: const BorderSide(width: 1, color: Colors.blue), borderRadius: BorderRadius.circular(5))
                                  : RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          // color: widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty ? Colors.red : null,
                          child: ListTile(
                            onTap: () async {
                              if ((competidor.ativo == 'Sim' && (item.parceiros.where((element) => element.idParceiro == competidor.id).isEmpty)) || competidor.id == '0') {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext contextDialog) {
                                    return AlertDialog(
                                      title: const Text('Substituir'),
                                      content: const SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text("Deseja realmente substituir esse parceiro?"),
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
                                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                                              if (mounted) {
                                                controller.closeView('');
                                                FocusScope.of(context).unfocus();

                                                await comprasServico
                                                    .editarParceiro(item.parceiros[0].id, item.parceiros[0].idParceiro, competidor.id, item.parceiros[0].nomeModalidade)
                                                    .then((value) {
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
                                                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text(mensagem),
                                                          backgroundColor: Colors.red,
                                                        ));
                                                      }
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            leading: Text(competidor.id),
                            trailing: competidor.ativo == 'Não'
                                ? const Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Competidor já'),
                                      Text('Fez todas as inscrições'),
                                    ],
                                  )
                                : competidor.ativo == 'Somatoria'
                                    ? const Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('HandiCap do Competidor'),
                                          Text('Estoura a somatória'),
                                        ],
                                      )
                                    : competidor.ativo == 'HCMinMax'
                                        ? const Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('HandiCap do Competidor'),
                                              Text('Não é compatível com a prova'),
                                            ],
                                          )
                                        : null,
                            title: Text(
                              competidor.nome,
                              style: TextStyle(
                                  color: item.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty
                                      ? Colors.black
                                      : isDarkMode
                                          ? Colors.white
                                          : null),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  competidor.apelido,
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                ),
                                if (competidor.nomeCidade.isNotEmpty)
                                  Text(
                                    "${competidor.nomeCidade} - ${competidor.siglaEstado}",
                                    style: const TextStyle(fontWeight: FontWeight.w500, color: Color.fromARGB(255, 89, 89, 89)),
                                  ),
                              ],
                            ),
                          ),
                        );
                      });

                      return widgets;
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
