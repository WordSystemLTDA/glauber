import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/compras/interator/estados/compras_estado.dart';
import 'package:provadelaco/src/modulos/compras/interator/stores/compras_store.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/card_compras.dart';
import 'package:provider/provider.dart';

class PaginaCompras extends StatefulWidget {
  const PaginaCompras({super.key});

  @override
  State<PaginaCompras> createState() => _PaginaComprasState();
}

class _PaginaComprasState extends State<PaginaCompras> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var comprasStore = context.read<ComprasStore>();
      var usuarioProvider = context.read<UsuarioProvider>();

      if (usuarioProvider.usuario != null) {
        comprasStore.listar(usuarioProvider.usuario);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var comprasStore = context.read<ComprasStore>();
    var usuarioProvider = context.read<UsuarioProvider>();
    var height = MediaQuery.of(context).size.height;

    if (usuarioProvider.usuario == null) {
      return const Center(child: Text('Você precisa estar logado.'));
    }

    return ValueListenableBuilder<ComprasEstado>(
      valueListenable: comprasStore,
      builder: (context, state, _) {
        if (state is ComprasErroAoListar) {
          return RefreshIndicator(
            onRefresh: () async {
              comprasStore.listar(usuarioProvider.usuario);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: height - 200,
                child: const Center(
                  child: Text('Nenhuma compra foi encontrada.'),
                ),
              ),
            ),
          );
        }

        if (state is ComprasCarregado) {
          print(state.compras);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Pago',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Não Pago',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Lib. Reembolso',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.yellow,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Canc. / Reemb.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    comprasStore.listar(usuarioProvider.usuario);
                  },
                  child: ListView.builder(
                    itemCount: state.compras.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var item = state.compras[index];

                      return CardCompras(item: item);
                    },
                  ),
                ),
              ),
            ],
          );
        }

        return const Text('');
      },
    );
  }
}
