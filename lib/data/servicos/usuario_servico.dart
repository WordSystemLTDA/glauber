// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/usuario_modelo.dart';
import 'package:provadelaco/data/repositories/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioServico {
  static const String _keyUsuario = 'usuario';

  static Future<UsuarioModelo?> getUsuario(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usuarioString = prefs.getString(_keyUsuario);

    if (usuarioString != null) {
      Map<String, dynamic> usuarioMap = json.decode(usuarioString);
      UsuarioModelo usuario = UsuarioModelo.fromMap(usuarioMap);

      // Atualize o UsuarioProvider
      context.read<UsuarioProvider>().setUsuario(usuario);

      return usuario;
    }

    return null;
  }

  static Future<void> sair(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Limpe os dados do usuário nas SharedPreferences
    prefs.remove(_keyUsuario);

    // Notifique o UsuarioProvider (se estiver usando Provider)
    context.read<UsuarioProvider>().setUsuario(null);
  }

  static Future<void> salvarUsuario(BuildContext context, UsuarioModelo usuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usuarioString = json.encode(usuario.toMap());
    prefs.setString(_keyUsuario, usuarioString);

    // Atualize o UsuarioProvider
    context.read<UsuarioProvider>().setUsuario(usuario);
  }
}
