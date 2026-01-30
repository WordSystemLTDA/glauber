// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';
import 'package:provadelaco/domain/models/modelo_banners_carrossel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardBannerCarrossel extends StatelessWidget {
  final EventoModelo evento;
  final ModeloBannersCarrossel? bannerCarrossel;
  final int index;
  final bool? aparecerSombra;

  const CardBannerCarrossel({super.key, required this.evento, this.bannerCarrossel, required this.index, this.aparecerSombra = true});

  @override
  Widget build(BuildContext context) {
    var foto = index == 0
        ? evento.foto
        : bannerCarrossel != null
            ? bannerCarrossel!.foto
            : evento.foto;

    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: foto,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(value: downloadProgress.progress),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          if (aparecerSombra == true) ...[
            Skeleton.ignore(
              child: GestureDetector(
                onTap: () {
                  final imageProvider = Image.network(foto).image;
                  showImageViewer(
                    context,
                    imageProvider,
                    useSafeArea: true,
                    immersive: false,
                    doubleTapZoomable: true,
                  );
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: const Alignment(0.0, -0.6),
                        begin: const Alignment(0.0, 0),
                        colors: <Color>[const Color(0x8A000000), Colors.black12.withValues(alpha: 0.0)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent, // Needed for invisible things to be tapped.
              onTap: () {},
              child: const SizedBox(
                width: 150,
                height: 150,
                child: Padding(
                  padding: EdgeInsets.all(9.0), // Configure hit area.
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
