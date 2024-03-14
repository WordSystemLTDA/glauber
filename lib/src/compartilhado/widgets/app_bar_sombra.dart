// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provider/provider.dart';

class AppBarSombra extends StatefulWidget implements PreferredSizeWidget {
  final Widget titulo;
  final bool? aparecerIconeNotificacao;
  final bool? aparecerIconeCalendario;
  final bool? aparecerIdUsuario;

  const AppBarSombra({
    super.key,
    required this.titulo,
    this.aparecerIconeNotificacao,
    this.aparecerIconeCalendario,
    this.aparecerIdUsuario,
  });

  @override
  State<AppBarSombra> createState() => _AppBarSombraState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarSombraState extends State<AppBarSombra> {
  @override
  Widget build(BuildContext context) {
    var usuarioProvider = context.read<UsuarioProvider>();

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
        title: widget.aparecerIdUsuario ?? false
            ? SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.titulo,
                    if (usuarioProvider.usuario != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_outline, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            "ID: ${usuarioProvider.usuario!.id!}",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                  ],
                ),
              )
            : widget.titulo,
        actions: [
          if (widget.aparecerIconeCalendario ?? false) ...[
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: () {
                Navigator.pushNamed(context, AppRotas.calendario);
              },
            ),
          ],
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
