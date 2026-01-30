import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/config/config_modelo.dart';
import 'package:provadelaco/data/repositories/config_provider.dart';
import 'package:provider/provider.dart';

class ConfigServico {
  static Future<void> salvarVersao(BuildContext context, ConfigModelo versao) async {
    context.read<ConfigProvider>().setConfig(versao);
  }
}
