import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/home/interator/modelos/evento_modelo.dart';

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
    var evento = widget.evento;
    var aparecerInformacoes = widget.aparecerInformacoes ?? false;

    return SizedBox(
      height: 220,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/selecionar_prova');
          },
          child: Stack(
            children: [
              Image.network(
                evento.foto,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (aparecerInformacoes)
                        const Text(
                          'My Lounge',
                          style: TextStyle(
                            color: Color.fromARGB(255, 225, 225, 225),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (aparecerInformacoes)
                        const Text(
                          'Astorga',
                          style: TextStyle(
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
                      const SizedBox(height: 5),
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
