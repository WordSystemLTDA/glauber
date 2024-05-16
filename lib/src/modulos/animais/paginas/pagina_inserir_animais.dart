import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
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
  TextEditingController cidadeController = TextEditingController(text: 'Sem cidade');
  SearchController pesquisaCidadeController = SearchController();
  final TextEditingController sexoController = TextEditingController();
  String idCidade = '';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;

    var cidadeServico = context.read<CidadeServico>();

    return Scaffold(
      appBar: const AppBarSombra(
        titulo: Text('Inserir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nome do Animal'),
              const SizedBox(height: 5),
              const TextField(
                decoration: InputDecoration(
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
                        width: width / 2,
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Data de Nascimento',
                          ),
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
                        width: width / 2,
                        hintText: 'Selecione o Sexo do Animal',
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'Macho', label: 'Macho'),
                          DropdownMenuEntry(value: 'Fêmea', label: 'Fêmea'),
                        ],
                        onSelected: (value) {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Raça do Animal'),
              const SizedBox(height: 5),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Raca do Animal',
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
              InkWell(
                onTap: () {
                  setState(() {
                    souPropietario = souPropietario ? false : true;
                  });
                },
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
                    const SizedBox(width: 200, child: Text('Sou o propietário.')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
