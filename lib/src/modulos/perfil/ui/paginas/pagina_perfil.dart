import 'package:flutter/material.dart';
import 'package:glauber/src/essencial/usuario_provider.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> with AutomaticKeepAliveClientMixin {
  List<dynamic> itemsPerfil = [
    {
      'titulo': const Text('Editar dados'),
      'icone': const Icon(Icons.edit_outlined),
    },
    {
      'titulo': const Text('Avaliar APP'),
      'icone': const Icon(Icons.star_outline),
    },
    {
      'titulo': const Text('Notificações'),
      'icone': const Icon(Icons.notifications_outlined),
    },
    {
      'titulo': const Text('Dúvida'),
      'icone': const Icon(Icons.tungsten_outlined),
    },
    {
      'titulo': const Text('Ajuda'),
      'icone': const Icon(Icons.help_outline),
    },
    {
      'titulo': const Text('Suporte'),
      'icone': const Icon(Icons.support_agent_outlined),
    },
    {
      'titulo': const Text('Atualização'),
      'icone': const Icon(Icons.system_update_outlined),
    },
    {
      'titulo': const Text('Sugestões'),
      'icone': const Icon(Icons.send_outlined),
    },
    {
      'titulo': const Text('Compartilhar App'),
      'icone': const Icon(Icons.share_outlined),
    },
    {
      'titulo': const Text('Excluir Conta'),
      'icone': const Icon(Icons.delete_outline),
    },
    {
      'titulo': const Text('Sair', style: TextStyle(color: Colors.red)),
      'icone': const Icon(Icons.logout_outlined, color: Colors.red),
      'funcao': (context) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) {
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
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Sair'),
                  onPressed: () async {
                    UsuarioProvider.removerUsuario().then((sucesso) {
                      if (sucesso) {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      }
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemsPerfil.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => itemsPerfil[index]['funcao'](context),
                  leading: itemsPerfil[index]['icone'],
                  title: itemsPerfil[index]['titulo'],
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
