import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/parceiros_compra_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/competidores_servico.dart';
import 'package:provider/provider.dart';

class CardParceirosCompra extends StatefulWidget {
  final ComprasModelo item;
  final ParceirosCompraModelo parceiro;
  final List<ParceirosCompraModelo> parceiros;

  const CardParceirosCompra({super.key, required this.item, required this.parceiro, required this.parceiros});

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              if (item.permitirEditarParceiros == 'Sim') {
                controller.openView();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(parceiro.nomeModalidade),
                      const SizedBox(height: 5),
                      Text(parceiro.nomeProva),
                      const SizedBox(height: 5),
                      Text(
                        parceiro.nomeParceiro,
                        style: const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 5),
                      if (parceiro.nomeCidade.isNotEmpty) Text("${parceiro.nomeCidade} - ${parceiro.siglaEstado}"),
                    ],
                  ),
                  if (item.permitirEditarParceiros == 'Sim')
                    IconButton(
                      onPressed: () {
                        if (item.permitirEditarParceiros == 'Sim') {
                          controller.openView();
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) async {
        final keyword = controller.value.text;

        List<CompetidoresModelo>? competidores = await competidoresServico.listarCompetidores(keyword);

        Iterable<Widget> widgets = competidores.map((competidor) {
          return Card(
            elevation: 3.0,
            color: widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty ? const Color(0xFFfbe5ea) : null,
            shape: widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty
                ? RoundedRectangleBorder(side: const BorderSide(width: 1, color: Colors.red), borderRadius: BorderRadius.circular(5))
                : RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            // color: widget.parceiros.where((element) => element.idParceiro == competidor.id).isNotEmpty ? Colors.red : null,
            child: ListTile(
              onTap: () async {
                if (widget.parceiros.where((element) => element.idParceiro == competidor.id).isEmpty) {
                  controller.closeView('');
                  FocusScope.of(context).unfocus();

                  await comprasServico.editarParceiro(parceiro.id, competidor.id).then((value) {
                    var (sucesso, mensagem) = value;
                    if (sucesso) {
                      setState(() {
                        parceiro.idParceiro = competidor.id;
                        parceiro.nomeParceiro = competidor.nome;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(mensagem),
                        backgroundColor: Colors.green,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(mensagem),
                        backgroundColor: Colors.red,
                      ));
                    }
                  });
                }
              },
              leading: Text(competidor.id),
              title: Text(competidor.nome),
              subtitle: Text(
                competidor.apelido,
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
            ),
          );
        });

        return widgets;
      },
    );
  }
}
