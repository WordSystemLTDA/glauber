import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/conexoes_banco.dart';

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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'E-mail'),
            ),
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
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String email = _emailController.text;
                  String senha = _senhaController.text;
                  final dio = Dio();
                  final resposta = dio.post(ConexoesBanco().urlLogin(), data: {
                    'email': email,
                    'senha': senha,
                  });
                  resposta.then((value) {
                    if (value.data == 'usuario_permitido') {
                      Navigator.pushReplacementNamed(context, '/inicio');
                    } else if (value.data == 'usuario_negado') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        showCloseIcon: true,
                        backgroundColor: Colors.red,
                        content: Text('Email ou senha incorreto!'),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        showCloseIcon: true,
                        backgroundColor: Colors.red,
                        content: Text('Ocorreu um erro!'),
                      ));
                    }
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Entrar'),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                            ElevatedButton(onPressed: () {}, child: const Text('Recuperar'))
                          ],
                        ),
                      ),
                    ));
                  },
                );
              },
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Esqueceu sua senha? '), Text('Clique aqui', style: TextStyle(color: Colors.red))],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: const SizedBox(
                width: 200,
                height: 60,
                child: Center(child: Text('Entrar com o Google')),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: const SizedBox(
                width: 200,
                height: 60,
                child: Center(child: Text('Entrar com o Facebook')),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/cadastrar');
              },
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Não está cadastrado? '), Text('Cadastra-se', style: TextStyle(color: Colors.blue))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
