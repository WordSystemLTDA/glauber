import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/config_repository.dart';
import 'package:provider/provider.dart';

class LogoApp extends StatefulWidget {
  final double width;
  final double? height;

  const LogoApp({super.key, required this.width, this.height});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {
  Widget carregando = const Center(
    child: SizedBox(
      width: 10,
      height: 10,
      child: CircularProgressIndicator(
        strokeWidth: 1,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var width = widget.width;
    var height = widget.height;

    if (height != null) {
      return Consumer<ConfigProvider>(
        builder: (context, value, child) {
          if (value.configs == null) {
            return carregando;
          }

          return CachedNetworkImage(
            imageUrl: value.configs!.logoApp,
            placeholder: (context, url) => carregando,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.parse(width.toString()),
            height: double.parse(height.toString()),
          );
        },
      );
    } else {
      return Consumer<ConfigProvider>(
        builder: (context, value, child) {
          if (value.configs == null) {
            return carregando;
          }

          return CachedNetworkImage(
            imageUrl: value.configs!.logoApp,
            placeholder: (context, url) => carregando,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.parse(width.toString()),
          );
        },
      );
    }
  }
}
