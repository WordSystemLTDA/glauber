import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/prova_parceiros_modelo.dart';

class CardOrdemDeEntradaProva extends StatefulWidget {
  final ProvaParceirosModelos item;
  final bool mostrarOpcoes;
  final bool selecionado;
  final String nomeprova;

  const CardOrdemDeEntradaProva({
    super.key,
    required this.item,
    required this.mostrarOpcoes,
    required this.selecionado,
    required this.nomeprova,
  });

  @override
  State<CardOrdemDeEntradaProva> createState() => _CardOrdemDeEntradaProvaState();
}

class _CardOrdemDeEntradaProvaState extends State<CardOrdemDeEntradaProva> {
  @override
  Widget build(BuildContext context) {
    var itemParceiro = widget.item;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: widget.selecionado ? const BorderSide(width: 1, color: Colors.green) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${itemParceiro.nomeClienteCabeceira.toUpperCase()}${itemParceiro.sorteiocabeceira.contains('Sim') ? ' (SORTEIO)' : ''}",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          Text(
                            "${itemParceiro.nomeClientePezeiro.toUpperCase()}${itemParceiro.sorteiopezeiro.contains('Sim') ? ' (SORTEIO)' : ''}",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8.0, // gap between adjacent chips
              // runSpacing: 4.0, // gap between lines
              // alignment: WrapAlignment.spaceBetween,
              children: [
                if (itemParceiro.boi1 != '')
                  Row(
                    children: [
                      const Text('1:', style: TextStyle(color: Color.fromARGB(255, 107, 107, 107))),
                      Text(itemParceiro.boi1 == '' ? '0' : itemParceiro.boi1),
                    ],
                  ),
                if (itemParceiro.boi2 != '')
                  Row(
                    children: [
                      const Text('2:', style: TextStyle(color: Color.fromARGB(255, 107, 107, 107))),
                      Text(itemParceiro.boi2 == '' ? '0' : itemParceiro.boi2),
                    ],
                  ),
                if (itemParceiro.boi3 != '')
                  Row(
                    children: [
                      const Text('3:', style: TextStyle(color: Color.fromARGB(255, 107, 107, 107))),
                      Text(itemParceiro.boi3 == '' ? '0' : itemParceiro.boi3),
                    ],
                  ),
                if (itemParceiro.boi4 != '')
                  Row(
                    children: [
                      const Text('4:', style: TextStyle(color: Color.fromARGB(255, 107, 107, 107))),
                      Text(itemParceiro.boi4 == '' ? '0' : itemParceiro.boi4),
                    ],
                  ),
                if (itemParceiro.finalT != '')
                  Row(
                    children: [
                      const Text('F:', style: TextStyle(color: Color.fromARGB(255, 107, 107, 107))),
                      Text(itemParceiro.finalT == '' ? '0' : itemParceiro.finalT),
                    ],
                  ),
                if (itemParceiro.medio != '')
                  Row(
                    children: [
                      const Text('M:', style: TextStyle(color: Color.fromARGB(255, 107, 107, 107))),
                      Text(double.parse(itemParceiro.medio).toStringAsFixed(2)),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inscrição: ${itemParceiro.numeroDaInscricao}',
                  textAlign: TextAlign.center,
                ),
                if (widget.nomeprova == 'CLASSIFICAÇÃO FINAL') ...[
                  Text(
                    'Classificação: ${itemParceiro.ranking}',
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'Ranking: ${itemParceiro.classificacao}',
                    textAlign: TextAlign.center,
                  ),
                ],
                Text(
                  itemParceiro.somatoria,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
