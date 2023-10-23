import 'package:flutter/material.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> {
  List<dynamic> itemsPerfil = [
    {'titulo': 'Avaliar app', 'icone': Icons.star},
    {'titulo': 'Notificações', 'icone': Icons.notifications},
    {'titulo': 'Dúvida', 'icone': Icons.branding_watermark},
    {'titulo': 'Ajuda', 'icone': Icons.help},
    {'titulo': 'Suporte', 'icone': Icons.branding_watermark},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: itemsPerfil.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              leading: Icon(itemsPerfil[index]['icone']),
              title: Text(itemsPerfil[index]['titulo'].toString()),
              trailing: const Icon(Icons.arrow_forward),
            );
          },
        ));
  }
}
