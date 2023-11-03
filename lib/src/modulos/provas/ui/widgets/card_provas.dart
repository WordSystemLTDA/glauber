import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/uteis.dart';
import 'package:glauber/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';

class CardProvas extends StatefulWidget {
  final ProvaModelo prova;
  final String idEvento;
  const CardProvas({super.key, required this.prova, required this.idEvento});

  @override
  State<CardProvas> createState() => _CardProvasState();
}

class _CardProvasState extends State<CardProvas> {
  @override
  Widget build(BuildContext context) {
    var prova = widget.prova;

    return SizedBox(
      height: 130,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return PaginaFinalizarCompra(idProva: prova.id, idEvento: widget.idEvento);
              },
            ));
          },
          borderRadius: BorderRadius.circular(5),
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
      ),
    );
  }
}
