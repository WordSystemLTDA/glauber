import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:provadelaco/src/modulos/buscar/ui/paginas/pagina_buscar.dart';
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

  void botaoSair() {
    showDialog<String>(
      context: context,
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Deseja realmente sair?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(contextDialog).pop();
              },
            ),
            TextButton(
              child: const Text('Sair'),
              onPressed: () async {
                final autenticacaoServico = context.read<AutenticacaoServico>();
                final firebaseMessagingService = context.read<FirebaseMessagingService>();
                String? tokenNotificacao = await firebaseMessagingService.getDeviceFirebaseToken();

                autenticacaoServico.sair(tokenNotificacao).then((sucessoAoExcluirToken) {
                  if (sucessoAoExcluirToken) {
                    UsuarioProvider.removerUsuario().then((sucessoAoSair) {
                      if (sucessoAoSair) {
                        Navigator.pushNamedAndRemoveUntil(context, '/inicio', (Route<dynamic> route) => false);
                      }
                    });
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  void verificar() {
    var usuarioProvider = UsuarioProvider.getUsuario();
    var mudarSenhaServico = context.read<MudarSenhaServico>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && usuarioProvider != null && usuarioProvider.primeiroAcesso == 'Não' && usuarioProvider.tipo == 'normal') {
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
                            mudarSenhaServico.mudarSenha(novaSenha.text).then((sucesso) {
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

  String nomeUsuario() {
    if (UsuarioProvider.getUsuario() != null && UsuarioProvider.getUsuario()!.nome!.isNotEmpty) {
      var nomeComEspaco = UsuarioProvider.getUsuario()!.nome!.split(' ');

      if (nomeComEspaco.length > 1) {
        return "${nomeComEspaco[0][0].toUpperCase()}${nomeComEspaco[1][0].toUpperCase()}";
      } else {
        return "${UsuarioProvider.getUsuario()!.nome![0].toUpperCase()}${UsuarioProvider.getUsuario()!.nome![1].toUpperCase()}";
      }
    } else {
      return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: UsuarioProvider.getUsuario() == null,
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
      endDrawer: Drawer(
        width: 200,
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 35,
                child: Text(nomeUsuario()),
              ),
            ),
            if (UsuarioProvider.getUsuario() != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  UsuarioProvider.getUsuario()!.nome!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 0),
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  UsuarioProvider.getUsuario()!.email!,
                ),
              ),
            ],
            const SizedBox(height: 10),
            const Divider(),
            Column(
              children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      pageIndex = 0;
                      pageController.jumpToPage(0);
                    });
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Início'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const PaginaBuscar();
                      },
                    ));
                  },
                  leading: const Icon(Icons.search),
                  title: const Text('Buscar'),
                ),
                if (UsuarioProvider.getUsuario() != null) ...[
                  ListTile(
                    onTap: () {
                      setState(() {
                        pageIndex = 2;
                        pageController.jumpToPage(2);
                      });
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.sell_outlined),
                    title: const Text('Inscrições'),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        pageIndex = 3;
                        pageController.jumpToPage(3);
                      });
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Perfil'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        pageIndex = 2;
                        pageController.jumpToPage(2);
                      });
                    },
                    leading: const Icon(Icons.format_list_numbered_outlined),
                    title: const Text('Ordem de Entrada'),
                  ),
                  ListTile(
                    onTap: () {
                      botaoSair();
                    },
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Sair',
                      style: TextStyle(color: Colors.red),
                    ),
                    // trailing: Icon(Icons),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
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
  }
}
