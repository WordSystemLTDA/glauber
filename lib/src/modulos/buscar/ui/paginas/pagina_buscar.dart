import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/widgets/app_bar_sombra.dart';
import 'package:provadelaco/src/modulos/buscar/interator/estados/buscar_estado.dart';
import 'package:provadelaco/src/modulos/buscar/interator/stores/buscar_store.dart';
import 'package:provadelaco/src/modulos/buscar/ui/widgets/card_buscas.dart';
import 'package:provider/provider.dart';

class PaginaBuscar extends StatefulWidget {
  const PaginaBuscar({super.key});

  @override
  State<PaginaBuscar> createState() => _PaginaBuscarState();
}

class _PaginaBuscarState extends State<PaginaBuscar> with AutomaticKeepAliveClientMixin {
  TextEditingController nomeBuscaController = TextEditingController();

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
            child: ValueListenableBuilder<BuscarEstado>(
              valueListenable: buscarStore,
              builder: (context, state, _) {
                if (state is Carregando) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is Carregado) {
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
                      itemCount: state.eventos.length,
                      itemBuilder: (context, index) {
                        var item = state.eventos[index];

                        return CardBuscas(
                          evento: item,
                        );
                      },
                    ),
                  );
                }

                return const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('Sem resultados...'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
