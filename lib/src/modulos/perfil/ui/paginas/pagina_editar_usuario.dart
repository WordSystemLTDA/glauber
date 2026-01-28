import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/core/constantes/constantes_global.dart';
import 'package:provadelaco/src/core/formatters/rg_formatter.dart';
import 'package:provadelaco/src/core/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/core/widgets/handicaps_dialog.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_servico.dart';
import 'package:provadelaco/src/domain/models/modelo_modalidades_cadastro.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_selecionar_modalidades.dart';
import 'package:provadelaco/src/data/servicos/cidade_servico_impl.dart';
import 'package:provadelaco/src/data/servicos/editar_usuario_servico_impl.dart';
import 'package:provadelaco/src/domain/models/cidade_modelo.dart';
import 'package:provadelaco/src/domain/models/formulario_editar_usuario_modelo.dart';
import 'package:provider/provider.dart';

class PaginaEditarUsuario extends StatefulWidget {
  const PaginaEditarUsuario({super.key});

  @override
  State<PaginaEditarUsuario> createState() => _PaginaEditarUsuarioState();
}

class _PaginaEditarUsuarioState extends State<PaginaEditarUsuario> {
  bool salvando = false;
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController apelidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  // final TextEditingController sexoController = TextEditingController();
  // final TextEditingController dataNascimentoController = TextEditingController();
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
  final TextEditingController _hcLacoIndividualController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();

  TextEditingController chavePix = TextEditingController();

  TextEditingController cidadeController = TextEditingController();
  SearchController pesquisaCidadeController = SearchController();
  bool ocultarSenha = true;

  String idHcCabeceira = '0';
  String idHcPiseiro = '0';
  String idHcLacoIndividual = '0';
  // String dataNascimentoNormal = '';
  String idCidade = '';
  String tipoDeChave = 'Celular';
  String profissional = '';
  String genero = '';
  String lacoemdupla = '';
  String tambores3 = '';
  String lacoindividual = '';
  List<ModeloModalidadesCadastro> modalidadesSelecionados = [];

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

  @override
  void dispose() {
    nomeController.dispose();
    apelidoController.dispose();
    emailController.dispose();
    cpfController.dispose();
    rgController.dispose();
    _dataNascimentoController.dispose();
    telefoneController.dispose();
    celularController.dispose();
    senhaController.dispose();
    civilController.dispose();
    cabeceiraController.dispose();
    pezeiroController.dispose();
    cepController.dispose();
    enderecoController.dispose();
    bairroController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    cidadeController.dispose();
    pesquisaCidadeController.dispose();
    chavePix.dispose();
    super.dispose();
  }

  void editar(usuario) {
    // 3 Tambores
    if (tambores3 == 'Sim') {
      if (_dataNascimentoController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Center(child: Text('Data de Nascimento é Obrigatório!')),
        ));
        return;
      }

