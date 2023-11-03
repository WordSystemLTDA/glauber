import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/compras/interator/estados/compras_estado.dart';
import 'package:glauber/src/modulos/compras/interator/stores/compras_store.dart';
import 'package:glauber/src/modulos/compras/ui/widgets/card_compras.dart';
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

      comprasStore.listar();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var comprasStore = context.read<ComprasStore>();

    return ValueListenableBuilder(
      valueListenable: comprasStore,
      builder: (context, state, _) {
        if (state is ComprasCarregando) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ComprasCarregado) {
          return RefreshIndicator(
            onRefresh: () async {
              comprasStore.listar();
            },
            child: ListView.builder(
              itemCount: state.compras.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                var item = state.compras[index];

                return CardCompras(item: item);
              },
            ),
          );
        }

        return const Center(
          child: Text('Você ainda não tem nenhuma Compra.'),
        );
      },
    );
  }
}
