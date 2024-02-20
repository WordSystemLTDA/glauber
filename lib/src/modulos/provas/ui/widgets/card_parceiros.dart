import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/competidores_servico.dart';
import 'package:provider/provider.dart';

class CardParceiros extends StatefulWidget {
  final CompetidoresModelo item;
  const CardParceiros({super.key, required this.item});

  @override
  State<CardParceiros> createState() => _CardParceirosState();
}

class _CardParceirosState extends State<CardParceiros> {
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
      builder: (BuildContext context, SearchController controller) {
        return Card(
          elevation: 3.0,
          child: ListTile(
            onTap: () {
              controller.openView();
            },
            leading: item.nome.isEmpty ? null : Text(item.id),
            title: Text(item.nome.isEmpty ? 'Selecione um Parceiro' : item.nome),
            contentPadding: item.nome.isEmpty ? const EdgeInsets.symmetric(horizontal: 24, vertical: 10) : null,
            subtitle: item.nome.isEmpty ? null : Text(item.apelido, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) async {
        final keyword = controller.value.text;

        List<CompetidoresModelo>? competidores = await competidoresServico.listarCompetidores(keyword);

        Iterable<Widget> widgets = competidores.map((competidor) {
          return GestureDetector(
            onTap: () {
              controller.closeView('');
              setState(() {
                item.id = competidor.id;
                item.nome = competidor.nome;
                item.apelido = competidor.apelido;

                // idCidade = cidade.id;
                // cidadeController.text = cidade.nome;
              });
              FocusScope.of(context).unfocus();
            },
            child: Card(
              elevation: 3.0,
              child: ListTile(
                leading: Text(competidor.id),
                title: Text(competidor.nome),
                subtitle: Text(
                  competidor.apelido,
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
        });

        return widgets;
      },
    );
  }
}
