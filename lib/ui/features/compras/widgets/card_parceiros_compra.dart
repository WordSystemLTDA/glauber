// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provadelaco/config/constantes/constantes_global.dart';
import 'package:provadelaco/data/repositories/usuario_provider.dart';
import 'package:provadelaco/data/servicos/compras_servico.dart';

import 'package:provadelaco/domain/models/compras/compras_modelo.dart';
import 'package:provadelaco/domain/models/parceiros_compra_modelo.dart';
import 'package:provadelaco/data/servicos/competidores_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores_modelo.dart';
import 'package:provider/provider.dart';

class CardParceirosCompra extends StatefulWidget {
  final ComprasModelo item;
  final ParceirosCompraModelo parceiro;
  final List<ParceirosCompraModelo> parceiros;
  final Function() aoSalvar;

  const CardParceirosCompra({
    super.key,
    required this.item,
    required this.parceiro,
    required this.parceiros,
    required this.aoSalvar,
  });

  @override
  State<CardParceirosCompra> createState() => _CardParceirosCompraState();
}

class _CardParceirosCompraState extends State<CardParceirosCompra> {
  SearchController searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    var competidoresServico = context.read<CompetidoresServico>();
    var comprasServico = context.read<ComprasServico>();
    var item = widget.item;
    var parceiro = widget.parceiro;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SearchAnchor(
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
        return Card(
          margin: const EdgeInsets.only(bottom: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: parceiro.parceiroTemCompra == 'Confirmado'
                    ? Colors.green
                    : parceiro.parceiroTemCompra == 'Pendente'
                        ? const Color.fromARGB(255, 209, 130, 3)
                        : Colors.transparent,
              )),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              if (item.provas[0].permitirEditarParceiros == 'Sim') {
                controller.openView();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(parceiro.nomeModalidade),
                      const SizedBox(height: 5),
                      Text(
                        parceiro.nomeParceiro,
                        style: const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 5),
                      if (parceiro.nomeCidade.isNotEmpty) Text("${parceiro.nomeCidade} - ${parceiro.siglaEstado}"),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                    height: 95,
                    child: Stack(
                      children: [
                        if (item.provas[0].permitirEditarParceiros == 'Sim')
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              onPressed: () {
                                if (item.provas[0].permitirEditarParceiros == 'Sim') {
                                  controller.openView();
                                }
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Positioned(
                          bottom: 10,
                          right: 5,
                          child: Text(
                            parceiro.parceiroTemCompra == 'Pendente'
                                ? 'À Confirmar'
                                : parceiro.parceiroTemCompra == 'Confirmado'
                                    ? 'Confirmado'
                                    : '',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: parceiro.parceiroTemCompra == 'Confirmado'
                                    ? Colors.green
                                    : parceiro.parceiroTemCompra == 'Pendente'
                                        ? Colors.red
                                        : null),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) async {
        final keyword = controller.value.text;
        var usuarioProvider = context.read<UsuarioProvider>();
        List<CompetidoresModelo>? competidores = await competidoresServico.listarCompetidores(widget.item.idCabeceira, usuarioProvider.usuario, keyword, parceiro.idProva);

        Iterable<Widget> widgets = competidores.map((competidor) {
          return Card(
            elevation: 3.0,
            color: (competidor.ativo == 'Não' || widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty) && competidor.id != '0'
                ? const Color(0xFFfbe5ea)
                : (competidor.ativo == 'Somatoria' || competidor.ativo == 'HCMinMax')
                    ? Colors.blue[50]
                    : null,
            shape: (competidor.ativo == 'Não' || widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty) && competidor.id != '0'
                ? RoundedRectangleBorder(side: const BorderSide(width: 1, color: Colors.red), borderRadius: BorderRadius.circular(5))
                : (competidor.ativo == 'Somatoria' || competidor.ativo == 'HCMinMax')
                    ? RoundedRectangleBorder(side: const BorderSide(width: 1, color: Colors.blue), borderRadius: BorderRadius.circular(5))
                    : RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            // color: widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty ? Colors.red : null,
            child: ListTile(
              onTap: () async {
                if ((competidor.ativo == 'Sim' && (widget.parceiros.where((element) => element.idParceiro == competidor.id).isEmpty)) || competidor.id == '0') {
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

                                  // print(parceiro.toMap());
                                  // print(competidor.id);

                                  await comprasServico.editarParceiro(parceiro.id, parceiro.idParceiro, competidor.id, parceiro.nomeModalidade).then((value) {
                                    var (sucesso, mensagem) = value;

                                    if (sucesso) {
                                      if (mounted) {
                                        widget.aoSalvar();
                                        if (context.mounted) {
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
                    color: widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty
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
    );
  }
}
