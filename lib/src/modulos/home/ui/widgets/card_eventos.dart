import 'package:flutter/material.dart';

class CardEventos extends StatefulWidget {
  final dynamic evento;
  const CardEventos({super.key, required this.evento});

  @override
  State<CardEventos> createState() => _CardEventosState();
}

class _CardEventosState extends State<CardEventos> {
  @override
  Widget build(BuildContext context) {
    var evento = widget.evento;

    return SizedBox(
      height: 220,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/selecionar_ingresso');
          },
          child: Stack(
            children: [
              Image.network(
                'https://www.tenhomaisdiscosqueamigos.com/wp-content/uploads/2016/07/lollapalooza-brasil-2017.png',
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      evento,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
