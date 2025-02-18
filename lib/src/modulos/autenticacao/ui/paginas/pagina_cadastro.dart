import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/compartilhado/widgets/handicaps_dialog.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/autenticacao_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/modelos/modelo_modalidades_cadastro.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/autenticacao_store.dart';
import 'package:provadelaco/src/modulos/perfil/interator/modelos/cidade_modelo.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/cidade_servico.dart';
import 'package:provider/provider.dart';

class PaginaCadastroArgumentos {
  final List<ModeloModalidadesCadastro> modalidades;
  final bool jaEstaCadastrado;

  const PaginaCadastroArgumentos({required this.modalidades, required this.jaEstaCadastrado});
}

class PaginaCadastro extends StatefulWidget {
  final PaginaCadastroArgumentos argumentos;
  const PaginaCadastro({super.key, required this.argumentos});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  final _nomeController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _hcCabeceiraController = TextEditingController();
  final _hcPiseiroController = TextEditingController();
  final _hcLacoIndividualController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _celularController = TextEditingController();
  final _cidadeController = TextEditingController(text: 'Sem cidade');
  final _pesquisaCidadeController = SearchController();

  String idHcCabeceira = '0';
  String idHcPiseiro = '0';
  String idHcLacoIndividual = '0';
  String profissional = '';
  String genero = '';
  String idCidade = '';

  bool ocultarSenha = true;
  bool ocultarConfirmar = true;

  @override
  void initState() {
    super.initState();
    final autenticacaoStore = context.read<AutenticacaoStore>();
    var usuarioProvider = context.read<UsuarioProvider>();

    if (widget.argumentos.jaEstaCadastrado == true) {
      // TODO: fazer
    }

    autenticacaoStore.addListener(() {
      AutenticacaoEstado state = autenticacaoStore.value;
      if (state is Cadastrado) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, AppRotas.login, (Route<dynamic> route) => false);
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
    _dataNascimentoController.dispose();
    _celularController.dispose();
    _cidadeController.dispose();
    _pesquisaCidadeController.dispose();
    super.dispose();
  }

  void cadastrar() {
    var autenticacaoStore = context.read<AutenticacaoStore>();

    String nome = _nomeController.text;
    String apelido = _apelidoController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmar = _confirmarSenhaController.text;
    String celular = _celularController.text;
    String cidade = idCidade;
    String hcCabeceira = idHcCabeceira;
    String hcPiseiro = idHcPiseiro;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.red,
        content: Center(child: Text('Preencha todos os campos!')),
      ));
    } else if (((hcCabeceira.isEmpty || hcCabeceira == '0') || (hcPiseiro.isEmpty || hcPiseiro == '0')) &&
        widget.argumentos.modalidades.where((element) => element.id == '3').isNotEmpty) {
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
        var dataNascimentoF = _dataNascimentoController.text.split('/');
        var dataNascimento = "${dataNascimentoF[2]}-${dataNascimentoF[1]}-${dataNascimentoF[0]}";

        autenticacaoStore.cadastrar(
          nome: nome.trimLeft().trimRight(),
          apelido: apelido.trimLeft().trimRight(),
          email: email.trimLeft().trimRight(),
          senha: senha,
          celular: celular,
          cidade: cidade,
          hcCabeceira: hcCabeceira,
          hcPiseiro: hcPiseiro,
          datanascimento: dataNascimento,
          handicaplacoindividual: idHcLacoIndividual,
          modalidades: widget.argumentos.modalidades,
          sexo: genero,
          tipodecategoriaprofissional: profissional,
        );
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
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Wrap(
                    children: [
                      const Text("Suas Modalidades: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text("${widget.argumentos.modalidades.map((e) => e.nome.toString())}", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  if (widget.argumentos.jaEstaCadastrado == false) ...[
                    const Divider(height: 30),
                    Text('Dados Gerais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
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
                      controller: _celularController,
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
                      searchController: _pesquisaCidadeController,
                      builder: (BuildContext context, SearchController controller) {
                        return TextField(
                          onTap: () {
                            _pesquisaCidadeController.openView();
                          },
                          controller: _cidadeController,
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
                                _cidadeController.text = cidade.nome;
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
                  ],
                  if (widget.argumentos.modalidades.where((element) => element.id == '3').isNotEmpty) ...[
                    const Divider(height: 30),
                    Text('Laço em Dupla', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    const Text('HandiCap Cabeça*'),
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
                    const Text('HandiCap Pé*'),
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
                  ],
                  if (widget.argumentos.modalidades.where((element) => element.id == '2').isNotEmpty) ...[
                    const Divider(height: 30),
                    Text('Laço Individual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    const Text('HandiCap*'),
                    const SizedBox(height: 5),
                    TextField(
                      readOnly: true,
                      controller: _hcLacoIndividualController,
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
                                    _hcLacoIndividualController.text = handicaps.where((element) => element.id == '3').first.nome;
                                    idHcLacoIndividual = '3';
                                  } else {
                                    _hcLacoIndividualController.text = itemHC.nome;
                                    idHcLacoIndividual = itemHC.id;
                                  }
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                  if (widget.argumentos.modalidades.where((element) => element.id == '1').isNotEmpty) ...[
                    const Divider(height: 30),
                    Text('3 Tambores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    const Text('Data de Nascimento*'),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _dataNascimentoController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DataInputFormatter(),
                      ],
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Data de Nascimento'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Profissional*'),
                              const SizedBox(height: 5),
                              DropdownMenu(
                                expandedInsets: EdgeInsets.zero,
                                initialSelection: 'Não',
                                hintText: 'Você é Profissinal',
                                onSelected: (opcao) {
                                  if (opcao == null) return;

                                  setState(() {
                                    profissional = opcao;
                                  });
                                },
                                dropdownMenuEntries: const [
                                  DropdownMenuEntry(value: 'Não', label: 'Não'),
                                  DropdownMenuEntry(value: 'Sim', label: 'Sim'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Gênero'),
                              const SizedBox(height: 5),
                              DropdownMenu(
                                expandedInsets: EdgeInsets.zero,
                                initialSelection: '',
                                hintText: 'Seu gênero',
                                onSelected: (opcao) {
                                  if (opcao == null) return;

                                  setState(() {
                                    genero = opcao;
                                  });
                                },
                                dropdownMenuEntries: const [
                                  DropdownMenuEntry(value: 'Masculino', label: 'Masculino'),
                                  DropdownMenuEntry(value: 'Feminino', label: 'Feminino'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 25),
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
