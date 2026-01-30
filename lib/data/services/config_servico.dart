import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/config_repository.dart';
import 'package:provadelaco/domain/models/config/config.dart';
import 'package:provider/provider.dart';

class ConfigServico {
  static Future<void> salvarVersao(BuildContext context, ConfigModelo versao) async {
    context.read<ConfigProvider>().setConfig(versao);
  }
}
