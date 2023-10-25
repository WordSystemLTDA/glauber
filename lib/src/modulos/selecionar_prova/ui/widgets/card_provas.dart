import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/uteis.dart';

class CardProvas extends StatefulWidget {
  const CardProvas({super.key});

  @override
  State<CardProvas> createState() => _CardProvasState();
}

class _CardProvasState extends State<CardProvas> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/finalizar_compra');
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
                    const Text(
                      'Prova de Laço',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      Utils.coverterEmReal.format(100.0),
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
