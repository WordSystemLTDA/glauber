import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoriaController = TabController(
      initialIndex: 0,
      length: categorias.length,
      vsync: this,
    );
  }

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
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Center(
                      child: Text(
                        'texto $i',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ));
              },
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TabBar(
              controller: _categoriaController,
              isScrollable: true,
              tabs: categorias
                  .map((e) => Tab(
                          child: Text(
                        e,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
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
}
