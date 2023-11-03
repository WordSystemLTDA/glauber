import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/compras/interator/modelos/compras_modelo.dart';

class CardCompras extends StatefulWidget {
  final ComprasModelo item;
  const CardCompras({super.key, required this.item});

  @override
  State<CardCompras> createState() => _CardComprasState();
}

class _CardComprasState extends State<CardCompras> {
  double tamanhoCard = 130;

  @override
  Widget build(BuildContext context) {
    var item = widget.item;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              Container(
                width: 5,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: const VerticalDivider(
                  color: Colors.red,
                  thickness: 5,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("#${item.id} - Zé neto e Cristiano"),
                      const SizedBox(height: 10),
                      Text("Prova de Laço ${item.valorTotal}"),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('11/10/2023'), Text('14:48 PM'), Text('Pendente')],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: tamanhoCard,
                width: 60,
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.telegram,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.qr_code_scanner,
                            size: 30,
                          ),
                        ),
                      ],
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
