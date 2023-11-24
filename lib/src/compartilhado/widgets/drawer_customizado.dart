import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/modulos/buscar/ui/paginas/pagina_buscar.dart';
import 'package:provider/provider.dart';

class DrawerCustomizado extends StatefulWidget {
  final Function(int index) aoMudarPagina;
  const DrawerCustomizado({super.key, required this.aoMudarPagina});

  @override
  State<DrawerCustomizado> createState() => _DrawerCustomizadoState();
}

class _DrawerCustomizadoState extends State<DrawerCustomizado> {
  String nomeUsuario() {
    if (UsuarioProvider.getUsuario() != null && UsuarioProvider.getUsuario()!.nome!.isNotEmpty) {
      var nomeComEspaco = UsuarioProvider.getUsuario()!.nome!.split(' ');

      if (nomeComEspaco.length > 1) {
        return "${nomeComEspaco[0][0].toUpperCase()}${nomeComEspaco[1][0].toUpperCase()}";
      } else {
        return "${UsuarioProvider.getUsuario()!.nome![0].toUpperCase()}${UsuarioProvider.getUsuario()!.nome![1].toUpperCase()}";
      }
    } else {
      return "N/A";
    }
  }

  void botaoSair() {
    showDialog<String>(
      context: context,
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Deseja realmente sair?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(contextDialog).pop();
              },
            ),
            TextButton(
              child: const Text('Sair'),
              onPressed: () async {
                final autenticacaoServico = context.read<AutenticacaoServico>();
                final firebaseMessagingService = context.read<FirebaseMessagingService>();
                String? tokenNotificacao = await firebaseMessagingService.getDeviceFirebaseToken();

                autenticacaoServico.sair(tokenNotificacao).then((sucessoAoExcluirToken) {
                  if (sucessoAoExcluirToken) {
                    UsuarioProvider.removerUsuario().then((sucessoAoSair) {
                      if (sucessoAoSair) {
                        Navigator.pushNamedAndRemoveUntil(context, '/inicio', (Route<dynamic> route) => false);
                      }
                    });
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var usuario = UsuarioProvider.getUsuario();

    return Drawer(
      width: 200,
      child: ListView(
        children: [
          Center(
            child: (usuario != null && (usuario.tipo == 'social' && usuario.foto != 'semfoto'))
                ? CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 35,
                    backgroundImage: Image.network(
                      usuario.foto!,
                    ).image,
                  )
                : CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 35,
                    child: Text(nomeUsuario()),
                  ),
          ),
          if (UsuarioProvider.getUsuario() != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "#${UsuarioProvider.getUsuario()!.id} - ${UsuarioProvider.getUsuario()!.nome!}",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 0),
              child: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                UsuarioProvider.getUsuario()!.email!,
              ),
            ),
          ],
          const SizedBox(height: 10),
          const Divider(),
          Column(
            children: [
              ListTile(
                onTap: () {
                  widget.aoMudarPagina(0);
                },
                leading: const Icon(Icons.home_outlined),
                title: const Text('Início'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const PaginaBuscar();
                    },
                  ));
                },
                leading: const Icon(Icons.search),
                title: const Text('Buscar'),
              ),
              if (UsuarioProvider.getUsuario() != null) ...[
                ListTile(
                  onTap: () {
                    widget.aoMudarPagina(1);
                  },
                  leading: const Icon(Icons.sell_outlined),
                  title: const Text('Inscrições'),
                ),
                ListTile(
                  onTap: () {
                    widget.aoMudarPagina(3);
                  },
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Perfil'),
                ),
                ListTile(
                  onTap: () {
                    widget.aoMudarPagina(2);
                  },
                  leading: const Icon(Icons.format_list_numbered_outlined),
                  title: const Text('Ordem de Entrada'),
                ),
                ListTile(
                  onTap: () {
                    botaoSair();
                  },
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.red),
                  ),
                  // trailing: Icon(Icons),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }
}
