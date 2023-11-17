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
    return SizedBox(
      height: tamanhoCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            // widget.aoClicarNaProva(prova);
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
                      child: const VerticalDivider(color: Colors.red, thickness: 5),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'nome',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'valor',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 70,
                height: tamanhoCard,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                  ),
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.grey, width: 1)),
                    ),
                    height: tamanhoCard,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1);
                      },
                      padding: const EdgeInsets.only(bottom: 1),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return InkWell(
                          borderRadius: index == 0 ? const BorderRadius.only(topRight: Radius.circular(5)) : const BorderRadius.only(bottomRight: Radius.circular(5)),
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: index == 0 ? const BorderRadius.only(topRight: Radius.circular(5)) : const BorderRadius.only(bottomRight: Radius.circular(5)),
                            ),
                            width: 90,
                            height: tamanhoCard / 2.1,
                            child: Center(
                              child: Text(
                                index.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
