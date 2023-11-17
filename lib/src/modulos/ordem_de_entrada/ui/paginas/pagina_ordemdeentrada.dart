import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/estados/orderdeentrada_estado.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/stores/ordemdeentrada_store.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/ui/widgets/card_ordemdeentrada.dart';
import 'package:provider/provider.dart';

class PaginaOrdemDeEntrada extends StatefulWidget {
  const PaginaOrdemDeEntrada({super.key});

  @override
  State<PaginaOrdemDeEntrada> createState() => _PaginaOrdemDeEntradaState();
}

class _PaginaOrdemDeEntradaState extends State<PaginaOrdemDeEntrada> {
  @override
  Widget build(BuildContext context) {
    var ordemDeEntradaStore = context.read<OrdemDeEntradaStore>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 10.0,
            )
          ]),
          child: AppBar(
            elevation: 0.0,
            title: const Text("Ordem de Entrada"),
          ),
        ),
      ),
      body: ValueListenableBuilder<OrdemDeEntradaEstado>(
        valueListenable: ordemDeEntradaStore,
        builder: (context, state, _) {
          if (state is OrdemDeEntradaCarregando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OrdemDeEntradaCarregado) {
            return ListView.builder(
              itemCount: state.ordemdeentradas.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                var item = state.ordemdeentradas[index];

                return CardOrdemDeEntrada(item: item);
              },
            );
          }

          return const Center(
            child: Text('Não tem nada aqui por enquanto.'),
          );
        },
      ),
    );
  }
}
