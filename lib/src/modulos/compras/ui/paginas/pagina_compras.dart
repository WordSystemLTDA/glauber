import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/constantes_global.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/compras/interator/estados/transferencia_estado.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/clientes_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/provedor/compras_provedor.dart';
import 'package:provadelaco/src/modulos/compras/interator/provedor/transferencia_provedor.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';
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
  bool modoTransferencia = false;
  bool transferindo = false;
  List<ComprasModelo> comprasTransferencia = [];
  SearchController pesquisaClientesController = SearchController();
  TextEditingController textoClientesController = TextEditingController();
  String idClienteSelecionado = '0';

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
      var transferenciaProvedor = context.read<TransferenciaProvedor>();
      transferenciaProvedor.addListener(() {
        TransferenciaEstado state = transferenciaProvedor.value;

        if (state is TransferidoComSucesso) {
          if (mounted) {
            Navigator.pop(context);

            setState(() {
              comprasTransferencia.clear();
              idClienteSelecionado = '0';
              textoClientesController.text = '';
            });

            listarCompras(resetar: true);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              showCloseIcon: true,
              backgroundColor: Colors.green,
              content: Center(child: Text(state.mensagem)),
            ));
          }
        } else if (state is ErroAoTransferir) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.red,
            content: Center(child: Text(state.erro.toString())),
          ));
        }
      });
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
    var transferenciaProvedor = context.read<TransferenciaProvedor>();
    var usuarioProvider = context.read<UsuarioProvider>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: ListenableBuilder(
        listenable: comprasStore,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            floatingActionButton: usuarioProvider.usuario != null && usuarioProvider.usuario!.nivel == 'Master'
                ? SizedBox(
                    width: width - 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton.extended(
                          heroTag: null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: modoTransferencia ? Colors.green : Colors.grey,
                          label: const Text('Transferência'),
                          onPressed: () {
                            setState(() {
                              if (modoTransferencia == true) {
                                modoTransferencia = false;
                                comprasTransferencia.clear();
                              } else {
                                modoTransferencia = true;
                              }
                            });
                          },
                        ),
                        if (comprasTransferencia.isNotEmpty) ...[
                          FloatingActionButton.extended(
                            heroTag: null,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            backgroundColor: modoTransferencia ? Colors.green : Colors.grey,
                            label: Text('Transferir ${comprasTransferencia.length} ${comprasTransferencia.length == 1 ? 'item' : 'itens'}'),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (contextModal) {
                                  return ValueListenableBuilder<TransferenciaEstado>(
                                    valueListenable: transferenciaProvedor,
                                    builder: (context, state, _) {
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(contextModal).unfocus();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 30,
                                            bottom: MediaQuery.of(contextModal).viewInsets.bottom,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SearchAnchor(
                                                viewBuilder: (suggestions) {
                                                  return ListView.builder(
                                                    itemCount: suggestions.length,
                                                    padding: EdgeInsets.only(bottom: ConstantesGlobal.alturaTeclado),
                                                    itemBuilder: (context, index) {
                                                      var item = suggestions.elementAt(index);

                                                      return item;
                                                    },
                                                  );
                                                },
                                                isFullScreen: true,
                                                searchController: pesquisaClientesController,
                                                builder: (BuildContext context, SearchController controller) {
                                                  return TextField(
                                                    onTap: () {
                                                      pesquisaClientesController.openView();
                                                    },
                                                    controller: textoClientesController,
                                                    readOnly: true,
                                                    decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      label: Text('Transferir para'),
                                                    ),
                                                  );
                                                },
                                                suggestionsBuilder: (BuildContext context, SearchController controller) async {
                                                  final keyword = controller.value.text;

                                                  List<ClientesModelo>? clientes = await context.read<ComprasServico>().listarClientes(keyword);

                                                  Iterable<Widget> widgets = clientes.map((cliente) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        controller.closeView('');
                                                        setState(() {
                                                          idClienteSelecionado = cliente.id;
                                                          textoClientesController.text = cliente.nome;
                                                        });
                                                        FocusScope.of(context).unfocus();
                                                      },
                                                      child: Card(
                                                        elevation: 3.0,
                                                        child: ListTile(
                                                          leading: Text(cliente.id),
                                                          title: Text(cliente.nome),
                                                          subtitle: Text(
                                                            cliente.apelido,
                                                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });

                                                  return widgets;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    transferenciaProvedor.transferirCompras(comprasTransferencia, idClienteSelecionado);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: const MaterialStatePropertyAll(Colors.green),
                                                    foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                                    shape: MaterialStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                  child: state is Transferindo
                                                      ? const Center(
                                                          child: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: CircularProgressIndicator(
                                                              color: Colors.white,
                                                              strokeWidth: 1,
                                                            ),
                                                          ),
                                                        )
                                                      : Text('Transferir ${comprasTransferencia.length} ${comprasTransferencia.length == 1 ? 'item' : 'itens'}'),
                                                ),
                                              ),
                                              const SizedBox(height: 40),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  )
                : null,
            body: Column(
              children: [
                const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: 'Anteriores'),
                    Tab(text: 'Atuais'),
                    Tab(text: 'Canceladas'),
                  ],
                ),
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
                  child: TabBarView(
                    children: [
                      Skeletonizer(
                        enabled: comprasStore.pagina1 == 1,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            listarCompras(resetar: true);
                          },
                          child: comprasStore.carregando
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
                                )
                              : comprasStore.compras.anteriores.isEmpty
                                  ? SingleChildScrollView(
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
                                    )
                                  : ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: comprasStore.compras.anteriores.length + 1,
                                      controller: _scrollController,
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70),
                                      itemBuilder: (context, index) {
                                        if (index < comprasStore.compras.anteriores.length) {
                                          var item = comprasStore.compras.anteriores[index];

                                          return SizedBox(
                                            width: width,
                                            child: Card(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 5,
                                                      height: 90,
                                                      clipBehavior: Clip.hardEdge,
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(5),
                                                          bottomLeft: Radius.circular(5),
                                                        ),
                                                      ),
                                                      child: const VerticalDivider(color: Colors.grey, thickness: 5),
                                                    ),
                                                  ),
                                                  ExpansionTile(
                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    tilePadding: const EdgeInsets.only(right: 20),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            item.nomeProva,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          Text(
                                                            item.nomeEvento,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontSize: 13),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('Inscrições: ${item.compras.length}'),
                                                              Text(
                                                                double.tryParse(item.somaTotal) != null ? double.tryParse(item.somaTotal)!.obterReal() : '',
                                                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // childrenPadding: const EdgeInsets.all(10),
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(bottom: 10, top: 0),
                                                        child: Divider(
                                                          height: 1,
                                                        ),
                                                      ),
                                                      ...item.compras.map((e) {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 7, right: 7),
                                                          child: CardCompras(
                                                            item: e,
                                                            comprasTransferencia: comprasTransferencia,
                                                            aoClicarParaTransferir: (compra) {
                                                              if (comprasTransferencia.contains(compra)) {
                                                                setState(() {
                                                                  comprasTransferencia.remove(compra);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  comprasTransferencia.add(compra);
                                                                });
                                                              }
                                                            },
                                                            modoTransferencia: modoTransferencia,
                                                            atualizarLista: () {
                                                              listarCompras(resetar: true);
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                      const SizedBox(height: 7),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 32),
                                            child: comprasStore.temMaisParaCarregar
                                                ? const Center(child: CircularProgressIndicator())
                                                : const Center(child: Text('Você chegou no fim da lista.')),
                                          );
                                        }
                                      },
                                    ),
                        ),
                      ),
                      Skeletonizer(
                        enabled: comprasStore.pagina2 == 1,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            listarCompras(resetar: true);
                          },
                          child: comprasStore.carregando
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
                                )
                              : comprasStore.compras.atuais.isEmpty
                                  ? SingleChildScrollView(
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
                                    )
                                  : ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: comprasStore.compras.atuais.length + 1,
                                      controller: _scrollController,
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70),
                                      itemBuilder: (context, index) {
                                        if (index < comprasStore.compras.atuais.length) {
                                          var item = comprasStore.compras.atuais[index];

                                          return SizedBox(
                                            width: width,
                                            child: Card(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 5,
                                                      height: 90,
                                                      clipBehavior: Clip.hardEdge,
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(5),
                                                          bottomLeft: Radius.circular(5),
                                                        ),
                                                      ),
                                                      child: const VerticalDivider(color: Colors.grey, thickness: 5),
                                                    ),
                                                  ),
                                                  ExpansionTile(
                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    tilePadding: const EdgeInsets.only(right: 20),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            item.nomeProva,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          Text(
                                                            item.nomeEvento,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontSize: 13),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('Inscrições: ${item.compras.length}'),
                                                              Text(
                                                                double.tryParse(item.somaTotal) != null ? double.tryParse(item.somaTotal)!.obterReal() : '',
                                                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // childrenPadding: const EdgeInsets.all(10),
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(bottom: 10, top: 0),
                                                        child: Divider(
                                                          height: 1,
                                                        ),
                                                      ),
                                                      ...item.compras.map((e) {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 7, right: 7),
                                                          child: CardCompras(
                                                            item: e,
                                                            comprasTransferencia: comprasTransferencia,
                                                            aoClicarParaTransferir: (compra) {
                                                              if (comprasTransferencia.contains(compra)) {
                                                                setState(() {
                                                                  comprasTransferencia.remove(compra);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  comprasTransferencia.add(compra);
                                                                });
                                                              }
                                                            },
                                                            modoTransferencia: modoTransferencia,
                                                            atualizarLista: () {
                                                              listarCompras(resetar: true);
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                      const SizedBox(height: 7),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 32),
                                            child: comprasStore.temMaisParaCarregar
                                                ? const Center(child: CircularProgressIndicator())
                                                : const Center(child: Text('Você chegou no fim da lista.')),
                                          );
                                        }
                                      },
                                    ),
                        ),
                      ),
                      Skeletonizer(
                        enabled: comprasStore.pagina3 == 1,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            listarCompras(resetar: true);
                          },
                          child: comprasStore.carregando
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Align(alignment: Alignment.topCenter, child: CircularProgressIndicator()),
                                )
                              : comprasStore.compras.canceladas.isEmpty
                                  ? SingleChildScrollView(
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
                                    )
                                  : ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: comprasStore.compras.canceladas.length + 1,
                                      controller: _scrollController,
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70),
                                      itemBuilder: (context, index) {
                                        if (index < comprasStore.compras.canceladas.length) {
                                          var item = comprasStore.compras.canceladas[index];

                                          return SizedBox(
                                            width: width,
                                            child: Card(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 5,
                                                      height: 90,
                                                      clipBehavior: Clip.hardEdge,
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(5),
                                                          bottomLeft: Radius.circular(5),
                                                        ),
                                                      ),
                                                      child: const VerticalDivider(color: Colors.grey, thickness: 5),
                                                    ),
                                                  ),
                                                  ExpansionTile(
                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    tilePadding: const EdgeInsets.only(right: 20),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            item.nomeProva,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          Text(
                                                            item.nomeEvento,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontSize: 13),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('Inscrições: ${item.compras.length}'),
                                                              Text(
                                                                double.tryParse(item.somaTotal) != null ? double.tryParse(item.somaTotal)!.obterReal() : '',
                                                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // childrenPadding: const EdgeInsets.all(10),
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(bottom: 10, top: 0),
                                                        child: Divider(
                                                          height: 1,
                                                        ),
                                                      ),
                                                      ...item.compras.map((e) {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 7, right: 7),
                                                          child: CardCompras(
                                                            item: e,
                                                            comprasTransferencia: comprasTransferencia,
                                                            aoClicarParaTransferir: (compra) {
                                                              if (comprasTransferencia.contains(compra)) {
                                                                setState(() {
                                                                  comprasTransferencia.remove(compra);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  comprasTransferencia.add(compra);
                                                                });
                                                              }
                                                            },
                                                            modoTransferencia: modoTransferencia,
                                                            atualizarLista: () {
                                                              listarCompras(resetar: true);
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                      const SizedBox(height: 7),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 32),
                                            child: comprasStore.temMaisParaCarregar
                                                ? const Center(child: CircularProgressIndicator())
                                                : const Center(child: Text('Você chegou no fim da lista.')),
                                          );
                                        }
                                      },
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
