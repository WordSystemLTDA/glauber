import 'package:flutter/material.dart';

class AppBarSombra extends StatefulWidget implements PreferredSizeWidget {
  final Widget titulo;
  final bool? aparecerIconeNotificacao;
  const AppBarSombra({super.key, required this.titulo, this.aparecerIconeNotificacao});

  @override
  State<AppBarSombra> createState() => _AppBarSombraState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarSombraState extends State<AppBarSombra> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primaryContainer,
          offset: const Offset(0, 0),
          blurRadius: 10.0,
        ),
      ]),
      child: AppBar(
        elevation: 0.0,
        title: widget.titulo,
        actions: [
          if (widget.aparecerIconeNotificacao ?? false) ...[
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ]
        ],
      ),
    );
  }
}
