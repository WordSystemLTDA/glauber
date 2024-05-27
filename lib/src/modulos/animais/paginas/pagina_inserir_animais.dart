import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/modulos/animais/servicos/servico_animais.dart';
import 'package:provadelaco/src/modulos/perfil/interator/modelos/cidade_modelo.dart';
import 'package:provadelaco/src/modulos/perfil/interator/servicos/cidade_servico.dart';
import 'package:provider/provider.dart';

class PaginaInserirAnimais extends StatefulWidget {
  const PaginaInserirAnimais({super.key});

  @override
  State<PaginaInserirAnimais> createState() => _PaginaInserirAnimaisState();
}

class _PaginaInserirAnimaisState extends State<PaginaInserirAnimais> {
  bool souPropietario = true;

  SearchController pesquisaCidadeController = SearchController();

  TextEditingController cidadeController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController racaDoAnimalController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString());

  String idCidade = '';
  String sexo = 'Macho';

  var escolhendoArquivo = ValueNotifier(false);
  var salvando = ValueNotifier(false);
  var fotoSelecionada = ValueNotifier(File(''));
  var fotoSelecionadaEdicaoUrl = '';

  void aoClicarParaSelecionarFoto() async {
    // if (mounted) {
    //   escolhendoArquivo.value = true;

    //   FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    //   if (result != null) {
    //     File file = File(result.files.single.path!);

    //     fotoSelecionada.value = file;
    //     escolhendoArquivo.value = false;
    //   } else {
    //     escolhendoArquivo.value = false;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;

    var cidadeServico = context.read<CidadeServico>();

    return Scaffold(
      appBar: const AppBarSombra(titulo: Text('Inserir')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  souPropietario = souPropietario ? false : true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: souPropietario,
                      onChanged: (novoValor) {
                        setState(() {
                          souPropietario = novoValor!;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 200,
                      child: Text('Sou o propietário.'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width - 50,
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: () {
                  salvando.value = true;

                  context
                      .read<ServicoAnimais>()
                      .inserir(
                        nomeController.text,
                        Utils.trocarFormatacaoData(dataNascimentoController.text),
                        sexo,
                        racaDoAnimalController.text,
                        idCidade,
                        '',
                        souPropietario ? '0' : '1',
                      )
                      .then((value) {
                    if (value.$1) {
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.$2)));
                    }

                    salvando.value = false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                label: ValueListenableBuilder(
                  valueListenable: salvando,
                  builder: (context, value, _) {
                    if (value) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      );
                    }

                    return const Text('Salvar');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nome do Animal'),
              const SizedBox(height: 5),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  hintText: 'Nome do Animal',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Data de Nascimento'),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: (width / 2) - 15,
                        child: TextField(
                          decoration: const InputDecoration(hintText: 'Data de Nascimento'),
                          readOnly: true,
                          controller: dataNascimentoController,
                          onTap: () async {
                            final DateTime? time = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.parse(Utils.trocarFormatacaoData(dataNascimentoController.text)),
                            );

                            if (time != null) {
                              setState(() {
                                dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(time).toString();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sexo'),
                      const SizedBox(height: 5),
                      DropdownMenu(
                        width: (width / 2) - 15,
                        hintText: 'Selecione o Sexo do Animal',
                        initialSelection: sexo,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'Macho', label: 'Macho'),
                          DropdownMenuEntry(value: 'Fêmea', label: 'Fêmea'),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            sexo = value;
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Raça do Animal'),
              const SizedBox(height: 5),
              TextField(
                controller: racaDoAnimalController,
                decoration: const InputDecoration(hintText: 'Raça do Animal'),
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
                    controller: cidadeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Selecione uma cidade',
                    ),
                    onTap: () {
                      pesquisaCidadeController.openView();
                    },
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
              const Text('Foto'),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  // color: const Color.fromARGB(255, 234, 234, 234),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ValueListenableBuilder(
                    valueListenable: escolhendoArquivo,
                    builder: (context, escolhendoArquivoValue, _) {
                      return ValueListenableBuilder(
                        valueListenable: fotoSelecionada,
                        builder: (context, fotoSelecionadaValue, _) {
                          return GestureDetector(
                            onDoubleTap: () {},
                            onTap: escolhendoArquivoValue ? null : () => aoClicarParaSelecionarFoto(),
                            child: Card(
                              margin: const EdgeInsets.all(2),
                              child: Visibility(
                                visible: !escolhendoArquivoValue,
                                replacement: const Center(child: CircularProgressIndicator()),
                                child: Visibility(
                                  visible: fotoSelecionadaValue.path.isEmpty ? fotoSelecionadaEdicaoUrl.isNotEmpty : fotoSelecionadaValue.path.isNotEmpty,
                                  replacement: const Center(child: Text('Clique aqui para escolher uma imagem')),
                                  child: fotoSelecionadaValue.path.isEmpty
                                      ? Image.network(
                                          fotoSelecionadaEdicaoUrl,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.file(
                                          fotoSelecionadaValue,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
