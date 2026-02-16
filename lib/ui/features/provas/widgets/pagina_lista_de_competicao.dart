import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/modelo_prova_ao_vivo.dart';
import 'package:provadelaco/ui/features/provas/widgets/card_lista_competicao.dart';
import 'package:provadelaco/domain/models/nomes_cabeceira_modelo.dart';

class PaginaListaDeCompeticao extends StatelessWidget {
  final List<ModeloProvaAoVivo> listaCompeticao;
  final String searchText;
  final Function(ModeloProvaAoVivo) aoSelecionar;
  final String idEvento;
  final dynamic evento;
  final List<NomesCabeceiraModelo>? nomesCabeceira;

  const PaginaListaDeCompeticao({
    super.key,
    required this.listaCompeticao,
    required this.searchText,
    required this.aoSelecionar,
    required this.idEvento,
    required this.evento,
    required this.nomesCabeceira,
  });

  @override
  Widget build(BuildContext context) {
    final listaFiltrada = listaCompeticao
        .where((item) => item.nome.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    if (listaFiltrada.isEmpty) {
      return const Center(child: Text('Nenhuma prova encontrada'));
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemCount: listaFiltrada.length,
      itemBuilder: (context, index) {
        var item = listaFiltrada[index];
        return CardListaCompeticao(
          item: item,
          evento: evento,
          nomesCabeceira: nomesCabeceira,
          idEvento: idEvento,
          provasCarrinho: const [],
          aoSelecionar: aoSelecionar,
        );
      },
    );
  }
}
