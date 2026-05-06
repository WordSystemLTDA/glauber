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
  bool _competidorEstaBloqueado(CompetidoresModelo competidor) {
    if ((competidor.motivosBloqueio ?? []).isNotEmpty) {
      return true;
    }

    if (competidor.podeCorrer == false) {
      return true;
    }

    if (widget.listaCompetidores.where((element) => element.id == competidor.id).isNotEmpty && competidor.id != '0') {
      return true;
    }

    if (competidor.ativo == 'Não' || competidor.ativo == 'Somatoria' || competidor.ativo == 'HCMinMax') {
      return true;
    }

    return false;
  }

  void _mostrarMensagemBloqueio(CompetidoresModelo competidor) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_mensagemBloqueioCompetidor(competidor)),
        showCloseIcon: true,
      ),
    );
  }

  String _mensagemBloqueioCompetidor(CompetidoresModelo competidor) {
    if ((competidor.motivosBloqueio ?? []).isNotEmpty) {
      return competidor.motivosBloqueio!.join('\n');
    }

    if (competidor.podeCorrer == false && competidor.mensagemValidacao != null && competidor.mensagemValidacao!.isNotEmpty) {
      return competidor.mensagemValidacao!;
    }

    if (widget.listaCompetidores.where((element) => element.id == competidor.id).isNotEmpty && competidor.id != '0') {
      return 'COMPETIDOR JA SELECIONADO';
    }

    if (competidor.ativo == 'Não') {
      return 'COMPETIDOR INDISPONIVEL';
    }

    if (competidor.ativo == 'Somatoria') {
      return 'SOMATORIA EXCEDE O LIMITE';
    }

    if (competidor.ativo == 'HCMinMax') {
      return 'HC FORA DA FAIXA';
    }

    return 'VINCULACAO BLOQUEADA';
  }

  Future<void> _abrirSelecaoParceiro() async {
    final item = widget.item;

    final competidor = await Navigator.of(context).push<CompetidoresModelo>(
      MaterialPageRoute(
        builder: (_) => PaginaSelecionarCompetidor(
          idCabeceira: widget.idCabeceira,
          idProva: widget.idProva,
          destacarCardsStatus: true,
          bloquearCliqueIncompativel: true,
          idsJaSelecionados: widget.listaCompetidores.map((e) => e.id).toList(),
          jaSelecionado: (competidor) => widget.listaCompetidores.where((element) => element.id == competidor.id).isNotEmpty,
          podeSelecionar: (competidor) {
            if (competidor.id == '0') {
              return true;
            }

            if (_competidorEstaBloqueado(competidor)) {
              return false;
            }

            return competidor.ativo == 'Sim';
          },
          mensagemBloqueio: _mensagemBloqueioCompetidor,
        ),
      ),
    );

    if (competidor == null || !mounted) {
      return;
    }

    if (_competidorEstaBloqueado(competidor)) {
      _mostrarMensagemBloqueio(competidor);
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
    // Só bloqueia se o parceiro está preenchido E a somatória é inválida
    final canSelect = item.nome.isEmpty || item.podeCorrer != false;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 3.0,
      color: (item.nome.isNotEmpty && item.podeCorrer == false) ? Colors.red.shade50 : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: canSelect ? _abrirSelecaoParceiro : null,
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
                  Opacity(
                    opacity: canSelect ? 1.0 : 0.5,
                    child: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                  ),
                ],
              ),
              if (item.hccabeceira != null && item.hccabeceiraParceiro != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Handicap: ${item.hccabeceira} + ${item.hcpezeiroParceiro} = ${item.somaDupla}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            'Limite: ${item.somatoriProva}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue),
                          ),
                        ],
                      ),
                      if (item.podeCorrer == false && item.mensagemValidacao != null && item.mensagemValidacao!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          item.mensagemValidacao!,
                          style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ] else if (item.podeCorrer == true) ...[
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.check_circle, size: 14, color: Colors.green),
                            SizedBox(width: 5),
                            Text(
                              'Dupla compatível',
                              style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
