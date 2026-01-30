import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provadelaco/config/constantes/constantes_global.dart';
import 'package:provadelaco/config/constantes/funcoes_global.dart';
import 'package:provadelaco/data/repositories/usuario_provider.dart';
import 'package:provadelaco/data/servicos/compras_servico.dart';

import 'package:provadelaco/domain/models/compras/compras_modelo.dart';
import 'package:provadelaco/ui/features/compras/widgets/card_parceiros_compra.dart';
import 'package:provadelaco/data/servicos/competidores_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores_modelo.dart';
import 'package:provider/provider.dart';

class ModalParceiros extends StatefulWidget {
  final String idCompra;
  final String idProva;
  final String idEvento;
  const ModalParceiros({super.key, required this.idCompra, required this.idProva, required this.idEvento});

  @override
  State<ModalParceiros> createState() => _ModalParceirosState();
}

class _ModalParceirosState extends State<ModalParceiros> {
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
                    Text(item?.nomeEvento ?? 'Sem Prova'),
                    if (item!.parceiros.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Seus Parceiros', style: TextStyle(fontWeight: FontWeight.w700)),
                          SearchAnchor(
                            viewBuilder: (suggestions) {
                              if (suggestions.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 50.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text('Nenhum competidor disponível para essa Prova.'),
                                  ),
                                );
                              }
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
                            builder: (BuildContext context, SearchController controller) {
                              return TextButton(
                                onPressed: () {
                                  controller.openView();
                                },
                                child: const Text('Competidores disponíveis', style: TextStyle(fontSize: 14)),
                              );
                            },
                            suggestionsBuilder: (BuildContext context, SearchController controller) async {
                              final keyword = controller.value.text;
                              var usuarioProvider = context.read<UsuarioProvider>();
                              bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
                              var competidoresServico = context.read<CompetidoresServico>();

                              List<CompetidoresModelo>? competidores =
                                  await competidoresServico.listarBancoCompetidores(item!.idCabeceira!, usuarioProvider.usuario, keyword, widget.idProva);

                              Iterable<Widget> widgets = competidores.map((competidor) {
                                return Card(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  child: ListTile(
                                    onTap: () {},
                                    leading: Text(competidor.id),
                                    title: Text(competidor.nome, style: TextStyle(color: isDarkMode ? Colors.white : null)),
                                    trailing: competidor.celular == null || (competidor.celular != null && competidor.celular!.isEmpty)
                                        ? null
                                        : IconButton(
                                            onPressed: () {
                                              if (competidor.celular != null && competidor.celular!.isNotEmpty) {
                                                FuncoesGlobais.abrirWhatsapp(competidor.celular!);
                                              }
                                            },
                                            icon: const FaIcon(
                                              FontAwesomeIcons.whatsapp,
                                              color: Colors.green,
                                            ),
                                          ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(competidor.apelido, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                                        if (competidor.hccabeceira != null && competidor.hcpezeiro != null) ...[
                                          Text("Cabeça: ${competidor.hccabeceira!} - Pé: ${competidor.hcpezeiro}", style: const TextStyle(fontWeight: FontWeight.w500)),
                                        ],
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
                        ],
                      ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
