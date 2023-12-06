import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/config/config_modelo.dart';

class ConfigProvider extends ChangeNotifier {
  ConfigModelo? _configs;

  ConfigModelo? get configs => _configs;

  void setConfig(ConfigModelo? configs) {
    _configs = configs;
    notifyListeners();
  }

  CachedNetworkImage? logoApp(context, {required double width, double? height}) {
    if (_configs == null) {
      return null;
    }

    var logo = _configs!.logoApp;

    Widget carregando = const Center(
      child: SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      ),
    );

    if (height != null) {
      return CachedNetworkImage(
        imageUrl: logo,
        placeholder: (context, url) => carregando,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: double.parse(width.toString()),
        height: double.parse(height.toString()),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: logo,
        placeholder: (context, url) => carregando,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: double.parse(width.toString()),
      );
    }
  }
}
