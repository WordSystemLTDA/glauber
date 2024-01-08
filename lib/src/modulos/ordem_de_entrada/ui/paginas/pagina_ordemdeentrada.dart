import 'package:flutter/material.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/estados/orderdeentrada_estado.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/stores/ordemdeentrada_store.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/ui/widgets/card_ordemdeentrada.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      body: ValueListenableBuilder<OrdemDeEntradaEstado>(
        valueListenable: ordemDeEntradaStore,
        builder: (context, state, _) {
          var ordemdeentradas = state is OrdemDeEntradaCarregando
              ? DadosFakes.dadosFakesOrdemEntrada
              : state is OrdemDeEntradaCarregado
                  ? state.ordemdeentradas
                  : [];

          if (state is OrdemDeEntradaErroAoListar) {
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

          return Skeletonizer(
            enabled: state is OrdemDeEntradaCarregando,
            child: RefreshIndicator(
              onRefresh: () async {
                ordemDeEntradaStore.listar(usuarioProvider.usuario);
              },
              child: ListView.builder(
                itemCount: ordemdeentradas.length,
                padding: const EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  var item = ordemdeentradas[index];

                  return CardOrdemDeEntrada(item: item);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
