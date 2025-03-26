import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/core/constantes/uteis.dart';
import 'package:provadelaco/src/core/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/modulos/animais/paginas/pagina_inserir_animais.dart';
import 'package:provadelaco/src/modulos/animais/provedores/provedor_animal.dart';
import 'package:provider/provider.dart';

class PaginaAnimaisArgumentos {
  final bool? selecionarAnimais;

  PaginaAnimaisArgumentos({this.selecionarAnimais = false});
}

class PaginaAnimais extends StatefulWidget {
  final PaginaAnimaisArgumentos argumentos;
  const PaginaAnimais({super.key, required this.argumentos});

  @override
  State<PaginaAnimais> createState() => _PaginaAnimaisState();
}

class _PaginaAnimaisState extends State<PaginaAnimais> {
  TextEditingController nomeBuscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        listar();
      }
    });
  }

  void listar({String pesquisa = ''}) async {
    ProvedorAnimal provedor = context.read<ProvedorAnimal>();
    await provedor.listar(pesquisa);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvedorAnimal>(builder: (context, provedor, child) {
      return Scaffold(
        appBar: const AppBarSombra(titulo: Text("Seus Animais")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRotas.animaisCadastrar).then((value) {
              listar(pesquisa: nomeBuscaController.text);
            });
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: () async {},
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nomeBuscaController,
                  decoration: const InputDecoration(
                    hintText: 'Pesquise aqui',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onChanged: (nomePesquisa) {
                    listar(pesquisa: nomePesquisa);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provedor.animais.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  prototypeItem: const SizedBox(height: 105),
                  itemBuilder: (context, index) {
                    var item = provedor.animais[index];

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: InkWell(
                        onTap: () {
                          if (widget.argumentos.selecionarAnimais == true) {
                            Navigator.pop(context, item);
                          }
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                item.foto,
                                height: 105,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    width: 105,
                                    height: 105,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return const Icon(Icons.error_outline, color: Colors.grey, size: 105);
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(item.nomedoanimal, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    Text(item.racadoanimal),
                                    Text(item.sexo),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${(DateTime.now().year - DateTime.parse(Utils.trocarFormatacaoData(item.datanascianimal, pattern: '/', to: '-')).year).toString()} anos",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(item.padrao == 'Sim' ? 'Padrão' : ''),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (widget.argumentos.selecionarAnimais == false) ...[
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Implement edit functionality
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return PaginaInserirAnimais(modeloAnimais: item);
                                        },
                                      )).then((value) {
                                        listar(pesquisa: nomeBuscaController.text);
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      // Implement delete functionality
                                      provedor.excluir(item.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
