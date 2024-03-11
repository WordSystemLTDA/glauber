import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/competidores_servico.dart';
import 'package:provider/provider.dart';

class CardParceiros extends StatefulWidget {
  final CompetidoresModelo item;
  final List<CompetidoresModelo> listaCompetidores;

  const CardParceiros({super.key, required this.item, required this.listaCompetidores});

  @override
  State<CardParceiros> createState() => _CardParceirosState();
}

class _CardParceirosState extends State<CardParceiros> {
  SearchController searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    var competidoresServico = context.read<CompetidoresServico>();
    var item = widget.item;

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3.0,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              controller.openView();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item.nome.isEmpty) Text(item.nome.isEmpty ? 'Selecione um Parceiro' : ''),
                      Row(
                        children: [
                          if (item.nome.isNotEmpty)
                            Text(
                              item.id,
                              style: const TextStyle(fontSize: 12),
                            ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.nome, style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text(
                                item.apelido,
                                style: const TextStyle(color: Colors.green),
                              ),
                              if (item.nome.isNotEmpty)
                                Text(
                                  "${item.nomeCidade} - ${item.siglaEstado}",
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: Color.fromARGB(255, 89, 89, 89)),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                    ],
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
            color: widget.listaCompetidores.contains(competidor) ? const Color(0xFFfbe5ea) : null,
            shape: widget.listaCompetidores.contains(competidor)
                ? RoundedRectangleBorder(side: const BorderSide(width: 1, color: Colors.red), borderRadius: BorderRadius.circular(5))
                : RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              onTap: () {
                if (!(widget.listaCompetidores.contains(competidor))) {
                  controller.closeView('');
                  FocusScope.of(context).unfocus();
                  setState(() {
                    item.id = competidor.id;
                    item.nome = competidor.nome;
                    item.apelido = competidor.apelido;
                    item.nomeCidade = competidor.nomeCidade;
                    item.siglaEstado = competidor.siglaEstado;
                  });
                }
              },
              leading: Text(competidor.id),
              title: Text(competidor.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    competidor.apelido,
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                  ),
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
