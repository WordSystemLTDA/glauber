import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provider/provider.dart';

class PaginaPreencherInformacoes extends StatefulWidget {
  final String nome;
  final String email;
  final String idSocialLogin;
  const PaginaPreencherInformacoes({super.key, required this.nome, required this.email, required this.idSocialLogin});

  @override
  State<PaginaPreencherInformacoes> createState() => _PaginaPreencherInformacoesState();
}

class _PaginaPreencherInformacoesState extends State<PaginaPreencherInformacoes> {
  final _nomeController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _hcCabeceiraController = TextEditingController();
  final _hcPiseiroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var autenticacaoStore = context.read<AutenticacaoStore>();

    _nomeController.text = widget.nome;
    _apelidoController.text = widget.nome;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ValueListenableBuilder(
        valueListenable: autenticacaoStore,
        builder: (context, state, _) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 0),
                      blurRadius: 10.0,
                    )
                  ],
                ),
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
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ex: José Silveira dos Santos'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Apelido'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _apelidoController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ex: zé'),
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
                        String hcCabeceira = _hcCabeceiraController.text;
                        String hcPiseiro = _hcPiseiroController.text;

                        if (nome.isEmpty || hcCabeceira.isEmpty || hcPiseiro.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.red,
                            content: Center(child: Text('Preencha todos os campos!')),
                          ));
                        } else {
                          autenticacaoStore.preencherInformacoes(nome, apelido, widget.email, hcCabeceira, hcPiseiro, widget.idSocialLogin);
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
