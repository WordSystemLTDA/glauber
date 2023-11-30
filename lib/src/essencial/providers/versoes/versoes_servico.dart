import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/versoes/versoes_modelo.dart';
import 'package:provadelaco/src/essencial/providers/versoes/versoes_provider.dart';
import 'package:provider/provider.dart';

class VersoesServico {
  static Future<void> salvarVersao(BuildContext context, VersoesModelo versao) async {
    context.read<VersoesProvider>().setVersoes(versao);
  }
}
