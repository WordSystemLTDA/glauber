import 'package:flutter/material.dart';

class Buscar extends StatefulWidget {
  const Buscar({super.key});

  @override
  State<Buscar> createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[350],
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                )),
            hintText: 'Pesquisar...',
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
              // iconSize: 59,
            ),
          ),
        ),
      ),
    ]);
  }
}
