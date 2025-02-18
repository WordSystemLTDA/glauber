import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/modelos/modelo_modalidades_cadastro.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_cadastro.dart';

class PaginaSelecionarModalidades extends StatefulWidget {
  const PaginaSelecionarModalidades({super.key});

  @override
  State<PaginaSelecionarModalidades> createState() => _PaginaSelecionarModalidadesState();
}

class _PaginaSelecionarModalidadesState extends State<PaginaSelecionarModalidades> {
  List<ModeloModalidadesCadastro> listaModalidades = [
    ModeloModalidadesCadastro(id: '1', nome: '3 Tambores'),
    ModeloModalidadesCadastro(id: '2', nome: 'Laço Individual'),
    ModeloModalidadesCadastro(id: '3', nome: 'Laço em Dupla'),
  ];

  List<ModeloModalidadesCadastro> modalidadesSelecionadas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Selecione as Modalidades que deseja competir',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listaModalidades.length,
              itemBuilder: (context, index) {
                final item = listaModalidades[index];

                return SizedBox(
                  height: 80,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (modalidadesSelecionadas.contains(item)) {
                            modalidadesSelecionadas.remove(item);
                            return;
                          }

                          modalidadesSelecionadas.add(item);
                        });
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(item.nome, style: const TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Checkbox(
                              value: modalidadesSelecionadas.contains(item),
                              onChanged: (value) {
                                setState(() {
                                  if (modalidadesSelecionadas.contains(item)) {
                                    modalidadesSelecionadas.remove(item);
                                    return;
                                  }

                                  modalidadesSelecionadas.add(item);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(modalidadesSelecionadas.isEmpty ? Colors.grey : Colors.green),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  if (modalidadesSelecionadas.isEmpty) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Você precisa selecionar uma modalidade.', textAlign: TextAlign.center),
                      backgroundColor: Colors.red,
                      showCloseIcon: true,
                    ));
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    AppRotas.cadastro,
                    arguments: PaginaCadastroArgumentos(modalidades: modalidadesSelecionadas),
                  );
                },
                child: const Text('Ir para Cadastro', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
