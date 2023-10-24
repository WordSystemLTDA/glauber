import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/compras/ui/widgets/card_compras.dart';

class PaginaCompras extends StatefulWidget {
  const PaginaCompras({super.key});

  @override
  State<PaginaCompras> createState() => _PaginaComprasState();
}

class _PaginaComprasState extends State<PaginaCompras> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return const CardCompras();
      },
    );
  }
}
