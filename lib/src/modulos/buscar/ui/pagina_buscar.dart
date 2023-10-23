import 'package:flutter/material.dart';

class PaginaBuscar extends StatefulWidget {
  const PaginaBuscar({super.key});

  @override
  State<PaginaBuscar> createState() => _PaginaBuscarState();
}

class _PaginaBuscarState extends State<PaginaBuscar> {
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
              icon: const Icon(Icons.search),
              // iconSize: 59,
            ),
          ),
        ),
      ),
    ]);
  }
}
