import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/handicap_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/handicap_store.dart';
import 'package:provadelaco/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class PaginaPreencherInformacoes extends StatefulWidget {
  final dynamic usuario;
  final String tokenNotificacao;
  final TiposLoginSocial tipoLogin;
  const PaginaPreencherInformacoes({super.key, required this.usuario, required this.tokenNotificacao, required this.tipoLogin});

  @override
  State<PaginaPreencherInformacoes> createState() => _PaginaPreencherInformacoesState();
}

class _PaginaPreencherInformacoesState extends State<PaginaPreencherInformacoes> {
  final _nomeController = TextEditingController();
  final _hcCabeceiraController = TextEditingController();
  final _hcPiseiroController = TextEditingController();
  String idHcCabeceira = '0';
  String idHcPiseiro = '0';

  @override
  void dispose() {
    _nomeController.dispose();
    _hcCabeceiraController.dispose();
    _hcPiseiroController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setarInformacoes();
    final autenticacaoStore = context.read<AutenticacaoStore>();

    autenticacaoStore.addListener(() {
      AutenticacaoEstado state = autenticacaoStore.value;
      if (state is Cadastrado) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return const PaginaInicio();
              },
            ), (Route<dynamic> route) => false);
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

  void setarInformacoes() {
    if (widget.tipoLogin == TiposLoginSocial.google) {
      var usuarioTipo = widget.usuario as GoogleSignInAccount;

      _nomeController.text = usuarioTipo.displayName!;
    } else if (widget.tipoLogin == TiposLoginSocial.apple) {
      var usuarioTipo = widget.usuario as AuthorizationCredentialAppleID;
      _nomeController.text = "${usuarioTipo.familyName} ${usuarioTipo.givenName}";
    }
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
                  const Text('HandiCap Cabeceira'),
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

                                  return const Center(child: Text('Erro ao tentar Listar HandiCaps'));
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('HandiCap Piseiro'),
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

                                  return const Center(child: Text('Erro ao tentar Listar HandiCaps'));
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
                        String hcCabeceira = idHcCabeceira;
                        String hcPiseiro = idHcPiseiro;

                        if (nome.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.red,
                            content: Center(child: Text('O nome não pode ser vazio.')),
                          ));
                        } else if (hcCabeceira.isEmpty && hcPiseiro.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.red,
                            content: Center(child: Text('Algum dos dois HandiCap precisa ser preenchido.')),
                          ));
                        } else {
                          autenticacaoStore.cadastrarSocial(widget.usuario, widget.tipoLogin, hcCabeceira, hcPiseiro);
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
