import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/widgets/handicaps_dialog.dart';
import 'package:provadelaco/src/modulos/autenticacao/data/servicos/autenticacao_servico_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class PaginaPreencherInformacoesArgumentos {
  final dynamic usuario;
  final String tokenNotificacao;
  final TiposLogin tipoLogin;

  PaginaPreencherInformacoesArgumentos({required this.usuario, required this.tokenNotificacao, required this.tipoLogin});
}

class PaginaPreencherInformacoes extends StatefulWidget {
  final PaginaPreencherInformacoesArgumentos argumentos;
  const PaginaPreencherInformacoes({super.key, required this.argumentos});

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
  void initState() {
    super.initState();
    setarInformacoes();
    final autenticacaoStore = context.read<AutenticacaoStore>();

    autenticacaoStore.addListener(() {
      AutenticacaoEstado state = autenticacaoStore.value;
      if (state is Cadastrado) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, AppRotas.inicio, (Route<dynamic> route) => false);
          }
        });
      } else if (state is ErroAoCadastrar) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.erro.toString().substring(11)),
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
    _nomeController.dispose();
    _hcCabeceiraController.dispose();
    _hcPiseiroController.dispose();
    super.dispose();
  }

  void setarInformacoes() {
    if (widget.argumentos.tipoLogin == TiposLogin.google) {
      var usuarioTipo = widget.argumentos.usuario as GoogleSignInAccount;

      _nomeController.text = usuarioTipo.displayName!;
    } else if (widget.argumentos.tipoLogin == TiposLogin.apple) {
      var usuarioTipo = widget.argumentos.usuario as AuthorizationCredentialAppleID;
      if (usuarioTipo.familyName != null && usuarioTipo.givenName != null) {
        _nomeController.text = "${usuarioTipo.familyName} ${usuarioTipo.givenName}";
      }
    }
  }

  void cadastrar() {
    var autenticacaoStore = context.read<AutenticacaoStore>();
    String nome = _nomeController.text;
    String hcCabeceira = idHcCabeceira;
    String hcPiseiro = idHcPiseiro;

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.red,
        content: Center(child: Text('O nome não pode ser vazio.')),
      ));
    } else if (hcCabeceira.isEmpty || hcPiseiro.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.red,
        content: Center(child: Text('Algum dos dois HandiCap precisa ser preenchido.')),
      ));
    } else {
      autenticacaoStore.cadastrarSocial(context, widget.argumentos.usuario, widget.argumentos.tipoLogin, _nomeController.text, hcCabeceira, hcPiseiro);
    }
  }

  @override
  Widget build(BuildContext context) {
    var autenticacaoStore = context.read<AutenticacaoStore>();

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
                  const Text('HandiCap Cabeça'),
                  const SizedBox(height: 5),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    controller: _hcCabeceiraController,
                    decoration: const InputDecoration(
                      hintText: "Seu HandiCap",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return HandiCapsDialog(
                            aoMudar: (itemHC, handicaps) {
                              if (int.parse(idHcPiseiro) == 3 && double.parse(itemHC.id) < 3) {
                                _hcCabeceiraController.text = handicaps.where((element) => element.id == '3').first.nome;
                                idHcCabeceira = '3';
                              } else {
                                _hcCabeceiraController.text = itemHC.nome;
                                idHcCabeceira = itemHC.id;
                              }
                              Navigator.pop(context);
                            },
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
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Seu HandiCap'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return HandiCapsDialog(
                            aoMudar: (itemHC, handicaps) {
                              setState(() {
                                if (int.parse(idHcCabeceira) == 3 && double.parse(itemHC.id) < 3) {
                                  _hcPiseiroController.text = handicaps.where((element) => element.id == '3').first.nome;
                                  idHcPiseiro = '3';
                                } else {
                                  _hcPiseiroController.text = itemHC.nome;
                                  idHcPiseiro = itemHC.id;
                                }
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        cadastrar();
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
