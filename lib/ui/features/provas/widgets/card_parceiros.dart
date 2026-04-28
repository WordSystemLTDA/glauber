// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/ui/features/competidores/widgets/pagina_selecionar_competidor.dart';

class CardParceiros extends StatefulWidget {
  final CompetidoresModelo item;
  final String idProva;
  final List<CompetidoresModelo> listaCompetidores;
  final String? idCabeceira;

  const CardParceiros({
    super.key,
    required this.item,
    required this.idProva,
    required this.listaCompetidores,
    this.idCabeceira,
  });

  @override
  State<CardParceiros> createState() => _CardParceirosState();
}

class _CardParceirosState extends State<CardParceiros> {
  String _mensagemBloqueioCompetidor(CompetidoresModelo competidor) {
    if (widget.listaCompetidores.where((element) => element.id == competidor.id).isNotEmpty && competidor.id != '0') {
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

  Future<void> _abrirSelecaoParceiro() async {
    final item = widget.item;

    final competidor = await Navigator.of(context).push<CompetidoresModelo>(
      MaterialPageRoute(
        builder: (_) => PaginaSelecionarCompetidor(
          idCabeceira: widget.idCabeceira,
          idProva: widget.idProva,
          destacarCardsStatus: true,
          jaSelecionado: (competidor) => widget.listaCompetidores.where((element) => element.id == competidor.id).isNotEmpty,
          podeSelecionar: (competidor) {
            return ((competidor.ativo == 'Sim' && (widget.listaCompetidores.where((element) => element.id == competidor.id).isEmpty)) || competidor.id == '0');
          },
          mensagemBloqueio: _mensagemBloqueioCompetidor,
        ),
      ),
    );

    if (competidor == null || !mounted) {
      return;
    }

    setState(() {
      item.id = competidor.id;
      item.nome = competidor.nome;
      item.apelido = competidor.apelido;
      item.nomeCidade = competidor.nomeCidade;
      item.siglaEstado = competidor.siglaEstado;
      item.jaExistente = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 3.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: _abrirSelecaoParceiro,
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
                          if (item.nomeCidade.isNotEmpty)
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
  }
}
