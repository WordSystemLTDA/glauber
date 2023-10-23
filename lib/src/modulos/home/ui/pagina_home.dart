import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/home/ui/widgets/card_eventos.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> with TickerProviderStateMixin {
  int categoriasIndex = 0;
  List<String> categorias = ['Todas', 'Provas de Laços'];

  late TabController _categoriaController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 220.0,
              autoPlay: true,
              aspectRatio: 2.0,
              autoPlayInterval: const Duration(seconds: 10),
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
            ),
            items: const [
              CardEventos(evento: 'Evento 1'),
              CardEventos(evento: 'Evento 2'),
              CardEventos(evento: 'Evento 3'),
              CardEventos(evento: 'Evento 4'),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TabBar(
                controller: _categoriaController,
                isScrollable: true,
                tabs: categorias
                    .map((e) => Tab(
                          child: Text(e, style: const TextStyle(fontSize: 16)),
                        ))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(color: Colors.amber),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return const CardEventos(evento: 'opa');
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _categoriaController = TabController(
      initialIndex: 0,
      length: categorias.length,
      vsync: this,
    );
  }
}
