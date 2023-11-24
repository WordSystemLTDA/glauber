import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/formatters/rg_formatter.dart';
import 'package:provadelaco/src/essencial/usuario_provider.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/estados/handicap_estado.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/stores/handicap_store.dart';
import 'package:provadelaco/src/modulos/perfil/interator/modelos/formulario_editar_usuario_modelo.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/editar_usuario_servico.dart';
import 'package:provider/provider.dart';

class PaginaEditarUsuario extends StatefulWidget {
  const PaginaEditarUsuario({super.key});

  @override
  State<PaginaEditarUsuario> createState() => _PaginaEditarUsuarioState();
}

class _PaginaEditarUsuarioState extends State<PaginaEditarUsuario> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController apelidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController civilController = TextEditingController();

  final TextEditingController cabeceiraController = TextEditingController();
  final TextEditingController pezeiroController = TextEditingController();

  final TextEditingController cepController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();

  String idHcCabeceira = '0';
  String idHcPiseiro = '0';
  String dataNascimentoNormal = '';
  String cidade = '';

  var dadosSexos = [
    {
      'valor': 'Masculino',
      'nome': 'Masculino',
    },
    {
      'valor': 'Feminino',
      'nome': 'Feminino',
    },
  ];

  var dadosCivil = [
    {
      'valor': 'Solteiro(a)',
      'nome': 'Solteiro(a)',
    },
    {
      'valor': 'Casado(a)',
      'nome': 'Casado(a)',
    },
    {
      'valor': 'Divorciado(a)',
      'nome': 'Divorciado(a)',
    },
    {
      'valor': 'Viúvo(a)',
      'nome': 'Viúvo(a)',
    },
  ];

  @override
  void initState() {
    super.initState();
    setarInformacoes();
  }

  void setarInformacoes() {
    var usuario = UsuarioProvider.getUsuario()!;
    setState(() {
      nomeController.text = usuario.nome!;
      apelidoController.text = usuario.nome!;
      emailController.text = usuario.email!;
      cpfController.text = usuario.cpf!;
      rgController.text = usuario.rg!;
      dataNascimentoController.text = usuario.dataNascimento!;
      telefoneController.text = usuario.telefone!;
      celularController.text = usuario.celular!;
      senhaController.text = usuario.senha!;

      cabeceiraController.text = usuario.hcCabeceira;
      pezeiroController.text = usuario.hcPezeiro;

      enderecoController.text = usuario.endereco!;
      bairroController.text = usuario.bairro!;
      numeroController.text = usuario.numero!;
      complementoController.text = usuario.complemento!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    var handiCapStore = context.read<HandiCapStore>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              title: const Text("Editar Dados"),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -----------------------------------------------------------------
              const Text(
                'Dados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(hintText: 'Nome'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: apelidoController,
                decoration: const InputDecoration(hintText: 'Apelido'),
              ),
              const SizedBox(height: 10),
              if (UsuarioProvider.getUsuario()!.tipo! == 'normal') ...[
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'E-mail'),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cpfController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                      decoration: const InputDecoration(hintText: 'CPF'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: rgController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        RgInputFormatter(),
                      ],
                      decoration: const InputDecoration(hintText: 'RG'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sexoController,
                      readOnly: true,
                      decoration: const InputDecoration(hintText: 'Sexo'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  itemCount: dadosSexos.length,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  itemBuilder: (context, index) {
                                    var item = dadosSexos[index];

                                    return ListTile(
                                      onTap: () {
                                        setState(() {
                                          sexoController.text = item['valor']!;
                                        });
                                        Navigator.pop(context);
                                      },
                                      title: Text(item['nome']!),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: dataNascimentoController,
                      decoration: const InputDecoration(hintText: 'Data de Nascimento'),
                      readOnly: true,
                      onTap: () async {
                        final DateTime? time = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                          initialDate: DateTime.now(),
                        );

                        if (time != null) {
                          setState(() {
                            dataNascimentoNormal = DateFormat('yyyy-MM-dd').format(time).toString();
                            dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(time).toString();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: telefoneController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      decoration: const InputDecoration(hintText: 'Telefone'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: celularController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      decoration: const InputDecoration(hintText: 'Celular'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (UsuarioProvider.getUsuario()!.tipo! == 'normal') ...[
                    SizedBox(
                      width: width * 0.60,
                      child: TextField(
                        controller: senhaController,
                        decoration: const InputDecoration(hintText: 'Senha'),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: civilController,
                      decoration: const InputDecoration(hintText: 'Civil'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SizedBox(
                                height: 270,
                                child: ListView.builder(
                                  itemCount: dadosCivil.length,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  itemBuilder: (context, index) {
                                    var item = dadosCivil[index];

                                    return ListTile(
                                      onTap: () {
                                        setState(() {
                                          civilController.text = item['valor']!;
                                        });
                                        Navigator.pop(context);
                                      },
                                      title: Text(item['nome']!),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              // -----------------------------------------------------------------
              const SizedBox(height: 20),
              const Text(
                'HandiCap`s',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      controller: cabeceiraController,
                      decoration: const InputDecoration(hintText: 'Cabeceira'),
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
                                                cabeceiraController.text = item.valor;
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
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      controller: pezeiroController,
                      decoration: const InputDecoration(hintText: 'Pezeiro'),
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
                                                pezeiroController.text = item.valor;
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
                    ),
                  ),
                ],
              ),
              // -----------------------------------------------------------------
              const SizedBox(height: 20),
              const Text(
                'Endereço',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cepController,
                decoration: const InputDecoration(hintText: 'CEP'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: enderecoController,
                decoration: const InputDecoration(hintText: 'Endereço'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: bairroController,
                      decoration: const InputDecoration(hintText: 'Bairro'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: numeroController,
                      decoration: const InputDecoration(hintText: 'Número'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: complementoController,
                      decoration: const InputDecoration(hintText: 'Complemento'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: cidadeController,
                      decoration: const InputDecoration(hintText: 'Cidade'),
                    ),
                  ),
                ],
              ),
              // -----------------------------------------------------------------
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    var editarUsuarioServico = context.read<EditarUsuarioServico>();

                    editarUsuarioServico
                        .editarUsuario(
                      FormularioEditarUsuarioModelo(
                        id: UsuarioProvider.getUsuario()!.id!,
                        nome: nomeController.text,
                        apelido: apelidoController.text,
                        civil: civilController.text,
                        sexo: sexoController.text,
                        dataNascimento: dataNascimentoNormal,
                        cpf: cpfController.text,
                        rg: rgController.text,
                        email: emailController.text,
                        senha: senhaController.text,
                        telefone: telefoneController.text,
                        celular: celularController.text,
                        cep: cepController.text,
                        endereco: enderecoController.text,
                        numero: numeroController.text,
                        bairro: bairroController.text,
                        complemento: complementoController.text,
                        cidade: '1',
                        hcCabeceira: cabeceiraController.text,
                        hcPezeiro: pezeiroController.text,
                      ),
                    )
                        .then((sucesso) {
                      if (sucesso) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Sucesso ao editar dados.'),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                          backgroundColor: Colors.green,
                        ));
                      }
                    });
                  },
                  child: const Text('Salvar'),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
