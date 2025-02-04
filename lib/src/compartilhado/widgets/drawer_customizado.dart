import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/funcoes_global.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/compartilhado/theme/theme_controller.dart';
import 'package:provadelaco/src/essencial/providers/config/config_provider.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/servicos/autenticacao_servico.dart';
import 'package:provadelaco/src/modulos/compras/interator/provedor/compras_provedor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerCustomizado extends StatefulWidget {
  final Function(int index) aoMudarPagina;
  const DrawerCustomizado({super.key, required this.aoMudarPagina});

  @override
  State<DrawerCustomizado> createState() => _DrawerCustomizadoState();
}

class _DrawerCustomizadoState extends State<DrawerCustomizado> {
  String ultimaVersao = '';
  String versaoInstalada = '';

  String nomeUsuario() {
    var usuario = context.read<UsuarioProvider>().usuario;

    if (usuario != null && usuario.nome!.isNotEmpty) {
      var nomeComEspaco = usuario.nome!.trimLeft().trimRight().split(RegExp(r"\s+")).join(' ').split(' ');

      if (nomeComEspaco.length > 1) {
        return "${nomeComEspaco[0][0].toUpperCase()}${nomeComEspaco[1][0].toUpperCase()}";
      } else {
        return "${usuario.nome![0].toUpperCase()}${usuario.nome![1].toUpperCase()}";
      }
    } else {
      return "N/A";
    }
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
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  if (mounted) {
                    final autenticacaoServico = context.read<AutenticacaoServico>();
                    final firebaseMessagingService = context.read<FirebaseMessagingService>();
                    final usuarioProvider = context.read<UsuarioProvider>();
                    final comprasProvedor = context.read<ComprasProvedor>();
                    String? tokenNotificacao = kIsWeb ? '' : await firebaseMessagingService.getDeviceFirebaseToken();

                    autenticacaoServico.sair(usuarioProvider.usuario, tokenNotificacao).then((resposta) {
                      var (sucessoAoExcluirToken, _) = resposta;

                      if (sucessoAoExcluirToken) {
                        if (mounted) {
                          UsuarioServico.sair(context).then((value) {
                            comprasProvedor.resetarCompras();
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(context, '/inicio', (Route<dynamic> route) => false);
                            }
                          });
                        }
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

  void setarInformacoes() async {
    var configProvider = context.read<ConfigProvider>();

    var versao = await FuncoesGlobais.getVersaoInstalada();

    var ultimaVersaoIos = configProvider.configs!.versaoAppIos;
    var ultimaVersaoAndroid = configProvider.configs!.versaoAppAndroid;

    setState(() {
      versaoInstalada = versao;
      ultimaVersao = Platform.isAndroid ? ultimaVersaoAndroid : ultimaVersaoIos;
    });
  }

  @override
  void initState() {
    super.initState();
    setarInformacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuarioProvider>(builder: (context, usuarioProvider, child) {
      return Drawer(
        width: 200,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Center(
                      child: (usuarioProvider.usuario != null && (usuarioProvider.usuario!.tipo == 'social' && usuarioProvider.usuario!.foto != 'semfoto'))
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 35,
                              backgroundImage: Image.network(
                                usuarioProvider.usuario!.foto!,
                              ).image,
                            )
                          : CircleAvatar(
                              backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha: 1.0),
                              radius: 35,
                              child: Text(
                                nomeUsuario(),
                                style: const TextStyle(fontSize: 22, color: Colors.white),
                              ),
                            ),
                    ),
                    if (usuarioProvider.usuario != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "#${usuarioProvider.usuario!.id} - ${usuarioProvider.usuario!.nome!}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 0),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          usuarioProvider.usuario!.email!,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    const Divider(),
                    Column(
                      children: [
                        if (kIsWeb) ...[
                          ListTile(
                            onTap: () async {
                              // widget.aoMudarPagina(0);
                              if (await canLaunchUrl(Uri.parse('https://gsequine.com.br/sistema/index.php'))) {
                                await launchUrl(
                                  Uri.parse('https://gsequine.com.br/sistema/index.php'),
                                  webOnlyWindowName: '_self',
                                );
                              }
                            },
                            leading: const Icon(Icons.admin_panel_settings),
                            title: const Text('Painel Admin'),
                          ),
                        ],
                        ValueListenableBuilder<ThemeMode>(
                          valueListenable: context.read<ThemeController>(),
                          builder: (context, state, _) {
                            return ListTile(
                              leading: context.read<ThemeController>().value == ThemeMode.dark ? const Icon(Icons.nightlight_round) : const Icon(Icons.wb_sunny),
                              dense: true,
                              title: const Text('Mudar Tema'),
                              onTap: () {
                                context.read<ThemeController>().onThemeSwitchEvent();
                              },
                            );
                          },
                        ),
                        ListTile(
                          onTap: () {
                            widget.aoMudarPagina(0);
                          },
                          leading: const Icon(Icons.home_outlined),
                          title: const Text('Início'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, AppRotas.buscar);
                          },
                          leading: const Icon(Icons.search),
                          title: const Text('Buscar'),
                        ),
                        if (usuarioProvider.usuario != null) ...[
                          ListTile(
                            onTap: () {
                              widget.aoMudarPagina(1);
                            },
                            leading: const Icon(Icons.sell_outlined),
                            title: const Text('Inscrições'),
                          ),
                          ListTile(
                            onTap: () {
                              widget.aoMudarPagina(3);
                            },
                            leading: const Icon(Icons.person_outline),
                            title: const Text('Perfil'),
                          ),
                          ListTile(
                            onTap: () {
                              widget.aoMudarPagina(2);
                            },
                            leading: const Icon(Icons.format_list_numbered_outlined),
                            title: const Text('Ordem de Entrada'),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, AppRotas.calendario);
                            },
                            leading: const Icon(Icons.calendar_month_outlined),
                            title: const Text('Calendário'),
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
                    ),
                  ],
                ),
              ),
              if (!kIsWeb) ...[
                const Divider(),
                Text(
                  "Ultima versão $ultimaVersao",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "Versão instalada $versaoInstalada",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      );
    });
  }
}
