import 'package:flutter/material.dart';
import 'package:provadelaco/data/repositories/buscar_repository.dart';
import 'package:provadelaco/ui/core/ui/app_bar_sombra.dart';
import 'package:provadelaco/ui/features/buscar/widgets/card_buscas.dart';
import 'package:provider/provider.dart';

class PaginaBuscar extends StatefulWidget {
  const PaginaBuscar({super.key});

  @override
  State<PaginaBuscar> createState() => _PaginaBuscarState();
}

class _PaginaBuscarState extends State<PaginaBuscar> with AutomaticKeepAliveClientMixin {
  TextEditingController nomeBuscaController = TextEditingController();

  @override
  void dispose() {
    nomeBuscaController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BuscarStore buscarStore = context.read<BuscarStore>();

    return Scaffold(
      appBar: const AppBarSombra(
        titulo: Text("Buscar Eventos"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nomeBuscaController,
              decoration: const InputDecoration(
                hintText: 'Pesquisar eventos...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onChanged: (nomePesquisa) {
                buscarStore.listarEventoPorNome(nomePesquisa);
              },
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: buscarStore,
              builder: (context, _) {
                if (buscarStore.carregando) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (buscarStore.carregando == false && buscarStore.eventos.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('Sem resultados...'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    buscarStore.listarEventoPorNome(nomeBuscaController.text);
                  },
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: buscarStore.eventos.length,
                    itemBuilder: (context, index) {
                      var item = buscarStore.eventos[index];

                      return CardBuscas(
                        evento: item,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
