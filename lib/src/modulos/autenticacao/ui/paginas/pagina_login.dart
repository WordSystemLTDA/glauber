import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/funcoes_global.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/compartilhado/widgets/logo_app.dart';
import 'package:provadelaco/src/essencial/servicos/listar_dados_servicos_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/data/servicos/autenticacao_servico_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provider/provider.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool ocultarSenha = true;
  String celularSuporte = '';
  String possuiCadastro2 = '';
  String possuiCadastro1 = '';
  String ativoCadastro = '';

  void entrarComEmail() async {
    final AutenticacaoStore autenticacaoStore = context.read<AutenticacaoStore>();
    final firebaseMessagingService = context.read<FirebaseMessagingService>();

    String? tokenNotificacao = kIsWeb ? '' : await firebaseMessagingService.getDeviceFirebaseToken();

    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Center(child: Text('Preencha todos os campos.')),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ));
        return;
      }
    }

    if (mounted) {
      autenticacaoStore.entrar(context, _emailController.text, _senhaController.text, TiposLogin.email, tokenNotificacao);
    }
  }

  void entrarSocial(TiposLogin tipoLogin) async {
    final AutenticacaoStore autenticacaoStore = context.read<AutenticacaoStore>();
    final FirebaseMessagingService firebaseMessagingService = context.read<FirebaseMessagingService>();
    String? tokenNotificacao = kIsWeb ? '' : await firebaseMessagingService.getDeviceFirebaseToken();

    if (mounted) {
      autenticacaoStore.entrar(context, _emailController.text, _senhaController.text, tipoLogin, tokenNotificacao);
    }
  }

  @override
  void initState() {
    super.initState();
    final autenticacaoStore = context.read<AutenticacaoStore>();
    final listarDadosServicosImpl = context.read<ListarDadosServicosImpl>();

    listarDadosServicosImpl.listarDados().then((value) {
      setState(() {
        celularSuporte = value.celularSuporte;
        ativoCadastro = value.ativoCadastro;
        possuiCadastro1 = value.possuiCadastro1;
        possuiCadastro2 = value.possuiCadastro2;
      });
    });

    autenticacaoStore.addListener(() {
      AutenticacaoEstado state = autenticacaoStore.value;
      if (state is Autenticado) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, AppRotas.inicio, (Route<dynamic> route) => false);
          }
        });
      } else if (state is AutenticacaoErro) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Center(child: Text(state.erro.toString().substring(11))),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ));
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final AutenticacaoStore autenticacaoStore = context.read<AutenticacaoStore>();

    return ValueListenableBuilder<AutenticacaoEstado>(
      valueListenable: autenticacaoStore,
      builder: (context, state, _) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Scaffold(
                body: SafeArea(
                  child: Center(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final listarDadosServicosImpl = context.read<ListarDadosServicosImpl>();

                        listarDadosServicosImpl.listarDados().then((value) {
                          setState(() {
                            celularSuporte = value.celularSuporte;
                            ativoCadastro = value.ativoCadastro;
                            possuiCadastro1 = value.possuiCadastro1;
                            possuiCadastro2 = value.possuiCadastro2;
                          });
                        });
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const LogoApp(width: 230),
                            const SizedBox(height: 50),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(hintText: 'E-mail'),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              obscureText: ocultarSenha,
                              controller: _senhaController,
                              decoration: const InputDecoration(
                                hintText: 'Senha',
                                // suffix: IconButton(
                                //   onPressed: () {
                                //     setState(() {
                                //       ocultarSenha = !ocultarSenha;
                                //     });
                                //   },
                                //   icon: ocultarSenha ? const Icon(Icons.remove_red_eye) : const Icon(Icons.remove_red_eye_outlined),
                                // ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(255, 247, 24, 8)),
                                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  entrarComEmail();
                                },
                                child: const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      insetPadding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      child: SizedBox(
                                        width: width - 50,
                                        height: 250,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('E-mail'),
                                              const SizedBox(height: 10),
                                              const TextField(
                                                decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'E-mail'),
                                              ),
                                              const SizedBox(height: 10),
                                              Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      child: const Text('Recuperar'),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        if (celularSuporte.isNotEmpty) {
                                                          FuncoesGlobais.abrirWhatsapp(celularSuporte);
                                                        }
                                                      },
                                                      child: const Row(
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons.whatsapp,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text('Entrar em contato via WhatsApp'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              title: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Esqueceu sua senha? ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Clique aqui',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            SignInButton(
                              Buttons.GoogleDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                              text: 'Entrar com o Google',
                              onPressed: () {
                                entrarSocial(TiposLogin.google);
                              },
                            ),
                            const SizedBox(height: 10),
                            if (!kIsWeb && Platform.isIOS) ...[
                              SignInButton(
                                Buttons.AppleDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                text: 'Entrar com a Apple',
                                onPressed: () async {
                                  entrarSocial(TiposLogin.apple);
                                },
                              ),
                            ],
                            const SizedBox(height: 20),
                            ListTile(
                              onTap: () {
                                if (ativoCadastro == 'Sim') {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext contextDialog) {
                                      return AlertDialog(
                                        title: const Text('Cadastro'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                possuiCadastro1,
                                                style: const TextStyle(fontSize: 18),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Não'),
                                            onPressed: () {
                                              Navigator.of(contextDialog).pop();
                                              Navigator.pushNamed(context, '/autenticacao/cadastrar');
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Sim'),
                                            onPressed: () async {
                                              Navigator.of(contextDialog).pop();
                                              if (mounted) {
                                                showDialog<String>(
                                                  context: context,
                                                  builder: (BuildContext contextDialog) {
                                                    return AlertDialog(
                                                      title: const Text('Cadastro'),
                                                      content: SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(
                                                              possuiCadastro2,
                                                              style: const TextStyle(fontSize: 18),
                                                              textAlign: TextAlign.justify,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        SizedBox(
                                                          width: 110,
                                                          child: TextButton(
                                                            child: const Row(
                                                              children: [
                                                                FaIcon(FontAwesomeIcons.whatsapp),
                                                                SizedBox(width: 5),
                                                                Text('Suporte'),
                                                              ],
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(contextDialog).pop();
                                                              if (celularSuporte.isNotEmpty) {
                                                                FuncoesGlobais.abrirWhatsapp(celularSuporte);
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        TextButton(
                                                          child: const Text('OK'),
                                                          onPressed: () async {
                                                            Navigator.of(contextDialog).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  return;
                                }

                                Navigator.pushNamed(context, '/autenticacao/cadastrar');
                              },
                              title: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Não está cadastrado? ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text('Cadastre-se', style: TextStyle(color: Colors.blue, fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (state is Carregando)
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
