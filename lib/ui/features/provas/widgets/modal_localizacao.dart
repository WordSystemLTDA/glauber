import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/evento/evento_modelo.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalLocalizacao extends StatefulWidget {
  final EventoModelo evento;
  const ModalLocalizacao({super.key, required this.evento});

  @override
  State<ModalLocalizacao> createState() => _ModalLocalizacaoState();
}

class _ModalLocalizacaoState extends State<ModalLocalizacao> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var evento = widget.evento;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "CEP: ",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(evento.cep),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Bairro: ",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(evento.bairro),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Complemento: ",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(evento.complemento),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Endereço: ",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: width / 2,
                  child: Text(
                    evento.endereco,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Cidade: ",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(evento.nomeCidade),
              ],
            ),
            if (evento.longitude != '0' && evento.latitude != '0') ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    var latitude = evento.latitude;
                    var longitude = evento.longitude;

                    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                    if (await canLaunchUrl(Uri.parse(googleUrl))) {
                      await launchUrl(Uri.parse(googleUrl));
                    } else {
                      throw 'Não foi possível abrir o mapa.';
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Abrir no Google Maps'),
                      SizedBox(width: 5),
                      Icon(Icons.map_sharp, size: 20),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
