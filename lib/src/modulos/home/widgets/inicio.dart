import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> with TickerProviderStateMixin {
  int categorias_index = 0;
  List<String> categorias = ['todas', 'prova de laço'];

  late TabController _categoriaController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView(children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/selecionar_ingresso');
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(color: Colors.amber),
                      child: Center(
                        child: Text(
                          'texto $i',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      )),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TabBar(
              controller: _categoriaController,
              isScrollable: true,
              tabs: categorias
                  .map((e) => Tab(
                          child: Text(
                        e,
                        style: const TextStyle(fontSize: 16),
                      )))
                  .toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
          ),
        )
      ]),
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
