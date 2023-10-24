import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/buscar/ui/paginas/pagina_buscar.dart';
import 'package:glauber/src/modulos/compras/ui/paginas/pagina_compras.dart';
import 'package:glauber/src/modulos/home/ui/paginas/pagina_home.dart';
import 'package:glauber/src/modulos/perfil/ui/paginas/pagina_perfil.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  int pageIndex = 0;

  final pages = [
    const PaginaHome(),
    const PaginaBuscar(),
    const PaginaCompras(),
    const PaginaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGO'),
        centerTitle: true,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() => pageIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket), label: 'Compras'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil')
        ],
      ),
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
            Column(
              children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      pageIndex = 0;
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
                      pageIndex = 1;
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
                      pageIndex = 2;
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
                      pageIndex = 3;
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
              ],
            )
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}
