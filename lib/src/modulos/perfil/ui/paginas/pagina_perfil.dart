import 'package:flutter/material.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> with AutomaticKeepAliveClientMixin {
  List<dynamic> itemsPerfil = [
    {'titulo': 'Editar dados', 'icone': Icons.edit_outlined},
    {'titulo': 'Avaliar APP', 'icone': Icons.star_outline},
    {'titulo': 'Notificações', 'icone': Icons.notifications_outlined},
    {'titulo': 'Dúvida', 'icone': Icons.tungsten_outlined},
    {'titulo': 'Ajuda', 'icone': Icons.help_outline},
    {'titulo': 'Suporte', 'icone': Icons.support_agent_outlined},
    {'titulo': 'Atualização', 'icone': Icons.system_update_outlined},
    {'titulo': 'Sugestões', 'icone': Icons.send_outlined},
    {'titulo': 'Compartilhar App', 'icone': Icons.share_outlined},
    {'titulo': 'Exclur Conta', 'icone': Icons.delete_outline},
    {'titulo': 'Sair', 'icone': Icons.logout_outlined},
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
                  onTap: () {},
                  leading: Icon(itemsPerfil[index]['icone']),
                  title: Text(itemsPerfil[index]['titulo'].toString()),
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
