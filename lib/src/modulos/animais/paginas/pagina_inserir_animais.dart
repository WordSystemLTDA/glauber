import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/modulos/animais/servicos/servico_animais.dart';
import 'package:provider/provider.dart';

class PaginaInserirAnimais extends StatefulWidget {
  const PaginaInserirAnimais({super.key});

  @override
  State<PaginaInserirAnimais> createState() => _PaginaInserirAnimaisState();
}

class _PaginaInserirAnimaisState extends State<PaginaInserirAnimais> {
  bool souPropietario = true;

  TextEditingController sexoController = TextEditingController();
  TextEditingController racaDoAnimalController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString());

  String sexo = 'Macho';

  var escolhendoArquivo = ValueNotifier(false);
  var salvando = ValueNotifier(false);
  var fotoSelecionada = ValueNotifier(File(''));
  var fotoSelecionadaEdicaoUrl = '';

  void aoClicarParaSelecionarFoto() async {
    if (mounted) {
      escolhendoArquivo.value = true;

      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        File file = File(result.files.single.path!);

        fotoSelecionada.value = file;
        escolhendoArquivo.value = false;
      } else {
        escolhendoArquivo.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;

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
                  if (salvando.value) return;

                  salvando.value = true;

                  if (nomeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Nome do animal é obrigatório.'),
                    ));
                    return;
                  }

                  if (dataNascimentoController.text.isEmpty) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Data de Nascimento é obrigatório.'),
                    ));
                    return;
                  }

                  if (sexo.isEmpty) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Sexo é obrigatório.'),
                    ));
                    return;
                  }

                  if (racaDoAnimalController.text.isEmpty) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Raça do Animal é obrigatório.'),
                    ));
                    return;
                  }

                  context
                      .read<ServicoAnimais>()
                      .inserir(
                        nome: nomeController.text,
                        dataNascimento: Utils.trocarFormatacaoData(dataNascimentoController.text),
                        sexo: sexo,
                        raca: racaDoAnimalController.text,
                        foto: '',
                        idProprietario: souPropietario ? '0' : '1',
                      )
                      .then((value) {
                    if (value.sucesso) {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(value.mensagem),
                        ));
                      }
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
