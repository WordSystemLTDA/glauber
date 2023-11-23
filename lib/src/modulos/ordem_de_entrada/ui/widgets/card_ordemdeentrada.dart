import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';

class CardOrdemDeEntrada extends StatefulWidget {
  final OrdemDeEntradaModelo item;

  const CardOrdemDeEntrada({
    super.key,
    required this.item,
  });

  @override
  State<CardOrdemDeEntrada> createState() => _CardOrdemDeEntradaState();
}

class _CardOrdemDeEntradaState extends State<CardOrdemDeEntrada> {
  double tamanhoCard = 120;

  @override
  Widget build(BuildContext context) {
    var item = widget.item;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            // widget.aoClicarNaProva(prova);
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Parceiros de ${item.nomeCliente}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          item.nomeCabeceira,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        Flexible(
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            shrinkWrap: true,
                            itemCount: item.parceiros.length,
                            itemBuilder: (context, index) {
                              var itemParceiro = item.parceiros[index];

                              return ListTile(
                                title: Text(itemParceiro.nomeCliente),
                                trailing: Text(itemParceiro.somatoria),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: const VerticalDivider(color: Colors.green, thickness: 5),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${item.nomeEvento} - ${item.nomeProva}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            item.nomeCabeceira,
                            style: const TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
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
  }
}
