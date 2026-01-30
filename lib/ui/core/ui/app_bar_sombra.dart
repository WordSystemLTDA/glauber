// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/config/config.dart';
import 'package:provadelaco/data/repositories/usuario_repository.dart';
import 'package:provadelaco/data/services/competidores_servico.dart';
import 'package:provadelaco/domain/models/competidores/competidores.dart';
import 'package:provadelaco/routing/routes.dart';
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
    var competidoresServico = context.read<CompetidoresServico>();
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                            SearchAnchor(
                              viewBuilder: (suggestions) {
                                if (suggestions.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 50.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text('Nenhum competidor disponível para essa Prova.'),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: suggestions.length,
                                  padding: EdgeInsets.only(bottom: ConstantesGlobal.alturaTeclado),
                                  itemBuilder: (context, index) {
                                    var itemN = suggestions.elementAt(index);

                                    return itemN;
                                  },
                                );
                              },
                              isFullScreen: true,
                              builder: (BuildContext context, SearchController controller) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.openView();
                                  },
                                  child: Text(
                                    "ID: ${usuarioProvider.usuario!.id!}",
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                );
                              },
                              suggestionsBuilder: (BuildContext context, SearchController controller) async {
                                final keyword = controller.value.text;
                                var usuarioProvider = context.read<UsuarioProvider>();

                                List<CompetidoresModelo>? competidores = await competidoresServico.listarCompetidores('1', usuarioProvider.usuario, keyword, '713');

                                Iterable<Widget> widgets = competidores.map((competidor) {
                                  return Card(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    child: ListTile(
                                      onTap: () {
                                        usuarioProvider.setUsuario(usuarioProvider.usuario!.copyWith(
                                          id: () => competidor.id,
                                          nome: () => competidor.nome,
                                          apelido: () => competidor.apelido,
                                        ));
                                        controller.closeView('');
                                      },
                                      leading: Text(competidor.id),
                                      title: Text(
                                        competidor.nome,
                                        style: TextStyle(color: isDarkMode ? Colors.white : null),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            competidor.apelido,
                                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                          ),
                                          if (competidor.nomeCidade.isNotEmpty)
                                            Text(
                                              "${competidor.nomeCidade} - ${competidor.siglaEstado}",
                                              style: const TextStyle(fontWeight: FontWeight.w500, color: Color.fromARGB(255, 89, 89, 89)),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                });

                                return widgets;
                              },
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
