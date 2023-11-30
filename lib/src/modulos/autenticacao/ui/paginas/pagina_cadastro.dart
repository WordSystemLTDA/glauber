import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/handicap_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/handicap_store.dart';
import 'package:provider/provider.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  final _nomeController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _hcCabeceiraController = TextEditingController();
  final _hcPiseiroController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  String idHcCabeceira = '0';
  String idHcPiseiro = '0';

  bool ocultarSenha = true;
  bool ocultarConfirmar = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _apelidoController.dispose();
    _emailController.dispose();
    _hcCabeceiraController.dispose();
    _hcPiseiroController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final autenticacaoStore = context.read<AutenticacaoStore>();

    autenticacaoStore.addListener(() {
      AutenticacaoEstado state = autenticacaoStore.value;
      if (state is Cadastrado) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else if (state is ErroAoCadastrar) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.erro.toString()),
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
  Widget build(BuildContext context) {
    var autenticacaoStore = context.read<AutenticacaoStore>();
    var handiCapStore = context.read<HandiCapStore>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ValueListenableBuilder(
        valueListenable: autenticacaoStore,
        builder: (context, state, _) {
          return Scaffold(
            appBar: const AppBarSombra(
              titulo: Text("Cadastre-se"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(30),
              child: ListView(
                children: [
                  const Text('Nome completo'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ex: João'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Apelido'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _apelidoController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ex: João'),
                  ),
                  const SizedBox(height: 10),
                  const Text('E-mail'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ex: joao@gmail.com'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Senha'),
                            const SizedBox(height: 5),
                            TextField(
                              obscureText: ocultarSenha,
                              controller: _senhaController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Senha',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ocultarSenha = !ocultarSenha;
                                    });
                                  },
                                  icon: ocultarSenha
                                      ? const Icon(Icons.remove_red_eye)
                                      : const Icon(
                                          Icons.remove_red_eye_outlined,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Confirmar senha'),
                            const SizedBox(height: 5),
                            TextField(
                              obscureText: ocultarConfirmar,
                              controller: _confirmarSenhaController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Confirmar senha',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ocultarConfirmar = !ocultarConfirmar;
                                    });
                                  },
                                  icon: ocultarConfirmar ? const Icon(Icons.remove_red_eye) : const Icon(Icons.remove_red_eye_outlined),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('HandiCap Cabeça'),
                  const SizedBox(height: 5),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Seu HandiCap",
                      border: OutlineInputBorder(),
                    ),
                    controller: _hcCabeceiraController,
                    onTap: () {
                      handiCapStore.listar();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SizedBox(
                              height: 400,
                              child: ValueListenableBuilder<HandiCapEstado>(
                                valueListenable: handiCapStore,
                                builder: (context, state, _) {
                                  if (state is HandiCapCarregando) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (state is HandiCapCarregado) {
                                    return ListView.builder(
                                      itemCount: state.handicaps.length,
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      itemBuilder: (context, index) {
                                        var item = state.handicaps[index];

                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              _hcCabeceiraController.text = item.nome;
                                              idHcCabeceira = item.id;
                                            });
                                            Navigator.pop(context);
                                          },
                                          title: Text(item.nome),
                                        );
                                      },
                                    );
                                  }

                                  return const Text('Erro ao tentar Listar HandiCaps');
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('HandiCap Pé'),
                  const SizedBox(height: 5),
                  TextField(
                    readOnly: true,
                    controller: _hcPiseiroController,
                    onTap: () {
                      handiCapStore.listar();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SizedBox(
                              height: 400,
                              child: ValueListenableBuilder<HandiCapEstado>(
                                valueListenable: handiCapStore,
                                builder: (context, state, _) {
                                  if (state is HandiCapCarregando) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (state is HandiCapCarregado) {
                                    return ListView.builder(
                                      itemCount: state.handicaps.length,
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      itemBuilder: (context, index) {
                                        var item = state.handicaps[index];

                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              _hcPiseiroController.text = item.nome;
                                              idHcPiseiro = item.id;
                                            });
                                            Navigator.pop(context);
                                          },
                                          title: Text(item.nome),
                                        );
                                      },
                                    );
                                  }

                                  return const Text('Erro ao tentar Listar HandiCaps');
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Seu HandiCap'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String nome = _nomeController.text;
                        String apelido = _apelidoController.text;
                        String email = _emailController.text;
                        String senha = _senhaController.text;
                        String confirmar = _confirmarSenhaController.text;
                        String hcCabeceira = idHcCabeceira;
                        String hcPiseiro = idHcPiseiro;

                        if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmar.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.red,
                            content: Center(child: Text('Preencha todos os campos!')),
                          ));
                        } else if (hcCabeceira.isEmpty && hcPiseiro.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.red,
                            content: Center(child: Text('Algum dos dois HandiCap precisa ser preenchido.')),
                          ));
                        } else {
                          if (senha != confirmar) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              showCloseIcon: true,
                              backgroundColor: Colors.red,
                              content: Center(child: Text('Campos de senha precisam ser iguais!')),
                            ));
                          } else {
                            autenticacaoStore.cadastrar(nome, apelido, email, senha, hcCabeceira, hcPiseiro);
                          }
                        }
                      },
                      child: state is Cadastrando ? const CircularProgressIndicator() : const Text('Cadastrar-se'),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
