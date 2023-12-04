import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/compartilhado/widgets/drawer_customizado.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:provadelaco/src/modulos/compras/ui/paginas/pagina_compras.dart';
import 'package:provadelaco/src/modulos/home/ui/paginas/pagina_home.dart';
import 'package:provadelaco/src/modulos/inicio/interator/servicos/mudar_senha_servico.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/ui/paginas/pagina_ordemdeentrada.dart';
import 'package:provadelaco/src/modulos/perfil/ui/paginas/pagina_perfil.dart';
import 'package:provider/provider.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  int pageIndex = 0;
  final PageController pageController = PageController(initialPage: 0);
  TextEditingController novaSenha = TextEditingController();

  @override
  void initState() {
    super.initState();
    verificar();
  }

  void verificar() {
    var mudarSenhaServico = context.read<MudarSenhaServico>();
    var usuarioProvider = context.read<UsuarioProvider>().usuario;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && usuarioProvider != null && usuarioProvider.primeiroAcesso == 'Não' && usuarioProvider.tipo == 'social') {
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
                      'Mudar Senha',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: novaSenha,
                      decoration: const InputDecoration(hintText: 'Nova senha'),
                    ),
                    const SizedBox(height: 20),
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
                          onPressed: () {
                            mudarSenhaServico.mudarSenha(usuarioProvider, novaSenha.text).then((sucesso) {
                              if (sucesso) {
                                Navigator.pop(context);

                                if (mounted) {
                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Center(child: Text('Sua senha foi mudada com sucesso.')),
                                    showCloseIcon: true,
                                    backgroundColor: Colors.green,
                                  ));
                                }
                              }
                            });
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                            foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                          ),
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
    return Consumer<UsuarioProvider>(builder: (context, usuarioProvider, child) {
      return Scaffold(
        floatingActionButton: Visibility(
          visible: usuarioProvider.usuario == null,
          child: SizedBox(
            width: 150,
            height: 50,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const PaginaLogin();
                  },
                ));
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: const Color.fromARGB(255, 247, 24, 8),
              label: const Text(
                'Entrar',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        endDrawer: DrawerCustomizado(
          aoMudarPagina: (index) {
            setState(() {
              pageIndex = index;
              pageController.jumpToPage(index);
            });
            Navigator.pop(context);
          },
        ),
        endDrawerEnableOpenDragGesture: false,
        appBar: const AppBarSombra(
          titulo: Text("LOGO"),
        ),
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            PaginaHome(),
            PaginaCompras(),
            PaginaOrdemDeEntrada(),
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
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.sell_outlined), label: 'Inscrições'),
            BottomNavigationBarItem(icon: Icon(Icons.format_list_numbered_outlined), label: 'Ordem Entrada'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil')
          ],
        ),
      );
    });
  }
}
