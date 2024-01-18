import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/compras/interator/provedor/compras_provedor.dart';
import 'package:provadelaco/src/modulos/compras/ui/widgets/card_compras.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaginaCompras extends StatefulWidget {
  const PaginaCompras({super.key});

  @override
  State<PaginaCompras> createState() => _PaginaComprasState();
}

class _PaginaComprasState extends State<PaginaCompras> with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        listarCompras();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listarCompras();
    });
  }

  void listarCompras({bool? resetar}) {
    var comprasStore = context.read<ComprasProvedor>();
    var usuarioProvider = context.read<UsuarioProvider>();

    if (usuarioProvider.usuario != null) {
      comprasStore.listar(usuarioProvider.usuario, resetar ?? false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var comprasStore = context.read<ComprasProvedor>();
    var usuarioProvider = context.read<UsuarioProvider>();
    var height = MediaQuery.of(context).size.height;

    if (usuarioProvider.usuario == null) {
      return Center(
        child: TextButton(
          child: const Text('Você precisa estar logado.'),
          onPressed: () {
            Navigator.pushNamed(context, AppRotas.login);
          },
        ),
      );
    }

    return ListenableBuilder(
      listenable: comprasStore,
      builder: (BuildContext context, Widget? child) {
        if (comprasStore.compras.isEmpty && !comprasStore.carregando) {
          return RefreshIndicator(
            onRefresh: () async {
              listarCompras(resetar: true);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: height - 200,
                child: const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text('Nenhuma compra foi encontrada.'),
                  ),
                ),
              ),
            ),
          );
        }

        return Skeletonizer(
          enabled: comprasStore.pagina == 1,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Skeleton.shade(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
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
                        Skeleton.shade(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
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
                        Skeleton.shade(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
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
                        Skeleton.shade(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.yellow,
                            ),
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
                    listarCompras(resetar: true);
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: comprasStore.compras.length + 1,
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      if (index < comprasStore.compras.length) {
                        var item = comprasStore.compras[index];

                        return CardCompras(
                          item: item,
                          atualizarLista: () {
                            listarCompras(resetar: true);
                          },
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: comprasStore.temMaisParaCarregar
                              ? const Center(child: CircularProgressIndicator())
                              : const Center(
                                  child: Text('Você chegou no fim da lista.'),
                                ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
