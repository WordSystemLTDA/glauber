import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/firebase/firebase_messaging_service.dart';
import 'package:provadelaco/src/essencial/usuario_servico.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_preencher_informacoes.dart';
import 'package:provadelaco/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool ocultarSenha = true;

  void entrarComEmail() async {
    final AutenticacaoStore autenticacaoStore = context.read<AutenticacaoStore>();
    final firebaseMessagingService = context.read<FirebaseMessagingService>();
    String? tokenNotificacao = await firebaseMessagingService.getDeviceFirebaseToken();

    if (mounted) {
      autenticacaoStore.entrarComEmail(context, _emailController.text, _senhaController.text, tokenNotificacao);
    }
  }

  void entrarSocial(TiposLoginSocial tipoLoginSocial) async {
    final AutenticacaoStore autenticacaoStore = context.read<AutenticacaoStore>();
    final FirebaseMessagingService firebaseMessagingService = context.read<FirebaseMessagingService>();
    String? tokenNotificacao = await firebaseMessagingService.getDeviceFirebaseToken();

    if (mounted) {
      autenticacaoStore.listarInformacoesLogin(context, tipoLoginSocial, tokenNotificacao).then((resposta) {
        var (sucesso, usuario) = resposta;

        if (!sucesso) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return PaginaPreencherInformacoes(usuario: usuario, tokenNotificacao: tokenNotificacao!, tipoLogin: tipoLoginSocial);
            },
          ));
        } else {
          UsuarioServico.salvarUsuario(context, usuario!);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final autenticacaoStore = context.read<AutenticacaoStore>();

    autenticacaoStore.addListener(() {
      AutenticacaoEstado state = autenticacaoStore.value;
      if (state is Autenticado) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return const PaginaInicio();
              },
            ), (Route<dynamic> route) => false);
          }
        });
      } else if (state is AutenticacaoErro) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Center(child: Text('Dados incorretos')),
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'LOGO',
                            style: TextStyle(fontSize: 32),
                          ),
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
                                backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 247, 24, 8)),
                                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                    child: SizedBox(
                                      width: 300,
                                      height: 230,
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
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: const Text('Recuperar'),
                                            )
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
                              entrarSocial(TiposLoginSocial.google);
                            },
                          ),
                          const SizedBox(height: 10),
                          if (Platform.isIOS) ...[
                            SignInButton(
                              Buttons.AppleDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              text: 'Entrar com a Apple',
                              onPressed: () async {
                                entrarSocial(TiposLoginSocial.apple);
                              },
                            ),
                          ],
                          const SizedBox(height: 20),
                          ListTile(
                            onTap: () {
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
