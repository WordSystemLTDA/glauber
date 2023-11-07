import 'package:flutter/material.dart';
import 'package:glauber/src/essencial/usuario_provider.dart';
import 'package:glauber/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:glauber/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
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

  @override
  Widget build(BuildContext context) {
    final AutenticacaoStore autenticacaoStore = context.read<AutenticacaoStore>();

    return ValueListenableBuilder<AutenticacaoEstado>(
      valueListenable: autenticacaoStore,
      builder: (context, value, _) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      obscureText: ocultarSenha,
                      controller: _senhaController,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              ocultarSenha = !ocultarSenha;
                            });
                          },
                          icon: ocultarSenha ? const Icon(Icons.remove_red_eye) : const Icon(Icons.remove_red_eye_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                        onPressed: () {
                          autenticacaoStore.entrar(_emailController.text, _senhaController.text);
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
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(Icons.g_translate_outlined),
                              ),
                              Text('Entrar com o Google'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(Icons.facebook_outlined),
                              ),
                              Text('Entrar com o Facebook'),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                          Text('Cadastra-se', style: TextStyle(color: Colors.blue, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
            UsuarioProvider.init();
            Navigator.pushReplacementNamed(context, '/inicio');
          }
        });
      } else if (state is AutenticacaoErro) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Dados incorretos'),
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
}
