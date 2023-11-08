import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/uteis.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';

class CardProvas extends StatefulWidget {
  final ProvaModelo prova;
  final String idEvento;
  final Function(ProvaModelo prova) aoClicarNaProva;
  const CardProvas({super.key, required this.prova, required this.idEvento, required this.aoClicarNaProva});

  @override
  State<CardProvas> createState() => _CardProvasState();
}

class _CardProvasState extends State<CardProvas> {
  double tamanhoCard = 120;

  @override
  Widget build(BuildContext context) {
    var prova = widget.prova;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            widget.aoClicarNaProva(prova);
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prova.nomeProva,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            Utils.coverterEmReal.format(double.parse(prova.valor)),
                            style: const TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                height: tamanhoCard,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                  ),
                  margin: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5)),
                          child: const SizedBox(
                            width: 60,
                            child: Center(
                              child: Text(
                                'Cabeça',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5)),
                          child: const SizedBox(
                            width: 60,
                            child: Center(
                              child: Text(
                                'Piseiro',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
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
