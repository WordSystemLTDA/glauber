import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/ui/paginas/pagina_provas.dart';

class CardBuscas extends StatefulWidget {
  final EventoModelo evento;
  const CardBuscas({super.key, required this.evento});

  @override
  State<CardBuscas> createState() => _CardBuscasState();
}

class _CardBuscasState extends State<CardBuscas> {
  double tamanhoCard = 120;

  @override
  Widget build(BuildContext context) {
    var evento = widget.evento;

    return SizedBox(
      height: tamanhoCard,
      child: Card(
        margin: EdgeInsets.zero,
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
              CachedNetworkImage(
                imageUrl: evento.foto,
                width: double.infinity,
                height: double.infinity,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: double.infinity,
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
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        evento.nomeCidade,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 225, 225, 225),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        evento.nomeEvento,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
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
