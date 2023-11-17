import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
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

  bool ocultarSenha = true;
  bool ocultarConfirmar = true;

  @override
  Widget build(BuildContext context) {
    var autenticacaoStore = context.read<AutenticacaoStore>();

    return ValueListenableBuilder(
      valueListenable: autenticacaoStore,
      builder: (context, state, _) {
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
                title: const Text("Cadastrar-se"),
              ),
            ),
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
                const Text('H.C Cabeceira'),
                const SizedBox(height: 5),
                TextField(
                  controller: _hcCabeceiraController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Seu H.C'),
                ),
                const SizedBox(height: 10),
                const Text('H.C Piseiro'),
                const SizedBox(height: 5),
                TextField(
                  controller: _hcPiseiroController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Seu H.C'),
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
                      String hcCabeceira = _hcCabeceiraController.text;
                      String hcPiseiro = _hcPiseiroController.text;

                      if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmar.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.red,
                          content: Text('Preencha todos os campos!'),
                        ));
                      } else {
                        if (senha != confirmar) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.red,
                            content: Text('Campos de senha precisam ser iguais!'),
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
    );
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
}
