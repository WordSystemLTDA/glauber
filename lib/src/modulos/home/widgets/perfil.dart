import 'dart:js_interop';

import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  List<dynamic> itemsPerfil = [
    {'titulo': 'Avaliar app', 'icone': 'Icons.star'},
    {'titulo': 'Notificações', 'icone': 'Icons.notifications'},
    {'titulo': 'Dúvida', 'icone': 'Icons.branding_watermark'},
    {'titulo': 'Ajuda', 'icone': 'Icons.help'},
    {'titulo': 'Suporte', 'icone': 'Icons.branding_watermark'},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: itemsPerfil.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(itemsPerfil[index]['icone'].jsify()),
              title: Text(itemsPerfil[index]['titulo'].toString()),
              trailing: Icon(Icons.arrow_forward),
            );
          },
        ));
  }
}
