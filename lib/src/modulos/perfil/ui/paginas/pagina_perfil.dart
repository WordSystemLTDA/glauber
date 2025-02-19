import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> with AutomaticKeepAliveClientMixin {
  String ultimaVersao = '';
  String versaoInstalada = '';

  List<dynamic> itemsPerfil = [
    {
      'titulo': const Text('Editar dados'),
      'ativo': true,
      'icone': const Icon(Icons.edit_outlined),
      'funcao': (BuildContext context) {
        Navigator.pushNamed(context, AppRotas.editarUsuario);
      }
    },
    {
      'titulo': const Text('Animais'),
      'ativo': true,
      'icone': const Icon(FontAwesomeIcons.horse),
      'funcao': (BuildContext context) {
        Navigator.pushNamed(context, AppRotas.animais);
      }
    },
    {
      'titulo': const Text('Avaliar APP'),
      'ativo': true,
      'icone': const Icon(Icons.star_outline),
    },
    {
      'titulo': const Text('Notificações'),
      'ativo': true,
      'icone': const Icon(Icons.notifications_outlined),
    },
    {
      'titulo': const Text('Dúvida'),
      'ativo': true,
      'icone': const Icon(Icons.tungsten_outlined),
    },
    {
      'titulo': const Text('Ajuda'),
      'ativo': true,
      'icone': const Icon(Icons.help_outline),
    },
    {
      'titulo': const Text('Suporte'),
      'ativo': true,
      'icone': const Icon(Icons.support_agent_outlined),
      'funcao': (BuildContext context) {
        var usuarioProvider = context.read<UsuarioProvider>();

        if (usuarioProvider.usuario != null && usuarioProvider.usuario!.celularSuporte!.isNotEmpty) {
          FuncoesGlobais.abrirWhatsapp(usuarioProvider.usuario!.celularSuporte!);
        }
      }
    },
    {
      'titulo': const Text('Atualização'),
      'ativo': true,
      'icone': const Icon(Icons.system_update_outlined),
      'funcao': (BuildContext context) {
        var usuarioProvider = context.read<UsuarioProvider>();

        if (usuarioProvider.usuario != null &&
            usuarioProvider.usuario!.atualizacaoAndroid != null &&
            usuarioProvider.usuario!.atualizacaoAndroid!.isNotEmpty &&
            usuarioProvider.usuario!.atualizacaoIos != null &&
            usuarioProvider.usuario!.atualizacaoIos!.isNotEmpty) {
          FuncoesGlobais.abrirLinkAtualizacao(usuarioProvider.usuario!.atualizacaoAndroid!, usuarioProvider.usuario!.atualizacaoIos!);
        }
      }
    },
    {
      'titulo': const Text('Sugestões'),
      'ativo': true,
      'icone': const Icon(Icons.send_outlined),
    },
    {
      'titulo': const Text('Compartilhar App'),
      'ativo': true,
      'icone': const Icon(Icons.share_outlined),
    },
    {
      'titulo': const Text('Excluir Conta'),
      'icone': const Icon(Icons.delete_outline),
      'ativo': true,
      'funcao': (BuildContext context) async {
        showDialog<String>(
          context: context,
          builder: (BuildContext contextDialog) {
            return AlertDialog(
              title: const Text('Excluir'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Deseja realmente excluir sua conta?"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Não'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Sim'),
                  onPressed: () async {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Exclusão de Conta'),
                          content: const SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text("Excluindo a sua conta você perderá o acesso a todos os seus dados, tem certeza que quer excluir?"),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Não'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Sim'),
                              onPressed: () async {
                                final autenticacaoServico = context.read<AutenticacaoServico>();
                                final firebaseMessagingService = context.read<FirebaseMessagingService>();
                                var usuarioProvider = context.read<UsuarioProvider>();
                                String? tokenNotificacao = kIsWeb ? '' : await firebaseMessagingService.getDeviceFirebaseToken();

                                autenticacaoServico.excluirConta(usuarioProvider.usuario, tokenNotificacao).then((resposta) {
                                  var (sucessoAoExcluirConta, mensagem) = resposta;

                                  if (sucessoAoExcluirConta) {
                                    if (context.mounted) {
                                      UsuarioServico.sair(context).then((value) {
                                        if (context.mounted) {
                                          Navigator.pushNamedAndRemoveUntil(context, '/inicio', (Route<dynamic> route) => false);
                                        }
                                      });
                                    }
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(mensagem),
                                      ));
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    },
    {
      'titulo': const Text('Sair', style: TextStyle(color: Colors.red)),
      'icone': const Icon(Icons.logout_outlined, color: Colors.red),
      'ativo': true,
      'funcao': (BuildContext context) {
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
                      final autenticacaoServico = context.read<AutenticacaoServico>();
                      final firebaseMessagingService = context.read<FirebaseMessagingService>();
                      final usuarioProvider = context.read<UsuarioProvider>();
                      final comprasProvedor = context.read<ComprasProvedor>();
                      String? tokenNotificacao = kIsWeb ? '' : await firebaseMessagingService.getDeviceFirebaseToken();

                      autenticacaoServico.sair(usuarioProvider.usuario, tokenNotificacao).then((resposta) {
                        var (sucessoAoExcluirToken, _) = resposta;

                        if (sucessoAoExcluirToken) {
                          if (context.mounted) {
                            UsuarioServico.sair(context).then((value) {
                              comprasProvedor.resetarCompras();
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(context, AppRotas.inicio, (Route<dynamic> route) => false);
                              }
                            });
                          }
                        }
                      });
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    },
  ];

  String nomeUsuario() {
    var usuarioProvider = context.read<UsuarioProvider>();

    if (usuarioProvider.usuario != null && usuarioProvider.usuario!.nome!.isNotEmpty) {
      var nomeComEspaco = usuarioProvider.usuario!.nome!.trimLeft().trimRight().split(RegExp(r"\s+")).join(' ').split(' ');

      if (nomeComEspaco.length > 1) {
        if (nomeComEspaco[1][0].isNotEmpty) {
          return "${nomeComEspaco[0][0].toUpperCase()}${nomeComEspaco[1][0].toUpperCase()}";
        } else {
          return "N/A";
        }
      } else {
        return "${usuarioProvider.usuario!.nome![0].toUpperCase()}${usuarioProvider.usuario!.nome![1].toUpperCase()}";
      }
    } else {
      itemsPerfil[0]['ativo'] = false;
      itemsPerfil[1]['ativo'] = false;
      itemsPerfil[2]['ativo'] = false;
      itemsPerfil[itemsPerfil.length - 1]['ativo'] = false;
      itemsPerfil[itemsPerfil.length - 2]['ativo'] = false;
      return "N/A";
    }
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var itemsAtivos = itemsPerfil.where((element) => element['ativo'] == true).toList();

    return Consumer<UsuarioProvider>(builder: (context, usuarioProvider, child) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (usuarioProvider.usuario != null && (usuarioProvider.usuario!.tipo == 'social' && usuarioProvider.usuario!.foto != 'semfoto'))
                        ? CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 45,
                            backgroundImage: Image.network(usuarioProvider.usuario!.foto!).image,
                          )
                        : CircleAvatar(
                            backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha: 1.0),
                            radius: 45,
                            child: Text(
                              nomeUsuario(),
                              style: const TextStyle(fontSize: 22, color: Colors.white),
                            ),
                          ),
                    if (usuarioProvider.usuario != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "#${usuarioProvider.usuario!.id} - ${usuarioProvider.usuario!.nome!}",
                        ),
                      ),
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        usuarioProvider.usuario!.email!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "HC Cabeça: ${usuarioProvider.usuario!.hcCabeceira!.isEmpty ? 'Nenhum' : usuarioProvider.usuario!.hcCabeceira}",
                          ),
                          const SizedBox(width: 20),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "HC Pé: ${usuarioProvider.usuario!.hcPezeiro!.isEmpty ? 'Nenhum' : usuarioProvider.usuario!.hcPezeiro}",
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(height: 1),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: context.read<ThemeController>(),
              builder: (context, state, _) {
                return ListTile(
                  leading: context.read<ThemeController>().value == ThemeMode.dark ? const Icon(Icons.nightlight_outlined) : const Icon(Icons.wb_sunny_outlined),
                  title: const Text('Mudar Tema'),
                  onTap: () {
                    context.read<ThemeController>().onThemeSwitchEvent();
                  },
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: Color.fromARGB(255, 82, 82, 82),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 40),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemsAtivos.length,
                separatorBuilder: (contextLista, index) {
                  return const Divider(
                    indent: 0,
                    endIndent: 0,
                    height: 1,
                  );
                },
                itemBuilder: (contextLista, index) {
                  var item = itemsAtivos[index];

                  return ListTile(
                    onTap: () => item['funcao'] != null ? item['funcao'](context) : null,
                    leading: item['icone'],
                    title: item['titulo'],
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromARGB(255, 82, 82, 82),
                    ),
                  );
                },
              ),
            ),
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
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }
}
