import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provider/provider.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> with AutomaticKeepAliveClientMixin {
  List<dynamic> itemsPerfil = [
    {
      'titulo': const Text('Editar dados'),
      'ativo': UsuarioProvider.getUsuario() != null,
      'icone': const Icon(Icons.edit_outlined),
    },
    {
      'titulo': const Text('Avaliar APP'),
      'ativo': true,
      'icone': const Icon(Icons.star_outline),
    },
    {
      'titulo': const Text('Notificações'),
      'ativo': true,
      'icone': const Icon(Icons.notifications_outlined),
    },
    {
      'titulo': const Text('Dúvida'),
      'ativo': true,
      'icone': const Icon(Icons.tungsten_outlined),
    },
    {
      'titulo': const Text('Ajuda'),
      'ativo': true,
      'icone': const Icon(Icons.help_outline),
    },
    {
      'titulo': const Text('Suporte'),
      'ativo': true,
      'icone': const Icon(Icons.support_agent_outlined),
    },
    {
      'titulo': const Text('Atualização'),
      'ativo': true,
      'icone': const Icon(Icons.system_update_outlined),
    },
    {
      'titulo': const Text('Sugestões'),
      'ativo': true,
      'icone': const Icon(Icons.send_outlined),
    },
    {
      'titulo': const Text('Compartilhar App'),
      'ativo': true,
      'icone': const Icon(Icons.share_outlined),
    },
    {
      'titulo': const Text('Excluir Conta'),
      'icone': const Icon(Icons.delete_outline),
      'ativo': UsuarioProvider.getUsuario() != null,
      'funcao': (context) {
        var usuario = UsuarioProvider.getUsuario();

        if (usuario == null) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('Você não está logado para excluir uma conta.')),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));

          return;
        }
      }
    },
    {
      'titulo': const Text('Sair', style: TextStyle(color: Colors.red)),
      'icone': const Icon(Icons.logout_outlined, color: Colors.red),
      'ativo': UsuarioProvider.getUsuario() != null,
      'funcao': (context) {
        var usuario = UsuarioProvider.getUsuario();

        if (usuario == null) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('Você não está logado para sair.')),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ));

          return;
        }

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
                    final autenticacaoServico = context.read<AutenticacaoServico>();
                    final firebaseMessagingService = context.read<FirebaseMessagingService>();
                    String? tokenNotificacao = await firebaseMessagingService.getDeviceFirebaseToken();

                    autenticacaoServico.sair(tokenNotificacao).then((sucessoAoExcluirToken) {
                      if (sucessoAoExcluirToken) {
                        UsuarioProvider.removerUsuario().then((sucessoAoSair) {
                          if (sucessoAoSair) {
                            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var itemsAtivos = itemsPerfil.where((element) => element['ativo'] == true).toList();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemsAtivos.length,
              separatorBuilder: (context, index) {
                return const Divider(indent: 0, endIndent: 0);
              },
              itemBuilder: (context, index) {
                var item = itemsAtivos[index];

                return ListTile(
                  onTap: () => item['funcao'](context),
                  leading: item['icone'],
                  title: item['titulo'],
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
