import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/compartilhado/widgets/handicaps_dialog.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provadelaco/src/modulos/perfil/interator/modelos/cidade_modelo.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/cidade_servico.dart';
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
  final TextEditingController celularController = TextEditingController();

  TextEditingController cidadeController = TextEditingController(text: 'Sem cidade');
  SearchController pesquisaCidadeController = SearchController();

  String idHcCabeceira = '0';
  String idHcPiseiro = '0';
  String idCidade = '';

  bool ocultarSenha = true;
  bool ocultarConfirmar = true;

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
    _apelidoController.dispose();
    _emailController.dispose();
    _hcCabeceiraController.dispose();
    _hcPiseiroController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void cadastrar() {
    var autenticacaoStore = context.read<AutenticacaoStore>();

    String nome = _nomeController.text;
    String apelido = _apelidoController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmar = _confirmarSenhaController.text;
    String celular = celularController.text;
    String cidade = idCidade;
    String hcCabeceira = idHcCabeceira;
    String hcPiseiro = idHcPiseiro;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.red,
        content: Center(child: Text('Preencha todos os campos!')),
      ));
    } else if ((hcCabeceira.isEmpty || hcCabeceira == '0') || (hcPiseiro.isEmpty || hcPiseiro == '0')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.red,
        content: Center(child: Text('Você precisa preencher todos os handicaps.')),
      ));
    } else {
      if (senha != confirmar) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Center(child: Text('Campos de senha precisam ser iguais!')),
        ));
      } else {
        autenticacaoStore.cadastrar(nome, apelido, email, senha, celular, cidade, hcCabeceira, hcPiseiro);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var autenticacaoStore = context.read<AutenticacaoStore>();
    var cidadeServico = context.read<CidadeServico>();

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
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Nome Completo'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Apelido'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _apelidoController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Como quer ser chamado no Brete'),
                  ),
                  const SizedBox(height: 10),
                  const Text('E-mail'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ex: joao@gmail.com'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Celular'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: celularController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Celular',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Cidade'),
                  const SizedBox(height: 5),
                  SearchAnchor(
                    viewBuilder: (suggestions) {
                      return ListView.builder(
                        itemCount: suggestions.length,
                        padding: EdgeInsets.only(bottom: ConstantesGlobal.alturaTeclado),
                        itemBuilder: (context, index) {
                          var item = suggestions.elementAt(index);

                          return item;
                        },
                      );
                    },
                    isFullScreen: true,
                    searchController: pesquisaCidadeController,
                    builder: (BuildContext context, SearchController controller) {
                      return TextField(
                        onTap: () {
                          pesquisaCidadeController.openView();
                        },
                        controller: cidadeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                    suggestionsBuilder: (BuildContext context, SearchController controller) async {
                      final keyword = controller.value.text;

                      List<CidadeModelo>? cidades = await cidadeServico.listar(keyword);

                      Iterable<Widget> widgets = cidades!.map((cidade) {
                        return GestureDetector(
                          onTap: () {
                            controller.closeView('');
                            setState(() {
                              idCidade = cidade.id;
                              cidadeController.text = cidade.nome;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          child: Card(
                            elevation: 3.0,
                            child: ListTile(
                              leading: const Icon(Icons.copy_all_outlined),
                              title: Text(cidade.nome),
                              subtitle: Text(
                                cidade.nomeUf,
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        );
                      });

                      return widgets;
                    },
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
                      const SizedBox(width: 10),
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
                              setState(() {
                                if (int.parse(idHcPiseiro) == 3 && double.parse(itemHC.id) < 3) {
                                  _hcCabeceiraController.text = handicaps.where((element) => element.id == '3').first.nome;
                                  idHcCabeceira = '3';
                                } else {
                                  _hcCabeceiraController.text = itemHC.nome;
                                  idHcCabeceira = itemHC.id;
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
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
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
