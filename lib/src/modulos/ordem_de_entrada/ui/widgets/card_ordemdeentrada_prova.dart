import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/prova_parceiros_modelo.dart';

class CardOrdemDeEntradaProva extends StatefulWidget {
  final ProvaParceirosModelos item;
  final bool mostrarOpcoes;

  const CardOrdemDeEntradaProva({
    super.key,
    required this.item,
    required this.mostrarOpcoes,
  });

  @override
  State<CardOrdemDeEntradaProva> createState() => _CardOrdemDeEntradaProvaState();
}

class _CardOrdemDeEntradaProvaState extends State<CardOrdemDeEntradaProva> {
  @override
  Widget build(BuildContext context) {
    var itemParceiro = widget.item;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Inscrição: ${itemParceiro.numeroDaInscricao}",
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          Text("#${itemParceiro.id}"),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cabeceiro: #${itemParceiro.idClienteCabeceira} ${itemParceiro.nomeClienteCabeceira}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Pezeiro: #${itemParceiro.idClientePezeiro} ${itemParceiro.nomeClientePezeiro}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('1 BOI'),
                      Text(itemParceiro.boi1),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('2 BOI'),
                      Text(itemParceiro.boi2),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('3 BOI'),
                      Text(itemParceiro.boi3),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('4 BOI'),
                      Text(itemParceiro.boi4),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Final'),
                      Text(itemParceiro.finalT),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Média'),
                      Text(itemParceiro.medio),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Ranking: ${itemParceiro.ranking}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
