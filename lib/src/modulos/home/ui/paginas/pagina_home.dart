import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/home/ui/widgets/card_eventos.dart';
import 'package:glauber/src/modulos/home/ui/widgets/card_propagandas.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> with TickerProviderStateMixin {
  int categoriasIndex = 0;
  List<String> categorias = ['Todas', 'Provas de Laços', 'Outros', 'Outros', 'Outros'];

  late TabController _categoriaController;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 220.0,
                autoPlay: true,
                aspectRatio: 2.0,
                pauseAutoPlayOnTouch: true,
                autoPlayInterval: const Duration(seconds: 10),
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
              items: const [
                CardEventos(
                  evento: 'Evento 1',
                  aparecerInformacoes: true,
                ),
                CardEventos(
                  evento: 'Evento 2',
                  aparecerInformacoes: true,
                ),
                CardEventos(
                  evento: 'Evento 3',
                  aparecerInformacoes: true,
                ),
                CardEventos(
                  evento: 'Evento 4',
                  aparecerInformacoes: true,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 40,
              child: TabBar(
                dividerColor: Colors.transparent,
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
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 100.0,
                autoPlay: true,
                aspectRatio: 2.0,
                pauseAutoPlayOnTouch: true,
                autoPlayInterval: const Duration(seconds: 20),
              ),
              items: const [
                CardPropagandas(),
                CardPropagandas(),
                CardPropagandas(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return const CardEventos(evento: 'Evento de nome TAL');
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
