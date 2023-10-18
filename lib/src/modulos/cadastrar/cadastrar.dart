import 'package:flutter/material.dart';

class Cadastrar extends StatefulWidget {
  const Cadastrar({super.key});

  @override
  State<Cadastrar> createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Cadastrar-se'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(children: [
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('E-mail'),
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'joao@gmail.com'),
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
                      controller: _senhaController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Senha'),
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
                      controller: _confirmarSenhaController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Confirmar senha'),
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
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(
                            child: SizedBox(
                              width: 300,
                              height: 230,
                              child: Center(
                                  child: Text(
                                'Preencha todos os campos!',
                                style: TextStyle(fontSize: 20),
                              )),
                            ),
                          );
                        });
                  }
                },
                child: const Text('Cadastrar-se'),
              ))
        ]),
      ),
    );
  }
}
