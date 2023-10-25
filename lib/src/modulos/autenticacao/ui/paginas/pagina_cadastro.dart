import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provider/provider.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool ocultarSenha = true;
  bool ocultarConfirmar = true;

  @override
  Widget build(BuildContext context) {
    var autenticacaoStore = context.read<AutenticacaoStore>();

    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Cadastrar-se'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nome completo'),
                Text('0/40'),
              ],
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ex: João'),
            ),
            const SizedBox(height: 20),
            const Text('E-mail'),
            const SizedBox(height: 5),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ex: joao@gmail.com'),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String nome = _nomeController.text;
                  String email = _emailController.text;
                  String senha = _senhaController.text;
                  String confirmar = _confirmarSenhaController.text;

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
                      autenticacaoStore.cadastrar(nome, email, senha);
                    }
                  }
                },
                child: const Text('Cadastrar-se'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