      if (_dataNascimentoController.text.isNotEmpty && _dataNascimentoController.text.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Center(child: Text('Data de Nascimento inválida!')),
        ));
        return;
      }

      if (profissional.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Center(child: Text('Você precisa selecionar se é profissional ou não!')),
        ));
        return;
      }
    }

    // Laço Individual
    if (lacoindividual == 'Sim') {
      if (_hcLacoIndividualController.text.isEmpty || idHcLacoIndividual == '0') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Center(child: Text('Você precisa selecionar um HandiCap em Laço Individual!')),
        ));
        return;
      }
    }

    // Laço em Dupla
    if (lacoemdupla == 'Sim') {
      if ((idHcCabeceira.isEmpty || idHcCabeceira == '0') || (idHcPiseiro.isEmpty || idHcPiseiro == '0')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Center(child: Text('Você precisa preencher todos os handicaps.')),
        ));
        return;
      }
    }

    setState(() {
      salvando = true;
    });

    var editarUsuarioServico = context.read<EditarUsuarioServicoImpl>();

    var datanascimentoF = _dataNascimentoController.text.split('/');
    var datanascimento = datanascimentoF.isEmpty ? '0000-00-00' : "${datanascimentoF[2]}-${datanascimentoF[1]}-${datanascimentoF[0]}";

    editarUsuarioServico
        .editarUsuario(
      FormularioEditarUsuarioModelo(
        id: usuario.usuario!.id!,
        nome: nomeController.text.trimLeft().trimRight(),
        tipoDePix: tipoDeChave,
        chavePix: chavePix.text,
        apelido: apelidoController.text.trimLeft().trimRight(),
        civil: civilController.text,
        sexo: genero,
        dataNascimento: datanascimento,
        cpf: cpfController.text,
        rg: rgController.text,
        email: emailController.text.trimLeft().trimRight(),
        senha: senhaController.text,
        telefone: telefoneController.text,
        celular: celularController.text,
        cep: cepController.text,
        endereco: enderecoController.text,
        numero: numeroController.text,
        bairro: bairroController.text,
        complemento: complementoController.text,
        cidade: idCidade,
        hcCabeceira: idHcCabeceira,
        hcPezeiro: idHcPiseiro,
        handicaplacoindividual: idHcLacoIndividual,
        tipodecategoriaprofissional: profissional,
        lacoemdupla: lacoemdupla,
        tambores3: tambores3,
        lacoindividual: lacoindividual,
      ),
    )
        .then((resposta) {
      var (sucesso, mensagem) = resposta;

      var usuarioNovo = UsuarioModelo(
        id: usuario.usuario!.id!,
        tipoDePix: tipoDeChave,
        celularSuporte: usuario.usuario.celularSuporte,
        nivel: usuario.usuario.nivel,
        clienteBloqueado: false,
        chavePix: chavePix.text,
        nome: nomeController.text.trimLeft().trimRight(),
        sexo: genero,
        dataNascimento: (usuario.usuario.dataNascimento == '0000-00-00' && _dataNascimentoController.text.isEmpty) ? '0000-00-00' : datanascimento,
        cpf: cpfController.text,
        rg: rgController.text,
        email: emailController.text.trimLeft().trimRight(),
        senha: senhaController.text,
        telefone: telefoneController.text,
        celular: celularController.text,
        cep: cepController.text,
        endereco: enderecoController.text,
        numero: numeroController.text,
        bairro: bairroController.text,
        complemento: complementoController.text,
        idCidade: idCidade,
        nomeCidade: cidadeController.text,
        hcCabeceira: cabeceiraController.text,
        hcPezeiro: pezeiroController.text,
        idHcCabeceira: idHcCabeceira,
        idHcPezeiro: idHcPiseiro,
        token: usuario.usuario!.token,
        tipo: usuario.usuario!.tipo,
        primeiroAcesso: usuario.usuario!.primeiroAcesso,
        foto: usuario.usuario!.foto,
        somaDeHandicaps: usuario.usuario!.somaDeHandicaps,
        civil: civilController.text,
        apelido: apelidoController.text.trimLeft().trimRight(),
        atualizacaoAndroid: usuario.usuario!.atualizacaoAndroid,
        atualizacaoIos: usuario.usuario!.atualizacaoIos,
        ativoProva: usuario.usuario!.ativoProva,
        cabeceiroProvas: usuario.usuario!.cabeceiroProvas,
        pezeiroProvas: usuario.usuario!.pezeiroProvas,
        idhandicaplacoindividual: idHcLacoIndividual,
        handicaplacoindividual: _hcLacoIndividualController.text,
        tipodecategoriaprofissional: profissional,
        lacoemdupla: lacoemdupla,
        tambores3: tambores3,
        lacoindividual: lacoindividual,
      );

      if (sucesso) {
        if (mounted) {
          var usuarioProvider = context.read<UsuarioProvider>();

          usuarioProvider.setUsuario(usuarioNovo);
          UsuarioServico.salvarUsuario(context, usuarioNovo);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Sucesso ao editar dados.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(mensagem),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ));
        }
      }
      setState(() {
        salvando = false;
      });
    });
  }

  void setarInformacoes() {
    var usuario = context.read<UsuarioProvider>().usuario!;

    setState(() {
      nomeController.text = usuario.nome!;
      apelidoController.text = usuario.apelido!;
      emailController.text = usuario.email!;
      cpfController.text = usuario.cpf!;
      rgController.text = usuario.rg!;
      chavePix.text = usuario.chavePix!;
      tipoDeChave = usuario.tipoDePix!.isEmpty ? 'Celular' : usuario.tipoDePix!;

      if (usuario.dataNascimento! != '0000-00-00') {
        // dataNascimentoNormal = DateFormat('yyyy-MM-dd').format(DateTime.parse(usuario.dataNascimento!)).toString();
        _dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(usuario.dataNascimento!)).toString();
      }

      telefoneController.text = usuario.telefone!;
      celularController.text = usuario.celular!;
      senhaController.text = usuario.senha!;
      civilController.text = usuario.civil!;

      cabeceiraController.text = usuario.hcCabeceira!;
      pezeiroController.text = usuario.hcPezeiro!;
      idHcCabeceira = usuario.idHcCabeceira!;
      idHcPiseiro = usuario.idHcPezeiro!;

      cepController.text = usuario.cep!;
      enderecoController.text = usuario.endereco!;
      bairroController.text = usuario.bairro!;
      numeroController.text = usuario.numero!;
      complementoController.text = usuario.complemento!;
      cidadeController.text = usuario.nomeCidade!;
      idCidade = usuario.idCidade!;
      _hcLacoIndividualController.text = usuario.handicaplacoindividual!;

      var nascimentoF = usuario.dataNascimento?.split('-');
      var nascimento = nascimentoF == null ? '' : "${nascimentoF[2]}/${nascimentoF[1]}/${nascimentoF[0]}";

      _dataNascimentoController.text = nascimento;
      profissional = usuario.tipodecategoriaprofissional!;
      genero = usuario.sexo!;
      idHcLacoIndividual = usuario.idhandicaplacoindividual ?? '0';

      lacoemdupla = usuario.lacoemdupla ?? 'Não';
      tambores3 = usuario.tambores3 ?? 'Não';
      lacoindividual = usuario.lacoindividual ?? 'Não';

      modalidadesSelecionados = [
        if (tambores3 == 'Sim') ModeloModalidadesCadastro(id: '1', nome: '3 Tambores'),
        if (lacoindividual == 'Sim') ModeloModalidadesCadastro(id: '2', nome: 'Laço Individual'),
        if (lacoemdupla == 'Sim') ModeloModalidadesCadastro(id: '3', nome: 'Laço em Dupla'),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    var cidadeServico = context.read<CidadeServicoImpl>();

    return Consumer<UsuarioProvider>(builder: (context, usuario, chil) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            height: 50,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              // backgroundColor: Colors.green,
              onPressed: () {
                editar(usuario);
              },
              label: SizedBox(
                width: width - 100,
                child: salvando
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        ),
                      )
                    : const Text(
                        'Salvar',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ),
          appBar: const AppBarSombra(
            titulo: Text("Editar Dados"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -----------------------------------------------------------------
                Wrap(
                  children: [
                    const Text("Suas Modalidades: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text("${modalidadesSelecionados.map((e) => e.nome.toString())}", style: const TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRotas.selecionarModalidades,
                              arguments: PaginaSelecionarModalidadesArgumentos(edicao: true, modalidadesSelecionadas: modalidadesSelecionados))
                          .then((e) {
                        if (e == null) return;

                        var modalidades = List<ModeloModalidadesCadastro>.from(
                          (e as Map)['modalidades'].map((elemento) {
                            return ModeloModalidadesCadastro.fromMap(elemento);
                          }),
                        );

                        if (modalidades.isNotEmpty) {
                          setState(() {
                            modalidadesSelecionados = modalidades;
                            tambores3 = modalidades.where((element) => element.id == '1').isNotEmpty ? 'Sim' : 'Não';
                            lacoindividual = modalidades.where((element) => element.id == '2').isNotEmpty ? 'Sim' : 'Não';
                            lacoemdupla = modalidades.where((element) => element.id == '3').isNotEmpty ? 'Sim' : 'Não';
                          });
                        }
                      });
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text('Selecionar Modalidades'),
                  ),
                ),
                if (lacoemdupla == 'Sim') ...[
                  const Divider(height: 30),
                  const Text(
                    'Laço em Dupla',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: cabeceiraController,
                          decoration: const InputDecoration(
                            hintText: 'Cabeça',
                            label: Text('Cabeça'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: pezeiroController,
                          decoration: const InputDecoration(
                            hintText: 'Pé',
                            label: Text('Pé'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (lacoindividual == 'Sim') ...[
                  const Divider(height: 30),
                  Text('Laço Individual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  TextField(
                    readOnly: true,
                    controller: _hcLacoIndividualController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Seu HandiCap',
                      label: Text('HandiCap*'),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return HandiCapsDialog(
                            mostrarSomente: [1.00, 2.00, 3.00, 4.00],
                            aoMudar: (itemHC, handicaps) {
                              setState(() {
                                if (int.parse(idHcLacoIndividual) == 3 && double.parse(itemHC.id) < 3) {
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
                if (tambores3 == 'Sim') ...[
                  const Divider(height: 30),
                  Text('3 Tambores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _dataNascimentoController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DataInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Data de Nascimento',
                      label: Text('Data de Nascimento*'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownMenu(
                              expandedInsets: EdgeInsets.zero,
                              initialSelection: profissional,
                              hintText: 'Você é Profissinal',
                              label: Text('Profissional*'),
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
                            DropdownMenu(
                              expandedInsets: EdgeInsets.zero,
                              initialSelection: genero,
                              hintText: 'Seu gênero',
                              label: Text('Sexo*'),
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
                // -----------------------------------------------------------------
                const Divider(height: 30),
                const Text('Dados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 15),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    hintText: 'Nome',
                    label: Text('Nome'),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: apelidoController,
                  decoration: const InputDecoration(
                    hintText: 'Apelido',
                    label: Text('Apelido'),
                  ),
                ),
                if (usuario.usuario!.tipo! == 'email') ...[
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'E-mail',
                      label: Text('E-mail'),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cpfController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter(),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'CPF',
                          label: Text('CPF'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: rgController,
                        keyboardType: TextInputType.number,
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
                        controller: telefoneController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Telefone',
                          label: Text('Telefone'),
                        ),
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
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Celular',
                          label: Text('Celular'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (usuario.usuario!.tipo! == 'email') ...[
                      Expanded(
                        child: TextField(
                          controller: senhaController,
                          obscureText: ocultarSenha,
                          decoration: InputDecoration(
                            hintText: 'Senha',
                            label: const Text('Senha'),
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
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: civilController,
                        decoration: const InputDecoration(
                          hintText: 'Civil',
                          label: Text('Civil'),
                        ),
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
                  'Endereço',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cepController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'CEP',
                    label: Text('CEP'),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: enderecoController,
                  decoration: const InputDecoration(
                    hintText: 'Endereço',
                    label: Text('Endereço'),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: bairroController,
                        decoration: const InputDecoration(
                          hintText: 'Bairro',
                          label: Text('Bairro'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: numeroController,
                        decoration: const InputDecoration(
                          hintText: 'Número',
                          label: Text('Número'),
                        ),
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
                        decoration: const InputDecoration(
                          hintText: 'Complemento',
                          label: Text('Complemento'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SearchAnchor(
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
                              label: Text('Cidade'),
                            ),
                          );
                        },
                        suggestionsBuilder: (BuildContext context, SearchController controller) async {
                          final keyword = controller.value.text;

                          List<CidadeModelo>? cidades = await cidadeServico.listar(keyword);

                          Iterable<Widget> widgets = cidades.map((cidade) {
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
                    ),
                  ],
                ),
                // -----------------------------------------------------------------
                const SizedBox(height: 20),
                const Text(
                  'Outras Informações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    DropdownMenu(
                      initialSelection: tipoDeChave,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                          value: 'Celular',
                          label: 'Celular',
                        ),
                        DropdownMenuEntry(
                          value: 'CPF',
                          label: 'CPF',
                        ),
                        DropdownMenuEntry(
                          value: 'Email',
                          label: 'E-mail',
                        ),
                        DropdownMenuEntry(
                          value: 'Chave Aleatória',
                          label: 'Chave Aleatória',
                        ),
                      ],
                      onSelected: (String? value) {
                        setState(() {
                          tipoDeChave = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: chavePix,
                        decoration: const InputDecoration(
                          hintText: 'Chave Pix',
                          label: Text('Chave Pix'),
                        ),
                      ),
                    ),
                  ],
                ),
                // -----------------------------------------------------------------
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      );
    });
  }
}
