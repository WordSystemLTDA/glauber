import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/home/widgets/buscar.dart';
import 'package:glauber/src/modulos/home/widgets/compras.dart';
import 'package:glauber/src/modulos/home/widgets/inicio.dart';
import 'package:glauber/src/modulos/home/widgets/perfil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page_index = 0;

  final pages = [
    Inicio(),
    Buscar(),
    Compras(),
    Perfil(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGO'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.menu),
          )
        ],
      ),
      body: pages[page_index],
      bottomNavigationBar: NavigationBar(
          selectedIndex: page_index,
          onDestinationSelected: (index) {
            setState(() => page_index = index);
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(
                  Icons.home,
                ),
                label: 'início'),
            NavigationDestination(icon: Icon(Icons.search), label: 'buscar'),
            NavigationDestination(icon: Icon(Icons.airplane_ticket), label: 'compras'),
            NavigationDestination(icon: Icon(Icons.person), label: 'perfil')
          ]),
    );
  }
}
