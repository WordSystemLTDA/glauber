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
    const Inicio(),
    const Buscar(),
    const Compras(),
    const Perfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGO'),
        centerTitle: true,
      ),
      body: pages[page_index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: page_index,
          onTap: (index) {
            setState(() => page_index = index);
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'início'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'buscar'),
            BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket), label: 'compras'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'perfil')
          ]),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
                leading: const Icon(Icons.home),
                title: const Text('Início'),
                trailing: const Icon(Icons.arrow_forward),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
              ListTile(
                onTap: () {
                  setState(() {
                    page_index = 1;
                  });

                  Navigator.pop(context);
                },
                leading: const Icon(Icons.search),
                title: const Text('Buscar'),
                trailing: const Icon(Icons.arrow_forward),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
              ListTile(
                onTap: () {
                  setState(() {
                    page_index = 2;
                  });
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.airplane_ticket),
                title: const Text('Compras'),
                trailing: const Icon(Icons.arrow_forward),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
              ListTile(
                onTap: () {
                  setState(() {
                    page_index = 3;
                  });
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.person),
                title: const Text('Perfil'),
                trailing: const Icon(Icons.arrow_forward),
              ),
              const Divider(height: 0, indent: 10, endIndent: 10, color: Colors.black),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
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
