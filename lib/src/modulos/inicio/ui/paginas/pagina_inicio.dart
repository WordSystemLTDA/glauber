import 'package:flutter/material.dart';
import 'package:glauber/src/essencial/usuario_provider.dart';
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
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    verificar();
  }

  void verificar() {
    var usuarioProvider = UsuarioProvider.getUsuario();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && usuarioProvider.primeiroAcesso == 'Não') {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mudar senha',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Senha'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Fechar'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 10.0,
            )
          ]),
          child: AppBar(
            elevation: 0.0,
            title: const Text("LOGO"),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          PaginaHome(),
          PaginaBuscar(),
          PaginaCompras(),
          PaginaPerfil(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() => pageIndex = index);
          pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket), label: 'Inscrições'),
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
