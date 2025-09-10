import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/core/constantes/funcoes_global.dart';
import 'package:provadelaco/src/core/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/core/widgets/drawer_customizado.dart';
import 'package:provadelaco/src/core/widgets/logo_app.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/compras/ui/paginas/pagina_compras.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:provadelaco/src/modulos/home/ui/paginas/pagina_home.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/ui/paginas/pagina_ordemdeentrada.dart';
import 'package:provadelaco/src/modulos/perfil/ui/paginas/pagina_perfil.dart';
import 'package:provadelaco/src/modulos/propaganda/ui/paginas/pagina_propaganda.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/ui/paginas/pagina_provas.dart';
import 'package:provider/provider.dart';

class PaginaInicioArgumentos {
  final String? rota;

  PaginaInicioArgumentos({required this.rota});
}

class PaginaInicio extends StatefulWidget {
  final PaginaInicioArgumentos? argumentos;
  const PaginaInicio({super.key, this.argumentos});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  int pageIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  TextEditingController novaSenha = TextEditingController();

  @override
  void initState() {
    super.initState();
    verificar();
    abrirPagina();
    abrirPaginaQuandoClicaNotificacao();
  }

  @override
  void dispose() {
    novaSenha.dispose();
    pageController.dispose();
    super.dispose();
  }

  void abrirPagina() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && widget.argumentos != null) {
        var rotaApp = widget.argumentos!.rota;

        if (rotaApp != null) {
          if (rotaApp == AppRotas.compras) {
            setState(() {
              pageIndex = 1;
              pageController.jumpToPage(1);
            });
          } else if (rotaApp == AppRotas.ordemDeEntrada) {
            setState(() {
              pageIndex = 2;
              pageController.jumpToPage(2);
            });
          } else if (rotaApp == AppRotas.perfil) {
            setState(() {
              pageIndex = 3;
              pageController.jumpToPage(3);
            });
          } else if (rotaApp == AppRotas.home) {
            setState(() {
              pageIndex = 0;
              pageController.jumpToPage(0);
            });
          }
        }
      }
    });
  }

  void funcaoMudarRota(dynamic message) {
    if (mounted) {
      if (message != null) {
        String rotaApp = message.data['rota'] ?? '';

        if (rotaApp.isNotEmpty) {
          if (rotaApp == AppRotas.compras) {
            setState(() {
              pageIndex = 1;
              pageController.jumpToPage(1);
            });
          } else if (rotaApp == AppRotas.ordemDeEntrada) {
            setState(() {
              pageIndex = 2;
              pageController.jumpToPage(2);
            });
          } else if (rotaApp == AppRotas.perfil) {
            setState(() {
              pageIndex = 3;
              pageController.jumpToPage(3);
            });
          } else if (rotaApp == AppRotas.home) {
            setState(() {
              pageIndex = 0;
              pageController.jumpToPage(0);
            });
          } else if (rotaApp == AppRotas.finalizarCompra) {
            Navigator.pushNamed(
              context,
              rotaApp,
              arguments: PaginaFinalizarCompraArgumentos(
                provas: List<ProvaModelo>.from(jsonDecode(message.data['provas']).map((elemento) {
                  return ProvaModelo.fromJson(elemento);
                })),
                idEvento: message.data['idEvento'],
              ),
            );
          } else if (rotaApp == AppRotas.provas) {
            Navigator.pushNamed(
              context,
              rotaApp,
              arguments: PaginaProvasArgumentos(
                idEvento: message.data['idEvento'],
              ),
            );
          } else if (rotaApp == AppRotas.propaganda) {
            Navigator.pushNamed(
              context,
              rotaApp,
              arguments: PaginaPropagandaArgumentos(
                idPropaganda: message.data['idPropaganda'],
              ),
            );
          } else {
            Navigator.pushNamed(context, rotaApp);
          }
        }
      }
    }
  }

  void abrirPaginaQuandoClicaNotificacao() async {
    // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //   funcaoMudarRota(message);
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    //   funcaoMudarRota(message);
    // });
  }

  void verificar() {
    // var mudarSenhaServico = context.read<MudarSenhaServico>();
    var usuarioProvider = context.read<UsuarioProvider>().usuario;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && usuarioProvider != null && usuarioProvider.primeiroAcesso == 'Não' && usuarioProvider.tipo == 'email') {
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return PopScope(
        //       canPop: false,
        //       child: Dialog(
        //         child: Padding(
        //           padding: const EdgeInsets.all(20.0),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               const Text(
        //                 'Mudar Senha',
        //                 style: TextStyle(fontSize: 16),
        //               ),
        //               const SizedBox(height: 10),
        //               TextField(
        //                 controller: novaSenha,
        //                 decoration: const InputDecoration(hintText: 'Nova senha'),
        //               ),
        //               const SizedBox(height: 20),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.end,
        //                 children: [
        //                   ElevatedButton(
        //                     onPressed: () {
        //                       Navigator.pop(context);
        //                     },
        //                     child: const Text('Fechar'),
        //                   ),
        //                   const SizedBox(width: 10),
        //                   ElevatedButton(
        //                     onPressed: () {
        //                       mudarSenhaServico.mudarSenha(usuarioProvider, novaSenha.text).then((sucesso) {
        //                         if (sucesso) {
        //                           Navigator.pop(context);

        //                           if (mounted) {
        //                             ScaffoldMessenger.of(context).removeCurrentSnackBar();
        //                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //                               content: Center(child: Text('Sua senha foi mudada com sucesso.')),
        //                               showCloseIcon: true,
        //                               backgroundColor: Colors.green,
        //                             ));
        //                           }
        //                         }
        //                       });
        //                     },
        //                     style: const ButtonStyle(
        //                       backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
        //                       foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
        //                     ),
        //                     child: const Text('Salvar'),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // );
      } else if (mounted && usuarioProvider != null && usuarioProvider.clienteBloqueado == true) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext contextDialog) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: const Text(
                  'Você foi bloqueado',
                  style: TextStyle(fontSize: 16),
                ),
                content: const Text('Você foi bloqueado para usar esse aplicativo, para conversar com o suporte clique em Abrir WhatsApp.'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Abrir WhatsApp'),
                    onPressed: () async {
                      FuncoesGlobais.abrirWhatsapp(usuarioProvider.celularSuporte!);
                    },
                  ),
                ],
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
                Navigator.pushNamed(context, AppRotas.login);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: const Color.fromARGB(255, 247, 24, 8),
              label: const Text('Entrar', style: TextStyle(fontSize: 14)),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        drawer: DrawerCustomizado(
          aoMudarPagina: (index) {
            setState(() {
              pageIndex = index;
              pageController.jumpToPage(index);
            });
            Navigator.pop(context);
          },
        ),
        drawerEnableOpenDragGesture: false,
        appBar: const AppBarSombra(
          titulo: LogoApp(width: 90),
          aparecerIconeNotificacao: true,
          aparecerIconeCalendario: true,
          aparecerIdUsuario: true,
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
