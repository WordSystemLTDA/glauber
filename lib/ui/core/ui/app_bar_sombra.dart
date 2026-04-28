// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/features/competidores/widgets/pagina_selecionar_competidor.dart';
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
  Future<void> _abrirSelecaoCompetidor(BuildContext context, UsuarioProvider usuarioProvider) async {
    final competidorSelecionado = await Navigator.of(context).push<CompetidoresModelo>(
      MaterialPageRoute(
        builder: (_) => const PaginaSelecionarCompetidor(),
      ),
    );

    if (!mounted || competidorSelecionado == null) {
      return;
    }

    usuarioProvider.setUsuario(usuarioProvider.usuario!.copyWith(
      id: () => competidorSelecionado.id,
      nome: () => competidorSelecionado.nome,
      apelido: () => competidorSelecionado.apelido,
    ));

    _mostrarSnackBarTopo('Competidor selecionado: ${competidorSelecionado.nome}');
  }

  void _mostrarSnackBarTopo(String mensagem) {
    final mediaQuery = MediaQuery.of(context);
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: mediaQuery.size.height - (mediaQuery.padding.top + kToolbarHeight + 40),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

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
                          if (kDebugMode) ...[
                            GestureDetector(
                              onTap: () => _abrirSelecaoCompetidor(context, usuarioProvider),
                              child: Text(
                                "ID: ${usuarioProvider.usuario!.id!}",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ] else ...[
                            Text(
                              "ID: ${usuarioProvider.usuario!.id!}",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ],
                      )
                  ],
                ),
              )
            : widget.titulo,
        actions: [
          if (widget.aparecerIconeNotificacao ?? false) ...[
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRotas.confirmarParceiros,
                );
              },
            ),
          ]
        ],
      ),
    );
  }
}
