import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/ui/paginas/pagina_provas.dart';

class CardEventos extends StatefulWidget {
  final EventoModelo evento;
  final bool? aparecerInformacoes;
  const CardEventos({super.key, required this.evento, this.aparecerInformacoes});

  @override
  State<CardEventos> createState() => _CardEventosState();
}

class _CardEventosState extends State<CardEventos> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var evento = widget.evento;
    var aparecerInformacoes = widget.aparecerInformacoes ?? false;

    return SizedBox(
      height: 220,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRotas.provas,
              arguments: PaginaProvasArgumentos(idEvento: evento.id),
            );
          },
          child: Stack(
            children: [
              // SizedBox(
              //   height: 220,
              //   child: CarouselSlider.builder(
              //     carouselController: _carrosselController,
              //     options: CarouselOptions(
              //       height: 220.0,
              //       autoPlay: evento.bannersCarrossel.isNotEmpty ? true : false,
              //       aspectRatio: 2.0,
              //       enableInfiniteScroll: evento.bannersCarrossel.isNotEmpty ? true : false,
              //       pauseAutoPlayOnTouch: true,
              //       viewportFraction: 1.0,
              //       autoPlayInterval: const Duration(seconds: 10),
              //     ),
              //     itemCount: evento.bannersCarrossel.length + 1,
              //     itemBuilder: (context, index, realIndex) {
              //       var bannerCarrossel = evento.bannersCarrossel.isEmpty ? null : evento.bannersCarrossel[index == 0 ? index : (index - 1)];

              //       return CardBannerCarrossel(
              //         evento: evento,
              //         bannerCarrossel: bannerCarrossel,
              //         index: index,
              //         aparecerSombra: false,
              //       );
              //     },
              //   ),
              // ),
              CachedNetworkImage(
                imageUrl: evento.foto,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                // progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                //   child: SizedBox(
                //     width: 40,
                //     height: 40,
                //     child: CircularProgressIndicator(value: downloadProgress.progress),
                //   ),
                // ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  size: 25,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: const Alignment(0.0, -0.6),
                      begin: const Alignment(0.0, 0),
                      colors: <Color>[const Color(0x8A000000), Colors.black12.withOpacity(0.0)],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (aparecerInformacoes)
                            Text(
                              evento.nomeCidade,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 225, 225, 225),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          SizedBox(
                            width: width * 0.50,
                            child: Text(
                              evento.nomeEvento,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, right: 10),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.parse(evento.dataEvento)),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 225, 225, 225),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
