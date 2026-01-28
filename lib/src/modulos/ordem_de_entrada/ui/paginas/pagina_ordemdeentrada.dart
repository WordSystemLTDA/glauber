import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/data/repositories/ordemdeentrada_store.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/ui/widgets/ordem_de_entrada_card.dart';
import 'package:provider/provider.dart';

class PaginaOrdemDeEntrada extends StatefulWidget {
  const PaginaOrdemDeEntrada({super.key});

  @override
  State<PaginaOrdemDeEntrada> createState() => _PaginaOrdemDeEntradaState();
}

class _PaginaOrdemDeEntradaState extends State<PaginaOrdemDeEntrada> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        var ordemDeEntradaStore = context.read<OrdemDeEntradaStore>();
        var usuarioProvider = context.read<UsuarioProvider>();

        if (usuarioProvider.usuario != null) {
          ordemDeEntradaStore.listar(usuarioProvider.usuario);
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var ordemDeEntradaStore = context.read<OrdemDeEntradaStore>();
    var usuarioProvider = context.read<UsuarioProvider>();
    var height = MediaQuery.of(context).size.height;

    if (usuarioProvider.usuario == null) {
      return const Center(child: Text('Você precisa estar logado.'));
    }

    return Scaffold(
      body: ListenableBuilder(
        listenable: ordemDeEntradaStore,
        builder: (context, _) {
          var ordemdeentradas = ordemDeEntradaStore.ordemdeentradas;

          if (ordemDeEntradaStore.ordemdeentradas.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ordemDeEntradaStore.listar(usuarioProvider.usuario);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: height - 200,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text('Nenhuma ordem de entrada foi encontrada.'),
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ordemDeEntradaStore.listar(usuarioProvider.usuario);
            },
            child: ListView.builder(
              itemCount: ordemdeentradas.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                var item = ordemdeentradas[index];
          
                return CardOrdemDeEntrada(
                  item: item,
                  mostrarOpcoes: false,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
