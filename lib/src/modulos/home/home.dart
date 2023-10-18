import 'dart:math';

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
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ),
            Column(children: [
              ListTile(
                onTap: () {
                  setState(() {
                    page_index = 0;
                  });
                  Navigator.pop(context);
                },
                leading: Icon(Icons.home),
                title: Text('Início'),
                trailing: Icon(Icons.arrow_forward),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
              ListTile(
                onTap: () {
                  setState(() {
                    page_index = 1;
                  });
                  Navigator.pop(context);
                },
                leading: Icon(Icons.search),
                title: Text('Buscar'),
                trailing: Icon(Icons.arrow_forward),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
              ListTile(
                onTap: () {
                  setState(() {
                    page_index = 2;
                  });
                  Navigator.pop(context);
                },
                leading: Icon(Icons.airplane_ticket),
                title: Text('Compras'),
                trailing: Icon(Icons.arrow_forward),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
              ListTile(
                onTap: () {
                  setState(() {
                    page_index = 3;
                  });
                  Navigator.pop(context);
                },
                leading: Icon(Icons.person),
                title: Text('Perfil'),
                trailing: Icon(Icons.arrow_forward),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                // trailing: Icon(Icons),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
            ])
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}
