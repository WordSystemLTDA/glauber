import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/domain/models/propaganda_modelo.dart';
import 'package:provadelaco/src/modulos/propaganda/ui/paginas/pagina_propaganda.dart';

class CardPropagandas extends StatefulWidget {
  final PropagandaModelo propaganda;
  const CardPropagandas({super.key, required this.propaganda});

  @override
  State<CardPropagandas> createState() => _CardPropagandasState();
}

class _CardPropagandasState extends State<CardPropagandas> {
  @override
  Widget build(BuildContext context) {
    var propaganda = widget.propaganda;

    return SizedBox(
      height: 110,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRotas.propaganda,
              arguments: PaginaPropagandaArgumentos(idPropaganda: propaganda.id),
            );
          },
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: propaganda.foto,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
                // progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                //   child: SizedBox(
                //     width: 40,
                //     height: 40,
                //     child: CircularProgressIndicator(value: downloadProgress.progress),
                //   ),
                // ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
