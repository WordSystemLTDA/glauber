import 'package:flutter/material.dart';

class PaginaBuscar extends StatefulWidget {
  const PaginaBuscar({super.key});

  @override
  State<PaginaBuscar> createState() => _PaginaBuscarState();
}

class _PaginaBuscarState extends State<PaginaBuscar> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar eventos...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
